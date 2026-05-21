class LocationModel {
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    required this.latitude,
    required this.longitude,
  });

  @override
  String toString() {
    return '''
City: $city
State: $state
Country: $country
Postal Code: $postalCode
Latitude: $latitude
Longitude: $longitude
''';
  }
}
