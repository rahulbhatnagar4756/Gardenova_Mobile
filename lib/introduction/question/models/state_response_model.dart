import 'dart:convert';

StateResponseModel stateResponseModelFromJson(String str) =>
    StateResponseModel.fromJson(json.decode(str));

String stateResponseModelToJson(StateResponseModel data) =>
    json.encode(data.toJson());

class StateResponseModel {
  StateResponseModel({bool? success, String? message, Data? data}) {
    _success = success;
    _message = message;
    _data = data;
  }

  StateResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

  StateResponseModel copyWith({bool? success, String? message, Data? data}) =>
      StateResponseModel(
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

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({String? country, List<States>? states, num? count}) {
    _country = country;
    _states = states;
    _count = count;
  }

  Data.fromJson(dynamic json) {
    _country = json['country'];
    if (json['states'] != null) {
      _states = [];
      json['states'].forEach((v) {
        _states?.add(States.fromJson(v));
      });
    }
    _count = json['count'];
  }

  String? _country;
  List<States>? _states;
  num? _count;

  Data copyWith({String? country, List<States>? states, num? count}) => Data(
    country: country ?? _country,
    states: states ?? _states,
    count: count ?? _count,
  );

  String? get country => _country;

  List<States>? get states => _states;

  num? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['country'] = _country;
    if (_states != null) {
      map['states'] = _states?.map((v) => v.toJson()).toList();
    }
    map['count'] = _count;
    return map;
  }
}

States statesFromJson(String str) => States.fromJson(json.decode(str));

String statesToJson(States data) => json.encode(data.toJson());

class States {
  States({String? name, String? iso2}) {
    _name = name;
    _iso2 = iso2;
  }

  States.fromJson(dynamic json) {
    _name = json['name'];
    _iso2 = json['iso2'];
  }

  String? _name;
  String? _iso2;

  States copyWith({String? name, String? iso2}) =>
      States(name: name ?? _name, iso2: iso2 ?? _iso2);

  String? get name => _name;

  String? get iso2 => _iso2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['iso2'] = _iso2;
    return map;
  }
}
