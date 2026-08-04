class AnswerResponseModel {
  AnswerResponseModel({bool? success, String? message, List<Data>? data}) {
    _success = success;
    _message = message;
    _data = data;
  }

  AnswerResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }

  bool? _success;
  String? _message;
  List<Data>? _data;

  bool? get success => _success;

  String? get message => _message;

  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({String? questionId, num? answerType, String? selectedOption}) {
    _questionId = questionId;
    _answerType = answerType;
    _selectedOption = selectedOption;
  }

  Data.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _answerType = json['answer_type'];
    _selectedOption = json['selected_option'];
  }

  String? _questionId;
  num? _answerType;
  String? _selectedOption;

  String? get questionId => _questionId;

  num? get answerType => _answerType;

  String? get selectedOption => _selectedOption;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['answer_type'] = _answerType;
    map['selected_option'] = _selectedOption;
    return map;
  }
}
