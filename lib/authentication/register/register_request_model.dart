import 'dart:convert';

import 'package:kasagardem/utils/constants/api_keys.dart';

RegisterRequestModel registerRequestModelFromJson(String str) =>
    RegisterRequestModel.fromJson(json.decode(str));

String registerRequestModelToJson(RegisterRequestModel data) =>
    json.encode(data.toJson());

class RegisterRequestModel {
  RegisterRequestModel({
    String? name,
    String? email,
    String? password,
    String? roleCode,
    String? phoneNumber,
  }) {
    _name = name;
    _email = email;
    _password = password;
    _roleCode = roleCode;
    _phoneNumber = phoneNumber;
  }

  RegisterRequestModel.fromJson(dynamic json) {
    _name = json[ApiKeys.name];
    _email = json[ApiKeys.email];
    _password = json[ApiKeys.password];
    _roleCode = json[ApiKeys.roleCode];
    _phoneNumber = json[ApiKeys.phoneNumber];
  }

  String? _name;
  String? _email;
  String? _password;
  String? _roleCode;
  String? _phoneNumber;

  RegisterRequestModel copyWith({
    String? name,
    String? email,
    String? password,
    String? roleId,
    String? phoneNumber,
  }) => RegisterRequestModel(
    name: name ?? _name,
    email: email ?? _email,
    password: password ?? _password,
    roleCode: roleId ?? _roleCode,
    phoneNumber: phoneNumber ?? _phoneNumber,
  );

  set name(String? value) => _name = value;

  set email(String? value) => _email = value;

  set password(String? value) => _password = value;

  set roleCode(String? value) => _roleCode = value;

  set phoneNumber(String? value) => _phoneNumber = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[ApiKeys.name] = _name;
    map[ApiKeys.email] = _email;
    map[ApiKeys.password] = _password;
    map[ApiKeys.roleCode] = _roleCode;
    map[ApiKeys.phoneNumber] = _phoneNumber;
    return map;
  }
}
