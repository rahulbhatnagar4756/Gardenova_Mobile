import '../../utils/network_services/api_repository.dart';
import 'model/razorpay_order_model.dart';

class RazorpayPaymentRepository {
  static const String createOrderUrl = 'api/v1/payment/razorpay/create-order';
  static const String verifyPaymentUrl = 'api/v1/payment/razorpay/verify';

  Future<RazorpayOrderResponse?> createOrder(
    Map<String, dynamic> body,
  ) async {
    final response = await ApiRepository.instance.post(
      createOrderUrl,
      body: body,
    );
    if (response == null) return null;
    return RazorpayOrderResponse.fromJson(response);
  }

  Future<RazorpayVerifyResponse?> verifyPayment(
    Map<String, dynamic> body,
  ) async {
    final response = await ApiRepository.instance.post(
      verifyPaymentUrl,
      body: body,
    );
    if (response == null) return null;
    return RazorpayVerifyResponse.fromJson(response);
  }
}
