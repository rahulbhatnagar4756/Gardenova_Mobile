import 'dart:convert';

import '../../utils/utils.dart';

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

    success = Utils.parseBool(json['success']);
    message = json['message']?.toString();

    data = json['data'] != null
        ? PlantDetailsData.fromJson(json['data'])
        : null;
  }
}

class Care {
  final String? watering;
  final String? sunlight;
  final String? pruning;

  Care({this.watering, this.sunlight, this.pruning});

  Care copyWith({String? watering, String? sunlight, String? pruning}) => Care(
    watering: watering ?? this.watering,
    sunlight: sunlight ?? this.sunlight,
    pruning: pruning ?? this.pruning,
  );

  factory Care.fromJson(String str) => Care.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Care.fromMap(Map<String, dynamic> json) => Care(
    watering: json["watering"],
    sunlight: json["sunlight"],
    pruning: json["pruning"],
  );

  Map<String, dynamic> toMap() => {
    "watering": watering,
    "sunlight": sunlight,
    "pruning": pruning,
  };
}

class PlantDetailsData {
  PlantModelDetails? plant;
  bool? alreadyAdded;
  Care? care;
  ReminderModel? reminder;

  PlantDetailsData({this.plant, this.alreadyAdded, this.reminder, this.care});

  PlantDetailsData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    plant = json['plant'] != null
        ? PlantModelDetails.fromJson(json['plant'])
        : null;

    alreadyAdded = Utils.parseBool(json['AlreadyAdded']);
    care = json['care'] != null ? Care.fromMap(json['care']) : null;

    reminder = json['reminder'] != null
        ? ReminderModel.fromJson(json['reminder'])
        : null;
  }

  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   if (plant != null) {
  //     data['plant'] = plant!.toJson();
  //   }
  //   data['alreadyAdded'] = alreadyAdded;
  //   if (reminder != null) {
  //     data['reminder'] = reminder!.toJson();
  //   }
  //   return data;
  // }
}

class PlantModelDetails {
  /// IDS
  int? id;

  /// NAMES
  String? commonName;
  String? scientificName;
  String? otherName;
  String? family;
  String? genus;
  String? speciesEpithet;

  /// BASIC INFO
  String? origin;
  String? type;
  String? cycle;
  String? watering;
  String? wateringBenchmarkValue;
  String? wateringBenchmarkUnit;
  String? sunlight;
  String? soil;

  /// HARDINESS
  String? hardinessMin;
  String? hardinessMax;

  /// DIMENSION
  String? dimensionType;
  String? dimensionMinValue;
  String? dimensionMaxValue;
  String? dimensionUnit;

  /// CARE
  String? growthRate;
  String? maintenance;
  String? careLevel;
  String? careGuidesUrl;
  String? pruningMonth;
  String? propagation;

  /// EXTRA
  String? attracts;
  dynamic pestSusceptibility;
  String? plantAnatomy;

  /// FLAGS
  bool? droughtTolerant;
  bool? saltTolerant;
  bool? thorny;
  bool? invasive;
  bool? tropical;
  bool? indoor;
  bool? flowers;
  bool? cones;
  bool? fruits;
  bool? edibleFruit;
  bool? leaf;
  bool? edibleLeaf;
  bool? seeds;
  bool? cuisine;
  bool? medicinal;
  bool? poisonousToHumans;
  bool? poisonousToPets;

  /// SEASONS
  String? floweringSeason;
  String? harvestSeason;

  /// DESCRIPTION
  String? description;

  /// IMAGES
  String? imageOriginalUrl;
  String? imageRegularUrl;
  String? imageMediumUrl;
  String? imageSmallUrl;
  String? imageThumbnail;
  String? imageLicense;

  /// COMMON IMAGE
  String? imageUrl;

  PlantModelDetails({
    this.id,
    this.commonName,
    this.scientificName,
    this.otherName,
    this.family,
    this.genus,
    this.speciesEpithet,
    this.origin,
    this.type,
    this.cycle,
    this.watering,
    this.wateringBenchmarkValue,
    this.wateringBenchmarkUnit,
    this.sunlight,
    this.soil,
    this.hardinessMin,
    this.hardinessMax,
    this.dimensionType,
    this.dimensionMinValue,
    this.dimensionMaxValue,
    this.dimensionUnit,
    this.growthRate,
    this.maintenance,
    this.careLevel,
    this.careGuidesUrl,
    this.pruningMonth,
    this.propagation,
    this.attracts,
    this.pestSusceptibility,
    this.plantAnatomy,
    this.droughtTolerant,
    this.saltTolerant,
    this.thorny,
    this.invasive,
    this.tropical,
    this.indoor,
    this.flowers,
    this.cones,
    this.fruits,
    this.edibleFruit,
    this.leaf,
    this.edibleLeaf,
    this.seeds,
    this.cuisine,
    this.medicinal,
    this.poisonousToHumans,
    this.poisonousToPets,
    this.floweringSeason,
    this.harvestSeason,
    this.description,
    this.imageOriginalUrl,
    this.imageRegularUrl,
    this.imageMediumUrl,
    this.imageSmallUrl,
    this.imageThumbnail,
    this.imageLicense,
    this.imageUrl,
  });

  PlantModelDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    /// IDS
    id = Utils.parseInt(json['id']);

    /// NAMES
    commonName = json['common_name']?.toString();
    scientificName = json['scientific_name']?.toString();
    otherName = json['other_name']?.toString();
    family = json['family']?.toString();
    genus = json['genus']?.toString();
    speciesEpithet = json['species_epithet']?.toString();

    /// BASIC INFO
    origin = json['origin']?.toString();
    type = json['type']?.toString();
    cycle = json['cycle']?.toString();
    watering = json['watering']?.toString();

    wateringBenchmarkValue = json['watering_benchmark_value']?.toString();

    wateringBenchmarkUnit = json['watering_benchmark_unit']?.toString();

    sunlight = json['sunlight']?.toString();
    soil = json['soil']?.toString();

    /// HARDINESS
    hardinessMin = json['hardiness_min']?.toString();
    hardinessMax = json['hardiness_max']?.toString();

    /// DIMENSION
    dimensionType = json['dimension_type']?.toString();

    dimensionMinValue = json['dimension_min_value']?.toString();

    dimensionMaxValue = json['dimension_max_value']?.toString();

    dimensionUnit = json['dimension_unit']?.toString();

    /// CARE
    growthRate = json['growth_rate']?.toString();
    maintenance = json['maintenance']?.toString();
    careLevel = json['care_level']?.toString();

    careGuidesUrl = json['care_guides_url']?.toString();

    pruningMonth = json['pruning_month']?.toString();

    propagation = json['propagation']?.toString();

    /// EXTRA
    attracts = json['attracts']?.toString();

    pestSusceptibility = json['pest_susceptibility'];

    plantAnatomy = json['plant_anatomy']?.toString();

    /// FLAGS
    droughtTolerant = Utils.parseBool(json['drought_tolerant']);
    saltTolerant = Utils.parseBool(json['salt_tolerant']);
    thorny = Utils.parseBool(json['thorny']);
    invasive = Utils.parseBool(json['invasive']);
    tropical = Utils.parseBool(json['tropical']);
    indoor = Utils.parseBool(json['indoor']);
    flowers = Utils.parseBool(json['flowers']);
    cones = Utils.parseBool(json['cones']);
    fruits = Utils.parseBool(json['fruits']);
    edibleFruit = Utils.parseBool(json['edible_fruit']);
    leaf = Utils.parseBool(json['leaf']);
    edibleLeaf = Utils.parseBool(json['edible_leaf']);
    seeds = Utils.parseBool(json['seeds']);
    cuisine = Utils.parseBool(json['cuisine']);
    medicinal = Utils.parseBool(json['medicinal']);

    poisonousToHumans = Utils.parseBool(json['poisonous_to_humans']);

    poisonousToPets = Utils.parseBool(json['poisonous_to_pets']);

    /// SEASONS
    floweringSeason = json['flowering_season']?.toString();

    harvestSeason = json['harvest_season']?.toString();

    /// DESCRIPTION
    description = json['description']?.toString();

    /// IMAGES
    imageOriginalUrl = json['image_original_url']?.toString();

    imageRegularUrl = json['image_regular_url']?.toString();

    imageMediumUrl = json['image_medium_url']?.toString();

    imageSmallUrl = json['image_small_url']?.toString();

    imageThumbnail = json['image_thumbnail']?.toString();

    imageLicense = json['image_license']?.toString();

    /// COMMON IMAGE
    imageUrl =
        imageOriginalUrl ??
        imageMediumUrl ??
        imageSmallUrl ??
        imageThumbnail ??
        imageRegularUrl;
  }
}

/*
class PlantModelDetails {
  /// =========================
  /// IDS
  /// =========================

  String? id;
  int? oldId;

  String? speciesId;
  String? speciesName;
  int? plantId;

  /// =========================
  /// NAMES
  /// =========================

  String? commonName;
  String? scientificName;
  String? otherName;
  String? speciesEpithet;

  /// =========================
  /// FAMILY
  /// =========================

  String? family;
  String? genus;

  String? familyName;
  String? genusName;

  String? inatCommonName;

  /// =========================
  /// PLANT INFO
  /// =========================

  String? plantType;
  String? type;
  String? category;
  String? cycle;

  String? watering;
  String? wateringBenchmarkValue;
  String? wateringBenchmarkUnit;

  String? sunlight;
  String? careLevel;
  String? growthRate;
  String? growthHabit;

  String? maintenance;
  String? dimensionType;
  dynamic dimensionMinValue;
  dynamic dimensionMaxValue;
  String? dimensionUnit;

  /// =========================
  /// ENVIRONMENT
  /// =========================

  bool? indoor;
  bool? tropical;

  String? temperatureMin;
  double? temperatureMax;

  double? humidityMin;
  double? humidityMax;

  double? lightMin;
  double? lightMax;

  double? soilMoistureMin;
  double? soilMoistureMax;

  String? soil;
  dynamic climate;
  String? origin;

  String? hardinessMin;
  String? hardinessMax;

  /// =========================
  /// CARE
  /// =========================

  String? fertilizer;
  String? pruning;
  String? pruningMonth;

  String? propagation;

  dynamic pest;
  dynamic pestSusceptibility;

  String? diseases;

  /// =========================
  /// FEATURES
  /// =========================

  bool? poisonousToHumans;
  bool? poisonousToPets;

  bool? droughtTolerant;
  bool? saltTolerant;
  bool? thorny;
  bool? invasive;

  bool? edible;
  dynamic ediblePart;

  bool? edibleFruit;
  bool? edibleLeaf;

  bool? vegetable;
  bool? medicinal;

  bool? flowers;
  bool? fruits;
  bool? leaf;
  bool? seeds;
  bool? cones;

  bool? cuisine;

  /// =========================
  /// EXTRA
  /// =========================

  String? floweringSeason;
  String? harvestSeason;

  String? color;
  String? blooming;

  String? description;
  String? source;
  String? author;

  dynamic attracts;
  dynamic plantAnatomy;

  String? subspecies;
  String? cultivar;
  String? variety;

  /// =========================
  /// LOCATION
  /// =========================

  double? lat;
  double? lon;

  /// =========================
  /// IMAGES
  /// =========================

  String? imageUrl;

  String? imageOriginalUrl;
  String? imageRegularUrl;
  String? imageMediumUrl;
  String? imageSmallUrl;
  String? imageThumbnail;

  String? imageLicense;

  /// =========================
  /// LINKS
  /// =========================

  String? careGuidesUrl;

  PlantModelDetails({
    this.id,
    this.oldId,
    this.speciesId,
    this.speciesName,
    this.plantId,
    this.commonName,
    this.scientificName,
    this.otherName,
    this.speciesEpithet,
    this.family,
    this.genus,
    this.familyName,
    this.genusName,
    this.inatCommonName,
    this.plantType,
    this.type,
    this.category,
    this.cycle,
    this.watering,
    this.wateringBenchmarkValue,
    this.wateringBenchmarkUnit,
    this.sunlight,
    this.careLevel,
    this.growthRate,
    this.growthHabit,
    this.maintenance,
    this.dimensionType,
    this.dimensionMinValue,
    this.dimensionMaxValue,
    this.dimensionUnit,
    this.indoor,
    this.tropical,
    this.temperatureMin,
    this.temperatureMax,
    this.humidityMin,
    this.humidityMax,
    this.lightMin,
    this.lightMax,
    this.soilMoistureMin,
    this.soilMoistureMax,
    this.soil,
    this.climate,
    this.origin,
    this.fertilizer,
    this.pruning,
    this.pruningMonth,
    this.propagation,
    this.pest,
    this.pestSusceptibility,
    this.diseases,
    this.poisonousToHumans,
    this.poisonousToPets,
    this.droughtTolerant,
    this.saltTolerant,
    this.thorny,
    this.invasive,
    this.edible,
    this.ediblePart,
    this.edibleFruit,
    this.edibleLeaf,
    this.vegetable,
    this.medicinal,
    this.flowers,
    this.fruits,
    this.leaf,
    this.seeds,
    this.cones,
    this.cuisine,
    this.floweringSeason,
    this.harvestSeason,
    this.color,
    this.blooming,
    this.description,
    this.source,
    this.author,
    this.attracts,
    this.plantAnatomy,
    this.subspecies,
    this.cultivar,
    this.variety,
    this.lat,
    this.lon,
    this.imageUrl,
    this.imageOriginalUrl,
    this.imageRegularUrl,
    this.imageMediumUrl,
    this.imageSmallUrl,
    this.imageThumbnail,
    this.imageLicense,
    this.careGuidesUrl,
    this.hardinessMin,
    this.hardinessMax,
  });

  PlantModelDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    /// =========================
    /// IDS
    /// =========================

    id = json['id']?.toString();

    oldId = _parseInt(json['id']);

    plantId = _parseInt(json['plant_id']);

    speciesId = json['species_id']?.toString();

    speciesName = json['species_name']?.toString();

    /// =========================
    /// NAMES
    /// =========================

    commonName = json['common_name']?.toString();

    scientificName =
        json['scientific_name']?.toString() ?? json['species_name']?.toString();

    otherName = json['other_name']?.toString();

    speciesEpithet = json['species_epithet']?.toString();

    inatCommonName = json['inat_common_name']?.toString();

    /// =========================
    /// FAMILY
    /// =========================

    family = json['family']?.toString() ?? json['family_name']?.toString();

    genus = json['genus']?.toString() ?? json['genus_name']?.toString();

    familyName = json['family_name']?.toString();

    genusName = json['genus_name']?.toString();

    /// =========================
    /// BASIC
    /// =========================

    plantType = json['plant_type']?.toString();

    type = json['type']?.toString();

    category = json['category']?.toString();

    cycle = json['cycle']?.toString();

    watering = json['watering']?.toString();

    wateringBenchmarkValue = json['watering_benchmark_value']?.toString();

    wateringBenchmarkUnit = json['watering_benchmark_unit']?.toString();

    sunlight = json['sunlight']?.toString();

    careLevel = json['care_level']?.toString();

    growthRate = json['growth_rate']?.toString();

    growthHabit = json['growth_habit']?.toString();

    maintenance = json['maintenance']?.toString();

    dimensionType = json['dimension_type']?.toString();

    dimensionMinValue = json['dimension_min_value'];

    dimensionMaxValue = json['dimension_max_value'];

    dimensionUnit = json['dimension_unit']?.toString();

    /// =========================
    /// ENVIRONMENT
    /// =========================

    indoor = _parseBool(json['indoor']);

    tropical = _parseBool(json['tropical']);

    temperatureMin = json['temperature_min']?.toString();

    temperatureMax = _parseDouble(json['temperature_max']);

    humidityMin = _parseDouble(json['humidity_min']);

    humidityMax = _parseDouble(json['humidity_max']);

    lightMin = _parseDouble(json['light_min']);

    lightMax = _parseDouble(json['light_max']);

    soilMoistureMin = _parseDouble(json['soil_moisture_min']);

    soilMoistureMax = _parseDouble(json['soil_moisture_max']);

    soil = json['soil']?.toString();

    climate = json['climate'];

    origin = json['origin']?.toString();

    hardinessMin = json['hardiness_min']?.toString();

    hardinessMax = json['hardiness_max']?.toString();

    /// =========================
    /// CARE
    /// =========================

    fertilizer = json['fertilizer']?.toString();

    pruning = json['pruning']?.toString();

    pruningMonth = json['pruning_month']?.toString();

    propagation = json['propagation']?.toString();

    pest = json['pest'];

    pestSusceptibility = json['pest_susceptibility'];

    diseases = json['diseases']?.toString();

    /// =========================
    /// FEATURES
    /// =========================

    poisonousToHumans = _parseBool(json['poisonous_to_humans']);

    poisonousToPets = _parseBool(json['poisonous_to_pets']);

    droughtTolerant = _parseBool(json['drought_tolerant']);

    saltTolerant = _parseBool(json['salt_tolerant']);

    thorny = _parseBool(json['thorny']);

    invasive = _parseBool(json['invasive']);

    edible = _parseBool(json['edible']);

    ediblePart = json['edible_part'];

    edibleFruit = _parseBool(json['edible_fruit']);

    edibleLeaf = _parseBool(json['edible_leaf']);

    vegetable = _parseBool(json['vegetable']);

    medicinal = _parseBool(json['medicinal']);

    flowers = _parseBool(json['flowers']);

    fruits = _parseBool(json['fruits']);

    leaf = _parseBool(json['leaf']);

    seeds = _parseBool(json['seeds']);

    cones = _parseBool(json['cones']);

    cuisine = _parseBool(json['cuisine']);

    /// =========================
    /// EXTRA
    /// =========================

    floweringSeason = json['flowering_season']?.toString();

    harvestSeason = json['harvest_season']?.toString();

    color = json['color']?.toString();

    blooming = json['blooming']?.toString();

    description = json['description']?.toString();

    source = json['source']?.toString();

    author = json['author']?.toString();

    attracts = json['attracts'];

    plantAnatomy = json['plant_anatomy'];

    subspecies = json['subspecies']?.toString();

    cultivar = json['cultivar']?.toString();

    variety = json['variety']?.toString();

    /// =========================
    /// LOCATION
    /// =========================

    lat = _parseDouble(json['lat']);

    lon = _parseDouble(json['lon']);

    /// =========================
    /// IMAGES
    /// =========================

    imageUrl =
        json['image_url']?.toString() ??
        json['image_regular_url']?.toString() ??
        json['image_medium_url']?.toString() ??
        json['image_small_url']?.toString() ??
        json['image_thumbnail']?.toString();

    imageOriginalUrl = json['image_original_url']?.toString();

    imageRegularUrl = json['image_regular_url']?.toString();

    imageMediumUrl = json['image_medium_url']?.toString();

    imageSmallUrl = json['image_small_url']?.toString();

    imageThumbnail = json['image_thumbnail']?.toString();

    imageLicense = json['image_license']?.toString();

    /// =========================
    /// LINKS
    /// =========================

    careGuidesUrl = json['care_guides_url']?.toString();
  }

  /// =========================
  /// HELPERS
  /// =========================

  static bool _parseBool(dynamic value) {
    if (value == null) return false;

    if (value is bool) return value;

    final val = value.toString().toLowerCase();

    return val == 'true' || val == '1';
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

*/
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
    wateringReminderFrequency = Utils.parseInt(
      json['watering_reminder_frequency'],
    );

    wateringNotificationEnabled = Utils.parseBool(
      json['watering_notification_enabled'],
    );

    wateringPreferredTime = json['watering_preferred_time']?.toString();

    nextWateredAt = Utils.parseDate(json['next_watered_at']);

    lastWateredAt = Utils.parseDate(json['last_watered_at']);

    /// 🌿 Fertilizer
    fertilizerReminderFrequency = Utils.parseInt(
      json['fertilizer_reminder_frequency'],
    );

    fertilizerNotificationEnabled = Utils.parseBool(
      json['fertilizer_notification_enabled'],
    );

    fertilizerPreferredTime = json['fertilizer_preferred_time']?.toString();

    nextFertilizedAt = Utils.parseDate(json['next_fertilized_at']);

    lastFertilizedAt = Utils.parseDate(json['last_fertilized_at']);

    /// ✂️ Pruning
    pruningReminderFrequency = Utils.parseInt(
      json['pruning_reminder_frequency'],
    );

    /// API TYPO FIX
    // pruningNotificationEnabled = Utils.parseBool(
    //   json['puring_notification_enabled'],
    // );
    pruningNotificationEnabled = Utils.parseBool(
      json['puring_notification_enabled'] ??
          json['pruning_notification_enabled'],
    );

    nextPrunedAt = Utils.parseDate(json['next_pruned_at']);

    lastPrunedAt = Utils.parseDate(json['last_pruned_at']);

    /// 🧪 Generic Care
    genericCareReminderFrequency = Utils.parseInt(
      json['generic_care_reminder_frequency'],
    );

    genericNotificationEnabled = Utils.parseBool(
      json['generic_notification_enabled'],
    );

    nextGenericCareAt = Utils.parseDate(json['next_generic_care_at']);

    lastGenericCareAt = Utils.parseDate(json['last_generic_care_at']);
  }

  Map<String, dynamic> toJson() {
    return {
      /// 🌱 Watering
      "watering_reminder_frequency": wateringReminderFrequency,
      "watering_notification_enabled": wateringNotificationEnabled,
      "watering_preferred_time": wateringPreferredTime,
      "next_watered_at": nextWateredAt?.toIso8601String(),
      "last_watered_at": lastWateredAt?.toIso8601String(),

      /// 🌿 Fertilizer
      "fertilizer_reminder_frequency": fertilizerReminderFrequency,
      "fertilizer_notification_enabled": fertilizerNotificationEnabled,
      "fertilizer_preferred_time": fertilizerPreferredTime,
      "next_fertilized_at": nextFertilizedAt?.toIso8601String(),
      "last_fertilized_at": lastFertilizedAt?.toIso8601String(),

      /// ✂️ Pruning
      "pruning_reminder_frequency": pruningReminderFrequency,

      /// keeping correct api key
      "pruning_notification_enabled": pruningNotificationEnabled,

      "next_pruned_at": nextPrunedAt?.toIso8601String(),
      "last_pruned_at": lastPrunedAt?.toIso8601String(),

      /// 🧪 Generic Care
      "generic_care_reminder_frequency": genericCareReminderFrequency,

      "generic_notification_enabled": genericNotificationEnabled,

      "next_generic_care_at": nextGenericCareAt?.toIso8601String(),

      "last_generic_care_at": lastGenericCareAt?.toIso8601String(),
    };
  }

  /// =========================
  /// SAFE HELPERS
  /// =========================
}
