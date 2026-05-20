import 'dart:convert';

import '../../utils/constants/api_keys.dart';

UpdateProfileModel updateProfileModelFromJson(String str) =>
    UpdateProfileModel.fromJson(json.decode(str));

String updateProfileModelToJson(UpdateProfileModel data) =>
    json.encode(data.toJson());

class UpdateProfileModel {
  String? profileImage;
  String? dateOfBirth;
  String? gender;
  String? bio;
  String? occupation;
  String? company;
  String? name;
  String? email;
  String? phoneNo;

  UpdateProfileModel({
    this.profileImage,
    this.dateOfBirth,
    this.gender,
    this.bio,
    this.occupation,
    this.company,
    this.name,
    this.email,
    this.phoneNo,
  });

  UpdateProfileModel.fromJson(dynamic json) {
    profileImage = json['profileImage'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    bio = json['bio'];
    occupation = json['occupation'];
    company = json['company'];
    name = json['name'];
    email = json['email'];

    phoneNo = json['phoneNumber'];
    if (json is Map && json.containsKey('contactNumber')) {
      phoneNo = json['contactNumber'];
    }
  }

  UpdateProfileModel copyWith({
    String? profileImage,
    String? dateOfBirth,
    String? gender,
    String? bio,
    String? occupation,
    String? company,
    String? name,
    String? email,
    String? phoneNo,
  }) => UpdateProfileModel(
    profileImage: profileImage ?? this.profileImage,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    bio: bio ?? this.bio,
    occupation: occupation ?? this.occupation,
    company: company ?? this.company,
    name: name ?? this.name,
    email: email ?? this.email,
    phoneNo: phoneNo ?? this.phoneNo,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profileImage'] = profileImage;
    map['dateOfBirth'] = dateOfBirth;
    map['gender'] = gender;
    map['bio'] = bio;

    map['occupation'] = occupation;
    map['company'] = company;
    map[ApiKeys.name] = name;
    map[ApiKeys.email] = email;
    map['contactNumber'] = phoneNo;
    return map;
  }
}

class UpdateProfilePictureModel {
  String? profileImage;

  UpdateProfilePictureModel({this.profileImage});

  UpdateProfilePictureModel.fromJson(dynamic json) {
    profileImage = json['profileImage'];
  }

  UpdateProfilePictureModel copyWith({
    String? profileImage,
    String? dateOfBirth,
    String? gender,
    String? bio,
    String? occupation,
    String? company,
    String? name,
    String? email,
    String? phoneNo,
  }) => UpdateProfilePictureModel(
    profileImage: profileImage ?? this.profileImage,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profileImage'] = profileImage;
    return map;
  }
}
