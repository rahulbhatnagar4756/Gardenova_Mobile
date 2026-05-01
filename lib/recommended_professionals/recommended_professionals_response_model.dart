class RecommendedProfessionalsResponseModel {
  RecommendedProfessionalsResponseModel({
    bool? success,
    String? message,
    Data? data,
  }) {
    _success = success;
    _message = message;
    _data = data;
  }

  RecommendedProfessionalsResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

  RecommendedProfessionalsResponseModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) => RecommendedProfessionalsResponseModel(
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
  Data({List<ProfessionalRecommendations>? partnerRecommendations}) {
    _partnerRecommendations = partnerRecommendations;
  }

  Data.fromJson(dynamic json) {
    if (json['partnerRecommendations'] != null) {
      _partnerRecommendations = [];
      json['partnerRecommendations'].forEach((v) {
        _partnerRecommendations?.add(ProfessionalRecommendations.fromJson(v));
      });
    }
  }

  List<ProfessionalRecommendations>? _partnerRecommendations;

  Data copyWith({List<ProfessionalRecommendations>? partnerRecommendations}) =>
      Data(
        partnerRecommendations:
            partnerRecommendations ?? _partnerRecommendations,
      );

  List<ProfessionalRecommendations>? get partnerRecommendations =>
      _partnerRecommendations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_partnerRecommendations != null) {
      map['partnerRecommendations'] = _partnerRecommendations
          ?.map((v) => v.toJson())
          .toList();
    }
    return map;
  }
}

class ProfessionalRecommendations {
  ProfessionalRecommendations({
    String? partnerId,
    String? email,
    String? mobileNumber,
    String? companyName,
    List<String>? speciality,
    Address? address,
    String? website,
    String? contactPerson,
    String? projectImageUrl,
    String? whyRecommended,
    String? rating,
    bool? isSelected = false,
  }) {
    _partnerId = partnerId;
    _email = email;
    _mobileNumber = mobileNumber;
    _companyName = companyName;
    _speciality = speciality;
    _address = address;
    _website = website;
    _isSelected = isSelected;
    _contactPerson = contactPerson;
    _projectImageUrl = projectImageUrl;
    _whyRecommended = whyRecommended;
    _rating = rating;
  }

  ProfessionalRecommendations.fromJson(dynamic json) {
    _partnerId = json['partnerId'];
    _email = json['email'];
    _mobileNumber = json['mobileNumber'];
    _companyName = json['companyName'];
    _speciality = json['speciality'] != null
        ? json['speciality'].cast<String>()
        : [];
    _address = json['address'] != null
        ? Address.fromJson(json['address'])
        : null;
    _website = json['website'];
    _contactPerson = json['contactPerson'];
    _projectImageUrl = json['projectImageUrl'];
    _whyRecommended = json['whyRecommended'];
    _rating = json['rating'];
  }

  String? _partnerId;
  String? _email;
  String? _mobileNumber;
  String? _companyName;
  List<String>? _speciality;
  Address? _address;
  String? _website;
  String? _contactPerson;
  String? _projectImageUrl;
  String? _whyRecommended;
  String? _rating;
  bool? _isSelected = false;

  ProfessionalRecommendations copyWith({
    String? partnerId,
    String? email,
    String? mobileNumber,
    String? companyName,
    List<String>? speciality,
    Address? address,
    String? website,
    String? contactPerson,
    String? projectImageUrl,
    String? rating,
    String? whyRecommended,
    bool? isSelected = false,
  }) => ProfessionalRecommendations(
    partnerId: partnerId ?? _partnerId,
    email: email ?? _email,
    mobileNumber: mobileNumber ?? _mobileNumber,
    companyName: companyName ?? _companyName,
    speciality: speciality ?? _speciality,
    address: address ?? _address,
    website: website ?? _website,
    contactPerson: contactPerson ?? _contactPerson,
    projectImageUrl: projectImageUrl ?? _projectImageUrl,
    whyRecommended: whyRecommended ?? _whyRecommended,
    isSelected: isSelected ?? _isSelected,
    rating: rating ?? _rating,
  );

  String? get partnerId => _partnerId;

  String? get email => _email;

  String? get mobileNumber => _mobileNumber;

  String? get rating => _rating;

  String? get companyName => _companyName;

  List<String>? get speciality => _speciality;

  Address? get address => _address;

  String? get website => _website;

  String? get contactPerson => _contactPerson;

  String? get projectImageUrl => _projectImageUrl;

  String? get whyRecommended => _whyRecommended;

  bool? get isSelected => _isSelected;

  set setSelected(bool? value) => _isSelected = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['partnerId'] = _partnerId;
    map['email'] = _email;
    map['mobileNumber'] = _mobileNumber;
    map['companyName'] = _companyName;
    map['speciality'] = _speciality;
    if (_address != null) {
      map['address'] = _address?.toJson();
    }
    map['website'] = _website;
    map['rating'] = _rating;
    map['contactPerson'] = _contactPerson;
    map['projectImageUrl'] = _projectImageUrl;
    map['whyRecommended'] = _whyRecommended;
    return map;
  }
}

class Address {
  Address({
    String? street,
    String? city,
    String? state,
    String? country,
    String? zipCode,
  }) {
    _street = street;
    _city = city;
    _state = state;
    _country = country;
    _zipCode = zipCode;
  }

  Address.fromJson(dynamic json) {
    _street = json['street'];
    _city = json['city'];
    _state = json['state'];
    _country = json['country'];
    _zipCode = json['zipCode'];
  }

  String? _street;
  String? _city;
  String? _state;
  String? _country;
  String? _zipCode;

  Address copyWith({
    String? street,
    String? city,
    String? state,
    String? country,
    String? zipCode,
  }) => Address(
    street: street ?? _street,
    city: city ?? _city,
    state: state ?? _state,
    country: country ?? _country,
    zipCode: zipCode ?? _zipCode,
  );

  String? get street => _street;

  String? get city => _city;

  String? get state => _state;

  String? get country => _country;

  String? get zipCode => _zipCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['street'] = _street;
    map['city'] = _city;
    map['state'] = _state;
    map['country'] = _country;
    map['zipCode'] = _zipCode;
    return map;
  }
}
