class QuestionResponseModel {
  QuestionResponseModel({bool? success, String? message, Data? data}) {
    _success = success;
    _message = message;
    _data = data;
  }

  QuestionResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

  QuestionResponseModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) => QuestionResponseModel(
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
  Data({List<Questions>? questions}) {
    _questions = questions;
  }

  Data.fromJson(dynamic json) {
    if (json['questions'] != null) {
      _questions = [];
      json['questions'].forEach((v) {
        _questions?.add(Questions.fromJson(v));
      });
    }
  }

  List<Questions>? _questions;

  Data copyWith({List<Questions>? questions}) =>
      Data(questions: questions ?? _questions);

  List<Questions>? get questions => _questions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_questions != null) {
      map['questions'] = _questions?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}

class Questions {
  Questions({
    String? questionId,
    String? questionText,
    num? order,
    List<Options>? options,
    String? selectedAnswer,
  }) {
    _questionId = questionId;
    _questionText = questionText;
    _order = order;
    _options = options;
    selectedAnswer = selectedAnswer;
  }

  Questions.fromJson(dynamic json) {
    _questionId = json['question_id'];
    _questionText = json['question_text'];
    _order = json['order'];
    if (json['options'] != null) {
      _options = [];
      json['options'].forEach((v) {
        _options?.add(Options.fromJson(v));
      });
    }
  }

  String? _questionId;
  String? _questionText;
  num? _order;
  List<Options>? _options;
  String? selectedAnswer;

  Questions copyWith({
    String? questionId,
    String? questionText,
    num? order,
    List<Options>? options,
    String? selectedAnswer,
  }) => Questions(
    questionId: questionId ?? _questionId,
    questionText: questionText ?? _questionText,
    order: order ?? _order,
    options: options ?? _options,
    selectedAnswer: selectedAnswer ?? selectedAnswer,
  );

  String? get questionId => _questionId;

  String? get questionText => _questionText;

  num? get order => _order;

  List<Options>? get options => _options;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['question_id'] = _questionId;
    map['question_text'] = _questionText;
    map['order'] = _order;
    if (_options != null) {
      map['options'] = _options?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Options {
  Options({String? id, String? optionText}) {
    _id = id;
    _optionText = optionText;
  }

  Options.fromJson(dynamic json) {
    _id = json['id'];
    _optionText = json['option_text'];
  }

  String? _id;
  String? _optionText;

  Options copyWith({String? id, String? optionText}) =>
      Options(id: id ?? _id, optionText: optionText ?? _optionText);

  String? get id => _id;

  String? get optionText => _optionText;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['option_text'] = _optionText;
    return map;
  }
}
