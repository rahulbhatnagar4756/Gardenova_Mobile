import 'dart:developer';

import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../services/alternate_billing_service.dart';
import '../../services/razorpay_payment_service.dart';
import '../../settings/model/subscription_local_status_ui_model.dart';
import '../../settings/settings_view_model.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_keys.dart';
import '../../utils/routes.dart';
import '../../utils/shared_prefs_service.dart';
import '../upgradePlans/model/plan_model.dart';
import 'razorpay_payment_repository.dart';

class RazorpayPaymentController extends GetxController {
  final RazorpayPaymentRepository _repository = RazorpayPaymentRepository();

  late final PlanModel plan;
  late final bool isMonthly;
  late final bool hasAdditionalCoverage;
  late final bool isOneTimeCoverage;
  late final double totalAmount;
  late final SubscriptionStatusUiModel? currentSubscription;
  late final bool isUserPayment;

  final RxBool isLoading = false.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxString selectedMethod = 'upi'.obs;

  String? _activeSubscriptionId;

  @override
  void onInit() {
    super.onInit();
    _readArguments();
    _setupRazorpay();
  }

  void _readArguments() {
    final args = Get.arguments;
    if (args is! Map) {
      throw StateError('Razorpay payment requires plan arguments.');
    }

    plan = args['plan'] as PlanModel;
    isMonthly = args['isMonthly'] as bool? ?? true;
    hasAdditionalCoverage = args['hasAdditionalCoverage'] as bool? ?? false;
    isOneTimeCoverage = args['isOneTimeCoverage'] as bool? ?? true;
    totalAmount = (args['totalAmount'] as num?)?.toDouble() ?? 0;
    currentSubscription = args['currentSubscription'] as SubscriptionStatusUiModel?;
    isUserPayment = args['isUser'] as bool? ?? false;
  }

  String get billingLabel => isMonthly ? 'Monthly' : 'Annually';

  String get planCode => plan.resolvePlanCode(isMonthly: isMonthly);

  String get formattedAmount {
    final symbol = _currencySymbol(plan.currency);
    return '$symbol ${totalAmount.toInt()}';
  }

  String _currencySymbol(String? currency) {
    switch ((currency ?? 'INR').toUpperCase()) {
      case 'INR':
        return '₹';
      case 'BRL':
        return 'R\$';
      case 'USD':
        return '\$';
      default:
        return currency ?? '₹';
    }
  }

  void selectPaymentMethod(String method) {
    selectedMethod.value = method;
  }

  void _setupRazorpay() {
    RazorpayPaymentService.instance.initialize(
      onSuccess: _onPaymentSuccess,
      onFailure: _onPaymentFailure,
    );
  }

  Future<void> startPayment() async {
    if (isLoading.value || isProcessingPayment.value) return;

    if (planCode.isEmpty || planCode == 'free') {
      BaseSnackBar.show(title: 'Plan', message: 'Please select a paid plan to continue.');
      return;
    }

    isLoading.value = true;
    try {
      await AlternateBillingService.prepareIfAvailable();
      final externalTransactionToken = await AlternateBillingService.getExternalTransactionToken();

      final orderResponse = await _repository.createOrder(planCode);
      if (orderResponse?.success != true || orderResponse?.data?.subscriptionId == null) {
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
        description: '${plan.planName ?? 'Plan'} - $billingLabel',
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

  String? _subscriptionIdFromResponse(PaymentSuccessResponse response) {
    final data = response.data;
    final fromData = data?['razorpay_subscription_id']?.toString();
    if (fromData != null && fromData.isNotEmpty) return fromData;
    if (response.orderId != null && response.orderId!.isNotEmpty) {
      return response.orderId;
    }
    return _activeSubscriptionId;
  }

  void _persistSubscriptionId(String? subscriptionId) {
    if (subscriptionId == null || subscriptionId.isEmpty) return;
    SharedPrefsService.instance.setString(
      AppKeys.razorpaySubscriptionId,
      subscriptionId,
    );
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    isProcessingPayment.value = false;
    isLoading.value = true;

    try {
      final subscriptionId = _subscriptionIdFromResponse(response);
      final verifyResponse = await _repository.verifyPayment({
        if (subscriptionId != null) 'razorpay_subscription_id': subscriptionId,
        'razorpay_payment_id': response.paymentId,
        if (response.signature != null) 'razorpay_signature': response.signature,
        'planCode': planCode,
        'billing_provider': 'alternate',
        'billing_period': isMonthly ? 'monthly' : 'yearly',
      });

      if (verifyResponse?.success == true) {
        _persistSubscriptionId(subscriptionId);
        if (Get.isRegistered<SettingsViewModel>()) {
          final settingsViewModel = Get.find<SettingsViewModel>();
          settingsViewModel.persistRazorpaySubscriptionId(subscriptionId);
          if (isUserPayment) {
            settingsViewModel.getProfileDetail();
            settingsViewModel.getSubcriptionDetail();
          } else {
            settingsViewModel.getProfessionalProfileDetail();
          }
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

  void _onPaymentFailure(PaymentFailureResponse response) {
    isProcessingPayment.value = false;
    isLoading.value = false;

    final code = response.code;
    if (code == Razorpay.PAYMENT_CANCELLED) {
      BaseSnackBar.show(title: 'Payment', message: 'Payment was cancelled.');
      return;
    }

    BaseSnackBar.show(
      title: 'Payment Failed',
      message: response.message ?? 'Something went wrong. Please try again.',
    );
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

  @override
  void onClose() {
    RazorpayPaymentService.instance.dispose();
    super.onClose();
  }
}
