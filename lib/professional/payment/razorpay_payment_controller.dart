import 'dart:developer';

import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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

  String? _activeOrderId;

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
    currentSubscription =
        args['currentSubscription'] as SubscriptionStatusUiModel?;
    isUserPayment = args['isUser'] as bool? ?? false;
  }

  String get billingLabel => isMonthly ? 'Monthly' : 'Annually';

  String get planId =>
      isMonthly ? (plan.monthlyId ?? plan.id ?? '') : (plan.yearlyId ?? plan.id ?? '');

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

    if (planId.isEmpty) {
      BaseSnackBar.show(
        title: 'Plan',
        message: 'Unable to identify the selected plan.',
      );
      return;
    }

    isLoading.value = true;
    try {
      final orderResponse = await _repository.createOrder(_buildCreateOrderBody());
      if (orderResponse?.success != true || orderResponse?.data?.orderId == null) {
        BaseSnackBar.show(
          title: 'Payment',
          message: orderResponse?.message ?? 'Failed to create payment order.',
        );
        return;
      }

      final order = orderResponse!.data!;
      _activeOrderId = order.orderId;
      final amount = order.amount ?? (totalAmount * 100).round();
      final currency = order.currency ?? plan.currency ?? 'INR';

      isProcessingPayment.value = true;
      RazorpayPaymentService.instance.openCheckout(
        orderId: order.orderId!,
        amount: amount,
        currency: currency,
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

  Map<String, dynamic> _buildCreateOrderBody() {
    return {
      'plan_id': planId,
      'billing_period': isMonthly ? 'monthly' : 'yearly',
      'amount': totalAmount,
      'currency': plan.currency ?? 'INR',
      'additional_coverage': hasAdditionalCoverage,
      if (hasAdditionalCoverage)
        'coverage_type': isOneTimeCoverage ? 'one_time' : 'annual',
      if (currentSubscription?.id != null) 'current_plan_id': currentSubscription!.id,
    };
  }

  Future<void> _onPaymentSuccess(PaymentSuccessResponse response) async {
    isProcessingPayment.value = false;
    isLoading.value = true;

    try {
      final verifyResponse = await _repository.verifyPayment({
        'razorpay_order_id': response.orderId ?? _activeOrderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
        'plan_id': planId,
        'billing_period': isMonthly ? 'monthly' : 'yearly',
        'additional_coverage': hasAdditionalCoverage,
      });

      if (verifyResponse?.success == true) {
        if (Get.isRegistered<SettingsViewModel>()) {
          final settingsViewModel = Get.find<SettingsViewModel>();
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
