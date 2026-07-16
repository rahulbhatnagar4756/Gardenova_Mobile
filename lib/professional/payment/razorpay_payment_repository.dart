import '../../utils/network_services/api_repository.dart';
import 'model/razorpay_order_model.dart';

class RazorpayPaymentRepository {
  static const String createOrderUrl = 'api/v1/plans/subscriptions/create';
  static const String verifyPaymentUrl = 'api/v1/plans/subscriptions/verify';
  static const String cancelSubscriptionUrl = 'api/v1/plans/subscriptions/cancel';

  Future<RazorpayOrderResponse?> createOrder(
    String planCode, {
    String? externalTransactionToken,
  }) async {
    final response = await ApiRepository.instance.post(
      createOrderUrl,
      body: {
        'planCode': planCode,
        if (externalTransactionToken != null &&
            externalTransactionToken.isNotEmpty)
          'external_transaction_token': externalTransactionToken,
        'billing_provider': 'alternate',
      },
    );
    if (response == null) return null;
    return RazorpayOrderResponse.fromJson(response);
  }

  Future<RazorpayVerifyResponse?> verifyPayment(Map<String, dynamic> body) async {
    final response = await ApiRepository.instance.post(verifyPaymentUrl, body: body);
    if (response == null) return null;
    return RazorpayVerifyResponse.fromJson(response);
  }

  Future<RazorpayCancelResponse?> cancelSubscription({
    String? razorpaySubscriptionId,
    bool cancelAtCycleEnd = true,
  }) async {
    final response = await ApiRepository.instance.post(
      cancelSubscriptionUrl,
      body: {
        'billing_provider': 'alternate',
        'cancel_at_cycle_end': cancelAtCycleEnd,
        if (razorpaySubscriptionId != null &&
            razorpaySubscriptionId.isNotEmpty)
          'razorpay_subscription_id': razorpaySubscriptionId,
      },
    );
    if (response == null) return null;
    return RazorpayCancelResponse.fromJson(response);
  }
}
