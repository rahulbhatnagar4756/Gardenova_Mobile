import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart' as iapandroidbillingkit;
import 'package:in_app_purchase_android/in_app_purchase_android.dart' as iapandroidkit;
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

  static final SubscriptionService instance = SubscriptionService._privateConstructor();

  final InAppPurchase _iapConnection = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  List<ProductDetails> products = [];
  bool isAvailable = false;
  bool _iapSetup = false;
  bool acceptEvents = false;
  bool userInitiatedPurchase = false;
  String? intendedPurchaseProductId;

  /// Play / API product_id for the selected offer (e.g. starter_monthly, plus, pro).
  String? intendedApiProductId;

  /// API plan_id for the selected offer (e.g. stater-monthly, plus-yearly).
  String? intendedPlanId;
  String? currentProductId;
  int? currentPlanTier;

  final Set<String> _processedTransactionIds = <String>{};

  static const String _pendingPurchaseKey = 'gardenova_pending_purchase';
  static const String _verifySubscriptionUrl = 'api/v1/plans/subscriptions/verify';

  /// Play Console subscription product IDs (Subscription type, not one-time).
  ///
  /// Mapping (product_id → plan_id):
  /// - starter_monthly → stater-monthly
  /// - starter → stater-yearly
  /// - plus → plus-monthly / plus-yearly
  /// - pro → pro-monthly / pro-yearly
  static const Set<String> kProductIds = {'starter_monthly', 'starter', 'plus', 'pro'};

  /// product_id + plan_id for the user's selected tier and billing period.
  static ({String productId, String planId}) idsForSelection({
    required String tier,
    required bool isMonthly,
  }) {
    switch (tier.toLowerCase().trim()) {
      case 'starter':
        return isMonthly
            ? (productId: 'starter_monthly', planId: 'stater-monthly')
            : (productId: 'starter', planId: 'stater-yearly');
      case 'plus':
        return isMonthly
            ? (productId: 'plus', planId: 'plus-monthly')
            : (productId: 'plus', planId: 'plus-yearly');
      case 'pro':
        return isMonthly
            ? (productId: 'pro', planId: 'pro-monthly')
            : (productId: 'pro', planId: 'pro-yearly');
      default:
        final fallback = tier.toLowerCase().trim();
        return (productId: fallback, planId: isMonthly ? '$fallback-monthly' : '$fallback-yearly');
    }
  }

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

      final ProductDetailsResponse productDetailResponse = await _iapConnection.queryProductDetails(
        kProductIds,
      );

      if (productDetailResponse.error != null) {
        log('Error fetching subscription products: ${productDetailResponse.error}');
        return;
      }

      if (productDetailResponse.notFoundIDs.isNotEmpty) {
        log('Subscription SKUs not found in Play Console: ${productDetailResponse.notFoundIDs}');
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
    if (!Platform.isAndroid) {
      isAvailable = false;
      _iapSetup = true;
      log('Skipping IAP setup — Android Google Play subscriptions only.');
      return;
    }

    if (!_iapSetup) {
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
      _iapSetup = true;
    }

    // Retry product query if the first load failed / returned empty.
    if (products.isEmpty) {
      await initStoreInfo();
    }

    // Google Play requires purchases to be acknowledged within 3 days.
    // Unacknowledged purchases block plan changes ("Developer hasn't
    // acknowledged your purchase").
    await acknowledgePendingPurchases();
  }

  /// Acknowledge any Google Play purchase that is still pending completion.
  Future<void> _acknowledgePurchase(PurchaseDetails purchase) async {
    if (!purchase.pendingCompletePurchase) return;
    try {
      await _iapConnection.completePurchase(purchase);
      log(
        'Acknowledged Google Play purchase: ${purchase.productID} '
        '(purchaseID=${purchase.purchaseID})',
      );
    } catch (e) {
      log('completePurchase / acknowledge error for ${purchase.productID}: $e');
    }
  }

  /// Query past purchases and acknowledge any that Play still considers pending.
  ///
  /// Call on app start and before subscription upgrades/downgrades so users are
  /// not blocked by the Play Store acknowledgment dialog.
  Future<void> acknowledgePendingPurchases() async {
    if (!Platform.isAndroid || !isAvailable) return;

    try {
      final androidAddition = _iapConnection
          .getPlatformAddition<iapandroidkit.InAppPurchaseAndroidPlatformAddition>();
      final pastPurchasesResponse = await androidAddition.queryPastPurchases();

      if (pastPurchasesResponse.error != null) {
        log('queryPastPurchases error: ${pastPurchasesResponse.error}');
      }

      final past = pastPurchasesResponse.pastPurchases;
      log('Past Google Play purchases: ${past.length}');

      for (final purchase in past) {
        final wasPending = purchase.pendingCompletePurchase;
        log(
          'Past purchase: ${purchase.productID} '
          'status=${purchase.status} '
          'pendingComplete=$wasPending',
        );
        await _acknowledgePurchase(purchase);

        // Only re-verify purchases that still needed acknowledgment (or were
        // never synced), to avoid spamming the backend on every app open.
        if (!wasPending) continue;
        if (purchase.status != PurchaseStatus.purchased &&
            purchase.status != PurchaseStatus.restored) {
          continue;
        }

        final txId = purchase.purchaseID;
        if (txId != null && _processedTransactionIds.contains(txId)) continue;

        final ids = _idsFromPurchase(purchase);
        final verified = await verifyPurchaseWithBackend(
          purchaseToken: purchase.verificationData.serverVerificationData,
          productId: ids.productId,
          planId: ids.planId,
          orderId: _orderIdFromPurchase(purchase),
        );
        if (verified && txId != null) {
          _processedTransactionIds.add(txId);
          await _clearPendingPurchase();
        }
      }
    } catch (e) {
      log('acknowledgePendingPurchases error: $e');
    }
  }

  /// Actual Play Console product id for a plan tier + period.
  String getProductId(String planName, bool isMonthly) {
    final tier = planName.toLowerCase().trim();
    if (tier == 'free' || tier == 'trial') return '';
    return idsForSelection(tier: tier, isMonthly: isMonthly).productId;
  }

  static String playProductIdForTier(String tier, {bool isMonthly = true}) {
    final normalized = tier.toLowerCase().trim();
    if (normalized == 'free' || normalized == 'trial') return normalized;
    return idsForSelection(tier: normalized, isMonthly: isMonthly).productId;
  }

  /// Find the Google Play offer for [tier] + monthly/yearly base plan.
  iapandroidkit.GooglePlayProductDetails? findOfferForTier(String tier, {required bool isMonthly}) {
    return _resolveAndroidSubscription(tierOrProductId: tier, isMonthly: isMonthly);
  }

  /// Build UI plans from queried Google Play subscription products.
  ///
  /// Maps base-plan offers into monthly/annual prices per tier.
  List<PlanModel> buildPlansFromStore({bool includeProfessionalFields = false}) {
    // Keys: starter_monthly, starter_annual, plus_monthly, ...
    final storeMap = <String, ({String price, double rawPrice, String productId})>{};

    for (final product in products) {
      if (product is! iapandroidkit.GooglePlayProductDetails) continue;

      final tier = _extractTier(product.id) ?? _extractTier(_basePlanId(product) ?? '');
      if (tier == null) continue;

      final monthly = _isMonthlyOffer(product);
      final key = '${tier}_${monthly ? 'monthly' : 'annual'}';

      final existing = storeMap[key];
      // Prefer plain base-plan offers over promotional offers.
      if (existing == null || _isBasePlanOffer(product)) {
        storeMap[key] = (price: product.price, rawPrice: product.rawPrice, productId: product.id);
      }
    }

    log('Mapped store prices: ${storeMap.map((k, v) => MapEntry(k, v.price))}');

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

    final tier = (plan.tier ?? plan.planName ?? '').trim().toLowerCase();
    if (tier.isEmpty || tier == 'free' || tier == 'trial') {
      BaseSnackBar.show(
        title: 'Plan',
        message: 'Please select a paid subscription plan to continue.',
      );
      return;
    }

    final selectedIds = idsForSelection(tier: tier, isMonthly: isMonthly);
    final googleProduct = _resolveAndroidSubscription(
      tierOrProductId: tier,
      isMonthly: isMonthly,
      preferredProductId: selectedIds.productId,
    );
    if (googleProduct == null) {
      log('Subscription offer not found for tier=$tier isMonthly=$isMonthly');
      BaseSnackBar.show(
        title: 'Google Play',
        message:
            'This subscription is not available in Google Play right now. Please try again later.',
      );
      return;
    }

    final productId = googleProduct.id;
    final offerToken = googleProduct.offerToken;
    if (offerToken == null || offerToken.isEmpty) {
      log('Missing offerToken for subscription $productId');
      BaseSnackBar.show(
        title: 'Google Play',
        message: 'Unable to start this subscription offer. Please try again later.',
      );
      return;
    }

    userInitiatedPurchase = true;
    acceptEvents = true;
    intendedPurchaseProductId = productId;
    // Always verify with the mapped product_id + plan_id for this selection.
    intendedApiProductId = selectedIds.productId;
    intendedPlanId = selectedIds.planId;
    currentProductId =
        currentSubscription?.productId ?? currentSubscription?.planCode ?? currentSubscription?.id;
    currentPlanTier = getPlanTier(currentSubscription?.name);

    try {
      _showLoading();

      // Must acknowledge the current subscription before Play allows a plan change.
      await acknowledgePendingPurchases();

      final existingAndroidPurchase = await _findExistingAndroidSubscription(currentSubscription);

      if (existingAndroidPurchase != null) {
        if (existingAndroidPurchase.pendingCompletePurchase) {
          log('Old subscription pending completion. Acknowledging...');
          await _acknowledgePurchase(existingAndroidPurchase);
          await Future.delayed(const Duration(milliseconds: 500));
        }

        final currentTier = getPlanTier(currentSubscription?.name);
        final newTier = getPlanTier(plan.planName);
        final isDowngrade = newTier < currentTier;
        // Same-tier period change (monthly ↔ yearly): charge immediately.
        // True downgrades: defer until next renewal.
        final replacementMode = isDowngrade
            ? iapandroidbillingkit.ReplacementMode.deferred
            : iapandroidbillingkit.ReplacementMode.chargeFullPrice;

        log(
          'Google Play subscription change: '
          '${existingAndroidPurchase.productID} -> $productId '
          '(basePlan=${_basePlanId(googleProduct)}, '
          'mode=$replacementMode, offerToken=$offerToken)',
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
          'Google Play new subscription: $productId '
          '(basePlan=${_basePlanId(googleProduct)}, offerToken=$offerToken)',
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

  iapandroidkit.GooglePlayProductDetails? _resolveAndroidSubscription({
    required String tierOrProductId,
    required bool isMonthly,
    String? preferredProductId,
  }) {
    final tier =
        _extractTier(tierOrProductId) ??
        _extractTier(preferredProductId ?? '') ??
        tierOrProductId.toLowerCase().trim();

    final preferred = preferredProductId?.trim().toLowerCase();
    final matches = products.whereType<iapandroidkit.GooglePlayProductDetails>().where((p) {
      final pTier = _extractTier(p.id) ?? _extractTier(_basePlanId(p) ?? '');
      if (pTier != tier) return false;
      if (_isMonthlyOffer(p) != isMonthly) return false;
      if (preferred != null && preferred.isNotEmpty) {
        return p.id.toLowerCase() == preferred;
      }
      return true;
    }).toList();

    // Fallback if preferred SKU is missing but same tier/period exists.
    final fallbackMatches = matches.isNotEmpty
        ? matches
        : products.whereType<iapandroidkit.GooglePlayProductDetails>().where((p) {
            final pTier = _extractTier(p.id) ?? _extractTier(_basePlanId(p) ?? '');
            return pTier == tier && _isMonthlyOffer(p) == isMonthly;
          }).toList();

    if (fallbackMatches.isEmpty) return null;

    // Prefer plain base-plan offer (no promo offerId).
    return fallbackMatches.firstWhereOrNull(_isBasePlanOffer) ?? fallbackMatches.first;
  }

  String? _extractTier(String value) {
    final normalized = value.toLowerCase().trim().replaceAll('_', '-');
    if (normalized.isEmpty) return null;
    if (normalized.contains('starter')) return 'starter';
    if (normalized.contains('plus')) return 'plus';
    if (normalized.contains('pro')) return 'pro';
    return null;
  }

  bool _isMonthlyOffer(iapandroidkit.GooglePlayProductDetails product) {
    final basePlan = (_basePlanId(product) ?? '').toLowerCase();
    final productId = product.id.toLowerCase();
    final haystack = '$basePlan $productId';

    if (haystack.contains('year') || haystack.contains('annual') || haystack.contains('p1y')) {
      return false;
    }
    if (haystack.contains('month') ||
        haystack.contains('p1m') ||
        RegExp(r'(^|-)m($|-)').hasMatch(basePlan)) {
      return true;
    }
    // Fallback: if product id ends with _monthly and base plan unclear.
    return productId.contains('monthly') && !productId.contains('year');
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
    if (subscription == null) return candidates;

    void add(String? value) {
      final id = value?.trim().toLowerCase();
      if (id == null || id.isEmpty || id == 'free' || id == 'trial') return;
      candidates.add(id);
      candidates.add(id.replaceFirst('_yearly', '_annual'));
      candidates.add(id.replaceFirst('_annual', '_yearly'));
      final tier = _extractTier(id);
      if (tier != null) {
        candidates.add(tier);
        candidates.add(playProductIdForTier(tier, isMonthly: true));
        candidates.add(playProductIdForTier(tier, isMonthly: false));
      }
    }

    add(subscription.productId);
    add(subscription.planCode);
    add(subscription.id);
    add(subscription.name);
    add(getProductId(subscription.name ?? '', true));
    add(getProductId(subscription.name ?? '', false));
    return candidates;
  }

  Future<iapandroidkit.GooglePlayPurchaseDetails?> _findExistingAndroidSubscription(
    SubscriptionStatusUiModel? currentSubscription,
  ) async {
    try {
      final androidAddition = _iapConnection
          .getPlatformAddition<iapandroidkit.InAppPurchaseAndroidPlatformAddition>();
      final pastPurchasesResponse = await androidAddition.queryPastPurchases();
      final past = pastPurchasesResponse.pastPurchases;
      if (past.isEmpty) return null;

      // Acknowledge first — Play blocks plan changes until this is done.
      for (final purchase in past) {
        await _acknowledgePurchase(purchase);
      }

      final candidates = _candidateProductIds(currentSubscription);
      if (candidates.isNotEmpty) {
        for (final purchase in past) {
          final productId = purchase.productID.toLowerCase();
          if (candidates.contains(productId) ||
              candidates.any((id) => productId.endsWith(id) || id.endsWith(productId))) {
            return purchase;
          }
        }
      }

      // Fallback when backend subscription metadata is missing/stale.
      if (past.length == 1) return past.first;
      return past.firstWhereOrNull(
            (p) => p.status == PurchaseStatus.purchased || p.status == PurchaseStatus.restored,
          ) ??
          past.first;
    } catch (e) {
      log('queryPastPurchases error: $e');
    }
    return null;
  }

  /// Restore Google Play subscriptions
  Future<void> restorePurchases() async {
    if (!Platform.isAndroid) {
      BaseSnackBar.show(title: 'Google Play', message: 'Restore is available on Android only.');
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
    intendedApiProductId = null;
    intendedPlanId = null;
    acceptEvents = false;
  }

  /// Resolve product_id + plan_id from a Play purchase / SKU.
  ({String productId, String planId}) _idsFromPurchase(PurchaseDetails purchase) {
    if (intendedApiProductId != null &&
        intendedPlanId != null &&
        (intendedPurchaseProductId == null || purchase.productID == intendedPurchaseProductId)) {
      return (productId: intendedApiProductId!, planId: intendedPlanId!);
    }

    final playSku = purchase.productID;
    final tier = _extractTier(playSku) ?? 'starter';
    var isMonthly = true;

    final matches = products.whereType<iapandroidkit.GooglePlayProductDetails>().where(
      (p) => p.id == playSku,
    );
    for (final product in matches) {
      isMonthly = _isMonthlyOffer(product);
      break;
    }
    if (matches.isEmpty) {
      final sku = playSku.toLowerCase();
      isMonthly = !(sku.contains('year') || sku.contains('annual'));
      // starter yearly uses product id `starter` (no monthly in id).
      if (sku == 'starter') isMonthly = false;
      if (sku == 'starter_monthly') isMonthly = true;
    }

    return idsForSelection(tier: tier, isMonthly: isMonthly);
  }

  String? _orderIdFromPurchase(PurchaseDetails purchase) {
    if (purchase is iapandroidkit.GooglePlayPurchaseDetails) {
      final orderId = purchase.billingClientPurchase.orderId;
      if (orderId.trim().isNotEmpty) return orderId;
    }
    return purchase.purchaseID;
  }

  void _showLoading() {
    ApiRepository.instance.showLoader();
  }

  void _hideLoading() {
    ApiRepository.instance.hideLoader();
  }

  Future<void> _cachePendingPurchase(PurchaseDetails details, {String? overrideProductId}) async {
    try {
      final ids = _idsFromPurchase(details);
      final apiProductId = overrideProductId ?? ids.productId;
      final planId = ids.planId;
      final orderId = _orderIdFromPurchase(details);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _pendingPurchaseKey,
        jsonEncode({
          'productId': apiProductId,
          'product_id': apiProductId,
          'planId': planId,
          'plan_id': planId,
          'playProductId': details.productID,
          'orderId': orderId,
          'purchaseId': details.purchaseID,
          'transactionDate': details.transactionDate,
          'serverVerificationData': details.verificationData.serverVerificationData,
          'platform': 'android',
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      log('Pending subscription cached for product_id=$apiProductId plan_id=$planId');
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
      // Always clear Play acknowledgment backlog first (blocks upgrades otherwise).
      await setupInAppPurchase();
      await acknowledgePendingPurchases();

      final prefs = await SharedPreferences.getInstance();
      final pendingJson = prefs.getString(_pendingPurchaseKey);
      if (pendingJson == null) return;

      log('Found pending subscription — attempting recovery...');
      final data = jsonDecode(pendingJson) as Map<String, dynamic>;
      final productId = (data['product_id'] as String?) ?? (data['productId'] as String?) ?? '';
      final purchaseToken = data['serverVerificationData'] as String;
      final planId =
          (data['plan_id'] as String?) ??
          (data['planId'] as String?) ??
          (data['basePlanId'] as String?) ??
          '';
      final orderId = (data['orderId'] as String?) ?? (data['purchaseId'] as String?);

      final verified = await verifyPurchaseWithBackend(
        purchaseToken: purchaseToken,
        productId: productId,
        planId: planId,
        orderId: orderId,
      );

      if (verified) {
        await _clearPendingPurchase();
        // Refresh status from GET api/v1/plans/subscriptions/me
        await _refreshSubscriptionStatusAfterPurchase();
        log('Pending subscription activated and verified!');
      } else {
        log('Pending purchase verification failed — will retry next open');
      }
    } catch (e) {
      log('Pending purchase recovery error: $e');
    }
  }

  /// Builds the POST body for `api/v1/plans/subscriptions/verify`.
  ///
  /// Exposed for unit tests / request inspection.
  static Map<String, dynamic>? buildVerifyRequestBody({
    required String purchaseToken,
    required String productId,
    required String planId,
    String? orderId,
  }) {
    final resolvedProductId = productId.trim();
    final resolvedPlanId = planId.trim();
    if (resolvedProductId.isEmpty || resolvedPlanId.isEmpty) {
      return null;
    }

    return <String, dynamic>{
      'purchaseToken': purchaseToken,
      'productId': resolvedProductId,
      'basePlanId': resolvedPlanId,
      if (orderId != null && orderId.trim().isNotEmpty) 'orderId': orderId.trim(),
    };
  }

  /// Builds verify request from UI selection (tier + monthly/yearly).
  static Map<String, dynamic>? buildVerifyRequestForSelection({
    required String tier,
    required bool isMonthly,
    required String purchaseToken,
    String? orderId,
  }) {
    final ids = idsForSelection(tier: tier, isMonthly: isMonthly);
    return buildVerifyRequestBody(
      purchaseToken: purchaseToken,
      productId: ids.productId,
      planId: ids.planId,
      orderId: orderId,
    );
  }

  /// Verify Google Play purchase with backend after payment.
  ///
  /// POST `api/v1/plans/subscriptions/verify`
  /// Body always includes selected product_id + plan_id, e.g.:
  /// - starter_monthly / stater-monthly
  /// - starter / stater-yearly
  /// - plus / plus-monthly | plus-yearly
  /// - pro / pro-monthly | pro-yearly
  Future<bool> verifyPurchaseWithBackend({
    required String purchaseToken,
    required String productId,
    required String planId,
    String? orderId,
  }) async {
    try {
      final body = buildVerifyRequestBody(
        purchaseToken: purchaseToken,
        productId: productId,
        planId: planId,
        orderId: orderId,
      );
      if (body == null) {
        log('Verify skipped — missing product_id/plan_id');
        return false;
      }

      log('Subscription verify body => $body');
      final response = await ApiRepository.instance.post(
        _verifySubscriptionUrl,
        body: body,
        showDefaultLoader: false,
        showRunTimeError: false,
      );

      if (response != null &&
          (response['success'] == true ||
              response['statusCode'] == 200 ||
              response['statusCode'] == 201)) {
        return true;
      } else {
        // log('Backend verification failed: $response');
        return false;
      }
    } catch (e) {
      log('Backend verification error: $e');
      return false;
    }
  }

  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    try {
      for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
        log(
          'Subscription update: ${purchaseDetails.productID} '
          'status=${purchaseDetails.status} '
          'pendingComplete=${purchaseDetails.pendingCompletePurchase} '
          'acceptEvents=$acceptEvents',
        );

        final String? txId = purchaseDetails.purchaseID;
        if (txId != null && _processedTransactionIds.contains(txId)) {
          // Still ack if Play re-emits an already-processed purchase.
          await _acknowledgePurchase(purchaseDetails);
          log('Duplicate transaction ignored: $txId');
          continue;
        }

        switch (purchaseDetails.status) {
          case PurchaseStatus.canceled:
          case PurchaseStatus.error:
            await _acknowledgePurchase(purchaseDetails);
            if (acceptEvents) {
              _hideLoading();
              _resetPurchaseState();
            }
            break;

          case PurchaseStatus.pending:
            break;

          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            // Always cache + verify + acknowledge — even when UI flow timed out /
            // is inactive — so entitlement sync and Play acknowledgment never drop.
            await _handleSuccessfulPurchaseOrRestore(
              purchaseDetails,
              showUiFeedback: acceptEvents || userInitiatedPurchase,
            );
            break;
        }
      }
    } catch (e) {
      log('Error in _listenToPurchaseUpdated: $e');
    }
  }

  Future<void> _handleSuccessfulPurchaseOrRestore(
    PurchaseDetails purchaseDetails, {
    bool showUiFeedback = true,
  }) async {
    try {
      if (userInitiatedPurchase && intendedPurchaseProductId != null) {
        if (purchaseDetails.productID != intendedPurchaseProductId) {
          final bool isAndroidDowngrade =
              currentProductId != null &&
              (purchaseDetails.productID == currentProductId ||
                  purchaseDetails.productID.toLowerCase() == currentProductId!.toLowerCase());
          if (!isAndroidDowngrade) {
            log('Ignoring older product: ${purchaseDetails.productID}');
            await _acknowledgePurchase(purchaseDetails);
            return;
          }
        }
      }

      // Cache before ack so recovery can re-verify if the process dies.
      await _cachePendingPurchase(purchaseDetails);

      final ids = _idsFromPurchase(purchaseDetails);
      final verified = await verifyPurchaseWithBackend(
        purchaseToken: purchaseDetails.verificationData.serverVerificationData,
        productId: ids.productId,
        planId: ids.planId,
        orderId: _orderIdFromPurchase(purchaseDetails),
      );

      // Always acknowledge with Play so plan changes are not blocked.
      await _acknowledgePurchase(purchaseDetails);

      if (showUiFeedback) {
        _hideLoading();
        _resetPurchaseState();
      }

      if (verified) {
        await _clearPendingPurchase();
        if (purchaseDetails.purchaseID != null) {
          _processedTransactionIds.add(purchaseDetails.purchaseID!);
        }

        await _refreshSubscriptionStatusAfterPurchase();

        if (showUiFeedback) {
          BaseSnackBar.show(title: 'Success', message: 'Subscription activated successfully.');
          _navigateAfterSuccessfulPurchase();
        }
      } else if (showUiFeedback) {
        BaseSnackBar.show(
          title: 'Verification Pending',
          message: 'Purchase completed, but verification is pending. It will retry automatically.',
        );
      }
    } catch (e) {
      log('Error handling subscription purchase: $e');
      await _acknowledgePurchase(purchaseDetails);
      if (showUiFeedback) {
        _hideLoading();
        _resetPurchaseState();
      }
    }
  }

  /// Pull latest subscription status via GET api/v1/plans/subscriptions/me
  Future<void> _refreshSubscriptionStatusAfterPurchase() async {
    if (!Get.isRegistered<SettingsViewModel>()) return;
    try {
      await Get.find<SettingsViewModel>().getSubscriptionDetail();
    } catch (e) {
      log('Post-purchase status refresh error: $e');
    }
  }

  void _navigateAfterSuccessfulPurchase() {
    if (!Get.isRegistered<SettingsViewModel>()) {
      Get.until((route) => route.settings.name == Routes.dashboard);
      return;
    }
    final isProfessional = Get.find<SettingsViewModel>().screenType.value == AppKeys.professional;
    final target = isProfessional ? Routes.professionalDashboard : Routes.dashboard;
    if (Get.currentRoute == target) return;
    Get.until(
      (route) =>
          route.settings.name == target ||
          route.settings.name == Routes.dashboard ||
          route.settings.name == Routes.professionalDashboard,
    );
  }
}
