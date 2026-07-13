import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_calculate_remaining_days.dart';
import 'package:kasagardem/professional/payment/razorpay_payment_repository.dart';
import 'package:kasagardem/professional/upgradePlans/model/plan_model.dart';
import 'package:kasagardem/professional/upgradePlans/upgrade_plan_repository.dart';
import 'package:kasagardem/services/alternate_billing_service.dart';
import 'package:kasagardem/services/razorpay_payment_service.dart';
import 'package:kasagardem/services/subscription_service.dart';
import 'package:kasagardem/settings/model/subscription_local_status_ui_model.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
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
  final RazorpayPaymentRepository _razorpayRepository =
      RazorpayPaymentRepository();
  RxList<PlanModel> planList = <PlanModel>[].obs;
  PlanModel? selectedPlanData;
  RxBool isLoading = false.obs;
  RxBool isProcessingPayment = false.obs;
  SubscriptionStatusUiModel? currentModel;
  String? _activeSubscriptionId;
  String? _externalTransactionToken;

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
      _setRemainingDaysFromModel(currentModel);
      return;
    }

    if (Get.arguments is Map) {
      _setRemainingDaysFromPrefs();
      return;
    }

    _setRemainingDaysFromPrefs();
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
      final exp = DateTime(
        expirationDate.year,
        expirationDate.month,
        expirationDate.day,
      );
      remainingDays.value = exp.difference(today).inDays.clamp(0, 365).toString();
    } catch (_) {
      remainingDays.value = '0';
    }
  }

  void _setRemainingDaysFromPrefs() {
    remainingDays.value =
        SharedPrefsService.instance.getString(AppKeys.remainingDays) ?? '0';
  }

  void changeTab(bool value) {
    isTabMonthly.value = value;
    selectedPrice.value = '';
    for (final plan in planList) {
      plan.setSelect = false;
    }
    planList.refresh();
  }

  void selectPlan(PlanModel plan) {
    for (final item in planList) {
      item.setSelect = item == plan;
    }
    selectedPrice.value = isTabMonthly.value
        ? '${plan.priceMonthly!}/mo'
        : '${plan.priceAnnual!}/an';
    planList.refresh();
    selectedPlanData = null;
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

    final basePriceStr =
        (isTabMonthly.value ? plan.priceMonthly : plan.priceAnnual) ?? '0';
    return double.tryParse(
          basePriceStr.replaceAll(',', '').replaceAll(' ', ''),
        ) ??
        0.0;
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

    isLoading.value = true;
    try {
      await AlternateBillingService.prepareIfAvailable();
      _externalTransactionToken =
          await AlternateBillingService.getExternalTransactionToken();

      RazorpayPaymentService.instance.initialize(
        onSuccess: _onRazorpayPaymentSuccess,
        onFailure: _onRazorpayPaymentFailure,
      );

      final orderResponse = await _razorpayRepository.createOrder(
        planCode,
        externalTransactionToken: _externalTransactionToken,
      );
      if (orderResponse?.success != true ||
          orderResponse?.data?.subscriptionId == null) {
        BaseSnackBar.show(
          title: 'Payment',
          message: orderResponse?.message ?? 'Failed to create subscription.',
        );
        return;
      }

      final order = orderResponse!.data!;
      _activeSubscriptionId = order.subscriptionId;
      isProcessingPayment.value = true;

      RazorpayPaymentService.instance.openSubscriptionCheckout(
        subscriptionId: order.subscriptionId!,
        keyIdOverride: order.keyId,
        name: _userName(),
        email: _userEmail(),
        contact: _userContact(),
        description:
            '${plan.planName ?? 'Plan'} - ${isTabMonthly.value ? 'Monthly' : 'Annually'}',
      );
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

  Future<void> _onRazorpayPaymentSuccess(
    PaymentSuccessResponse response,
  ) async {
    isProcessingPayment.value = false;
    isLoading.value = true;

    try {
      final plan = selectedPlanData;
      final planCode =
          plan?.resolvePlanCode(isMonthly: isTabMonthly.value) ?? '';
      final subscriptionId = _subscriptionIdFromResponse(response);

      final verifyResponse = await _razorpayRepository.verifyPayment({
        if (subscriptionId != null) 'razorpay_subscription_id': subscriptionId,
        'razorpay_payment_id': response.paymentId,
        if (response.signature != null) 'razorpay_signature': response.signature,
        'planCode': planCode,
        'billing_provider': 'alternate',
        'billing_period': isTabMonthly.value ? 'monthly' : 'yearly',
        if (_externalTransactionToken != null &&
            _externalTransactionToken!.isNotEmpty)
          'external_transaction_token': _externalTransactionToken,
      });

      if (verifyResponse?.success == true) {
        _externalTransactionToken = null;
        _activeSubscriptionId = null;

        if (Get.isRegistered<SettingsViewModel>()) {
          final settingsViewModel = Get.find<SettingsViewModel>();
          settingsViewModel.activateSubscriptionLocally(
            planName: plan?.planName ?? planCode,
            isMonthly: isTabMonthly.value,
            endDateOverride: verifyResponse?.endDate,
          );
          await Future.wait([
            settingsViewModel.getProfileDetail(),
            settingsViewModel.getSubcriptionDetail(),
          ]);

          final refreshedDays =
              SharedPrefsService.instance.getString(AppKeys.remainingDays) ??
              '0';
          if (refreshedDays == '0' && verifyResponse?.endDate == null) {
            settingsViewModel.activateSubscriptionLocally(
              planName: plan?.planName ?? planCode,
              isMonthly: isTabMonthly.value,
            );
          }

          remainingDays.value =
              SharedPrefsService.instance.getString(AppKeys.remainingDays) ??
              remainingDays.value;
        } else {
          final endDate =
              verifyResponse?.endDate ??
              DateTime.now()
                  .add(Duration(days: isTabMonthly.value ? 30 : 365))
                  .toIso8601String();
          remainingDays.value = BaseCalculateRemainingDays.daysUntilEndDate(
            endDate,
          ).toString();
          SharedPrefsService.instance.setString(
            AppKeys.remainingDays,
            remainingDays.value,
          );
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
        message: verifyResponse?.message ??
            'Payment received. Verification is pending.',
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
    _externalTransactionToken = null;

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
      final monthlyProdId = SubscriptionService.instance.getProductId(
        plan.planName ?? '',
        true,
      );
      final annualProdId = SubscriptionService.instance.getProductId(
        plan.planName ?? '',
        false,
      );

      if (monthlyProdId.isNotEmpty) {
        final monthlyProduct = SubscriptionService.instance.products
            .firstWhereOrNull((p) => p.id == monthlyProdId);
        if (monthlyProduct != null) {
          plan.priceMonthly = monthlyProduct.rawPrice.toInt().toString();
        }
      }

      if (annualProdId.isNotEmpty) {
        final annualProduct = SubscriptionService.instance.products
            .firstWhereOrNull((p) => p.id == annualProdId);
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
      await SubscriptionService.instance.buyPlan(
        plan,
        isTabMonthly.value,
        currentModel,
      );
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    RazorpayPaymentService.instance.dispose();
    super.onClose();
  }
}
