class LandscapeDesignRequestModel {
  String? imageBase64;
  Prefs? prefs;

  LandscapeDesignRequestModel({this.imageBase64, this.prefs});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image_base64'] = imageBase64;
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

  LandscapeData({this.originalUrl, this.gardenUrl, this.description});

  LandscapeData.fromJson(Map<String, dynamic> json) {
    originalUrl = json['originalUrl'];
    gardenUrl = json['gardenUrl'];
    description = json['description'];
  }
}
