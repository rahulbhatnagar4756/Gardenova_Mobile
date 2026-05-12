class MyPlantDetailModel {
  bool? success;
  String? message;
  PlantDetailData? data;

  MyPlantDetailModel({this.success, this.message, this.data});

  MyPlantDetailModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? PlantDetailData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data?.toJson()};
  }
}

class PlantDetailData {
  int? userPlantId;
  PlantDetails? plant;
  ReminderModel? reminder;

  PlantDetailData({this.userPlantId, this.plant, this.reminder});

  PlantDetailData.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    userPlantId = json['user_plant_id'];

    plant = json['plant'] != null ? PlantDetails.fromJson(json['plant']) : null;

    reminder = json['reminder'] != null
        ? ReminderModel.fromJson(json['reminder'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'user_plant_id': userPlantId,
      'plant': plant?.toJson(),
      'reminder': reminder?.toJson(),
    };
  }
}

class PlantDetails {
  int? plantId;
  String? scientificName;
  String? commonName;
  String? otherName;
  String? family;
  String? genus;
  String? plantType;
  String? speciesEpithet;
  String? description;
  String? author;
  String? subspecies;
  String? cultivar;
  String? variety;
  String? origin;
  String? type;
  String? cycle;
  String? watering;
  String? wateringBenchmarkValue;
  String? wateringBenchmarkUnit;
  String? sunlight;
  String? hardinessMin;
  String? hardinessMax;
  String? dimensionType;
  dynamic dimensionMinValue;
  dynamic dimensionMaxValue;
  String? dimensionUnit;
  String? growthRate;
  String? maintenance;
  String? careLevel;
  String? soil;
  String? pruningMonth;
  String? propagation;
  String? attracts;
  String? pestSusceptibility;
  String? plantAnatomy;
  bool? droughtTolerant;
  bool? saltTolerant;
  bool? thorny;
  bool? invasive;
  bool? tropical;
  bool? indoor;
  bool? flowers;
  String? floweringSeason;
  bool? cones;
  bool? fruits;
  bool? edibleFruit;
  String? harvestSeason;
  bool? leaf;
  bool? edibleLeaf;
  bool? seeds;
  bool? cuisine;
  bool? medicinal;
  bool? poisonousToHumans;
  bool? poisonousToPets;
  String? careGuidesUrl;

  String? imageOriginalUrl;
  String? imageRegularUrl;
  String? imageMediumUrl;
  String? imageSmallUrl;
  String? imageThumbnail;
  String? imageLicense;

  PlantDetails({
    this.plantId,
    this.scientificName,
    this.commonName,
    this.otherName,
    this.family,
    this.genus,
    this.plantType,
    this.speciesEpithet,
    this.description,
    this.author,
    this.subspecies,
    this.cultivar,
    this.variety,
    this.origin,
    this.type,
    this.cycle,
    this.watering,
    this.wateringBenchmarkValue,
    this.wateringBenchmarkUnit,
    this.sunlight,
    this.hardinessMin,
    this.hardinessMax,
    this.dimensionType,
    this.dimensionMinValue,
    this.dimensionMaxValue,
    this.dimensionUnit,
    this.growthRate,
    this.maintenance,
    this.careLevel,
    this.soil,
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
    this.floweringSeason,
    this.cones,
    this.fruits,
    this.edibleFruit,
    this.harvestSeason,
    this.leaf,
    this.edibleLeaf,
    this.seeds,
    this.cuisine,
    this.medicinal,
    this.poisonousToHumans,
    this.poisonousToPets,
    this.careGuidesUrl,
    this.imageOriginalUrl,
    this.imageRegularUrl,
    this.imageMediumUrl,
    this.imageSmallUrl,
    this.imageThumbnail,
    this.imageLicense,
  });

  PlantDetails.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    plantId = json['plant_id'];
    scientificName = json['scientific_name'];
    commonName = json['common_name'];
    otherName = json['other_name'];
    family = json['family'];
    genus = json['genus'];
    plantType = json['plant_type'];
    speciesEpithet = json['species_epithet'];
    description = json['description'];
    author = json['author'];
    subspecies = json['subspecies'];
    cultivar = json['cultivar'];
    variety = json['variety'];
    origin = json['origin'];
    type = json['type'];
    cycle = json['cycle'];
    watering = json['watering'];
    wateringBenchmarkValue = json['watering_benchmark_value']?.toString();
    wateringBenchmarkUnit = json['watering_benchmark_unit'];
    sunlight = json['sunlight'];
    hardinessMin = json['hardiness_min'];
    hardinessMax = json['hardiness_max'];
    dimensionType = json['dimension_type'];
    dimensionMinValue = json['dimension_min_value'];
    dimensionMaxValue = json['dimension_max_value'];
    dimensionUnit = json['dimension_unit'];
    growthRate = json['growth_rate'];
    maintenance = json['maintenance'];
    careLevel = json['care_level'];
    soil = json['soil'];
    pruningMonth = json['pruning_month'];
    propagation = json['propagation'];
    attracts = json['attracts'];
    pestSusceptibility = json['pest_susceptibility'];
    plantAnatomy = json['plant_anatomy'];

    droughtTolerant = json['drought_tolerant'];
    saltTolerant = json['salt_tolerant'];
    thorny = json['thorny'];
    invasive = json['invasive'];
    tropical = json['tropical'];
    indoor = json['indoor'];
    flowers = json['flowers'];
    floweringSeason = json['flowering_season'];
    cones = json['cones'];
    fruits = json['fruits'];
    edibleFruit = json['edible_fruit'];
    harvestSeason = json['harvest_season'];
    leaf = json['leaf'];
    edibleLeaf = json['edible_leaf'];
    seeds = json['seeds'];
    cuisine = json['cuisine'];
    medicinal = json['medicinal'];
    poisonousToHumans = json['poisonous_to_humans'];
    poisonousToPets = json['poisonous_to_pets'];

    careGuidesUrl = json['care_guides_url'];

    imageOriginalUrl = json['image_original_url'];
    imageRegularUrl = json['image_regular_url'];
    imageMediumUrl = json['image_medium_url'];
    imageSmallUrl = json['image_small_url'];
    imageThumbnail = json['image_thumbnail'];
    imageLicense = json['image_license'];
  }

  Map<String, dynamic> toJson() {
    return {
      'plant_id': plantId,
      'scientific_name': scientificName,
      'common_name': commonName,
      'other_name': otherName,
      'family': family,
      'genus': genus,
      'plant_type': plantType,
      'species_epithet': speciesEpithet,
      'description': description,
      'author': author,
      'subspecies': subspecies,
      'cultivar': cultivar,
      'variety': variety,
      'origin': origin,
      'type': type,
      'cycle': cycle,
      'watering': watering,
      'watering_benchmark_value': wateringBenchmarkValue,
      'watering_benchmark_unit': wateringBenchmarkUnit,
      'sunlight': sunlight,
      'hardiness_min': hardinessMin,
      'hardiness_max': hardinessMax,
      'dimension_type': dimensionType,
      'dimension_min_value': dimensionMinValue,
      'dimension_max_value': dimensionMaxValue,
      'dimension_unit': dimensionUnit,
      'growth_rate': growthRate,
      'maintenance': maintenance,
      'care_level': careLevel,
      'soil': soil,
      'pruning_month': pruningMonth,
      'propagation': propagation,
      'attracts': attracts,
      'pest_susceptibility': pestSusceptibility,
      'plant_anatomy': plantAnatomy,
      'drought_tolerant': droughtTolerant,
      'salt_tolerant': saltTolerant,
      'thorny': thorny,
      'invasive': invasive,
      'tropical': tropical,
      'indoor': indoor,
      'flowers': flowers,
      'flowering_season': floweringSeason,
      'cones': cones,
      'fruits': fruits,
      'edible_fruit': edibleFruit,
      'harvest_season': harvestSeason,
      'leaf': leaf,
      'edible_leaf': edibleLeaf,
      'seeds': seeds,
      'cuisine': cuisine,
      'medicinal': medicinal,
      'poisonous_to_humans': poisonousToHumans,
      'poisonous_to_pets': poisonousToPets,
      'care_guides_url': careGuidesUrl,
      'image_original_url': imageOriginalUrl,
      'image_regular_url': imageRegularUrl,
      'image_medium_url': imageMediumUrl,
      'image_small_url': imageSmallUrl,
      'image_thumbnail': imageThumbnail,
      'image_license': imageLicense,
    };
  }
}

class ReminderModel {
  bool? wateringNotificationEnabled;
  int? wateringReminderFrequency;
  String? wateringPreferredTime;

  DateTime? nextWateredAt;
  DateTime? lastWateredAt;

  bool? fertilizerNotificationEnabled;
  int? fertilizerReminderFrequency;
  String? fertilizerPreferredTime;

  DateTime? nextFertilizedAt;
  DateTime? lastFertilizedAt;

  bool? puringNotificationEnabled;
  int? pruningReminderFrequency;

  DateTime? nextPrunedAt;
  DateTime? lastPrunedAt;

  bool? genericNotificationEnabled;
  int? genericCareReminderFrequency;

  DateTime? lastGenericCareAt;
  DateTime? nextGenericCareAt;

  ReminderModel({
    this.wateringNotificationEnabled,
    this.wateringReminderFrequency,
    this.wateringPreferredTime,
    this.nextWateredAt,
    this.lastWateredAt,
    this.fertilizerNotificationEnabled,
    this.fertilizerReminderFrequency,
    this.fertilizerPreferredTime,
    this.nextFertilizedAt,
    this.lastFertilizedAt,
    this.puringNotificationEnabled,
    this.pruningReminderFrequency,
    this.nextPrunedAt,
    this.lastPrunedAt,
    this.genericNotificationEnabled,
    this.genericCareReminderFrequency,
    this.lastGenericCareAt,
    this.nextGenericCareAt,
  });

  ReminderModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return;

    wateringNotificationEnabled = json['watering_notification_enabled'];

    wateringReminderFrequency = json['watering_reminder_frequency'];

    wateringPreferredTime = json['watering_preferred_time'];

    nextWateredAt = _parseDate(json['next_watered_at']);

    lastWateredAt = _parseDate(json['last_watered_at']);

    fertilizerNotificationEnabled = json['fertilizer_notification_enabled'];

    fertilizerReminderFrequency = json['fertilizer_reminder_frequency'];

    fertilizerPreferredTime = json['fertilizer_preferred_time'];

    nextFertilizedAt = _parseDate(json['next_fertilized_at']);

    lastFertilizedAt = _parseDate(json['last_fertilized_at']);

    puringNotificationEnabled = json['puring_notification_enabled'];

    pruningReminderFrequency = json['pruning_reminder_frequency'];

    nextPrunedAt = _parseDate(json['next_pruned_at']);

    lastPrunedAt = _parseDate(json['last_pruned_at']);

    genericNotificationEnabled = json['generic_notification_enabled'];

    genericCareReminderFrequency = json['generic_care_reminder_frequency'];

    lastGenericCareAt = _parseDate(json['last_generic_care_at']);

    nextGenericCareAt = _parseDate(json['next_generic_care_at']);
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;

    try {
      return DateTime.parse(value.toString()).toLocal();
    } catch (_) {
      return null;
    }
  }
  

  Map<String, dynamic> toJson() {
    return {
      'watering_notification_enabled': wateringNotificationEnabled,

      'watering_reminder_frequency': wateringReminderFrequency,

      'watering_preferred_time': wateringPreferredTime,

      'next_watered_at': nextWateredAt?.toIso8601String(),

      'last_watered_at': lastWateredAt?.toIso8601String(),

      'fertilizer_notification_enabled': fertilizerNotificationEnabled,

      'fertilizer_reminder_frequency': fertilizerReminderFrequency,

      'fertilizer_preferred_time': fertilizerPreferredTime,

      'next_fertilized_at': nextFertilizedAt?.toIso8601String(),

      'last_fertilized_at': lastFertilizedAt?.toIso8601String(),

      'puring_notification_enabled': puringNotificationEnabled,

      'pruning_reminder_frequency': pruningReminderFrequency,

      'next_pruned_at': nextPrunedAt?.toIso8601String(),

      'last_pruned_at': lastPrunedAt?.toIso8601String(),

      'generic_notification_enabled': genericNotificationEnabled,

      'generic_care_reminder_frequency': genericCareReminderFrequency,

      'last_generic_care_at': lastGenericCareAt?.toIso8601String(),

      'next_generic_care_at': nextGenericCareAt?.toIso8601String(),
    };
  }
}
