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
  final String? subscriptionId;
  final String? keyId;

  RazorpayOrderData({this.subscriptionId, this.keyId});

  factory RazorpayOrderData.fromJson(Map<String, dynamic> json) {
    return RazorpayOrderData(
      subscriptionId: json['subscriptionId']?.toString() ??
          json['subscription_id']?.toString(),
      keyId: json['key_id']?.toString() ?? json['keyId']?.toString(),
    );
  }
}

class RazorpayVerifyResponse {
  final bool? success;
  final String? message;

  RazorpayVerifyResponse({this.success, this.message});

  factory RazorpayVerifyResponse.fromJson(Map<String, dynamic> json) {
    return RazorpayVerifyResponse(
      success: json['success'] == true || json['statusCode'] == 200 || json['statusCode'] == 201,
      message: json['message']?.toString(),
    );
  }
}
