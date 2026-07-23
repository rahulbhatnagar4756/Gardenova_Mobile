import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
// Razorpay subscription (disabled — Google Play Billing only)
// import 'package:flutter/material.dart';
// import 'package:kasagardem/professional/payment/razorpay_payment_repository.dart';
import 'package:kasagardem/professional/upgradePlans/model/plan_model.dart';
// import 'package:kasagardem/professional/upgradePlans/upgrade_plan_repository.dart';
// import 'package:kasagardem/services/alternate_billing_service.dart';
// import 'package:kasagardem/services/razorpay_payment_service.dart';
import 'package:kasagardem/services/subscription_service.dart';
import 'package:kasagardem/settings/model/subscription_local_status_ui_model.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class UserSubscriptionController extends GetxController {
  RxBool isTabMonthly = true.obs;
  RxString selectedPrice = ''.obs;
  RxString remainingDays = ''.obs;
  // getplans API disabled — plans load from Google Play Billing.
  // final UpgradePlanRepository _repository = UpgradePlanRepository();
  // final RazorpayPaymentRepository _razorpayRepository = RazorpayPaymentRepository();
  RxList<PlanModel> planList = <PlanModel>[].obs;
  PlanModel? selectedPlanData;
  RxBool isLoading = false.obs;
  RxBool isProcessingPayment = false.obs;
  SubscriptionStatusUiModel? currentModel;
  // String? _activeSubscriptionId;

  @override
  void onInit() {
    // Razorpay alternate billing disabled — Google Play Billing only.
    // if (Platform.isAndroid) {
    //   AlternateBillingService.prepareIfAvailable();
    // }
    initIAP();
    _readArguments();
    callGetAllPlanListApi();

    super.onInit();
  }

  void _readArguments() {
    if (Get.arguments is SubscriptionStatusUiModel) {
      currentModel = Get.arguments as SubscriptionStatusUiModel;

      print(currentModel!.toJson());
      _setRemainingDaysFromModel(currentModel);
      _applyBillingCycleFromSubscription();
      return;
    }

    if (Get.isRegistered<SettingsViewModel>()) {
      currentModel = Get.find<SettingsViewModel>().currentSubscriptionStatusModel.value;
      if (currentModel != null) {
        _setRemainingDaysFromModel(currentModel);
        _applyBillingCycleFromSubscription();
        return;
      }
    }

    if (Get.arguments is Map) {
      _setRemainingDaysFromPrefs();
      return;
    }

    _setRemainingDaysFromPrefs();
  }

  void _applyBillingCycleFromSubscription() {
    final cycle = (currentModel?.billingCycle ?? '').trim().toLowerCase();
    if (cycle.isEmpty) return;

    final isMonthly = cycle == 'monthly' || cycle == 'month' || cycle == 'mo';
    isTabMonthly.value = isMonthly;
  }

  void _setRemainingDaysFromModel(SubscriptionStatusUiModel? model) {
    if (model?.updatedAt == null) {
      remainingDays.value = '0';
      return;
    }

    try {
      final expirationDate = DateTime.parse(model!.updatedAt!).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final exp = DateTime(expirationDate.year, expirationDate.month, expirationDate.day);
      remainingDays.value = exp.difference(today).inDays.clamp(0, 365).toString();
    } catch (_) {
      remainingDays.value = '0';
    }
  }

  void _setRemainingDaysFromPrefs() {
    remainingDays.value = SharedPrefsService.instance.getString(AppKeys.remainingDays) ?? '0';
  }

  void changeTab(bool value) {
    if (isTabMonthly.value == value) return;

    isTabMonthly.value = value;

    // Subscribed users: only keep the subscribed plan selected, and only on
    // the billing period they are actually subscribed to.
    if (_hasActiveSubscription) {
      for (final plan in planList) {
        plan.setSelect = false;
      }
      selectedPlanData = null;
      selectedPrice.value = '';

      if (isTabMonthly.value == _isSubscribedToMonthly) {
        final subscribedPlan = _findSubscribedPlan();
        if (subscribedPlan != null) {
          subscribedPlan.setSelect = true;
          selectedPlanData = subscribedPlan;
          _updateSelectedPrice(subscribedPlan);
        }
      }
      planList.refresh();
      return;
    }

    for (final plan in planList) {
      plan.setSelect = false;
    }
    selectedPlanData = null;
    selectedPrice.value = '';
    planList.refresh();
  }

  void selectPlan(PlanModel plan) {
    // Keep current selection until the user taps a different plan.
    if (plan.isSelect == true) {
      selectedPlanData = plan;
      _updateSelectedPrice(plan);
      return;
    }

    for (final item in planList) {
      item.setSelect = item == plan;
    }
    selectedPlanData = plan;
    _updateSelectedPrice(plan);
    planList.refresh();
  }

  void _updateSelectedPrice(PlanModel plan) {
    selectedPrice.value = isTabMonthly.value
        ? '${plan.priceMonthly ?? '0'}/mo'
        : '${plan.priceAnnual ?? '0'}/an';
  }

  void goToOrderSummary() {
    final selectedPlan = planList.firstWhereOrNull((plan) => plan.isSelect == true);
    if (selectedPlan == null) {
      BaseSnackBar.show(title: 'Plan', message: 'Please select a plan');
      return;
    }

    selectedPlanData = selectedPlan;
    Get.toNamed(Routes.userOrderSummary);
  }

  double getOrderTotalAmount() {
    final plan = selectedPlanData;
    if (plan == null) return 0;

    final basePriceStr = (isTabMonthly.value ? plan.priceMonthly : plan.priceAnnual) ?? '0';
    return double.tryParse(basePriceStr.replaceAll(',', '').replaceAll(' ', '')) ?? 0.0;
  }

  // ---------------------------------------------------------------------------
  // Razorpay subscription (disabled — Google Play Billing only)
  // ---------------------------------------------------------------------------
  // Future<void> startRazorpayPayment() async {
  //   final plan = selectedPlanData;
  //   if (plan == null) {
  //     BaseSnackBar.show(title: 'Plan', message: 'Please select a plan');
  //     return;
  //   }
  //
  //   if (isLoading.value || isProcessingPayment.value) return;
  //
  //   final planCode = plan.resolvePlanCode(isMonthly: isTabMonthly.value);
  //   if (planCode.isEmpty || planCode == 'free') {
  //     BaseSnackBar.show(
  //       title: 'Plan',
  //       message: 'Please select a paid plan to continue.',
  //     );
  //     return;
  //   }
  //
  //   final accepted = await _showAlternateBillingDisclosure();
  //   if (!accepted) return;
  //
  //   isLoading.value = true;
  //   try {
  //     await AlternateBillingService.prepareIfAvailable();
  //     final externalTransactionToken =
  //         await AlternateBillingService.getExternalTransactionToken();
  //
  //     RazorpayPaymentService.instance.initialize(
  //       onSuccess: _onRazorpayPaymentSuccess,
  //       onFailure: _onRazorpayPaymentFailure,
  //     );
  //
  //     final orderResponse = await _razorpayRepository.createOrder(
  //       planCode,
  //       externalTransactionToken: externalTransactionToken,
  //     );
  //     if (orderResponse?.success != true ||
  //         orderResponse?.data?.subscriptionId == null) {
  //       return;
  //     }
  //
  //     final order = orderResponse!.data!;
  //     _activeSubscriptionId = order.subscriptionId;
  //     isProcessingPayment.value = true;
  //     if (order.scheduled == true) {
  //       BaseSnackBar.show(
  //         title: 'Payment',
  //         message: 'Subscription verified successfully.',
  //       );
  //       Get.until((route) => route.settings.name == Routes.dashboard);
  //     } else {
  //       RazorpayPaymentService.instance.openSubscriptionCheckout(
  //         subscriptionId: order.subscriptionId!,
  //         keyIdOverride: order.keyId,
  //         name: _userName(),
  //         email: _userEmail(),
  //         contact: _userContact(),
  //         description:
  //             '${plan.planName ?? 'Plan'} - ${isTabMonthly.value ? 'Monthly' : 'Annually'}',
  //       );
  //     }
  //   } catch (e) {
  //     log('Razorpay startPayment error: $e');
  //     BaseSnackBar.show(
  //       title: 'Payment',
  //       message: e is StateError ? e.message : 'Unable to start payment.',
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  // Future<bool> _showAlternateBillingDisclosure() async { ... }
  // Future<void> _onRazorpayPaymentSuccess(PaymentSuccessResponse response) async { ... }
  // void _onRazorpayPaymentFailure(PaymentFailureResponse response) { ... }
  // String? _subscriptionIdFromResponse(PaymentSuccessResponse response) { ... }
  // void _persistSubscriptionId(String? subscriptionId) { ... }
  // String? _userName() { ... }
  // String? _userEmail() { ... }
  // String? _userContact() { ... }

  Future<void> callGetAllPlanListApi() async {
    isLoading.value = true;

    // Commented getplans API — plans come from Google Play Billing / App Store.
    // final response = await _repository.getPlanList();
    // if (response != null) {
    //   final planResponse = PlansResponseModel.fromJson(response);
    //   planList
    //     ..clear()
    //     ..addAll(PlanModel.consolidateByTier(planResponse.data ?? []));
    // }

    await SubscriptionService.instance.setupInAppPurchase();
    planList
      ..clear()
      ..addAll(SubscriptionService.instance.buildPlansFromStore());

    if (planList.isEmpty) {
      BaseSnackBar.show(
        title: 'Google Play',
        message: 'Unable to load subscription plans from the store.',
      );
    }

    setSelectedPlan();
    updateStorePrices();
    isLoading.value = false;
  }

  Future<void> initIAP() async {
    await SubscriptionService.instance.setupInAppPurchase();
    updateStorePrices();
  }

  void updateStorePrices() {
    if (!SubscriptionService.instance.isAvailable ||
        SubscriptionService.instance.products.isEmpty) {
      return;
    }

    for (final plan in planList) {
      final monthlyProdId = SubscriptionService.instance.getProductId(plan.planName ?? '', true);
      final annualProdId = SubscriptionService.instance.getProductId(plan.planName ?? '', false);

      if (monthlyProdId.isNotEmpty) {
        final monthlyProduct = SubscriptionService.instance.products.firstWhereOrNull(
          (p) => p.id == monthlyProdId,
        );
        if (monthlyProduct != null) {
          plan.priceMonthly = monthlyProduct.rawPrice.toInt().toString();
        }
      }

      if (annualProdId.isNotEmpty) {
        final annualProduct = SubscriptionService.instance.products.firstWhereOrNull(
          (p) => p.id == annualProdId,
        );
        if (annualProduct != null) {
          plan.priceAnnual = annualProduct.rawPrice.toInt().toString();
        }
      }
    }

    planList.refresh();
  }

  /// Google Play Billing subscription purchase (Android only).
  Future<void> startPurchaseFlow() async {
    final plan = selectedPlanData;
    if (plan == null) {
      BaseSnackBar.show(title: 'Plan', message: 'Please select a plan');
      return;
    }

    if (isLoading.value || isProcessingPayment.value) return;

    if (!Platform.isAndroid) {
      BaseSnackBar.show(
        title: 'Google Play',
        message: 'Subscriptions are available on Android via Google Play only.',
      );
      return;
    }

    if (!SubscriptionService.instance.isAvailable) {
      BaseSnackBar.show(
        title: 'Google Play',
        message:
            'Play Store billing is not available on this device. Please try again on a device with Google Play.',
      );
      return;
    }

    // Sync latest subscription before upgrade/downgrade matching.
    if (Get.isRegistered<SettingsViewModel>()) {
      currentModel =
          Get.find<SettingsViewModel>().currentSubscriptionStatusModel.value ??
          currentModel;
    }

    isLoading.value = true;
    isProcessingPayment.value = true;
    try {
      await SubscriptionService.instance.buyPlan(
        plan,
        isTabMonthly.value,
        currentModel,
      );
    } catch (e) {
      log('Google Play subscription error: $e');
      BaseSnackBar.show(
        title: 'Payment',
        message: 'Unable to start Google Play subscription.',
      );
    } finally {
      isLoading.value = false;
      isProcessingPayment.value = false;
    }
  }

  void setSelectedPlan() {
    if (!_hasActiveSubscription) return;

    _applyBillingCycleFromSubscription();

    final subscribedPlan = _findSubscribedPlan();
    if (subscribedPlan == null) return;

    for (final plan in planList) {
      plan.setSelect = false;
    }
    subscribedPlan.setSelect = true;
    selectedPlanData = subscribedPlan;
    _updateSelectedPrice(subscribedPlan);
    planList.refresh();
  }

  bool get _hasActiveSubscription {
    final model = currentModel;
    if (model == null) return false;
    if (model.isActive == true) return true;

    final status = (model.status ?? '').trim().toLowerCase();
    return status == 'active' ||
        status == 'renewed' ||
        status == 'cancelled' ||
        status == 'canceled';
  }

  bool get _isSubscribedToMonthly {
    final cycle = (currentModel?.billingCycle ?? '').trim().toLowerCase();
    if (cycle.isEmpty) return true;
    return cycle == 'monthly' || cycle == 'month' || cycle == 'mo';
  }

  /// True when [plan] is the user's active subscription on the current billing tab.
  bool isCurrentSubscribedPlan(PlanModel plan) {
    if (!_hasActiveSubscription) return false;
    if (isTabMonthly.value != _isSubscribedToMonthly) return false;

    final subscribedPlan = _findSubscribedPlan();
    if (subscribedPlan == null) return false;

    return identical(plan, subscribedPlan) ||
        plan.id == subscribedPlan.id ||
        ((plan.tier ?? '').toLowerCase() == (subscribedPlan.tier ?? '').toLowerCase());
  }

  PlanModel? _findSubscribedPlan() {
    final model = currentModel;
    if (model == null) return null;

    final planId = model.id?.trim();
    if (planId != null && planId.isNotEmpty) {
      final byId = planList.firstWhereOrNull(
        (plan) => plan.id == planId || plan.monthlyId == planId || plan.yearlyId == planId,
      );
      if (byId != null) return byId;
    }

    final planName = (model.name ?? '').trim().toLowerCase();
    if (planName.isEmpty || planName == 'free' || planName == 'trial') {
      return null;
    }

    return planList.firstWhereOrNull((plan) {
      final tier = (plan.tier ?? '').trim().toLowerCase();
      final name = (plan.planName ?? '').trim().toLowerCase();
      return tier == planName || name == planName;
    });
  }

  @override
  void onClose() {
    // RazorpayPaymentService.instance.dispose();
    super.onClose();
  }
}
