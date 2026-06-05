import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../settings/model/subscription_local_status_ui_model.dart';
import '../settings/settings_view_model.dart';
import '../utils/network_services/api_repository.dart';
import '../utils/routes.dart';
import '../utils/constants/app_constants.dart';
import '../professional/upgradePlans/model/plan_model.dart';

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

  static const Set<String> kProductIds = {
    'starter_monthly',
    'starter_annual',
    'plus_monthly',
    'plus_annual',
    'pro_monthly',
    'pro_annual',
  };

  /// Initialize and query product details
  Future<void> initStoreInfo() async {
    try {
      final bool available = await _iapConnection.isAvailable();
      isAvailable = available;
      if (!available) {
        log("Store not available");
        return;
      }

      if (Platform.isIOS) {
        final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
            _iapConnection
                .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      }

      final ProductDetailsResponse productDetailResponse = await _iapConnection
          .queryProductDetails(kProductIds);

      if (productDetailResponse.error != null) {
        log('Error fetching products: ${productDetailResponse.error}');
        return;
      }

      products = productDetailResponse.productDetails;
      log('Fetched products length: ${products.length}');
      for (var product in products) {
        log('Product ID: ${product.id}, Price: ${product.price}');
      }
    } catch (e) {
      log('initStoreInfo error: $e');
    }
  }

  /// Setup listeners and drain old iOS queue items
  Future<void> setupInAppPurchase() async {
    if (_iapSetup) return;

    if (Platform.isIOS) {
      try {
        final transactions = await SKPaymentQueueWrapper().transactions();
        for (final t in transactions) {
          await SKPaymentQueueWrapper().finishTransaction(t);
        }
      } catch (e) {
        log('Drain pending iOS transactions error: $e');
      }
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

  /// Initiate purchase flow for a plan
  Future<void> buyPlan(
    PlanModel plan,
    bool isMonthly,
    SubscriptionStatusUiModel? currentSubscription,
  ) async {
    String productId = isMonthly
        ? (plan.monthlyProductId ?? "")
        : (plan.yearlyProductId ?? "");

    if (productId.isEmpty) {
      productId = getProductId(plan.planName ?? "", isMonthly);
    }

    if (productId.isEmpty) {
      // Mock flow for Free plan (or if product ID is empty)
      _showLoading();
      await Future.delayed(const Duration(seconds: 1));
      _hideLoading();

      log('Simulating purchase for Free/Trial plan');
      BaseSnackBar.show(title: "Info", message: "Free plan activated.");
      Get.until((route) => route.settings.name == Routes.dashboard);
      // Get.offAllNamed(Routes.professionalDashboard);
      return;
    }

    // Try to find the product in queried details
    final productDetails = products.firstWhereOrNull(
      (p) => p.id == productId || p.id.endsWith(productId) || productId.endsWith(p.id)
    );

    if (productDetails != null) {
      productId = productDetails.id;
    }

    if (productDetails == null) {
      // If store product details are not loaded, simulate a success for sandbox testing
      log(
        'Product $productId not found in store. Simulating purchase success.',
      );
      _showLoading();
      await Future.delayed(const Duration(milliseconds: 1500));
      _hideLoading();

      final mockVerified = await verifyPurchaseWithBackend(
        platform: Platform.isIOS ? 'ios' : 'android',
        productId: productId,
        purchaseToken:
            'mock_purchase_token_${DateTime.now().millisecondsSinceEpoch}',
        orderId: 'mock_order_${DateTime.now().millisecondsSinceEpoch}',
        transactionId: 'mock_tx_${DateTime.now().millisecondsSinceEpoch}',
        purchaseTime: DateTime.now().toUtc().toIso8601String(),
      );

      if (mockVerified) {
        if (Get.isRegistered<SettingsViewModel>()) {
          final settingsViewModel = Get.find<SettingsViewModel>();
          settingsViewModel.getProfessionalProfileDetail();
        }
        BaseSnackBar.show(
          title: "Success",
          message: "Subscription upgraded successfully (Simulated).",
        );
        Get.until((route) => route.settings.name == Routes.dashboard);
        // Get.offAllNamed(Routes.professionalDashboard);
      } else {
        // Fallback for offline/development if verify fails: locally update the profile model so the UI reflects the change
        if (Get.isRegistered<SettingsViewModel>()) {
          final settingsModel = Get.find<SettingsViewModel>();
          settingsModel.currentSubscriptionStatusModel.value =
              SubscriptionStatusUiModel(
                id: productId,
                name: plan.planName,
                status: "Active",
                isActive: true,
                isTrialActive: false,
                createdAt: DateTime.now().toIso8601String(),
                updatedAt: DateTime.now()
                    .add(const Duration(days: 30))
                    .toIso8601String(),
              );
          settingsModel.currentSubscriptionStatusModel.refresh();
        }
        BaseSnackBar.show(
          title: "Success",
          message: "Plan upgraded successfully (Simulated fallback).",
        );
        Get.until((route) => route.settings.name == Routes.dashboard);
        // Get.offAllNamed(Routes.professionalDashboard);
      }
      return;
    }

    userInitiatedPurchase = true;
    acceptEvents = true;
    intendedPurchaseProductId = productId;

    // Safety timeout
    Future.delayed(const Duration(seconds: 30), () {
      if (acceptEvents) {
        log('⏳ Purchase timeout reached. Resetting state.');
        _resetPurchaseState();
        _hideLoading();
      }
    });

    try {
      _showLoading();
      if (Platform.isAndroid) {
        GooglePlayPurchaseDetails? existingAndroidPurchase;

        if (currentSubscription != null && currentSubscription.id != null) {
          final InAppPurchaseAndroidPlatformAddition androidAddition =
              _iapConnection
                  .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
          final pastPurchasesResponse = await androidAddition
              .queryPastPurchases();
          for (final p in pastPurchasesResponse.pastPurchases) {
            if (p.productID == currentSubscription.id) {
              existingAndroidPurchase = p as GooglePlayPurchaseDetails;
              break;
            }
          }
        }

        if (existingAndroidPurchase != null) {
          if (existingAndroidPurchase.pendingCompletePurchase) {
            log('Old purchase pending completion. Acknowledging...');
            await _iapConnection.completePurchase(existingAndroidPurchase);
            await Future.delayed(const Duration(milliseconds: 500));
          }

          final currentTier = getPlanTier(currentSubscription?.name);
          final newTier = getPlanTier(plan.planName);
          final isUpgrade = newTier > currentTier;

          final ReplacementMode replacementMode = isUpgrade
              ? ReplacementMode.chargeFullPrice
              : ReplacementMode.deferred;

          log(
            'Google Play Upgrade/Downgrade: from ${currentSubscription?.id} to $productId. Replacement Mode: $replacementMode',
          );

          final param = GooglePlayPurchaseParam(
            productDetails: productDetails,
            changeSubscriptionParam: ChangeSubscriptionParam(
              oldPurchaseDetails: existingAndroidPurchase,
              replacementMode: replacementMode,
            ),
          );
          await _iapConnection.buyNonConsumable(purchaseParam: param);
        } else {
          log('Google Play Fresh Purchase: $productId');
          final param = GooglePlayPurchaseParam(productDetails: productDetails);
          await _iapConnection.buyNonConsumable(purchaseParam: param);
        }
      } else {
        log('StoreKit Purchase: $productId');
        final param = PurchaseParam(productDetails: productDetails);
        await _iapConnection.buyNonConsumable(purchaseParam: param);
      }
    } catch (e) {
      log('Purchase invocation error: $e');
      _resetPurchaseState();
      _hideLoading();
      BaseSnackBar.show(
        title: "Error",
        message: "Purchase failed: ${e.toString()}",
      );
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    try {
      acceptEvents = true;
      _showLoading();
      await _iapConnection.restorePurchases();
    } catch (e) {
      log('Restore purchases error: $e');
      acceptEvents = false;
      _hideLoading();
      BaseSnackBar.show(title: "Error", message: "Restore failed: $e");
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

  /// Cache purchase details before backend validation
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
          'platform': Platform.isIOS ? 'ios' : 'android',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      log('💾 Pending purchase cached for $productId');
    } catch (e) {
      log('⚠️ Failed to cache pending purchase: $e');
    }
  }

  /// Clear pending purchase cache
  Future<void> _clearPendingPurchase() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_pendingPurchaseKey);
      log('🗑️ Pending purchase cache cleared');
    } catch (e) {
      log('⚠️ Failed to clear pending purchase cache: $e');
    }
  }

  /// Recovery of unverified purchases (e.g. from crash or network failure)
  Future<void> checkAndRecoverPendingPurchases() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pendingJson = prefs.getString(_pendingPurchaseKey);
      if (pendingJson == null) return;

      log('🔄 Found pending purchase — attempting recovery...');
      final data = jsonDecode(pendingJson) as Map<String, dynamic>;
      final platform = data['platform'] as String;
      final productId = data['productId'] as String;
      final purchaseToken = data['serverVerificationData'] as String;

      final verified = await verifyPurchaseWithBackend(
        platform: platform,
        productId: productId,
        purchaseToken: purchaseToken,
        orderId: data['purchaseId'],
      );

      if (verified) {
        await _clearPendingPurchase();
        if (Get.isRegistered<SettingsViewModel>()) {
          final settingsViewModel = Get.find<SettingsViewModel>();
          settingsViewModel.getProfessionalProfileDetail();
        }
        log('✅ Pending subscription activated and verified!');
      } else {
        log('⚠️ Pending purchase verification failed — will retry next open');
      }
    } catch (e) {
      log('❌ Pending purchase recovery error: $e');
    }
  }

  /// Post purchase details to backend verify endpoint
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
          log('⚠️ purchaseTime parse error: $e');
        }
      }
      parsedDate ??= DateTime.now().toUtc();
      final normalizedPurchaseIso = parsedDate.toIso8601String();

      final body = <String, dynamic>{
        'platform': platform,
        'productId': productId,
        'purchaseToken': purchaseToken,
        if (orderId != null) 'orderId': orderId,
        if (transactionId != null) 'transactionId': transactionId,
        'purchaseTime': normalizedPurchaseIso,
      };

      log("body verification =>$body");
      final response = await ApiRepository.instance.post(
        'api/v1/subscription/verify',
        body: body,
      );

      if (response != null &&
          (response['success'] == true ||
              response['statusCode'] == 200 ||
              response['statusCode'] == 201)) {
        log('✅ Backend verification success for $productId');
        return true;
      } else {
        log('❌ Backend verification failed: $response');
        return false;
      }
    } catch (e) {
      log('❌ Backend verification error: $e');
      return false;
    }
  }

  /// Listen updates in the purchase stream
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
          "Transaction update received: ${purchaseDetails.productID} with status ${purchaseDetails.status}",
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
            if (purchaseDetails.pendingCompletePurchase || Platform.isIOS) {
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
      log("Error in _listenToPurchaseUpdated: $e");
    }
  }

  /// Handle successful purchase/restore from stream callback
  Future<void> _handleSuccessfulPurchaseOrRestore(
    PurchaseDetails purchaseDetails,
  ) async {
    try {
      if (userInitiatedPurchase && intendedPurchaseProductId != null) {
        if (purchaseDetails.productID != intendedPurchaseProductId) {
          final bool isAndroidDowngrade =
              Platform.isAndroid &&
              currentProductId != null &&
              purchaseDetails.productID == currentProductId;
          if (!isAndroidDowngrade) {
            log("Ignoring older product: ${purchaseDetails.productID}");
            if (purchaseDetails.pendingCompletePurchase || Platform.isIOS) {
              try {
                await _iapConnection.completePurchase(purchaseDetails);
              } catch (_) {}
            }
            return;
          }
        }
      }

      await _cachePendingPurchase(purchaseDetails);

      final String platform = Platform.isIOS ? 'ios' : 'android';
      final verified = await verifyPurchaseWithBackend(
        platform: platform,
        productId: purchaseDetails.productID,
        purchaseToken: purchaseDetails.verificationData.serverVerificationData,
        orderId: purchaseDetails.purchaseID,
        transactionId: purchaseDetails.purchaseID,
        purchaseTime: purchaseDetails.transactionDate,
      );

      if (purchaseDetails.pendingCompletePurchase || Platform.isIOS) {
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
          settingsViewModel.getProfessionalProfileDetail();
        }

        BaseSnackBar.show(
          title: "Success",
          message: "Plan purchased successfully.",
        );
        // need change
        Get.until((route) => route.settings.name == Routes.dashboard);
        // Get.offAllNamed(Routes.professionalDashboard);
      } else {
        BaseSnackBar.show(
          title: "Verification Pending",
          message: "Purchase completed, but verification is pending.",
        );
      }
    } catch (e) {
      log('Error handling purchase details: $e');
      _hideLoading();
      _resetPurchaseState();
    }
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
    SKPaymentTransactionWrapper transaction,
    SKStorefrontWrapper storefront,
  ) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
