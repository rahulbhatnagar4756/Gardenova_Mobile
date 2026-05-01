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
    String? name,
    String? scientific,
    String? image,
    String? description,
    List<String>? whyRecommended,
  }) {
    _id = id;
    _name = name;
    _scientific = scientific;
    _image = image;
    _description = description;
    _whyRecommended = whyRecommended;
  }

  PlantRecommendationsResponse.fromJson(dynamic json) {
    _id = json['id'].toString();
    _name = json['name'];
    _scientific = json['scientific'];
    _image = json['image'];
    _description = json['description'];
    _whyRecommended = json['whyRecommended'] != null
        ? json['whyRecommended'].cast<String>()
        : [];
  }

  String? _id;
  String? _name;
  String? _scientific;
  String? _image;
  String? _description;
  List<String>? _whyRecommended;

  PlantRecommendationsResponse copyWith({
    String? id,
    String? name,
    String? scientific,
    String? image,
    String? description,
    List<String>? whyRecommended,
  }) => PlantRecommendationsResponse(
    id: id ?? _id,
    name: name ?? _name,
    scientific: scientific ?? _scientific,
    image: image ?? _image,
    description: description ?? _description,
    whyRecommended: whyRecommended ?? _whyRecommended,
  );

  String? get id => _id;

  String? get name => _name;

  String? get scientific => _scientific;

  String? get image => _image;

  String? get description => _description;

  List<String>? get whyRecommended => _whyRecommended;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['scientific'] = _scientific;
    map['image'] = _image;
    map['description'] = _description;
    map['whyRecommended'] = _whyRecommended;
    return map;
  }
}
