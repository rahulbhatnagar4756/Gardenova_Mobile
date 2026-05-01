import 'dart:convert';

UpdateProfileModel updateProfileModelFromJson(String str) =>
    UpdateProfileModel.fromJson(json.decode(str));

String updateProfileModelToJson(UpdateProfileModel data) =>
    json.encode(data.toJson());

class UpdateProfileModel {
  UpdateProfileModel({
    this.profileImage,
    this.dateOfBirth,
    this.gender,
    this.bio,
    this.occupation,
    this.company,
  });

  UpdateProfileModel.fromJson(dynamic json) {
    profileImage = json['profileImage'];
    dateOfBirth = json['dateOfBirth'];
    gender = json['gender'];
    bio = json['bio'];
    occupation = json['occupation'];
    company = json['company'];
  }

  String? profileImage;
  String? dateOfBirth;
  String? gender;
  String? bio;
  String? occupation;
  String? company;

  UpdateProfileModel copyWith({
    String? profileImage,
    String? dateOfBirth,
    String? gender,
    String? bio,
    String? occupation,
    String? company,
  }) => UpdateProfileModel(
    profileImage: profileImage ?? this.profileImage,
    dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    gender: gender ?? this.gender,
    bio: bio ?? this.bio,
    occupation: occupation ?? this.occupation,
    company: company ?? this.company,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['profileImage'] = profileImage;
    map['dateOfBirth'] = dateOfBirth;
    map['gender'] = gender;
    map['bio'] = bio;

    map['occupation'] = occupation;
    map['company'] = company;
    return map;
  }
}
