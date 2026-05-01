class SaveAnswerRequestModel {
  SaveAnswerRequestModel({List<Answers>? answers}) {
    _answers = answers;
  }

  SaveAnswerRequestModel.fromJson(dynamic json) {
    if (json['answers'] != null) {
      _answers = [];
      json['answers'].forEach((v) {
        _answers?.add(Answers.fromJson(v));
      });
    }
  }

  List<Answers>? _answers;

  SaveAnswerRequestModel copyWith({List<Answers>? answers}) =>
      SaveAnswerRequestModel(answers: answers ?? _answers);

  List<Answers>? get answers => _answers;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_answers != null) {
      map['answers'] = _answers?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Answers {
  Answers({
    String? questionId,
    num? type,
    String? selectedOption,
    SelectedAddress? selectedAddress,
  }) {
    _questionId = questionId;
    _type = type;
    _selectedOption = selectedOption;
    _selectedAddress = selectedAddress;
  }

  Answers.fromJson(dynamic json) {
    _questionId = json['questionId'];
    _type = json['type'];
    _selectedOption = json['selectedOption'];
  }

  String? _questionId;
  num? _type;
  String? _selectedOption;
  SelectedAddress? _selectedAddress;

  Answers copyWith({
    String? questionId,
    num? type,
    String? selectedOption,
    SelectedAddress? selectedAddress,
  }) => Answers(
    questionId: questionId ?? _questionId,
    type: type ?? _type,
    selectedOption: selectedOption ?? _selectedOption,
    selectedAddress: selectedAddress ?? _selectedAddress,
  );

  String? get questionId => _questionId;

  num? get type => _type;

  String? get selectedOption => _selectedOption;

  SelectedAddress? get selectedAddress => _selectedAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['questionId'] = _questionId;
    map['type'] = _type;
    if (_selectedOption != null) {
      map['selectedOption'] = _selectedOption;
    }
    if (_selectedAddress != null) {
      map['selectedAddress'] = _selectedAddress?.toJson();
    }
    return map;
  }
}

class SelectedAddress {
  SelectedAddress({String? state, String? city}) {
    _state = state;
    _city = city;
  }

  SelectedAddress.fromJson(dynamic json) {
    _state = json['state'];
    _city = json['city'];
  }

  String? _state;
  String? _city;

  SelectedAddress copyWith({String? state, String? city}) =>
      SelectedAddress(state: state ?? _state, city: city ?? _city);

  String? get state => _state;

  String? get city => _city;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['state'] = _state;
    map['city'] = _city;
    return map;
  }
}
