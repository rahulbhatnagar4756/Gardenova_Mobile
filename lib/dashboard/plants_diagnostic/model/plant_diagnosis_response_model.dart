class PlantDiagnosisResponseModel {
  PlantDiagnosisResponseModel({bool? success, String? message, Data? data}) {
    _success = success;
    _message = message;
    _data = data;
  }

  PlantDiagnosisResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  Data? _data;

  PlantDiagnosisResponseModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) => PlantDiagnosisResponseModel(
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
    bool? isPlant,
    num? confidence,
    PlantInfo? plantInfo,
    HealthStatus? healthStatus,
    List<KasagardemSolutions>? kasagardemSolutions,
  }) {
    _isPlant = isPlant;
    _confidence = confidence;
    _plantInfo = plantInfo;
    _healthStatus = healthStatus;
    _kasagardemSolutions = kasagardemSolutions;
  }

  Data.fromJson(dynamic json) {
    _isPlant = json['isPlant'];
    _confidence = json['confidence'];
    _plantInfo = json['plantInfo'] != null
        ? PlantInfo.fromJson(json['plantInfo'])
        : null;
    _healthStatus = json['healthStatus'] != null
        ? HealthStatus.fromJson(json['healthStatus'])
        : null;
    if (json['kasagardemSolutions'] != null) {
      _kasagardemSolutions = [];
      json['kasagardemSolutions'].forEach((v) {
        _kasagardemSolutions?.add(KasagardemSolutions.fromJson(v));
      });
    }
  }

  dynamic _isPlant;
  num? _confidence;
  PlantInfo? _plantInfo;
  HealthStatus? _healthStatus;
  List<KasagardemSolutions>? _kasagardemSolutions;

  Data copyWith({
    dynamic isPlant,
    num? confidence,
    PlantInfo? plantInfo,
    HealthStatus? healthStatus,
    List<KasagardemSolutions>? kasagardemSolutions,
  }) => Data(
    isPlant: isPlant ?? _isPlant,
    confidence: confidence ?? _confidence,
    plantInfo: plantInfo ?? _plantInfo,
    healthStatus: healthStatus ?? _healthStatus,
    kasagardemSolutions: kasagardemSolutions ?? _kasagardemSolutions,
  );

  dynamic get isPlant => _isPlant;

  num? get confidence => _confidence;

  PlantInfo? get plantInfo => _plantInfo;

  HealthStatus? get healthStatus => _healthStatus;

  List<KasagardemSolutions>? get kasagardemSolutions => _kasagardemSolutions;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isPlant'] = _isPlant;
    map['confidence'] = _confidence;
    if (_plantInfo != null) {
      map['plantInfo'] = _plantInfo?.toJson();
    }
    if (_healthStatus != null) {
      map['healthStatus'] = _healthStatus?.toJson();
    }
    if (_kasagardemSolutions != null) {
      map['kasagardemSolutions'] = _kasagardemSolutions
          ?.map((v) => v.toJson())
          .toList();
    }
    return map;
  }
}

class KasagardemSolutions {
  KasagardemSolutions({
    String? issue,
    String? automationFeature,
    String? howItHelps,
    List<String>? benefits,
    List<String>? setupSteps,
  }) {
    _issue = issue;
    _automationFeature = automationFeature;
    _howItHelps = howItHelps;
    _benefits = benefits;
    _setupSteps = setupSteps;
  }

  KasagardemSolutions.fromJson(dynamic json) {
    _issue = json['issue'];
    _automationFeature = json['automationFeature'];
    _howItHelps = json['howItHelps'];
    _benefits = json['benefits'] != null ? json['benefits'].cast<String>() : [];
    _setupSteps = json['setupSteps'] != null
        ? json['setupSteps'].cast<String>()
        : [];
  }

  String? _issue;
  String? _automationFeature;
  String? _howItHelps;
  List<String>? _benefits;
  List<String>? _setupSteps;

  KasagardemSolutions copyWith({
    String? issue,
    String? automationFeature,
    String? howItHelps,
    List<String>? benefits,
    List<String>? setupSteps,
  }) => KasagardemSolutions(
    issue: issue ?? _issue,
    automationFeature: automationFeature ?? _automationFeature,
    howItHelps: howItHelps ?? _howItHelps,
    benefits: benefits ?? _benefits,
    setupSteps: setupSteps ?? _setupSteps,
  );

  String? get issue => _issue;

  String? get automationFeature => _automationFeature;

  String? get howItHelps => _howItHelps;

  List<String>? get benefits => _benefits;

  List<String>? get setupSteps => _setupSteps;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['issue'] = _issue;
    map['automationFeature'] = _automationFeature;
    map['howItHelps'] = _howItHelps;
    map['benefits'] = _benefits;
    map['setupSteps'] = _setupSteps;
    return map;
  }
}

class HealthStatus {
  HealthStatus({
    dynamic isHealthy,
    num? healthProbability,
    List<Issues>? issues,
  }) {
    _isHealthy = isHealthy;
    _healthProbability = healthProbability;
    _issues = issues;
  }

  HealthStatus.fromJson(dynamic json) {
    _isHealthy = json['isHealthy'];
    _healthProbability = json['healthProbability'];
    if (json['issues'] != null) {
      _issues = [];
      json['issues'].forEach((v) {
        _issues?.add(Issues.fromJson(v));
      });
    }
  }

  dynamic _isHealthy;
  num? _healthProbability;
  List<Issues>? _issues;

  HealthStatus copyWith({
    bool? isHealthy,
    num? healthProbability,
    List<Issues>? issues,
  }) => HealthStatus(
    isHealthy: isHealthy ?? _isHealthy,
    healthProbability: healthProbability ?? _healthProbability,
    issues: issues ?? _issues,
  );

  bool? get isHealthy => _isHealthy;

  num? get healthProbability => _healthProbability;

  List<Issues>? get issues => _issues;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isHealthy'] = _isHealthy;
    map['healthProbability'] = _healthProbability;
    if (_issues != null) {
      map['issues'] = _issues?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Issues {
  Issues({
    String? name,
    String? type,
    num? probability,
    String? severity,
    String? description,
    List<String>? symptoms,
    List<String>? causes,
    Treatment? treatment,
    List<String>? similarImages,
  }) {
    _name = name;
    _type = type;
    _probability = probability;
    _severity = severity;
    _description = description;
    _symptoms = symptoms;
    _causes = causes;
    _treatment = treatment;
    _similarImages = similarImages;
  }

  Issues.fromJson(dynamic json) {
    _name = json['name'];
    _type = json['type'];
    _probability = json['probability'];
    _severity = json['severity'];
    _description = json['description'];
    _symptoms = json['symptoms'] != null ? json['symptoms'].cast<String>() : [];
    _causes = json['causes'] != null ? json['causes'].cast<String>() : [];
    _treatment = json['treatment'] != null
        ? Treatment.fromJson(json['treatment'])
        : null;
    _similarImages = json['similarImages'] != null
        ? json['similarImages'].cast<String>()
        : [];
  }

  String? _name;
  String? _type;
  num? _probability;
  String? _severity;
  String? _description;
  List<String>? _symptoms;
  List<String>? _causes;
  Treatment? _treatment;
  List<String>? _similarImages;

  Issues copyWith({
    String? name,
    String? type,
    num? probability,
    String? severity,
    String? description,
    List<String>? symptoms,
    List<String>? causes,
    Treatment? treatment,
    List<String>? similarImages,
  }) => Issues(
    name: name ?? _name,
    type: type ?? _type,
    probability: probability ?? _probability,
    severity: severity ?? _severity,
    description: description ?? _description,
    symptoms: symptoms ?? _symptoms,
    causes: causes ?? _causes,
    treatment: treatment ?? _treatment,
    similarImages: similarImages ?? _similarImages,
  );

  String? get name => _name;

  String? get type => _type;

  num? get probability => _probability;

  String? get severity => _severity;

  String? get description => _description;

  List<String>? get symptoms => _symptoms;

  List<String>? get causes => _causes;

  Treatment? get treatment => _treatment;

  List<String>? get similarImages => _similarImages;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['type'] = _type;
    map['probability'] = _probability;
    map['severity'] = _severity;
    map['description'] = _description;
    map['symptoms'] = _symptoms;
    map['causes'] = _causes;
    if (_treatment != null) {
      map['treatment'] = _treatment?.toJson();
    }
    map['similarImages'] = _similarImages;
    return map;
  }
}

class Treatment {
  Treatment({
    List<String>? immediate,
    List<String>? longTerm,
    List<String>? prevention,
  }) {
    _immediate = immediate;
    _longTerm = longTerm;
    _prevention = prevention;
  }

  Treatment.fromJson(dynamic json) {
    _immediate = json['immediate'] != null
        ? json['immediate'].cast<String>()
        : [];
    _longTerm = json['longTerm'] != null ? json['longTerm'].cast<String>() : [];
    _prevention = json['prevention'] != null
        ? json['prevention'].cast<String>()
        : [];
  }

  List<String>? _immediate;
  List<String>? _longTerm;
  List<String>? _prevention;

  Treatment copyWith({
    List<String>? immediate,
    List<String>? longTerm,
    List<String>? prevention,
  }) => Treatment(
    immediate: immediate ?? _immediate,
    longTerm: longTerm ?? _longTerm,
    prevention: prevention ?? _prevention,
  );

  List<String>? get immediate => _immediate;

  List<String>? get longTerm => _longTerm;

  List<String>? get prevention => _prevention;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['immediate'] = _immediate;
    map['longTerm'] = _longTerm;
    map['prevention'] = _prevention;
    return map;
  }
}

class PlantInfo {
  PlantInfo({
    String? scientificName,
    List<String>? commonNames,
    num? probability,
    String? description,
    Taxonomy? taxonomy,
    List<String>? images,
    CareGuide? careGuide,
    String? uses,
    String? toxicity,
    String? culturalSignificance,
  }) {
    _scientificName = scientificName;
    _commonNames = commonNames;
    _probability = probability;
    _description = description;
    _taxonomy = taxonomy;
    _images = images;
    _careGuide = careGuide;
    _uses = uses;
    _toxicity = toxicity;
    _culturalSignificance = culturalSignificance;
  }

  PlantInfo.fromJson(dynamic json) {
    _scientificName = json['scientificName'];
    _commonNames = json['commonNames'] != null
        ? json['commonNames'].cast<String>()
        : [];
    _probability = json['probability'];
    _description = json['description'];
    _taxonomy = json['taxonomy'] != null
        ? Taxonomy.fromJson(json['taxonomy'])
        : null;
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _careGuide = json['careGuide'] != null
        ? CareGuide.fromJson(json['careGuide'])
        : null;
    _uses = json['uses'];
    _toxicity = json['toxicity'];
    _culturalSignificance = json['culturalSignificance'];
  }

  String? _scientificName;
  List<String>? _commonNames;
  num? _probability;
  String? _description;
  Taxonomy? _taxonomy;
  List<String>? _images;
  CareGuide? _careGuide;
  String? _uses;
  String? _toxicity;
  String? _culturalSignificance;

  PlantInfo copyWith({
    String? scientificName,
    List<String>? commonNames,
    num? probability,
    String? description,
    Taxonomy? taxonomy,
    List<String>? images,
    CareGuide? careGuide,
    String? uses,
    String? toxicity,
    String? culturalSignificance,
  }) => PlantInfo(
    scientificName: scientificName ?? _scientificName,
    commonNames: commonNames ?? _commonNames,
    probability: probability ?? _probability,
    description: description ?? _description,
    taxonomy: taxonomy ?? _taxonomy,
    images: images ?? _images,
    careGuide: careGuide ?? _careGuide,
    uses: uses ?? _uses,
    toxicity: toxicity ?? _toxicity,
    culturalSignificance: culturalSignificance ?? _culturalSignificance,
  );

  String? get scientificName => _scientificName;

  List<String>? get commonNames => _commonNames;

  num? get probability => _probability;

  String? get description => _description;

  Taxonomy? get taxonomy => _taxonomy;

  List<String>? get images => _images;

  CareGuide? get careGuide => _careGuide;

  String? get uses => _uses;

  String? get toxicity => _toxicity;

  String? get culturalSignificance => _culturalSignificance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['scientificName'] = _scientificName;
    map['commonNames'] = _commonNames;
    map['probability'] = _probability;
    map['description'] = _description;
    if (_taxonomy != null) {
      map['taxonomy'] = _taxonomy?.toJson();
    }
    map['images'] = _images;
    if (_careGuide != null) {
      map['careGuide'] = _careGuide?.toJson();
    }
    map['uses'] = _uses;
    map['toxicity'] = _toxicity;
    map['culturalSignificance'] = _culturalSignificance;
    return map;
  }
}

class CareGuide {
  CareGuide({
    String? watering,
    String? lightCondition,
    String? soilType,
    List<String>? propagation,
  }) {
    _watering = watering;
    _lightCondition = lightCondition;
    _soilType = soilType;
    _propagation = propagation;
  }

  CareGuide.fromJson(dynamic json) {
    _watering = json['watering'];
    _lightCondition = json['lightCondition'];
    _soilType = json['soilType'];
    _propagation = json['propagation'] != null
        ? json['propagation'].cast<String>()
        : [];
  }

  String? _watering;
  String? _lightCondition;
  String? _soilType;
  List<String>? _propagation;

  CareGuide copyWith({
    String? watering,
    String? lightCondition,
    String? soilType,
    List<String>? propagation,
  }) => CareGuide(
    watering: watering ?? _watering,
    lightCondition: lightCondition ?? _lightCondition,
    soilType: soilType ?? _soilType,
    propagation: propagation ?? _propagation,
  );

  String? get watering => _watering;

  String? get lightCondition => _lightCondition;

  String? get soilType => _soilType;

  List<String>? get propagation => _propagation;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['watering'] = _watering;
    map['lightCondition'] = _lightCondition;
    map['soilType'] = _soilType;
    map['propagation'] = _propagation;
    return map;
  }
}

class Taxonomy {
  Taxonomy({
    String? plantClass,
    String? genus,
    String? order,
    String? family,
    String? phylum,
    String? kingdom,
  }) {
    _plantClass = plantClass;
    _genus = genus;
    _order = order;
    _family = family;
    _phylum = phylum;
    _kingdom = kingdom;
  }

  Taxonomy.fromJson(dynamic json) {
    _plantClass = json['class'];
    _genus = json['genus'];
    _order = json['order'];
    _family = json['family'];
    _phylum = json['phylum'];
    _kingdom = json['kingdom'];
  }

  String? _plantClass;
  String? _genus;
  String? _order;
  String? _family;
  String? _phylum;
  String? _kingdom;

  Taxonomy copyWith({
    String? plantClass,
    String? genus,
    String? order,
    String? family,
    String? phylum,
    String? kingdom,
  }) => Taxonomy(
    plantClass: plantClass ?? _plantClass,
    genus: genus ?? _genus,
    order: order ?? _order,
    family: family ?? _family,
    phylum: phylum ?? _phylum,
    kingdom: kingdom ?? _kingdom,
  );

  String? get plantClass => _plantClass;

  String? get genus => _genus;

  String? get order => _order;

  String? get family => _family;

  String? get phylum => _phylum;

  String? get kingdom => _kingdom;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['class'] = _plantClass;
    map['genus'] = _genus;
    map['order'] = _order;
    map['family'] = _family;
    map['phylum'] = _phylum;
    map['kingdom'] = _kingdom;
    return map;
  }
}
