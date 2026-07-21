import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/professional/payment/razorpay_payment_repository.dart';
import 'package:kasagardem/professional/upgradePlans/model/plan_model.dart';
import 'package:kasagardem/professional/upgradePlans/upgrade_plan_repository.dart';
import 'package:kasagardem/services/alternate_billing_service.dart';
import 'package:kasagardem/services/razorpay_payment_service.dart';
import 'package:kasagardem/services/subscription_service.dart';
import 'package:kasagardem/settings/model/subscription_local_status_ui_model.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class UserSubscriptionController extends GetxController {
  RxBool isTabMonthly = true.obs;
  RxString selectedPrice = ''.obs;
  RxString remainingDays = ''.obs;
  final UpgradePlanRepository _repository = UpgradePlanRepository();
  final RazorpayPaymentRepository _razorpayRepository = RazorpayPaymentRepository();
  RxList<PlanModel> planList = <PlanModel>[].obs;
  PlanModel? selectedPlanData;
  RxBool isLoading = false.obs;
  RxBool isProcessingPayment = false.obs;
  SubscriptionStatusUiModel? currentModel;
  String? _activeSubscriptionId;

  @override
  void onInit() {
    if (Platform.isAndroid) {
      AlternateBillingService.prepareIfAvailable();
    }
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

  Future<void> startRazorpayPayment() async {
    final plan = selectedPlanData;
    if (plan == null) {
      BaseSnackBar.show(title: 'Plan', message: 'Please select a plan');
      return;
    }

    if (isLoading.value || isProcessingPayment.value) return;

    final planCode = plan.resolvePlanCode(isMonthly: isTabMonthly.value);
    if (planCode.isEmpty || planCode == 'free') {
      BaseSnackBar.show(
        title: 'Plan',
        message: 'Please select a paid plan to continue.',
      );
      return;
    }

    final accepted = await _showAlternateBillingDisclosure();
    if (!accepted) return;

    isLoading.value = true;
    try {
      await AlternateBillingService.prepareIfAvailable();
      final externalTransactionToken =
          await AlternateBillingService.getExternalTransactionToken();

      RazorpayPaymentService.instance.initialize(
        onSuccess: _onRazorpayPaymentSuccess,
        onFailure: _onRazorpayPaymentFailure,
      );

      final orderResponse = await _razorpayRepository.createOrder(
        planCode,
        externalTransactionToken: externalTransactionToken,
      );
      if (orderResponse?.success != true ||
          orderResponse?.data?.subscriptionId == null) {
        return;
      }

      final order = orderResponse!.data!;
      _activeSubscriptionId = order.subscriptionId;
      isProcessingPayment.value = true;
      if (order.scheduled == true) {
        BaseSnackBar.show(
          title: 'Payment',
          message: 'Subscription verified successfully.',
        );
        Get.until((route) => route.settings.name == Routes.dashboard);
      } else {
        RazorpayPaymentService.instance.openSubscriptionCheckout(
          subscriptionId: order.subscriptionId!,
          keyIdOverride: order.keyId,
          name: _userName(),
          email: _userEmail(),
          contact: _userContact(),
          description:
              '${plan.planName ?? 'Plan'} - ${isTabMonthly.value ? 'Monthly' : 'Annually'}',
        );
      }
    } catch (e) {
      log('Razorpay startPayment error: $e');
      BaseSnackBar.show(
        title: 'Payment',
        message: e is StateError ? e.message : 'Unable to start payment.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _showAlternateBillingDisclosure() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'External payment',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Payments are processed securely via Razorpay. This purchase is not managed by Google Play.',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color(0xFF6B7280),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'Continue',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.greenColor,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return result == true;
  }

  Future<void> _onRazorpayPaymentSuccess(PaymentSuccessResponse response) async {
    isProcessingPayment.value = false;
    isLoading.value = true;

    try {
      final plan = selectedPlanData;
      final planCode = plan?.resolvePlanCode(isMonthly: isTabMonthly.value) ?? '';
      final subscriptionId = _subscriptionIdFromResponse(response);

      final verifyResponse = await _razorpayRepository.verifyPayment({
        if (subscriptionId != null) 'razorpay_subscription_id': subscriptionId,
        'razorpay_payment_id': response.paymentId,
        if (response.signature != null) 'razorpay_signature': response.signature,
        'planCode': planCode,
        'billing_provider': 'alternate',
        'billing_period': isTabMonthly.value ? 'monthly' : 'yearly',
      });

      if (verifyResponse?.success == true) {
        _persistSubscriptionId(subscriptionId);
        if (Get.isRegistered<SettingsViewModel>()) {
          final settingsViewModel = Get.find<SettingsViewModel>();
          settingsViewModel.persistRazorpaySubscriptionId(subscriptionId);
          settingsViewModel.getProfileDetail();
          settingsViewModel.getSubscriptionDetail();
        }
        BaseSnackBar.show(
          title: 'Success',
          message: verifyResponse?.message ?? 'Payment completed successfully.',
        );
        Get.until((route) => route.settings.name == Routes.dashboard);
        return;
      }

      BaseSnackBar.show(
        title: 'Verification Pending',
        message: verifyResponse?.message ?? 'Payment received. Verification is pending.',
      );
    } catch (e) {
      log('Razorpay verify error: $e');
      BaseSnackBar.show(
        title: 'Verification',
        message: 'Payment completed, but verification failed.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _onRazorpayPaymentFailure(PaymentFailureResponse response) {
    isProcessingPayment.value = false;
    isLoading.value = false;

    if (response.code == Razorpay.PAYMENT_CANCELLED) {
      BaseSnackBar.show(title: 'Payment', message: 'Payment was cancelled.');
      return;
    }

    BaseSnackBar.show(
      title: 'Payment Failed',
      message: response.message ?? 'Something went wrong. Please try again.',
    );
  }

  String? _subscriptionIdFromResponse(PaymentSuccessResponse response) {
    final fromData = response.data?['razorpay_subscription_id']?.toString();
    if (fromData != null && fromData.isNotEmpty) return fromData;
    if (response.orderId != null && response.orderId!.isNotEmpty) {
      return response.orderId;
    }
    return _activeSubscriptionId;
  }

  void _persistSubscriptionId(String? subscriptionId) {
    if (subscriptionId == null || subscriptionId.isEmpty) return;
    SharedPrefsService.instance.setString(AppKeys.razorpaySubscriptionId, subscriptionId);
  }

  String? _userName() {
    final name = SharedPrefsService.instance.getString(AppKeys.name);
    return name?.trim().isNotEmpty == true ? name : null;
  }

  String? _userEmail() {
    final email = SharedPrefsService.instance.getString(AppKeys.email);
    return email?.trim().isNotEmpty == true ? email : null;
  }

  String? _userContact() {
    if (Get.isRegistered<SettingsViewModel>()) {
      final phone = Get.find<SettingsViewModel>().phoneNoController.text.trim();
      if (phone.isNotEmpty) return phone;
    }
    return null;
  }

  Future<void> callGetAllPlanListApi() async {
    isLoading.value = true;
    final response = await _repository.getPlanList();

    if (response != null) {
      final planResponse = PlansResponseModel.fromJson(response);
      planList
        ..clear()
        ..addAll(PlanModel.consolidateByTier(planResponse.data ?? []));
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

  Future<void> startPurchaseFlow() async {
    final plan = selectedPlanData;
    if (plan == null) {
      BaseSnackBar.show(title: 'Plan', message: 'Please select a plan');
      return;
    }

    if (Platform.isAndroid) {
      await startRazorpayPayment();
      return;
    }

    isLoading.value = true;
    try {
      await SubscriptionService.instance.buyPlan(plan, isTabMonthly.value, currentModel);
    } catch (_) {
    } finally {
      isLoading.value = false;
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
    RazorpayPaymentService.instance.dispose();
    super.onClose();
  }
}
