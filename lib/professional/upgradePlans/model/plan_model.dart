class PlansResponseModel {
  bool? _success;
  String? _message;
  Data? _data;

  PlansResponseModel({bool? success, String? message, Data? data}) {
    _success = success;
    _message = message;
    _data = data;
  }

  PlansResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

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
  List<PlanModel>? _plans;

  Data({List<PlanModel>? plans}) {
    _plans = plans;
  }

  Data.fromJson(dynamic json) {
    if (json['plans'] != null) {
      _plans = [];
      for (var v in json['plans']) {
        _plans?.add(PlanModel.fromJson(v));
      }
    }
  }

  List<PlanModel>? get plans => _plans;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_plans != null) {
      map['plans'] = _plans?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class PlanModel {
  String? _id;
  String? _planName;
  String? _description;
  int? _citiesCoverage;
  String? _priceMonthly;
  String? _priceAnnual;
  bool? _appearInSearch;
  bool? _isSelect;
  int? _leadsLimit;
  bool? _premiumProfileBadge;
  bool? _priorityCustomerSupport;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  PlanModel({
    String? id,
    String? planName,
    String? description,
    int? citiesCoverage,
    String? priceMonthly,
    String? priceAnnual,
    bool? appearInSearch,
    bool? isSelect,
    int? leadsLimit,
    bool? premiumProfileBadge,
    bool? priorityCustomerSupport,
    String? status,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _planName = planName;
    _description = description;
    _citiesCoverage = citiesCoverage;
    _priceMonthly = priceMonthly;
    _priceAnnual = priceAnnual;
    _appearInSearch = appearInSearch;
    _isSelect = isSelect ?? false;
    _leadsLimit = leadsLimit;
    _premiumProfileBadge = premiumProfileBadge;
    _priorityCustomerSupport = priorityCustomerSupport;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  PlanModel.fromJson(dynamic json) {
    _id = json['id'];
    _planName = json['plan_name'];
    _description = json['description'];
    _citiesCoverage = json['cities_coverage'];
    _priceMonthly = json['price_monthly'];
    _priceAnnual = json['price_annual'];
    _appearInSearch = json['appear_in_search'];
    _leadsLimit = json['leads_limit'];
    _premiumProfileBadge = json['premium_profile_badge'];
    _priorityCustomerSupport = json['priority_customer_support'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

    _isSelect = false;
  }

  String? get id => _id;

  String? get planName => _planName;

  String? get description => _description;

  int? get citiesCoverage => _citiesCoverage;

  String? get priceMonthly => _priceMonthly;

  String? get priceAnnual => _priceAnnual;

  bool? get appearInSearch => _appearInSearch;

  bool? get isSelect => _isSelect;

  int? get leadsLimit => _leadsLimit;

  bool? get premiumProfileBadge => _premiumProfileBadge;

  bool? get priorityCustomerSupport => _priorityCustomerSupport;

  String? get status => _status;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  set setSelect(bool? value) {
    _isSelect = value;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['id'] = _id;
    map['plan_name'] = _planName;
    map['description'] = _description;
    map['cities_coverage'] = _citiesCoverage;
    map['price_monthly'] = _priceMonthly;
    map['price_annual'] = _priceAnnual;
    map['appear_in_search'] = _appearInSearch;
    map['leads_limit'] = _leadsLimit;
    map['premium_profile_badge'] = _premiumProfileBadge;
    map['priority_customer_support'] = _priorityCustomerSupport;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;

    return map;
  }
}
