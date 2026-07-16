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
  final String? endDate;
  final String? subscriptionPlan;
  final String? accountStatus;

  RazorpayVerifyResponse({
    this.success,
    this.message,
    this.endDate,
    this.subscriptionPlan,
    this.accountStatus,
  });

  factory RazorpayVerifyResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final Map<String, dynamic>? dataMap =
        data is Map<String, dynamic> ? data : null;

    return RazorpayVerifyResponse(
      success: json['success'] == true ||
          json['statusCode'] == 200 ||
          json['statusCode'] == 201,
      message: json['message']?.toString(),
      endDate: dataMap?['endDate']?.toString() ??
          dataMap?['end_date']?.toString() ??
          json['endDate']?.toString() ??
          json['end_date']?.toString(),
      subscriptionPlan: dataMap?['subscriptionPlan']?.toString() ??
          dataMap?['subscription_plan']?.toString() ??
          dataMap?['planCode']?.toString() ??
          json['subscriptionPlan']?.toString(),
      accountStatus: dataMap?['accountStatus']?.toString() ??
          dataMap?['account_status']?.toString() ??
          json['accountStatus']?.toString(),
    );
  }
}

class RazorpayCancelResponse {
  final bool? success;
  final String? message;
  final String? endDate;
  final String? status;

  RazorpayCancelResponse({
    this.success,
    this.message,
    this.endDate,
    this.status,
  });

  factory RazorpayCancelResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final Map<String, dynamic>? dataMap =
        data is Map<String, dynamic> ? data : null;

    return RazorpayCancelResponse(
      success: json['success'] == true ||
          json['statusCode'] == 200 ||
          json['statusCode'] == 201,
      message: json['message']?.toString(),
      endDate: dataMap?['endDate']?.toString() ??
          dataMap?['end_date']?.toString() ??
          json['endDate']?.toString() ??
          json['end_date']?.toString(),
      status: dataMap?['status']?.toString() ??
          dataMap?['accountStatus']?.toString() ??
          dataMap?['account_status']?.toString() ??
          json['status']?.toString(),
    );
  }
}
