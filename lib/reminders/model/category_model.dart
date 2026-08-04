class CategoryModel {
  CategoryModel({String? title, String? code, String? counter}) {
    _title = title;
    _code = code;
    _counter = counter;
  }

  CategoryModel.fromJson(dynamic json) {
    _title = json['title'];
    _code = json['code'];
    _counter = json['counter'];
  }

  String? _title;
  String? _code;
  String? _counter;

  String? get title => _title;

  String? get code => _code;

  set code(String? value) => _code = value;

  String? get counter => _counter;

  set counter(String? value) => _counter = value;

  set title(String? value) => _title = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['code'] = _code;
    map['counter'] = _counter;
    return map;
  }
}
