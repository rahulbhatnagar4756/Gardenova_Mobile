class PlantDetailsResponseModel {
  bool? success;
  String? message;
  PlantDetailsData? data;

  PlantDetailsResponseModel({this.success, this.message, this.data});

  PlantDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? PlantDetailsData.fromJson(json['data'])
        : null;
  }
}

class PlantDetailsData {
  PlantModel? plant;
  ReminderModel? reminder;

  PlantDetailsData({this.plant, this.reminder});

  PlantDetailsData.fromJson(Map<String, dynamic> json) {
    plant = json['plant'] != null ? PlantModel.fromJson(json['plant']) : null;
    reminder = json['reminder'] != null
        ? ReminderModel.fromJson(json['reminder'])
        : null;
  }
}

class PlantModel {
  int? id;
  String? commonName;
  String? scientificName;
  String? family;
  String? genus;
  String? watering;
  String? sunlight;
  String? careLevel;
  String? growthRate;
  bool? indoor;

  String? temperatureMin;
  double? temperatureMax;

  dynamic humidityMin;
  dynamic humidityMax;

  dynamic lightMin;
  dynamic lightMax;

  dynamic soilMoistureMin;
  dynamic soilMoistureMax;

  dynamic poisonousToHumans;
  dynamic poisonousToPets;

  bool? droughtTolerant;
  bool? booleanValue;

  String? soil;
  String? fertilizer;
  String? pruning;
  String? cycle;

  dynamic pest;
  String? diseases;
  dynamic origin;
  String? category;
  dynamic climate;

  String? color;
  String? blooming;
  String? description;
  String? imageUrl;
  String? source;

  PlantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commonName = json['common_name'];
    scientificName = json['scientific_name'];
    family = json['family'];
    genus = json['genus'];
    watering = json['watering'];
    sunlight = json['sunlight'];
    careLevel = json['care_level'];
    growthRate = json['growth_rate'];
    indoor = _parseBool(json['indoor']);
    temperatureMin = json['temperature_min']?.toString();
    temperatureMax = (json['temperature_max'] as num?)?.toDouble();
    humidityMin = json['humidity_min'];
    humidityMax = json['humidity_max'];
    lightMin = json['light_min'];
    lightMax = json['light_max'];
    soilMoistureMin = json['soil_moisture_min'];
    soilMoistureMax = json['soil_moisture_max'];
    poisonousToHumans = json['poisonous_to_humans'];
    poisonousToPets = json['poisonous_to_pets'];
    droughtTolerant = _parseBool(json['drought_tolerant']);
    booleanValue = _parseBool(json['boolean']);
    soil = json['soil'];
    fertilizer = json['fertilizer'];
    pruning = json['pruning'];
    cycle = json['cycle'];
    pest = json['pest'];
    diseases = json['diseases'];
    origin = json['origin'];
    category = json['category'];
    climate = json['climate'];
    color = json['color'];
    blooming = json['blooming'];
    description = json['description'];
    imageUrl = json['image_url'];
    source = json['source'];
  }

  /// 🔥 COMMON BOOL PARSER
  bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;

    String val = value.toString().toLowerCase();
    return val == "true" || val == "1" || val == "falsa"
        ? false
        : val == "true";
  }
}

class ReminderModel {
  int? wateringReminderFrequency;
  bool? wateringNotificationEnabled;
  String? wateringPreferredTime;
  DateTime? nextWateredAt;
  DateTime? lastWateredAt;

  int? fertilizerReminderFrequency;
  bool? fertilizerNotificationEnabled;
  String? fertilizerPreferredTime;
  DateTime? nextFertilizedAt;
  DateTime? lastFertilizedAt;

  int? pruningReminderFrequency;
  bool? pruningNotificationEnabled;
  DateTime? nextPrunedAt;
  DateTime? lastPrunedAt;

  int? genericCareReminderFrequency;
  bool? genericNotificationEnabled;
  DateTime? nextGenericCareAt;
  DateTime? lastGenericCareAt;

  ReminderModel.fromJson(Map<String, dynamic> json) {
    // 🌱 Watering
    wateringReminderFrequency = json['watering_reminder_frequency'];
    wateringNotificationEnabled =
        _parseBool(json['watering_notification_enabled']);
    wateringPreferredTime = json['watering_preferred_time'];
    nextWateredAt = _parseDate(json['next_watered_at']);
    lastWateredAt = _parseDate(json['last_watered_at']);

    // 🌿 Fertilizer
    fertilizerReminderFrequency = json['fertilizer_reminder_frequency'];
    fertilizerNotificationEnabled =
        _parseBool(json['fertilizer_notification_enabled']);
    fertilizerPreferredTime = json['fertilizer_preferred_time'];
    nextFertilizedAt = _parseDate(json['next_fertilized_at']);
    lastFertilizedAt = _parseDate(json['last_fertilized_at']);

    // ✂️ Pruning
    pruningReminderFrequency = json['pruning_reminder_frequency'];

    /// 🔥 API TYPO FIX
    pruningNotificationEnabled =
        _parseBool(json['puring_notification_enabled']);

    nextPrunedAt = _parseDate(json['next_pruned_at']);
    lastPrunedAt = _parseDate(json['last_pruned_at']);

    // 🧪 Generic Care
    genericCareReminderFrequency =
    json['generic_care_reminder_frequency'];

    genericNotificationEnabled =
        _parseBool(json['generic_notification_enabled']);

    nextGenericCareAt = _parseDate(json['next_generic_care_at']);
    lastGenericCareAt = _parseDate(json['last_generic_care_at']);
  }

  // ✅ Safe bool parser
  bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;

    String val = value.toString().toLowerCase();
    return val == "true" || val == "1";
  }

  // ✅ Safe Date parser (UTC → local)
  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.parse(value).toLocal();
  }
}
