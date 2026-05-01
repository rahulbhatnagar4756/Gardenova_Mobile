class ProfessionalProfileModel {
  ProfessionalProfileModel({bool? success, String? message, Data? data}) {
    _success = success;
    _message = message;
    _data = data;
  }

  ProfessionalProfileModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

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
  Data({
    String? name,
    String? email,
    String? imageUrl,
    String? subscriptionPlan,
    String? startDate,
    String? endDate,
    String? accountStatus,
    String? description,
    String? region,
    String? category,
  }) {
    _name = name;
    _email = email;
    _imageUrl = imageUrl;
    _subscriptionPlan = subscriptionPlan;
    _startDate = startDate;
    _endDate = endDate;
    _accountStatus = accountStatus;
    _description = description;
    _region = region;
    _category = category;
  }

  Data.fromJson(dynamic json) {
    _name = json['name'];
    _email = json['email'];
    _imageUrl = json['profileImage'];
    _subscriptionPlan = json['subscriptionPlan'];
    _startDate = json['startDate'];
    _endDate = json['endDate'];
    _accountStatus = json['accountStatus'];
    _description = json['description'];
    _region = json['region'];
    _category = json['category'];
  }

  String? _name;
  String? _email;
  String? _imageUrl;
  String? _subscriptionPlan;
  String? _startDate;
  String? _endDate;
  String? _accountStatus;
  String? _description;
  String? _region;
  String? _category;

  String? get name => _name;

  String? get email => _email;

  String? get imageUrl => _imageUrl;

  String? get subscriptionPlan => _subscriptionPlan;

  String? get startDate => _startDate;

  String? get endDate => _endDate;

  String? get accountStatus => _accountStatus;

  String? get description => _description;

  String? get region => _region;

  String? get category => _category;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['email'] = _email;
    map['profileImage'] = _imageUrl;
    map['subscriptionPlan'] = _subscriptionPlan;
    map['startDate'] = _startDate;
    map['endDate'] = _endDate;
    map['accountStatus'] = _accountStatus;
    map['description'] = _description;
    map['region'] = _region;
    map['category'] = _category;
    return map;
  }
}
