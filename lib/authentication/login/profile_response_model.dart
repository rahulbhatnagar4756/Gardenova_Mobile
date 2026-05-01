import '../../utils/constants/api_keys.dart';

class ProfileResponseModel {
  ProfileResponseModel({bool? success, String? message, Data? data}) {
    _success = success;
    _message = message;
    _data = data;
  }

  ProfileResponseModel.fromJson(dynamic json) {
    _success = json[ApiKeys.success];
    _message = json[ApiKeys.message];
    _data = json[ApiKeys.data] != null
        ? Data.fromJson(json[ApiKeys.data])
        : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

  ProfileResponseModel copyWith({bool? success, String? message, Data? data}) =>
      ProfileResponseModel(
        success: success ?? _success,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get success => _success;

  String? get message => _message;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[ApiKeys.success] = _success;
    map[ApiKeys.message] = _message;
    if (_data != null) {
      map[ApiKeys.data] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    String? name,
    String? email,
    String? contactNumber,
    dynamic profileImage,
    dynamic imageUrl,
    dynamic dateOfBirth,
    dynamic gender,
    dynamic bio,
    Address? address,
    SocialLinks? socialLinks,
    dynamic occupation,
    dynamic company,
  }) {
    _name = name;
    _email = email;
    _contactNumber = contactNumber;
    _profileImage = profileImage;
    _imageUrl = imageUrl;
    _dateOfBirth = dateOfBirth;
    _gender = gender;
    _bio = bio;
    _address = address;
    _socialLinks = socialLinks;
    _occupation = occupation;
    _company = company;
  }

  Data.fromJson(dynamic json) {
    _name = json[ApiKeys.name];
    _email = json[ApiKeys.email];
    _contactNumber = json[ApiKeys.contactNumber];
    _profileImage = json[ApiKeys.profileImage];
    _imageUrl = json["imageUrl"];
    _dateOfBirth = json[ApiKeys.dateOfBirth];
    _gender = json[ApiKeys.gender];
    _bio = json[ApiKeys.bio];
    _address = json[ApiKeys.address] != null
        ? Address.fromJson(json[ApiKeys.address])
        : null;
    _socialLinks = json[ApiKeys.socialLinks] != null
        ? SocialLinks.fromJson(json[ApiKeys.socialLinks])
        : null;
    _occupation = json[ApiKeys.occupation];
    _company = json[ApiKeys.company];
  }

  String? _name;
  String? _email;
  String? _contactNumber;
  dynamic _profileImage;
  dynamic _imageUrl;
  dynamic _dateOfBirth;
  dynamic _gender;
  dynamic _bio;
  Address? _address;
  SocialLinks? _socialLinks;
  dynamic _occupation;
  dynamic _company;

  Data copyWith({
    String? name,
    String? email,
    String? contactNumber,
    dynamic profileImage,
    dynamic imageUrl,
    dynamic dateOfBirth,
    dynamic gender,
    dynamic bio,
    Address? address,
    SocialLinks? socialLinks,
    dynamic occupation,
    dynamic company,
  }) => Data(
    name: name ?? _name,
    email: email ?? _email,
    contactNumber: contactNumber ?? _contactNumber,
    profileImage: profileImage ?? _profileImage,
    imageUrl: imageUrl ?? _imageUrl,
    dateOfBirth: dateOfBirth ?? _dateOfBirth,
    gender: gender ?? _gender,
    bio: bio ?? _bio,
    address: address ?? _address,
    socialLinks: socialLinks ?? _socialLinks,
    occupation: occupation ?? _occupation,
    company: company ?? _company,
  );

  String? get name => _name;

  String? get email => _email;

  String? get contactNumber => _contactNumber;

  dynamic get profileImage => _profileImage;

  dynamic get imageUrl => _imageUrl;

  dynamic get dateOfBirth => _dateOfBirth;

  dynamic get gender => _gender;

  dynamic get bio => _bio;

  Address? get address => _address;

  SocialLinks? get socialLinks => _socialLinks;

  dynamic get occupation => _occupation;

  dynamic get company => _company;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[ApiKeys.name] = _name;
    map[ApiKeys.email] = _email;
    map[ApiKeys.contactNumber] = _contactNumber;
    map[ApiKeys.profileImage] = _profileImage;
    map["imageUrl"] = _imageUrl;
    map[ApiKeys.dateOfBirth] = _dateOfBirth;
    map[ApiKeys.gender] = _gender;
    map[ApiKeys.bio] = _bio;
    if (_address != null) {
      map[ApiKeys.address] = _address?.toJson();
    }
    if (_socialLinks != null) {
      map[ApiKeys.socialLinks] = _socialLinks?.toJson();
    }
    map[ApiKeys.occupation] = _occupation;
    map[ApiKeys.company] = _company;
    return map;
  }
}

class SocialLinks {
  SocialLinks({
    dynamic facebook,
    dynamic twitter,
    dynamic linkedin,
    dynamic instagram,
  }) {
    _facebook = facebook;
    _twitter = twitter;
    _linkedin = linkedin;
    _instagram = instagram;
  }

  SocialLinks.fromJson(dynamic json) {
    _facebook = json['facebook'];
    _twitter = json['twitter'];
    _linkedin = json['linkedin'];
    _instagram = json['instagram'];
  }

  dynamic _facebook;
  dynamic _twitter;
  dynamic _linkedin;
  dynamic _instagram;

  SocialLinks copyWith({
    dynamic facebook,
    dynamic twitter,
    dynamic linkedin,
    dynamic instagram,
  }) => SocialLinks(
    facebook: facebook ?? _facebook,
    twitter: twitter ?? _twitter,
    linkedin: linkedin ?? _linkedin,
    instagram: instagram ?? _instagram,
  );

  dynamic get facebook => _facebook;

  dynamic get twitter => _twitter;

  dynamic get linkedin => _linkedin;

  dynamic get instagram => _instagram;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['facebook'] = _facebook;
    map['twitter'] = _twitter;
    map['linkedin'] = _linkedin;
    map['instagram'] = _instagram;
    return map;
  }
}

class Address {
  Address({
    dynamic street,
    dynamic city,
    dynamic state,
    dynamic country,
    dynamic zipCode,
  }) {
    _street = street;
    _city = city;
    _state = state;
    _country = country;
    _zipCode = zipCode;
  }

  Address.fromJson(dynamic json) {
    _street = json[ApiKeys.street];
    _city = json[ApiKeys.city];
    _state = json[ApiKeys.state];
    _country = json[ApiKeys.country];
    _zipCode = json[ApiKeys.zipCode];
  }

  dynamic _street;
  dynamic _city;
  dynamic _state;
  dynamic _country;
  dynamic _zipCode;

  Address copyWith({
    dynamic street,
    dynamic city,
    dynamic state,
    dynamic country,
    dynamic zipCode,
  }) => Address(
    street: street ?? _street,
    city: city ?? _city,
    state: state ?? _state,
    country: country ?? _country,
    zipCode: zipCode ?? _zipCode,
  );

  dynamic get street => _street;

  dynamic get city => _city;

  dynamic get state => _state;

  dynamic get country => _country;

  dynamic get zipCode => _zipCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[ApiKeys.street] = _street;
    map[ApiKeys.city] = _city;
    map[ApiKeys.state] = _state;
    map[ApiKeys.country] = _country;
    map[ApiKeys.zipCode] = _zipCode;
    return map;
  }
}

/*
import '../../utils/constants/api_keys.dart';

class ProfileResponseModel {
  ProfileResponseModel({
    bool? success,
    String? message,
    Data? data,
  }) {
    _success = success;
    _message = message;
    _data = data;
  }

  ProfileResponseModel.fromJson(dynamic json) {
    _success = json[ApiKeys.success];
    _message = json[ApiKeys.message];
    _data = json[ApiKeys.data] != null
        ? Data.fromJson(json[ApiKeys.data])
        : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

  bool? get success => _success;
  String? get message => _message;
  Data? get data => _data;

  ProfileResponseModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) =>
      ProfileResponseModel(
        success: success ?? _success,
        message: message ?? _message,
        data: data ?? _data,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[ApiKeys.success] = _success;
    map[ApiKeys.message] = _message;
    if (_data != null) {
      map[ApiKeys.data] = _data?.toJson();
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
    String? endDate,
    String? address,
    String? phone,
    String? category,
  }) {
    _name = name;
    _email = email;
    _imageUrl = imageUrl;
    _subscriptionPlan = subscriptionPlan;
    _endDate = endDate;
    _address = address;
    _phone = phone;
    _category = category;
  }

  Data.fromJson(dynamic json) {
    _name = json[ApiKeys.name] ?? '';
    _email = json[ApiKeys.email] ?? '';
    _imageUrl = json['imageUrl'] ?? '';
    _subscriptionPlan = json['subscriptionPlan'] ?? '';
    _endDate = json['endDate'] ?? '';
    _address = json['address'] ?? '';
    _phone = json['phone'] ?? '';
    _category = json['category'] ?? '';
  }

  String? _name;
  String? _email;
  String? _imageUrl;
  String? _subscriptionPlan;
  String? _endDate;
  String? _address;
  String? _phone;
  String? _category;

  String? get name => _name;
  String? get email => _email;
  String? get imageUrl => _imageUrl;
  String? get subscriptionPlan => _subscriptionPlan;
  String? get endDate => _endDate;
  String? get address => _address;
  String? get phone => _phone;
  String? get category => _category;

  Data copyWith({
    String? name,
    String? email,
    String? imageUrl,
    String? subscriptionPlan,
    String? endDate,
    String? address,
    String? phone,
    String? category,
  }) =>
      Data(
        name: name ?? _name,
        email: email ?? _email,
        imageUrl: imageUrl ?? _imageUrl,
        subscriptionPlan: subscriptionPlan ?? _subscriptionPlan,
        endDate: endDate ?? _endDate,
        address: address ?? _address,
        phone: phone ?? _phone,
        category: category ?? _category,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map[ApiKeys.name] = _name;
    map[ApiKeys.email] = _email;
    map['imageUrl'] = _imageUrl;
    map['subscriptionPlan'] = _subscriptionPlan;
    map['endDate'] = _endDate;
    map['address'] = _address;
    map['phone'] = _phone;
    map['category'] = _category;
    return map;
  }
}*/
