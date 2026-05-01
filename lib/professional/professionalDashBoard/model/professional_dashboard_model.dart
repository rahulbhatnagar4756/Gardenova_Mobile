class ApiResponse {
  final bool? success;
  final String? message;
  final ProfessionalCompanyResponse? data;

  ApiResponse({this.success, this.message, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: parseString(json['message']),
      data: json['data'] != null
          ? ProfessionalCompanyResponse.fromJson(json['data'])
          : null,
    );
  }
}

class ProfessionalCompanyResponse {
  final int? total;
  final int? limit;
  final int? offset;
  final UserLocation? userLocation;
  final List<ProfessionalCompany> data;
  ProfessionalCompanyResponse({
    this.total,
    this.limit,
    this.offset,
    this.userLocation,
    this.data = const [],
  });

  factory ProfessionalCompanyResponse.fromJson(Map<String, dynamic> json) {
    return ProfessionalCompanyResponse(
      total: parseInt(json['total']),
      limit: parseInt(json['limit']),
      offset: parseInt(json['offset']),
      userLocation: json['user_location'] != null
          ? UserLocation.fromJson(json['user_location'])
          : null,
      data:
          (json['data'] as List?)
              ?.map(
                (e) => ProfessionalCompany.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

class UserLocation {
  final double? lat;
  final double? lng;

  UserLocation({this.lat, this.lng});

  factory UserLocation.fromJson(Map<String, dynamic> json) {
    return UserLocation(
      lat: parseDouble(json['lat']),
      lng: parseDouble(json['lng']),
    );
  }
}

class ProfessionalCompany {
  final String? id;
  final String? userId;
  final String? companyName;
  final String? legalName;
  final String? category;
  final String? description;
  final String? imageUrl;
  final String? city;
  final String? state;
  final String? address;
  final Contact? contact;
  final double? rating;
  final int? numAvaliacoes;
  final String? verifiedSource;
  final Subscription? subscription;
  final double? distanceKm;

  bool isSelected;

  ProfessionalCompany({
    this.id,
    this.userId,
    this.companyName,
    this.legalName,
    this.category,
    this.description,
    this.imageUrl,
    this.city,
    this.state,
    this.address,
    this.contact,
    this.rating,
    this.numAvaliacoes,
    this.verifiedSource,
    this.subscription,
    this.distanceKm,
    this.isSelected = false,
  });

  factory ProfessionalCompany.fromJson(Map<String, dynamic> json) {
    return ProfessionalCompany(
      id: json['id'].toString(),
            userId: json['userid'].toString(),
      companyName: json['company_name'],
      legalName: json['legal_name'],
      category: json['category'],
      description: json['description'],
      imageUrl: json['image_url'],
      city: json['city'],
      state: json['state'],
      address: json['address'],
      contact: json['contact'] != null
          ? Contact.fromJson(json['contact'])
          : null,
      rating: parseDouble(json['rating']),
      numAvaliacoes: parseInt(json['num_avaliacoes']),
      verifiedSource: json['verified_source'],
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'])
          : null,
      distanceKm: parseDouble(json['distance_km']),
      isSelected: false,
    );
  }
}

class Contact {
  final String? phone;
  final String? email;

  Contact({this.phone, this.email});

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      phone: parseString(json['phone']),
      email: parseString(json['email']),
    );
  }
}

class Subscription {
  final String? plan;

  Subscription({this.plan});

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(plan: parseString(json['plan']));
  }
}

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0.0;
}

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}

String parseString(dynamic value) {
  if (value == null) return "";
  return value.toString();
}
