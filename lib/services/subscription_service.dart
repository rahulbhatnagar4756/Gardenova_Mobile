import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart'
    as iapandroidbillingkit;
import 'package:in_app_purchase_android/in_app_purchase_android.dart'
    as iapandroidkit;
import 'package:shared_preferences/shared_preferences.dart';

import '../professional/upgradePlans/model/plan_model.dart';
import '../settings/model/subscription_local_status_ui_model.dart';
import '../settings/settings_view_model.dart';
import '../utils/constants/app_constants.dart';
import '../utils/constants/app_keys.dart';
import '../utils/network_services/api_repository.dart';
import '../utils/routes.dart';

/// Google Play Billing subscriptions (Android only).
class SubscriptionService {
  SubscriptionService._privateConstructor();

  static final SubscriptionService instance =
      SubscriptionService._privateConstructor();

  final InAppPurchase _iapConnection = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  List<ProductDetails> products = [];
  bool isAvailable = false;
  bool _iapSetup = false;
  bool acceptEvents = false;
  bool userInitiatedPurchase = false;
  String? intendedPurchaseProductId;
  String? currentProductId;
  int? currentPlanTier;

  final Set<String> _processedTransactionIds = <String>{};

  static const String _pendingPurchaseKey = 'gardenova_pending_purchase';

  /// Play Console subscription product IDs (Subscription type, not one-time).
  static const Set<String> kProductIds = {
    'starter_monthly',
    'starter_annual',
    'plus_monthly',
    'plus_annual',
    'pro_monthly',
    'pro_annual',
  };

  /// Initialize and query Google Play subscription product details.
  Future<void> initStoreInfo() async {
    try {
      if (!Platform.isAndroid) {
        isAvailable = false;
        log('Google Play subscriptions are Android-only.');
        return;
      }

      final bool available = await _iapConnection.isAvailable();
      isAvailable = available;
      if (!available) {
        log('Google Play Billing not available');
        return;
      }

      final ProductDetailsResponse productDetailResponse =
          await _iapConnection.queryProductDetails(kProductIds);

      if (productDetailResponse.error != null) {
        log(
          'Error fetching subscription products: ${productDetailResponse.error}',
        );
        return;
      }

      if (productDetailResponse.notFoundIDs.isNotEmpty) {
        log(
          'Subscription SKUs not found in Play Console: ${productDetailResponse.notFoundIDs}',
        );
      }

      products = productDetailResponse.productDetails;
      log('Fetched Google Play subscription products: ${products.length}');
      for (final product in products) {
        if (product is iapandroidkit.GooglePlayProductDetails) {
          log(
            'Subscription: ${product.id}, price=${product.price}, '
            'offerToken=${product.offerToken}, '
            'basePlan=${_basePlanId(product)}',
          );
        } else {
          log('Product ID: ${product.id}, Price: ${product.price}');
        }
      }
    } catch (e) {
      log('initStoreInfo error: $e');
    }
  }

  /// Setup purchase stream + load Play subscription catalog.
  Future<void> setupInAppPurchase() async {
    if (_iapSetup) return;

    if (!Platform.isAndroid) {
      isAvailable = false;
      _iapSetup = true;
      log('Skipping IAP setup — Android Google Play subscriptions only.');
      return;
    }

    _subscription = _iapConnection.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription?.cancel();
      },
      onError: (Object error) {
        log('Error in purchase stream: $error');
      },
    );

    await initStoreInfo();
    _iapSetup = true;
  }

  /// Get product ID from Plan Name and billing cycle
  String getProductId(String planName, bool isMonthly) {
    final prefix = planName.toLowerCase().trim();
    if (prefix == 'free' || prefix == 'trial') return '';
    return '${prefix}_${isMonthly ? 'monthly' : 'annual'}';
  }

  /// Build UI plans from queried Google Play subscription products.
  List<PlanModel> buildPlansFromStore({
    bool includeProfessionalFields = false,
  }) {
    final storeMap = <String, ({String price, double rawPrice})>{};

    for (final product in products) {
      if (product is iapandroidkit.GooglePlayProductDetails) {
        final existing = storeMap[product.id];
        // Prefer base-plan offer for list price display.
        if (existing == null || _isBasePlanOffer(product)) {
          storeMap[product.id] = (
            price: product.price,
            rawPrice: product.rawPrice,
          );
        }
      } else {
        storeMap[product.id] = (
          price: product.price,
          rawPrice: product.rawPrice,
        );
      }
    }

    return PlanModel.fromStoreProducts(
      storeProducts: storeMap,
      includeProfessionalFields: includeProfessionalFields,
    );
  }

  /// Get tier representation of plan name
  int getPlanTier(String? name) {
    if (name == null) return 0;
    switch (name.toLowerCase()) {
      case 'free':
      case 'trial':
        return 0;
      case 'starter':
        return 1;
      case 'plus':
        return 2;
      case 'pro':
        return 3;
      default:
        return 0;
    }
  }

  /// Start a real Google Play subscription purchase (Android only).
  ///
  /// Note: Flutter's plugin uses [InAppPurchase.buyNonConsumable] for
  /// subscriptions as well; this is not a one-time / non-consumable SKU.
  Future<void> buyPlan(
    PlanModel plan,
    bool isMonthly,
    SubscriptionStatusUiModel? currentSubscription,
  ) async {
    if (!Platform.isAndroid) {
      BaseSnackBar.show(
        title: 'Google Play',
        message: 'Subscriptions are available on Android via Google Play only.',
      );
      return;
    }

    if (!isAvailable) {
      BaseSnackBar.show(
        title: 'Google Play',
        message:
            'Google Play Billing is not available on this device. Use a device with Play Store.',
      );
      return;
    }

    String productId = isMonthly
        ? (plan.monthlyProductId ?? '')
        : (plan.yearlyProductId ?? '');

    if (productId.isEmpty) {
      productId = getProductId(plan.planName ?? '', isMonthly);
    }

    if (productId.isEmpty) {
      BaseSnackBar.show(
        title: 'Plan',
        message: 'Please select a paid subscription plan to continue.',
      );
      return;
    }

    final googleProduct = _resolveAndroidSubscription(productId);
    if (googleProduct == null) {
      log('Subscription product $productId not found in Play catalog.');
      BaseSnackBar.show(
        title: 'Google Play',
        message:
            'This subscription is not available in Google Play right now. Please try again later.',
      );
      return;
    }

    productId = googleProduct.id;
    final offerToken = googleProduct.offerToken;
    if (offerToken == null || offerToken.isEmpty) {
      log('Missing offerToken for subscription $productId');
      BaseSnackBar.show(
        title: 'Google Play',
        message:
            'Unable to start this subscription offer. Please try again later.',
      );
      return;
    }

    userInitiatedPurchase = true;
    acceptEvents = true;
    intendedPurchaseProductId = productId;
    currentProductId = currentSubscription?.id ?? currentSubscription?.planCode;
    currentPlanTier = getPlanTier(currentSubscription?.name);

    Future.delayed(const Duration(seconds: 30), () {
      if (acceptEvents) {
        log('Purchase timeout reached. Resetting state.');
        _resetPurchaseState();
        _hideLoading();
      }
    });

    try {
      _showLoading();

      final existingAndroidPurchase = await _findExistingAndroidSubscription(
        currentSubscription,
      );

      if (existingAndroidPurchase != null) {
        if (existingAndroidPurchase.pendingCompletePurchase) {
          log('Old subscription pending completion. Acknowledging...');
          await _iapConnection.completePurchase(existingAndroidPurchase);
          await Future.delayed(const Duration(milliseconds: 500));
        }

        final currentTier = getPlanTier(currentSubscription?.name);
        final newTier = getPlanTier(plan.planName);
        final isUpgrade = newTier > currentTier;

        final replacementMode = isUpgrade
            ? iapandroidbillingkit.ReplacementMode.chargeFullPrice
            : iapandroidbillingkit.ReplacementMode.deferred;

        log(
          'Google Play subscription change: '
          '${existingAndroidPurchase.productID} -> $productId '
          '(mode=$replacementMode, offerToken=$offerToken)',
        );

        final param = iapandroidkit.GooglePlayPurchaseParam(
          productDetails: googleProduct,
          offerToken: offerToken,
          changeSubscriptionParam: iapandroidkit.ChangeSubscriptionParam(
            oldPurchaseDetails: existingAndroidPurchase,
            replacementMode: replacementMode,
          ),
        );
        // Plugin API name is buyNonConsumable; product type is Subscription.
        await _iapConnection.buyNonConsumable(purchaseParam: param);
      } else {
        log(
          'Google Play new subscription: $productId (offerToken=$offerToken)',
        );
        final param = iapandroidkit.GooglePlayPurchaseParam(
          productDetails: googleProduct,
          offerToken: offerToken,
        );
        await _iapConnection.buyNonConsumable(purchaseParam: param);
      }
    } catch (e) {
      log('Google Play subscription purchase error: $e');
      _resetPurchaseState();
      _hideLoading();
      BaseSnackBar.show(
        title: 'Error',
        message: 'Unable to start Google Play subscription. Please try again.',
      );
    }
  }

  iapandroidkit.GooglePlayProductDetails? _resolveAndroidSubscription(
    String productId,
  ) {
    final matches = products
        .whereType<iapandroidkit.GooglePlayProductDetails>()
        .where(
          (p) =>
              p.id == productId ||
              p.id.endsWith(productId) ||
              productId.endsWith(p.id),
        )
        .toList();

    if (matches.isEmpty) {
      final generic = products.firstWhereOrNull(
        (p) =>
            p.id == productId ||
            p.id.endsWith(productId) ||
            productId.endsWith(p.id),
      );
      return generic is iapandroidkit.GooglePlayProductDetails ? generic : null;
    }

    return matches.firstWhereOrNull(_isBasePlanOffer) ?? matches.first;
  }

  bool _isBasePlanOffer(iapandroidkit.GooglePlayProductDetails product) {
    final index = product.subscriptionIndex;
    final offers = product.productDetails.subscriptionOfferDetails;
    if (index == null || offers == null || index >= offers.length) {
      return false;
    }
    final offerId = offers[index].offerId;
    return offerId == null || offerId.isEmpty;
  }

  String? _basePlanId(iapandroidkit.GooglePlayProductDetails product) {
    final index = product.subscriptionIndex;
    final offers = product.productDetails.subscriptionOfferDetails;
    if (index == null || offers == null || index >= offers.length) {
      return null;
    }
    return offers[index].basePlanId;
  }

  Set<String> _candidateProductIds(SubscriptionStatusUiModel? subscription) {
    final candidates = <String>{};
    void add(String? value) {
      final id = value?.trim().toLowerCase();
      if (id == null || id.isEmpty || id == 'free' || id == 'trial') return;
      candidates.add(id);
      candidates.add(id.replaceFirst('_yearly', '_annual'));
      candidates.add(id.replaceFirst('_annual', '_yearly'));
    }

    add(subscription?.planCode);
    add(subscription?.id);
    add(getProductId(subscription?.name ?? '', true));
    add(getProductId(subscription?.name ?? '', false));
    return candidates;
  }

  Future<iapandroidkit.GooglePlayPurchaseDetails?>
  _findExistingAndroidSubscription(
    SubscriptionStatusUiModel? currentSubscription,
  ) async {
    if (currentSubscription == null) return null;

    final candidates = _candidateProductIds(currentSubscription);
    if (candidates.isEmpty) return null;

    try {
      final androidAddition = _iapConnection
          .getPlatformAddition<
            iapandroidkit.InAppPurchaseAndroidPlatformAddition
          >();
      final pastPurchasesResponse = await androidAddition.queryPastPurchases();

      for (final purchase in pastPurchasesResponse.pastPurchases) {
        final productId = purchase.productID.toLowerCase();
        if (candidates.contains(productId) ||
            candidates.any(
              (id) => productId.endsWith(id) || id.endsWith(productId),
            )) {
          return purchase;
        }
      }

      if (pastPurchasesResponse.pastPurchases.length == 1) {
        return pastPurchasesResponse.pastPurchases.first;
      }
    } catch (e) {
      log('queryPastPurchases error: $e');
    }
    return null;
  }

  /// Restore Google Play subscriptions
  Future<void> restorePurchases() async {
    if (!Platform.isAndroid) {
      BaseSnackBar.show(
        title: 'Google Play',
        message: 'Restore is available on Android only.',
      );
      return;
    }

    try {
      acceptEvents = true;
      _showLoading();
      await _iapConnection.restorePurchases();
    } catch (e) {
      log('Restore purchases error: $e');
      acceptEvents = false;
      _hideLoading();
      BaseSnackBar.show(title: 'Error', message: 'Restore failed: $e');
    }
  }

  void _resetPurchaseState() {
    userInitiatedPurchase = false;
    intendedPurchaseProductId = null;
    acceptEvents = false;
  }

  void _showLoading() {
    ApiRepository.instance.showLoader();
  }

  void _hideLoading() {
    ApiRepository.instance.hideLoader();
  }

  Future<void> _cachePendingPurchase(
    PurchaseDetails details, {
    String? overrideProductId,
  }) async {
    try {
      final String productId = overrideProductId ?? details.productID;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _pendingPurchaseKey,
        jsonEncode({
          'productId': productId,
          'purchaseId': details.purchaseID,
          'transactionDate': details.transactionDate,
          'serverVerificationData':
              details.verificationData.serverVerificationData,
          'platform': 'android',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      log('Pending subscription cached for $productId');
    } catch (e) {
      log('Failed to cache pending purchase: $e');
    }
  }

  Future<void> _clearPendingPurchase() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingPurchaseKey);
      log('Pending purchase cache cleared');
    } catch (e) {
      log('Failed to clear pending purchase cache: $e');
    }
  }

  Future<void> checkAndRecoverPendingPurchases() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingJson = prefs.getString(_pendingPurchaseKey);
      if (pendingJson == null) return;

      log('Found pending subscription — attempting recovery...');
      final data = jsonDecode(pendingJson) as Map<String, dynamic>;
      final productId = data['productId'] as String;
      final purchaseToken = data['serverVerificationData'] as String;

      final verified = await verifyPurchaseWithBackend(
        platform: 'android',
        productId: productId,
        purchaseToken: purchaseToken,
        orderId: data['purchaseId'],
      );

      if (verified) {
        await _clearPendingPurchase();
        if (Get.isRegistered<SettingsViewModel>()) {
          final settingsViewModel = Get.find<SettingsViewModel>();
          if (settingsViewModel.screenType.value == AppKeys.professional) {
            settingsViewModel.getProfessionalProfileDetail();
          } else {
            await settingsViewModel.getProfileDetail();
          }
        }
        log('Pending subscription activated and verified!');
      } else {
        log('Pending purchase verification failed — will retry next open');
      }
    } catch (e) {
      log('Pending purchase recovery error: $e');
    }
  }

  Future<bool> verifyPurchaseWithBackend({
    required String platform,
    required String productId,
    required String purchaseToken,
    String? orderId,
    String? transactionId,
    String? purchaseTime,
  }) async {
    try {
      DateTime? parsedDate;
      if (purchaseTime != null && purchaseTime.trim().isNotEmpty) {
        final raw = purchaseTime.trim();
        final numeric = RegExp(r'^\d+$').hasMatch(raw);
        try {
          if (numeric) {
            if (raw.length >= 13) {
              parsedDate = DateTime.fromMillisecondsSinceEpoch(
                int.parse(raw),
                isUtc: true,
              );
            } else if (raw.length == 10) {
              parsedDate = DateTime.fromMillisecondsSinceEpoch(
                int.parse(raw) * 1000,
                isUtc: true,
              );
            } else {
              parsedDate = DateTime.fromMillisecondsSinceEpoch(
                int.parse(raw),
                isUtc: true,
              );
            }
          } else {
            final isoCandidate = raw.contains('T')
                ? raw
                : raw.replaceFirst(' ', 'T');
            parsedDate = DateTime.tryParse(isoCandidate)?.toUtc();
          }
        } catch (e) {
          log('purchaseTime parse error: $e');
        }
      }
      parsedDate ??= DateTime.now().toUtc();
      final normalizedPurchaseIso = parsedDate.toIso8601String();

      final body = <String, dynamic>{
        'platform': platform,
        'productId': productId,
        'purchaseToken': purchaseToken,
        'purchaseTime': normalizedPurchaseIso,
      };
      if (orderId != null) {
        body['orderId'] = orderId;
      }
      if (transactionId != null) {
        body['transactionId'] = transactionId;
      }

      log('body verification =>$body');
      final response = await ApiRepository.instance.post(
        'api/v1/subscription/verify',
        body: body,
      );

      if (response != null &&
          (response['success'] == true ||
              response['statusCode'] == 200 ||
              response['statusCode'] == 201)) {
        log('Backend verification success for $productId');
        return true;
      } else {
        log('Backend verification failed: $response');
        return false;
      }
    } catch (e) {
      log('Backend verification error: $e');
      return false;
    }
  }

  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    try {
      if (!acceptEvents) {
        log('Ignoring purchase updates because acceptEvents=false');
        return;
      }

      for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
        log(
          'Subscription update: ${purchaseDetails.productID} '
          'status=${purchaseDetails.status}',
        );

        final String? txId = purchaseDetails.purchaseID;
        if (txId != null && _processedTransactionIds.contains(txId)) {
          log('Duplicate transaction ignored: $txId');
          continue;
        }

        switch (purchaseDetails.status) {
          case PurchaseStatus.canceled:
          case PurchaseStatus.error:
            _hideLoading();
            _resetPurchaseState();
            if (purchaseDetails.pendingCompletePurchase) {
              try {
                await _iapConnection.completePurchase(purchaseDetails);
              } catch (_) {}
            }
            break;

          case PurchaseStatus.pending:
            break;

          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            await _handleSuccessfulPurchaseOrRestore(purchaseDetails);
            break;
        }
      }
    } catch (e) {
      log('Error in _listenToPurchaseUpdated: $e');
    }
  }

  Future<void> _handleSuccessfulPurchaseOrRestore(
    PurchaseDetails purchaseDetails,
  ) async {
    try {
      if (userInitiatedPurchase && intendedPurchaseProductId != null) {
        if (purchaseDetails.productID != intendedPurchaseProductId) {
          final bool isAndroidDowngrade =
              currentProductId != null &&
              purchaseDetails.productID == currentProductId;
          if (!isAndroidDowngrade) {
            log('Ignoring older product: ${purchaseDetails.productID}');
            if (purchaseDetails.pendingCompletePurchase) {
              try {
                await _iapConnection.completePurchase(purchaseDetails);
              } catch (_) {}
            }
            return;
          }
        }
      }

      await _cachePendingPurchase(purchaseDetails);

      final verified = await verifyPurchaseWithBackend(
        platform: 'android',
        productId: purchaseDetails.productID,
        purchaseToken: purchaseDetails.verificationData.serverVerificationData,
        orderId: purchaseDetails.purchaseID,
        transactionId: purchaseDetails.purchaseID,
        purchaseTime: purchaseDetails.transactionDate,
      );

      if (purchaseDetails.pendingCompletePurchase) {
        try {
          await _iapConnection.completePurchase(purchaseDetails);
        } catch (e) {
          log('completePurchase error: $e');
        }
      }

      _hideLoading();
      _resetPurchaseState();

      if (verified) {
        await _clearPendingPurchase();
        if (purchaseDetails.purchaseID != null) {
          _processedTransactionIds.add(purchaseDetails.purchaseID!);
        }

        if (Get.isRegistered<SettingsViewModel>()) {
          final settingsViewModel = Get.find<SettingsViewModel>();
          if (settingsViewModel.screenType.value == AppKeys.professional) {
            settingsViewModel.getProfessionalProfileDetail();
          } else {
            await settingsViewModel.getProfileDetail();
          }
        }

        BaseSnackBar.show(
          title: 'Success',
          message: 'Subscription activated successfully.',
        );
        Get.until((route) => route.settings.name == Routes.dashboard);
      } else {
        BaseSnackBar.show(
          title: 'Verification Pending',
          message: 'Purchase completed, but verification is pending.',
        );
      }
    } catch (e) {
      log('Error handling subscription purchase: $e');
      _hideLoading();
      _resetPurchaseState();
    }
  }
}
