class LandscapeDesignRequestModel {
  String? imageBase64;
  Prefs? prefs;
  String? responseId;
  LandscapeDesignRequestModel({this.imageBase64, this.prefs, this.responseId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_base64'] = imageBase64;
    data['response_id'] = responseId;
    if (prefs != null) {
      data['prefs'] = prefs!.toJson();
    }
    return data;
  }
}

class Prefs {
  String? style;

  Prefs({this.style});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['style'] = style;
    return data;
  }
}

class LandscapeDesignResponseModel {
  bool? success;
  String? message;
  LandscapeData? data;

  LandscapeDesignResponseModel({this.success, this.message, this.data});

  LandscapeDesignResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? LandscapeData.fromJson(json['data']) : null;
  }
}

class LandscapeData {
  String? originalUrl;
  String? gardenUrl;
  String? description;
  DetectedSpace? detectedSpace;
  RecommendedPlants? recommendedPlants;
  String? style;

  LandscapeData({
    this.originalUrl,
    this.gardenUrl,
    this.description,
    this.detectedSpace,
    this.recommendedPlants,
    this.style,
  });

  LandscapeData.fromJson(Map<String, dynamic> json) {
    originalUrl = json['originalUrl']?.toString();
    gardenUrl = json['gardenUrl']?.toString();
    description = json['description']?.toString();
    style = json['style']?.toString();
    detectedSpace = json['detectedSpace'] != null
        ? DetectedSpace.fromJson(Map<String, dynamic>.from(json['detectedSpace']))
        : null;
    recommendedPlants = json['recommendedPlants'] != null
        ? RecommendedPlants.fromJson(
            Map<String, dynamic>.from(json['recommendedPlants']),
          )
        : null;
  }
}

class DetectedSpace {
  String? spaceType;
  String? category;
  String? confidence;
  String? reasoning;

  DetectedSpace({
    this.spaceType,
    this.category,
    this.confidence,
    this.reasoning,
  });

  DetectedSpace.fromJson(Map<String, dynamic> json) {
    spaceType = json['spaceType'];
    category = json['category'];
    confidence = json['confidence'];
    reasoning = json['reasoning'];
  }
}

class RecommendedPlants {
  String? region;
  String? climate;
  List<RecommendedPlant> plants;

  RecommendedPlants({
    this.region,
    this.climate,
    this.plants = const [],
  });

  bool get hasPlants => plants.isNotEmpty;

  RecommendedPlants.fromJson(Map<String, dynamic> json)
      : plants = <RecommendedPlant>[] {
    region = json['region']?.toString();
    climate = json['climate']?.toString();
    final rawPlants = json['plants'];
    if (rawPlants is List) {
      plants = rawPlants
          .whereType<Map>()
          .map((item) => RecommendedPlant.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
  }
}

class RecommendedPlant {
  String? commonName;
  String? latinName;
  String? type;
  String? sunlight;
  String? waterNeeds;
  String? notes;

  RecommendedPlant({
    this.commonName,
    this.latinName,
    this.type,
    this.sunlight,
    this.waterNeeds,
    this.notes,
  });

  RecommendedPlant.fromJson(Map<String, dynamic> json) {
    commonName = json['commonName']?.toString();
    latinName = json['latinName']?.toString();
    type = json['type']?.toString();
    sunlight = json['sunlight']?.toString();
    waterNeeds = json['waterNeeds']?.toString();
    notes = json['notes']?.toString();
  }
}
