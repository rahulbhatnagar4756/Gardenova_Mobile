class CityResponseModel {
  CityResponseModel({bool? success, String? message, Data? data}) {
    _success = success;
    _message = message;
    _data = data;
  }

  CityResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

  CityResponseModel copyWith({bool? success, String? message, Data? data}) =>
      CityResponseModel(
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
  Data({String? country, String? state, List<Cities>? cities, num? count}) {
    _country = country;
    _state = state;
    _cities = cities;
    _count = count;
  }

  Data.fromJson(dynamic json) {
    _country = json['country'];
    _state = json['state'];
    if (json['cities'] != null) {
      _cities = [];
      json['cities'].forEach((v) {
        _cities?.add(Cities.fromJson(v));
      });
    }
    _count = json['count'];
  }

  String? _country;
  String? _state;
  List<Cities>? _cities;
  num? _count;

  Data copyWith({
    String? country,
    String? state,
    List<Cities>? cities,
    num? count,
  }) => Data(
    country: country ?? _country,
    state: state ?? _state,
    cities: cities ?? _cities,
    count: count ?? _count,
  );

  String? get country => _country;

  String? get state => _state;

  List<Cities>? get cities => _cities;

  num? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country'] = _country;
    map['state'] = _state;
    if (_cities != null) {
      map['cities'] = _cities?.map((v) => v.toJson()).toList();
    }
    map['count'] = _count;
    return map;
  }
}

class Cities {
  Cities({dynamic id, String? name}) {
    _id = id;
    _name = name;
  }

  Cities.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  dynamic _id;
  String? _name;

  Cities copyWith({dynamic id, String? name}) =>
      Cities(id: id ?? _id, name: name ?? _name);

  dynamic get id => _id;

  String? get name => _name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}
