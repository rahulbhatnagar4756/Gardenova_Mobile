class SaveAnswerResponseModel {
  SaveAnswerResponseModel({bool? success, String? message, Data? data}) {
    _success = success;
    _message = message;
    _data = data;
  }

  SaveAnswerResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

  SaveAnswerResponseModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) => SaveAnswerResponseModel(
    success: success ?? _success,
    message: message ?? _message,
    data: data ?? _data,
  );

  bool? get success => _success;

  String? get message => _message;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({String? responseId}) {
    _responseId = responseId;
  }

  Data.fromJson(dynamic json) {
    _responseId = json['responseId'];
  }

  String? _responseId;

  Data copyWith({String? responseId}) =>
      Data(responseId: responseId ?? _responseId);

  String? get responseId => _responseId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['responseId'] = _responseId;
    return map;
  }
}
