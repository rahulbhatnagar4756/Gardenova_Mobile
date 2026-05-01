class PlantDiagnosisRequestModel {
  PlantDiagnosisRequestModel({
    List<String>? images,
    num? latitude,
    num? longitude,
  }) {
    _images = images;
    _latitude = latitude;
    _longitude = longitude;
  }

  List<String>? _images;
  num? _latitude;
  num? _longitude;

  PlantDiagnosisRequestModel copyWith({
    List<String>? images,
    num? latitude,
    num? longitude,
  }) => PlantDiagnosisRequestModel(
    images: images ?? _images,
    latitude: latitude ?? _latitude,
    longitude: longitude ?? _longitude,
  );

  set images(List<String>? value) => _images = value;

  set latitude(num? value) => _latitude = value;

  set longitude(num? value) => _longitude = value;

  factory PlantDiagnosisRequestModel.fromJson(Map<String, dynamic> json) {
    return PlantDiagnosisRequestModel(
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['images'] = _images;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    return map;
  }
}
