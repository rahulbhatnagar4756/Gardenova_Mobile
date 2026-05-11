// class PlantDetailsResponseModel {
//   bool? success;
//   String? message;
//   PlantDetailsData? data;

//   PlantDetailsResponseModel({this.success, this.message, this.data});

//   PlantDetailsResponseModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null
//         ? PlantDetailsData.fromJson(json['data'])
//         : null;
//   }
// }

// class PlantDetailsData {
//   PlantModel? plant;
//   ReminderModel? reminder;

//   PlantDetailsData({this.plant, this.reminder});

//   PlantDetailsData.fromJson(Map<String, dynamic> json) {
//     plant = json['plant'] != null ? PlantModel.fromJson(json['plant']) : null;
//     reminder = json['reminder'] != null
//         ? ReminderModel.fromJson(json['reminder'])
//         : null;
//   }
// }

// class PlantModel {
//   int? id;
//   String? commonName;
//   String? scientificName;
//   String? family;
//   String? genus;
//   String? watering;
//   String? sunlight;
//   String? careLevel;
//   String? growthRate;
//   bool? indoor;

//   String? temperatureMin;
//   double? temperatureMax;

//   dynamic humidityMin;
//   dynamic humidityMax;

//   dynamic lightMin;
//   dynamic lightMax;

//   dynamic soilMoistureMin;
//   dynamic soilMoistureMax;

//   dynamic poisonousToHumans;
//   dynamic poisonousToPets;

//   bool? droughtTolerant;
//   bool? booleanValue;

//   String? soil;
//   String? fertilizer;
//   String? pruning;
//   String? cycle;

//   dynamic pest;
//   String? diseases;
//   dynamic origin;
//   String? category;
//   dynamic climate;

//   String? color;
//   String? blooming;
//   String? description;
//   String? imageUrl;
//   String? source;

//   PlantModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     commonName = json['common_name'];
//     scientificName = json['scientific_name'];
//     family = json['family'];
//     genus = json['genus'];
//     watering = json['watering'];
//     sunlight = json['sunlight'];
//     careLevel = json['care_level'];
//     growthRate = json['growth_rate'];
//     indoor = _parseBool(json['indoor']);
//     temperatureMin = json['temperature_min']?.toString();
//     temperatureMax = (json['temperature_max'] as num?)?.toDouble();
//     humidityMin = json['humidity_min'];
//     humidityMax = json['humidity_max'];
//     lightMin = json['light_min'];
//     lightMax = json['light_max'];
//     soilMoistureMin = json['soil_moisture_min'];
//     soilMoistureMax = json['soil_moisture_max'];
//     poisonousToHumans = json['poisonous_to_humans'];
//     poisonousToPets = json['poisonous_to_pets'];
//     droughtTolerant = _parseBool(json['drought_tolerant']);
//     booleanValue = _parseBool(json['boolean']);
//     soil = json['soil'];
//     fertilizer = json['fertilizer'];
//     pruning = json['pruning'];
//     cycle = json['cycle'];
//     pest = json['pest'];
//     diseases = json['diseases'];
//     origin = json['origin'];
//     category = json['category'];
//     climate = json['climate'];
//     color = json['color'];
//     blooming = json['blooming'];
//     description = json['description'];
//     imageUrl = json['image_url'];
//     source = json['source'];
//   }

//   /// 🔥 COMMON BOOL PARSER
//   bool _parseBool(dynamic value) {
//     if (value == null) return false;
//     if (value is bool) return value;

//     String val = value.toString().toLowerCase();
//     return val == "true" || val == "1" || val == "falsa"
//         ? false
//         : val == "true";
//   }
// }

// class ReminderModel {
//   int? wateringReminderFrequency;
//   bool? wateringNotificationEnabled;
//   String? wateringPreferredTime;
//   DateTime? nextWateredAt;
//   DateTime? lastWateredAt;

//   int? fertilizerReminderFrequency;
//   bool? fertilizerNotificationEnabled;
//   String? fertilizerPreferredTime;
//   DateTime? nextFertilizedAt;
//   DateTime? lastFertilizedAt;

//   int? pruningReminderFrequency;
//   bool? pruningNotificationEnabled;
//   DateTime? nextPrunedAt;
//   DateTime? lastPrunedAt;

//   int? genericCareReminderFrequency;
//   bool? genericNotificationEnabled;
//   DateTime? nextGenericCareAt;
//   DateTime? lastGenericCareAt;

//   ReminderModel.fromJson(Map<String, dynamic> json) {
//     // 🌱 Watering
//     wateringReminderFrequency = json['watering_reminder_frequency'];
//     wateringNotificationEnabled =
//         _parseBool(json['watering_notification_enabled']);
//     wateringPreferredTime = json['watering_preferred_time'];
//     nextWateredAt = _parseDate(json['next_watered_at']);
//     lastWateredAt = _parseDate(json['last_watered_at']);

//     // 🌿 Fertilizer
//     fertilizerReminderFrequency = json['fertilizer_reminder_frequency'];
//     fertilizerNotificationEnabled =
//         _parseBool(json['fertilizer_notification_enabled']);
//     fertilizerPreferredTime = json['fertilizer_preferred_time'];
//     nextFertilizedAt = _parseDate(json['next_fertilized_at']);
//     lastFertilizedAt = _parseDate(json['last_fertilized_at']);

//     // ✂️ Pruning
//     pruningReminderFrequency = json['pruning_reminder_frequency'];

//     /// 🔥 API TYPO FIX
//     pruningNotificationEnabled =
//         _parseBool(json['puring_notification_enabled']);

//     nextPrunedAt = _parseDate(json['next_pruned_at']);
//     lastPrunedAt = _parseDate(json['last_pruned_at']);

//     // 🧪 Generic Care
//     genericCareReminderFrequency =
//     json['generic_care_reminder_frequency'];

//     genericNotificationEnabled =
//         _parseBool(json['generic_notification_enabled']);

//     nextGenericCareAt = _parseDate(json['next_generic_care_at']);
//     lastGenericCareAt = _parseDate(json['last_generic_care_at']);
//   }

//   // ✅ Safe bool parser
//   bool _parseBool(dynamic value) {
//     if (value == null) return false;
//     if (value is bool) return value;

//     String val = value.toString().toLowerCase();
//     return val == "true" || val == "1";
//   }

//   // ✅ Safe Date parser (UTC → local)
//   DateTime? _parseDate(dynamic value) {
//     if (value == null) return null;
//     return DateTime.parse(value).toLocal();
//   }
// }

// new model
// class PlantDetailsResponseModel {
//   bool? success;
//   String? message;
//   PlantDetailsData? data;

//   PlantDetailsResponseModel({this.success, this.message, this.data});

//   PlantDetailsResponseModel.fromJson(Map<String, dynamic>? json) {
//     if (json == null) {
//       success = false;
//       message = "Invalid response";
//       data = null;
//       return;
//     }

//     success = json['success'] ?? false;
//     message = json['message']?.toString();

//     data = json['data'] != null
//         ? PlantDetailsData.fromJson(json['data'])
//         : null;
//   }
// }

// class PlantDetailsData {
//   PlantModel? plant;
//   ReminderModel? reminder;

//   PlantDetailsData({this.plant, this.reminder});

//   PlantDetailsData.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return;

//     plant = json['plant'] != null ? PlantModel.fromJson(json['plant']) : null;

//     reminder = json['reminder'] != null
//         ? ReminderModel.fromJson(json['reminder'])
//         : null;
//   }
// }

// class PlantModel {
//   String? id;
//   String? speciesId;
//   String? speciesName;

//   String? genusName;
//   String? familyName;

//   String? commonName;
//   String? inatCommonName;

//   String? imageUrl;

//   String? plantType;
//   String? growthHabit;

//   bool? edible;
//   dynamic ediblePart;

//   bool? vegetable;

//   double? lat;
//   double? lon;

//   PlantModel({
//     this.id,
//     this.speciesId,
//     this.speciesName,
//     this.genusName,
//     this.familyName,
//     this.commonName,
//     this.inatCommonName,
//     this.imageUrl,
//     this.plantType,
//     this.growthHabit,
//     this.edible,
//     this.ediblePart,
//     this.vegetable,
//     this.lat,
//     this.lon,
//   });

//   PlantModel.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return;

//     id = json['id']?.toString();
//     speciesId = json['species_id']?.toString();
//     speciesName = json['species_name']?.toString();

//     genusName = json['genus_name']?.toString();
//     familyName = json['family_name']?.toString();

//     commonName = json['common_name']?.toString();
//     inatCommonName = json['inat_common_name']?.toString();

//     imageUrl = json['image_url']?.toString();

//     plantType = json['plant_type']?.toString();
//     growthHabit = json['growth_habit']?.toString();

//     edible = _parseBool(json['edible']);
//     ediblePart = json['edible_part'];

//     vegetable = _parseBool(json['vegetable']);

//     lat = _parseDouble(json['lat']);
//     lon = _parseDouble(json['lon']);
//   }

//   // ✅ Safe bool parser
//   static bool _parseBool(dynamic value) {
//     if (value == null) return false;

//     if (value is bool) return value;

//     final val = value.toString().toLowerCase();

//     return val == "true" || val == "1";
//   }

//   // ✅ Safe double parser
//   static double? _parseDouble(dynamic value) {
//     if (value == null) return null;

//     if (value is double) return value;

//     if (value is int) return value.toDouble();

//     return double.tryParse(value.toString());
//   }
// }

// class ReminderModel {
//   // 🌱 Watering
//   bool? wateringNotificationEnabled;
//   int? wateringReminderFrequency;
//   String? wateringPreferredTime;

//   DateTime? nextWateredAt;
//   DateTime? lastWateredAt;

//   // 🌿 Fertilizer
//   bool? fertilizerNotificationEnabled;
//   int? fertilizerReminderFrequency;
//   String? fertilizerPreferredTime;

//   DateTime? nextFertilizedAt;
//   DateTime? lastFertilizedAt;

//   // ✂️ Pruning
//   bool? pruningNotificationEnabled;
//   int? pruningReminderFrequency;

//   DateTime? nextPrunedAt;
//   DateTime? lastPrunedAt;

//   // 🧪 Generic Care
//   bool? genericNotificationEnabled;
//   int? genericCareReminderFrequency;

//   DateTime? nextGenericCareAt;
//   DateTime? lastGenericCareAt;

//   ReminderModel({
//     this.wateringNotificationEnabled,
//     this.wateringReminderFrequency,
//     this.wateringPreferredTime,
//     this.nextWateredAt,
//     this.lastWateredAt,
//     this.fertilizerNotificationEnabled,
//     this.fertilizerReminderFrequency,
//     this.fertilizerPreferredTime,
//     this.nextFertilizedAt,
//     this.lastFertilizedAt,
//     this.pruningNotificationEnabled,
//     this.pruningReminderFrequency,
//     this.nextPrunedAt,
//     this.lastPrunedAt,
//     this.genericNotificationEnabled,
//     this.genericCareReminderFrequency,
//     this.nextGenericCareAt,
//     this.lastGenericCareAt,
//   });

//   ReminderModel.fromJson(Map<String, dynamic>? json) {
//     if (json == null) return;

//     // 🌱 Watering
//     wateringNotificationEnabled = _parseBool(
//       json['watering_notification_enabled'],
//     );

//     wateringReminderFrequency = _parseInt(json['watering_reminder_frequency']);

//     wateringPreferredTime = json['watering_preferred_time']?.toString();

//     nextWateredAt = _parseDate(json['next_watered_at']);
//     lastWateredAt = _parseDate(json['last_watered_at']);

//     // 🌿 Fertilizer
//     fertilizerNotificationEnabled = _parseBool(
//       json['fertilizer_notification_enabled'],
//     );

//     fertilizerReminderFrequency = _parseInt(
//       json['fertilizer_reminder_frequency'],
//     );

//     fertilizerPreferredTime = json['fertilizer_preferred_time']?.toString();

//     nextFertilizedAt = _parseDate(json['next_fertilized_at']);
//     lastFertilizedAt = _parseDate(json['last_fertilized_at']);

//     // ✂️ Pruning
//     pruningNotificationEnabled = _parseBool(
//       json['puring_notification_enabled'],
//     );

//     pruningReminderFrequency = _parseInt(json['pruning_reminder_frequency']);

//     nextPrunedAt = _parseDate(json['next_pruned_at']);
//     lastPrunedAt = _parseDate(json['last_pruned_at']);

//     // 🧪 Generic Care
//     genericNotificationEnabled = _parseBool(
//       json['generic_notification_enabled'],
//     );

//     genericCareReminderFrequency = _parseInt(
//       json['generic_care_reminder_frequency'],
//     );

//     nextGenericCareAt = _parseDate(json['next_generic_care_at']);
//     lastGenericCareAt = _parseDate(json['last_generic_care_at']);
//   }

//   // ✅ Safe bool parser
//   static bool _parseBool(dynamic value) {
//     if (value == null) return false;

//     if (value is bool) return value;

//     final val = value.toString().toLowerCase();

//     return val == "true" || val == "1";
//   }

//   // ✅ Safe int parser
//   static int _parseInt(dynamic value) {
//     if (value == null) return 0;

//     if (value is int) return value;

//     return int.tryParse(value.toString()) ?? 0;
//   }

//   // ✅ Safe Date parser
//   static DateTime? _parseDate(dynamic value) {
//     if (value == null) return null;

//     try {
//       return DateTime.parse(value.toString()).toLocal();
//     } catch (_) {
//       return null;
//     }
//   }
// }
/*
watering
sunlight
careLevel
growthRate

indoor

temperatureMin
temperatureMax

humidityMin
humidityMax

lightMin
lightMax

soilMoistureMin
soilMoistureMax

poisonousToHumans
poisonousToPets

droughtTolerant
booleanValue

soil
fertilizer
pruning
cycle

pest
diseases
origin
category
climate

color
blooming

description

source
*/
// old + new merged code
class PlantDetailsResponseModel {
  bool? success;
  String? message;
  PlantDetailsData? data;

  PlantDetailsResponseModel({this.success, this.message, this.data});

  PlantDetailsResponseModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      success = false;
      message = "Invalid response";
      data = null;
      return;
    }

    success = _parseBool(json['success']);
    message = json['message']?.toString();

    data = json['data'] != null
        ? PlantDetailsData.fromJson(json['data'])
        : null;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;

    if (value is bool) return value;

    final val = value.toString().toLowerCase();

    return val == "true" || val == "1";
  }
}

class PlantDetailsData {
  PlantModel? plant;
  ReminderModel? reminder;

  PlantDetailsData({this.plant, this.reminder});

  PlantDetailsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    plant = json['plant'] != null ? PlantModel.fromJson(json['plant']) : null;

    reminder = json['reminder'] != null
        ? ReminderModel.fromJson(json['reminder'])
        : null;
  }
}

class PlantModel {
  /// =========================
  /// OLD + NEW COMMON FIELDS
  /// =========================

  String? id;

  /// OLD
  int? oldId;

  /// NEW
  String? speciesId;
  String? speciesName;

  /// COMMON
  String? commonName;
  String? scientificName;

  /// OLD
  String? family;
  String? genus;

  /// NEW
  String? familyName;
  String? genusName;

  String? inatCommonName;

  /// OLD FIELDS
  String? watering;
  String? sunlight;
  String? careLevel;
  String? growthRate;

  bool? indoor;

  String? temperatureMin;
  double? temperatureMax;

  double? humidityMin;
  double? humidityMax;

  double? lightMin;
  double? lightMax;

  double? soilMoistureMin;
  double? soilMoistureMax;

  bool? poisonousToHumans;
  bool? poisonousToPets;

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
  String? source;

  /// NEW FIELDS
  String? plantType;
  String? growthHabit;

  bool? edible;
  dynamic ediblePart;

  bool? vegetable;

  double? lat;
  double? lon;

  /// COMMON
  String? imageUrl;

  PlantModel({
    this.id,
    this.oldId,
    this.speciesId,
    this.speciesName,
    this.commonName,
    this.scientificName,
    this.family,
    this.genus,
    this.familyName,
    this.genusName,
    this.inatCommonName,
    this.watering,
    this.sunlight,
    this.careLevel,
    this.growthRate,
    this.indoor,
    this.temperatureMin,
    this.temperatureMax,
    this.humidityMin,
    this.humidityMax,
    this.lightMin,
    this.lightMax,
    this.soilMoistureMin,
    this.soilMoistureMax,
    this.poisonousToHumans,
    this.poisonousToPets,
    this.droughtTolerant,
    this.booleanValue,
    this.soil,
    this.fertilizer,
    this.pruning,
    this.cycle,
    this.pest,
    this.diseases,
    this.origin,
    this.category,
    this.climate,
    this.color,
    this.blooming,
    this.description,
    this.source,
    this.plantType,
    this.growthHabit,
    this.edible,
    this.ediblePart,
    this.vegetable,
    this.lat,
    this.lon,
    this.imageUrl,
  });

  PlantModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    /// =========================
    /// IDS
    /// =========================

    id = json['id']?.toString();

    oldId = _parseInt(json['id']);

    speciesId = json['species_id']?.toString();
    speciesName = json['species_name']?.toString();

    /// =========================
    /// COMMON NAMES
    /// =========================

    commonName = json['common_name']?.toString();

    scientificName =
        json['scientific_name']?.toString() ?? json['species_name']?.toString();

    inatCommonName = json['inat_common_name']?.toString();

    /// =========================
    /// FAMILY / GENUS
    /// =========================

    family = json['family']?.toString() ?? json['family_name']?.toString();

    genus = json['genus']?.toString() ?? json['genus_name']?.toString();

    familyName = json['family_name']?.toString();
    genusName = json['genus_name']?.toString();

    /// =========================
    /// OLD DATA
    /// =========================

    watering = json['watering']?.toString();
    sunlight = json['sunlight']?.toString();
    careLevel = json['care_level']?.toString();
    growthRate = json['growth_rate']?.toString();

    indoor = _parseBool(json['indoor']);

    temperatureMin = json['temperature_min']?.toString();

    temperatureMax = _parseDouble(json['temperature_max']);

    humidityMin = _parseDouble(json['humidity_min']);
    humidityMax = _parseDouble(json['humidity_max']);

    lightMin = _parseDouble(json['light_min']);
    lightMax = _parseDouble(json['light_max']);

    soilMoistureMin = _parseDouble(json['soil_moisture_min']);

    soilMoistureMax = _parseDouble(json['soil_moisture_max']);

    poisonousToHumans = _parseBool(json['poisonous_to_humans']);

    poisonousToPets = _parseBool(json['poisonous_to_pets']);

    droughtTolerant = _parseBool(json['drought_tolerant']);

    booleanValue = _parseBool(json['boolean']);

    soil = json['soil']?.toString();
    fertilizer = json['fertilizer']?.toString();
    pruning = json['pruning']?.toString();
    cycle = json['cycle']?.toString();

    pest = json['pest'];

    diseases = json['diseases']?.toString();

    origin = json['origin'];

    category = json['category']?.toString();

    climate = json['climate'];

    color = json['color']?.toString();
    blooming = json['blooming']?.toString();

    description = json['description']?.toString();

    source = json['source']?.toString();

    /// =========================
    /// NEW DATA
    /// =========================

    plantType = json['plant_type']?.toString();

    growthHabit = json['growth_habit']?.toString();

    edible = _parseBool(json['edible']);

    ediblePart = json['edible_part'];

    vegetable = _parseBool(json['vegetable']);

    lat = _parseDouble(json['lat']);
    lon = _parseDouble(json['lon']);

    /// =========================
    /// COMMON
    /// =========================

    imageUrl = json['image_url']?.toString();
  }

  /// =========================
  /// SAFE HELPERS
  /// =========================

  static bool _parseBool(dynamic value) {
    if (value == null) return false;

    if (value is bool) return value;

    final val = value.toString().toLowerCase();

    return val == "true" || val == "1";
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;

    if (value is double) return value;

    if (value is int) return value.toDouble();

    return double.tryParse(value.toString());
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(value.toString());
  }
}

class ReminderModel {
  /// 🌱 Watering
  int? wateringReminderFrequency;
  bool? wateringNotificationEnabled;
  String? wateringPreferredTime;
  DateTime? nextWateredAt;
  DateTime? lastWateredAt;

  /// 🌿 Fertilizer
  int? fertilizerReminderFrequency;
  bool? fertilizerNotificationEnabled;
  String? fertilizerPreferredTime;
  DateTime? nextFertilizedAt;
  DateTime? lastFertilizedAt;

  /// ✂️ Pruning
  int? pruningReminderFrequency;
  bool? pruningNotificationEnabled;
  DateTime? nextPrunedAt;
  DateTime? lastPrunedAt;

  /// 🧪 Generic Care
  int? genericCareReminderFrequency;
  bool? genericNotificationEnabled;
  DateTime? nextGenericCareAt;
  DateTime? lastGenericCareAt;

  ReminderModel({
    this.wateringReminderFrequency,
    this.wateringNotificationEnabled,
    this.wateringPreferredTime,
    this.nextWateredAt,
    this.lastWateredAt,
    this.fertilizerReminderFrequency,
    this.fertilizerNotificationEnabled,
    this.fertilizerPreferredTime,
    this.nextFertilizedAt,
    this.lastFertilizedAt,
    this.pruningReminderFrequency,
    this.pruningNotificationEnabled,
    this.nextPrunedAt,
    this.lastPrunedAt,
    this.genericCareReminderFrequency,
    this.genericNotificationEnabled,
    this.nextGenericCareAt,
    this.lastGenericCareAt,
  });

  ReminderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    /// 🌱 Watering
    wateringReminderFrequency = _parseInt(json['watering_reminder_frequency']);

    wateringNotificationEnabled = _parseBool(
      json['watering_notification_enabled'],
    );

    wateringPreferredTime = json['watering_preferred_time']?.toString();

    nextWateredAt = _parseDate(json['next_watered_at']);

    lastWateredAt = _parseDate(json['last_watered_at']);

    /// 🌿 Fertilizer
    fertilizerReminderFrequency = _parseInt(
      json['fertilizer_reminder_frequency'],
    );

    fertilizerNotificationEnabled = _parseBool(
      json['fertilizer_notification_enabled'],
    );

    fertilizerPreferredTime = json['fertilizer_preferred_time']?.toString();

    nextFertilizedAt = _parseDate(json['next_fertilized_at']);

    lastFertilizedAt = _parseDate(json['last_fertilized_at']);

    /// ✂️ Pruning
    pruningReminderFrequency = _parseInt(json['pruning_reminder_frequency']);

    /// API TYPO FIX
    pruningNotificationEnabled = _parseBool(
      json['puring_notification_enabled'],
    );

    nextPrunedAt = _parseDate(json['next_pruned_at']);

    lastPrunedAt = _parseDate(json['last_pruned_at']);

    /// 🧪 Generic Care
    genericCareReminderFrequency = _parseInt(
      json['generic_care_reminder_frequency'],
    );

    genericNotificationEnabled = _parseBool(
      json['generic_notification_enabled'],
    );

    nextGenericCareAt = _parseDate(json['next_generic_care_at']);

    lastGenericCareAt = _parseDate(json['last_generic_care_at']);
  }

  /// =========================
  /// SAFE HELPERS
  /// =========================

  static bool _parseBool(dynamic value) {
    if (value == null) return false;

    if (value is bool) return value;

    final val = value.toString().toLowerCase();

    return val == "true" || val == "1";
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    return int.tryParse(value.toString()) ?? 0;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    try {
      return DateTime.parse(value.toString()).toLocal();
    } catch (_) {
      return null;
    }
  }
}
