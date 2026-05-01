class IntroductionModel {
  IntroductionModel({String? imagePath, String? title, String? description}) {
    _imagePath = imagePath;
    _title = title;
    _description = description;
  }

  IntroductionModel.fromJson(dynamic json) {
    _title = json['title'];
    _description = json['description'];
    _imagePath = json['image_path'];
  }

  String? _title;
  String? _description;
  String? _imagePath;

  IntroductionModel copyWith({
    String? title,
    String? description,
    String? imagePath,
  }) => IntroductionModel(
    title: title ?? _title,
    description: description ?? _description,
    imagePath: imagePath ?? _imagePath,
  );

  String? get title => _title;

  String? get description => _description;

  String? get imagePath => _imagePath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = _title;
    map['description'] = _description;
    map['image_path'] = _imagePath;
    return map;
  }
}
