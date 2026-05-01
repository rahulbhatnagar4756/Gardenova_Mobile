class LeadsResponseModel {
  bool? success;
  String? message;
  List<LeadModel>? data;

  LeadsResponseModel({this.success, this.message, this.data});

  LeadsResponseModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];

    if (json['data'] != null) {
      data = (json['data'] as List).map((e) => LeadModel.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

class LeadModel {
  String? userId;
  String? role;
  String? companyName;
  String? leadsStatus;
  String? leadId;
  String? createdAt;
  String? telefone;
  String? whatsapp;
  String? website;
  String? email;

  LocationModel? location;
  RequestingUserModel? requestingUser;

  bool isSelected;

  LeadModel({
    this.userId,
    this.role,
    this.companyName,
    this.leadsStatus,
    this.leadId,
    this.createdAt,
    this.telefone,
    this.whatsapp,
    this.website,
    this.email,
    this.location,
    this.requestingUser,
    this.isSelected = false,
  });

  LeadModel.fromJson(dynamic json)
    : userId = json['userId'],
      role = json['role'],
      companyName = json['company_name'] ?? json['name'],
      leadsStatus = json['leads_status'],
      leadId = json['lead_id'],
      createdAt = json['created_at'],
      telefone = json['telefone'],
      whatsapp = json['whatsapp'],
      website = json['website'],
      email = json['email'],

      isSelected = false {
    location = json['location'] != null
        ? LocationModel.fromJson(json['location'])
        : null;
    requestingUser = json['requestingUser'] != null
        ? RequestingUserModel.fromJson(json['requestingUser'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'role': role,
      'company_name': companyName,
      'leads_status': leadsStatus,
      'lead_id': leadId,
      'created_at': createdAt,
      'telefone': telefone,
      'whatsapp': whatsapp,
      'website': website,
      'email': email,
      'location': location?.toJson(),
      'requestingUser': requestingUser?.toJson(),
    };
  }
}

class LocationModel {
  String? city;
  String? state;
  String? address;
  String? latitude;
  String? longitude;

  LocationModel({
    this.city,
    this.state,
    this.address,
    this.latitude,
    this.longitude,
  });

  LocationModel.fromJson(dynamic json) {
    city = json['city'];
    state = json['state'];
    address = json['address'];
    latitude = json['latitude']?.toString();
    longitude = json['longitude']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'state': state,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

}

class RequestingUserModel {
  String? userId;
  String? professionalProfileId;
  String? description;
  String? category;
  String? size;

  RequestingUserModel({
    this.userId,
    this.professionalProfileId,
    this.description,
    this.category,
    this.size,
  });

  RequestingUserModel.fromJson(dynamic json) {
    userId = json['userId'];
    professionalProfileId = json['professionalProfileId']?.toString();
    description = json['description'];
    category = json['category'];
    size = json['size'];
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'professionalProfileId': professionalProfileId.toString(),
      'description': description,
      "category": category,
      "size":size
    };
  }
}
