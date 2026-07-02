class RazorpayOrderResponse {
  final bool? success;
  final String? message;
  final RazorpayOrderData? data;

  RazorpayOrderResponse({this.success, this.message, this.data});

  factory RazorpayOrderResponse.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: json['data'] != null
          ? RazorpayOrderData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class RazorpayOrderData {
  final String? orderId;
  final int? amount;
  final String? currency;
  final String? keyId;

  RazorpayOrderData({
    this.orderId,
    this.amount,
    this.currency,
    this.keyId,
  });

  factory RazorpayOrderData.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderData(
      orderId: json['order_id']?.toString() ?? json['orderId']?.toString(),
      amount: _parseAmount(json['amount']),
      currency: json['currency']?.toString() ?? 'INR',
      keyId: json['key_id']?.toString() ?? json['keyId']?.toString(),
    );
  }

  static int? _parseAmount(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }
}

class RazorpayVerifyResponse {
  final bool? success;
  final String? message;

  RazorpayVerifyResponse({this.success, this.message});

  factory RazorpayVerifyResponse.fromJson(Map<String, dynamic> json) {
    return RazorpayVerifyResponse(
      success: json['success'] == true ||
          json['statusCode'] == 200 ||
          json['statusCode'] == 201,
      message: json['message']?.toString(),
    );
  }
}
