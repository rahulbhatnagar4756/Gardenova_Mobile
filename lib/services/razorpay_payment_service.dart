import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../utils/constants/app_constants.dart';
import '../utils/constants/app_strings.dart';

typedef RazorpayPaymentSuccess = void Function(PaymentSuccessResponse response);
typedef RazorpayPaymentFailure = void Function(PaymentFailureResponse response);
typedef RazorpayExternalWallet = void Function(ExternalWalletResponse response);

class RazorpayPaymentService {
  RazorpayPaymentService._();

  static final RazorpayPaymentService instance = RazorpayPaymentService._();

  Razorpay? _razorpay;
  RazorpayPaymentSuccess? _onSuccess;
  RazorpayPaymentFailure? _onFailure;
  RazorpayExternalWallet? _onExternalWallet;

  String get keyId => dotenv.env['razorpay_key_id'] ?? '';

  void initialize({
    required RazorpayPaymentSuccess onSuccess,
    required RazorpayPaymentFailure onFailure,
    RazorpayExternalWallet? onExternalWallet,
  }) {
    dispose();
    _onSuccess = onSuccess;
    _onFailure = onFailure;
    _onExternalWallet = onExternalWallet;

    _razorpay = Razorpay();
    _razorpay!
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, _handleSuccess)
      ..on(Razorpay.EVENT_PAYMENT_ERROR, _handleFailure)
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout({
    required String orderId,
    required int amount,
    required String currency,
    String? keyIdOverride,
    String? name,
    String? email,
    String? contact,
    String? description,
  }) {
    final resolvedKeyId = keyIdOverride?.trim().isNotEmpty == true ? keyIdOverride!.trim() : keyId;

    if (resolvedKeyId.isEmpty) {
      throw StateError(AppStrings.razorpayKeyNotConfigured);
    }

    final options = <String, dynamic>{
      'key': resolvedKeyId,
      'amount': amount,
      'currency': currency,
      'name': appName,
      'order_id': orderId,
      'description': description ?? AppStrings.subscriptionPayment,
      'theme': {'color': '#2E7D4F'},
      'retry': {'enabled': true, 'max_count': 1},
      'prefill': {
        if (name != null && name.isNotEmpty) 'name': name,
        if (email != null && email.isNotEmpty) 'email': email,
        if (contact != null && contact.isNotEmpty) 'contact': contact,
      },
    };

    log('Opening Razorpay checkout for order: $orderId');
    _razorpay?.open(options);
  }

  void _handleSuccess(PaymentSuccessResponse response) {
    _onSuccess?.call(response);
  }

  void _handleFailure(PaymentFailureResponse response) {
    _onFailure?.call(response);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    if (_onExternalWallet != null) {
      _onExternalWallet!.call(response);
      return;
    }
    BaseSnackBar.show(
      title: AppStrings.wallet,
      message: '${AppStrings.redirectedTo} ${response.walletName ?? AppStrings.externalWallet}',
    );
  }

  void dispose() {
    _razorpay?.clear();
    _razorpay = null;
    _onSuccess = null;
    _onFailure = null;
    _onExternalWallet = null;
  }
}
