class PlantsListResponseModel {
  PlantsListResponseModel({bool? success, String? message, Data? data}) {
    _success = success;
    _message = message;
    _data = data;
  }

  PlantsListResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

  PlantsListResponseModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) => PlantsListResponseModel(
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
  Data({
    num? currentPage,
    num? totalPages,
    num? totalCount,
    num? limit,
    List<Plants>? plants,
  }) {
    _currentPage = currentPage;
    _totalPages = totalPages;
    _totalCount = totalCount;
    _limit = limit;
    _plants = plants;
  }

  Data.fromJson(dynamic json) {
    _currentPage = json['currentPage'];
    _totalPages = json['totalPages'];
    _totalCount = json['totalCount'];
    _limit = json['limit'];
    if (json['plants'] != null) {
      _plants = [];
      json['plants'].forEach((v) {
        _plants?.add(Plants.fromJson(v));
      });
    }
  }

  num? _currentPage;
  num? _totalPages;
  num? _totalCount;
  num? _limit;
  List<Plants>? _plants;

  Data copyWith({
    num? currentPage,
    num? totalPages,
    num? totalCount,
    num? limit,
    List<Plants>? plants,
  }) => Data(
    currentPage: currentPage ?? _currentPage,
    totalPages: totalPages ?? _totalPages,
    totalCount: totalCount ?? _totalCount,
    limit: limit ?? _limit,
    plants: plants ?? _plants,
  );

  num? get currentPage => _currentPage;

  num? get totalPages => _totalPages;

  num? get totalCount => _totalCount;

  num? get limit => _limit;

  List<Plants>? get plants => _plants;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currentPage'] = _currentPage;
    map['totalPages'] = _totalPages;
    map['totalCount'] = _totalCount;
    map['limit'] = _limit;
    if (_plants != null) {
      map['plants'] = _plants?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Plants {
  Plants({
    String? id,
    String? scientificName,
    String? commonName,
    String? imageSearchUrl,
    String? description,
    String? native,
    String? light,
    String? waterNeeds,
    String? maintenanceLevel,
    String? growthForm,
    List<String>? spaceTypes,
    List<String>? areaSizes,
    List<String>? challenges,
    List<String>? techPreferences,
    List<String>? careNotes,
    List<Locations>? locations,
  }) {
    _id = id;
    _scientificName = scientificName;
    _commonName = commonName;
    _imageSearchUrl = imageSearchUrl;
    _description = description;
    _native = native;
    _light = light;
    _waterNeeds = waterNeeds;
    _maintenanceLevel = maintenanceLevel;
    _growthForm = growthForm;
    _spaceTypes = spaceTypes;
    _areaSizes = areaSizes;
    _challenges = challenges;
    _techPreferences = techPreferences;
    _careNotes = careNotes;
    _locations = locations;
  }

  Plants.fromJson(dynamic json) {
    _id = json['id'];
    _scientificName = json['scientific_name'];
    _commonName = json['common_name'];
    _imageSearchUrl = json['image_search_url'];
    _description = json['description'];
    _native = json['native'];
    _light = json['light'];
    _waterNeeds = json['water_needs'];
    _maintenanceLevel = json['maintenance_level'];
    _growthForm = json['growth_form'];
    _spaceTypes = json['space_types'] != null
        ? json['space_types'].cast<String>()
        : [];
    _areaSizes = json['area_sizes'] != null
        ? json['area_sizes'].cast<String>()
        : [];
    _challenges = json['challenges'] != null
        ? json['challenges'].cast<String>()
        : [];
    _techPreferences = json['tech_preferences'] != null
        ? json['tech_preferences'].cast<String>()
        : [];
    _careNotes = json['care_notes'] != null
        ? json['care_notes'].cast<String>()
        : [];
    if (json['locations'] != null) {
      _locations = [];
      json['locations'].forEach((v) {
        _locations?.add(Locations.fromJson(v));
      });
    }
  }

  String? _id;
  String? _scientificName;
  String? _commonName;
  String? _imageSearchUrl;
  String? _description;
  dynamic _native;
  String? _light;
  String? _waterNeeds;
  String? _maintenanceLevel;
  String? _growthForm;
  List<String>? _spaceTypes;
  List<String>? _areaSizes;
  List<String>? _challenges;
  List<String>? _techPreferences;
  List<String>? _careNotes;
  List<Locations>? _locations;

  Plants copyWith({
    String? id,
    String? scientificName,
    String? commonName,
    String? imageSearchUrl,
    String? description,
    String? native,
    String? light,
    String? waterNeeds,
    String? maintenanceLevel,
    String? growthForm,
    List<String>? spaceTypes,
    List<String>? areaSizes,
    List<String>? challenges,
    List<String>? techPreferences,
    List<String>? careNotes,
    List<Locations>? locations,
  }) => Plants(
    id: id ?? _id,
    scientificName: scientificName ?? _scientificName,
    commonName: commonName ?? _commonName,
    imageSearchUrl: imageSearchUrl ?? _imageSearchUrl,
    description: description ?? _description,
    native: native ?? _native,
    light: light ?? _light,
    waterNeeds: waterNeeds ?? _waterNeeds,
    maintenanceLevel: maintenanceLevel ?? _maintenanceLevel,
    growthForm: growthForm ?? _growthForm,
    spaceTypes: spaceTypes ?? _spaceTypes,
    areaSizes: areaSizes ?? _areaSizes,
    challenges: challenges ?? _challenges,
    techPreferences: techPreferences ?? _techPreferences,
    careNotes: careNotes ?? _careNotes,
    locations: locations ?? _locations,
  );

  String? get id => _id;

  String? get scientificName => _scientificName;

  String? get commonName => _commonName;

  String? get imageSearchUrl => _imageSearchUrl;

  String? get description => _description;

  String? get native => _native;

  String? get light => _light;

  String? get waterNeeds => _waterNeeds;

  String? get maintenanceLevel => _maintenanceLevel;

  String? get growthForm => _growthForm;

  List<String>? get spaceTypes => _spaceTypes;

  List<String>? get areaSizes => _areaSizes;

  List<String>? get challenges => _challenges;

  List<String>? get techPreferences => _techPreferences;

  List<String>? get careNotes => _careNotes;

  List<Locations>? get locations => _locations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['scientific_name'] = _scientificName;
    map['common_name'] = _commonName;
    map['image_search_url'] = _imageSearchUrl;
    map['description'] = _description;
    map['native'] = _native;
    map['light'] = _light;
    map['water_needs'] = _waterNeeds;
    map['maintenance_level'] = _maintenanceLevel;
    map['growth_form'] = _growthForm;
    map['space_types'] = _spaceTypes;
    map['area_sizes'] = _areaSizes;
    map['challenges'] = _challenges;
    map['tech_preferences'] = _techPreferences;
    map['care_notes'] = _careNotes;
    if (_locations != null) {
      map['locations'] = _locations?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Locations {
  Locations({String? locationType, String? locationValue}) {
    _locationType = locationType;
    _locationValue = locationValue;
  }

  Locations.fromJson(dynamic json) {
    _locationType = json['location_type'];
    _locationValue = json['location_value'];
  }

  String? _locationType;
  String? _locationValue;

  Locations copyWith({String? locationType, String? locationValue}) =>
      Locations(
        locationType: locationType ?? _locationType,
        locationValue: locationValue ?? _locationValue,
      );

  String? get locationType => _locationType;

  String? get locationValue => _locationValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['location_type'] = _locationType;
    map['location_value'] = _locationValue;
    return map;
  }
}
