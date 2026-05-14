// class PlantRecommendationsResponseModel {
//   PlantRecommendationsResponseModel({
//     bool? success,
//     String? message,
//     Data? data,
//   }) {
//     _success = success;
//     _message = message;
//     _data = data;
//   }

//   PlantRecommendationsResponseModel.fromJson(dynamic json) {
//     if (json == null) {
//       _success = false;
//       _message = "Invalid response";
//       _data = null;
//       return;
//     }

//     _success = json['success'];
//     _message = json['message'];
//     _data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }

//   bool? _success;
//   String? _message;
//   Data? _data;

//   PlantRecommendationsResponseModel copyWith({
//     bool? success,
//     String? message,
//     Data? data,
//   }) => PlantRecommendationsResponseModel(
//     success: success ?? _success,
//     message: message ?? _message,
//     data: data ?? _data,
//   );

//   bool? get success => _success;

//   String? get message => _message;

//   Data? get data => _data;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['success'] = _success;
//     map['message'] = _message;
//     if (_data != null) {
//       map['data'] = _data?.toJson();
//     }
//     return map;
//   }
// }

// class Data {
//   Data({List<PlantRecommendationsResponse>? plantRecommendations}) {
//     _plantRecommendations = plantRecommendations;
//   }

//   Data.fromJson(dynamic json) {
//     if (json['plantRecommendations'] != null) {
//       _plantRecommendations = [];
//       json['plantRecommendations'].forEach((v) {
//         _plantRecommendations?.add(PlantRecommendationsResponse.fromJson(v));
//       });
//     }
//   }

//   List<PlantRecommendationsResponse>? _plantRecommendations;

//   Data copyWith({List<PlantRecommendationsResponse>? plantRecommendations}) =>
//       Data(plantRecommendations: plantRecommendations ?? _plantRecommendations);

//   List<PlantRecommendationsResponse>? get plantRecommendations =>
//       _plantRecommendations;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     if (_plantRecommendations != null) {
//       map['plantRecommendations'] = _plantRecommendations
//           ?.map((v) => v.toJson())
//           .toList();
//     }
//     return map;
//   }
// }

// class PlantRecommendationsResponse {
//   PlantRecommendationsResponse({
//     String? id,
//     String? name,
//     String? scientific,
//     String? image,
//     String? description,
//     List<String>? whyRecommended,
//   }) {
//     _id = id;
//     _name = name;
//     _scientific = scientific;
//     _image = image;
//     _description = description;
//     _whyRecommended = whyRecommended;
//   }

//   PlantRecommendationsResponse.fromJson(dynamic json) {
//     _id = json['id'].toString();
//     _name = json['name'];
//     _scientific = json['scientific'];
//     _image = json['image'];
//     _description = json['description'];

//     _whyRecommended = json['whyRecommended'] != null
//         ? json['whyRecommended'].cast<String>()
//         : [];
//   }

//   String? _id;
//   String? _name;
//   String? _scientific;
//   String? _image;
//   String? _description;
//   List<String>? _whyRecommended;

//   PlantRecommendationsResponse copyWith({
//     String? id,
//     String? name,
//     String? scientific,
//     String? image,
//     String? description,
//     List<String>? whyRecommended,
//   }) => PlantRecommendationsResponse(
//     id: id ?? _id,
//     name: name ?? _name,
//     scientific: scientific ?? _scientific,
//     image: image ?? _image,
//     description: description ?? _description,
//     whyRecommended: whyRecommended ?? _whyRecommended,
//   );

//   String? get id => _id;

//   String? get name => _name;

//   String? get scientific => _scientific;

//   String? get image => _image;

//   String? get description => _description;

//   List<String>? get whyRecommended => _whyRecommended;

//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['id'] = _id;
//     map['name'] = _name;
//     map['scientific'] = _scientific;
//     map['image'] = _image;
//     map['description'] = _description;
//     map['whyRecommended'] = _whyRecommended;
//     return map;
//   }
// }
/*
i am a flutter developer, with 4 year of experience, currently  i am working in it company as a empoloyee, i want to work now as indivitual so that in feature i can start my own company for it, so tell me what is the my plan should, be i will quit my job after a year, so tell me until now what things i have to prepare so that when i quick my job after a year i will ready or alreaedy dogin the client works directly, get the direct profiect from client.
*/

class PlantRecommendationsResponseModel {
  PlantRecommendationsResponseModel({
    bool? success,
    String? message,
    Data? data,
  }) {
    _success = success;
    _message = message;
    _data = data;
  }

  PlantRecommendationsResponseModel.fromJson(dynamic json) {
    if (json == null) {
      _success = false;
      _message = "Invalid response";
      _data = null;
      return;
    }

    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

  PlantRecommendationsResponseModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) => PlantRecommendationsResponseModel(
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
  Data({List<PlantRecommendationsResponse>? plantRecommendations}) {
    _plantRecommendations = plantRecommendations;
  }

  Data.fromJson(dynamic json) {
    if (json['plantRecommendations'] != null) {
      _plantRecommendations = [];

      json['plantRecommendations'].forEach((v) {
        _plantRecommendations?.add(PlantRecommendationsResponse.fromJson(v));
      });
    }
  }

  List<PlantRecommendationsResponse>? _plantRecommendations;

  Data copyWith({List<PlantRecommendationsResponse>? plantRecommendations}) =>
      Data(plantRecommendations: plantRecommendations ?? _plantRecommendations);

  List<PlantRecommendationsResponse>? get plantRecommendations =>
      _plantRecommendations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (_plantRecommendations != null) {
      map['plantRecommendations'] = _plantRecommendations
          ?.map((v) => v.toJson())
          .toList();
    }

    return map;
  }
}

class PlantRecommendationsResponse {
  PlantRecommendationsResponse({
    String? id,
    String? speciesId,
    String? speciesName,
    String? genusName,
    String? familyName,
    String? commonName,
    String? image,
    String? plantType,
    String? growthHabit,
    bool? edible,
    String? ediblePart,
    bool? vegetable,
    List<String>? whyRecommended,
    int? matchScore,
  }) {
    _id = id;
    _speciesId = speciesId;
    _speciesName = speciesName;
    _genusName = genusName;
    _familyName = familyName;
    _commonName = commonName;
    _image = image;
    _plantType = plantType;
    _growthHabit = growthHabit;
    _edible = edible;
    _ediblePart = ediblePart;
    _vegetable = vegetable;
    _whyRecommended = whyRecommended;
    _matchScore = matchScore;
  }

  PlantRecommendationsResponse.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _speciesId = json['speciesId']?.toString();
    _speciesName = json['speciesName'];
    _genusName = json['genusName'];
    _familyName = json['familyName'];
    _commonName = json['commonName'];
    // _image = json['image'];
    if (json.containsKey('image_url')) {
      _image = json['image_url'] ?? json['image'] ?? '';
    } else {
      _image = json['image'];
    }
    _plantType = json['plantType'];
    _growthHabit = json['growthHabit'];
    _edible = json['edible'];
    _ediblePart = json['ediblePart'];
    _vegetable = json['vegetable'];

    _whyRecommended = json['whyRecommended'] != null
        ? List<String>.from(json['whyRecommended'])
        : [];

    _matchScore = json['matchScore'];
  }

  String? _id;
  String? _speciesId;
  String? _speciesName;
  String? _genusName;
  String? _familyName;
  String? _commonName;
  String? _image;
  String? _plantType;
  String? _growthHabit;
  bool? _edible;
  String? _ediblePart;
  bool? _vegetable;
  List<String>? _whyRecommended;
  int? _matchScore;

  PlantRecommendationsResponse copyWith({
    String? id,
    String? speciesId,
    String? speciesName,
    String? genusName,
    String? familyName,
    String? commonName,
    String? image,
    String? plantType,
    String? growthHabit,
    bool? edible,
    String? ediblePart,
    bool? vegetable,
    List<String>? whyRecommended,
    int? matchScore,
  }) => PlantRecommendationsResponse(
    id: id ?? _id,
    speciesId: speciesId ?? _speciesId,
    speciesName: speciesName ?? _speciesName,
    genusName: genusName ?? _genusName,
    familyName: familyName ?? _familyName,
    commonName: commonName ?? _commonName,
    image: image ?? _image,
    plantType: plantType ?? _plantType,
    growthHabit: growthHabit ?? _growthHabit,
    edible: edible ?? _edible,
    ediblePart: ediblePart ?? _ediblePart,
    vegetable: vegetable ?? _vegetable,
    whyRecommended: whyRecommended ?? _whyRecommended,
    matchScore: matchScore ?? _matchScore,
  );

  String? get id => _id;

  String? get speciesId => _speciesId;

  String? get speciesName => _speciesName;

  String? get genusName => _genusName;

  String? get familyName => _familyName;

  String? get commonName => _commonName;

  String? get image => _image;

  String? get plantType => _plantType;

  String? get growthHabit => _growthHabit;

  bool? get edible => _edible;

  String? get ediblePart => _ediblePart;

  bool? get vegetable => _vegetable;

  List<String>? get whyRecommended => _whyRecommended;

  int? get matchScore => _matchScore;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['id'] = _id;
    map['speciesId'] = _speciesId;
    map['speciesName'] = _speciesName;
    map['genusName'] = _genusName;
    map['familyName'] = _familyName;
    map['commonName'] = _commonName;
    map['image'] = _image;
    map['image_url'] = _image;
    map['plantType'] = _plantType;
    map['growthHabit'] = _growthHabit;
    map['edible'] = _edible;
    map['ediblePart'] = _ediblePart;
    map['vegetable'] = _vegetable;
    map['whyRecommended'] = _whyRecommended;
    map['matchScore'] = _matchScore;

    return map;
  }
}
