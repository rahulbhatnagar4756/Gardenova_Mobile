// class PlantResponseModel {
//   bool? success;
//   String? message;
//   PlantData? data;

//   PlantResponseModel({this.success, this.message, this.data});

//   PlantResponseModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? PlantData.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     return {"success": success, "message": message, "data": data?.toJson()};
//   }
// }

// class PlantData {
//   int? currentPage;
//   int? totalPages;
//   int? totalCount;
//   int? limit;
//   List<PlantModel>? plants;

//   PlantData({
//     this.currentPage,
//     this.totalPages,
//     this.totalCount,
//     this.limit,
//     this.plants,
//   });

//   PlantData.fromJson(Map<String, dynamic> json) {
//     currentPage = json['currentPage'];
//     totalPages = json['totalPages'];
//     totalCount = json['totalCount'];
//     limit = json['limit'];

//     if (json['plants'] != null) {
//       plants = (json['plants'] as List)
//           .map((e) => PlantModel.fromJson(e))
//           .toList();
//     }
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       "currentPage": currentPage,
//       "totalPages": totalPages,
//       "totalCount": totalCount,
//       "limit": limit,
//       "plants": plants?.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// // old model
// // class PlantModel {
// //   String? userPlantId;
// //   int? id;
// //   int? plantId;
// //   String? commonName;
// //   String? scientificName;
// //   String? family;
// //   String? genus;
// //   String? imageUrl;

// //   String? healthStatus;

// //   /// Watering
// //   bool? wateringNotificationEnabled;
// //   String? wateringPreferredTime;
// //   int? wateringReminderFrequency;
// //   String? lastWateredAt;
// //   String? nextWateredAt;

// //   /// Fertilizer
// //   bool? fertilizerNotificationEnabled;
// //   String? fertilizerPreferredTime;
// //   int? fertilizerReminderFrequency;
// //   String? lastFertilizedAt;
// //   String? nextFertilizedAt;

// //   /// Pruning
// //   bool? pruningNotificationEnabled;
// //   int? pruningReminderFrequency;
// //   String? lastPrunedAt;
// //   String? nextPrunedAt;

// //   /// Generic care
// //   bool? genericNotificationEnabled;
// //   int? genericCareReminderFrequency;
// //   String? lastGenericCareAt;
// //   String? nextGenericCareAt;

// //   /// Dates
// //   String? createdAt;
// //   String? updatedAt;

// //   bool isSelected;

// //   PlantModel({
// //     this.id,
// //     this.userPlantId,
// //     this.plantId,
// //     this.commonName,
// //     this.scientificName,
// //     this.family,
// //     this.genus,
// //     this.imageUrl,
// //     this.healthStatus,
// //     this.wateringNotificationEnabled,
// //     this.wateringPreferredTime,
// //     this.wateringReminderFrequency,
// //     this.lastWateredAt,
// //     this.nextWateredAt,
// //     this.fertilizerNotificationEnabled,
// //     this.fertilizerPreferredTime,
// //     this.fertilizerReminderFrequency,
// //     this.lastFertilizedAt,
// //     this.nextFertilizedAt,
// //     this.pruningNotificationEnabled,
// //     this.pruningReminderFrequency,
// //     this.lastPrunedAt,
// //     this.nextPrunedAt,
// //     this.genericNotificationEnabled,
// //     this.genericCareReminderFrequency,
// //     this.lastGenericCareAt,
// //     this.nextGenericCareAt,
// //     this.createdAt,
// //     this.updatedAt,
// //     this.isSelected = false,
// //   });

// //   PlantModel.fromJson(Map<String, dynamic> json)
// //     : id = json['id'],
// //       userPlantId = json['user_plant_id'],
// //       plantId = json['plant_id'],
// //       commonName = json['common_name'],
// //       scientificName = json['scientific_name'],
// //       family = json['family'],
// //       genus = json['genus'],
// //       imageUrl = json['image_url'],
// //       healthStatus = json['health_status'],

// //       /// Handle bool safely (API gives "falsa")
// //       wateringNotificationEnabled = json['watering_notification_enabled'],
// //       wateringPreferredTime = json['watering_preferred_time'],
// //       wateringReminderFrequency = json['watering_reminder_frequency'],
// //       lastWateredAt = json['last_watered_at'],
// //       nextWateredAt = json['next_watered_at'],

// //       fertilizerNotificationEnabled = json['fertilizer_notification_enabled'],
// //       fertilizerPreferredTime = json['fertilizer_preferred_time'],
// //       fertilizerReminderFrequency = json['fertilizer_reminder_frequency'],
// //       lastFertilizedAt = json['last_fertilized_at'],
// //       nextFertilizedAt = json['next_fertilized_at'],

// //       pruningNotificationEnabled = json['pruning_notification_enabled'],
// //       pruningReminderFrequency = json['pruning_reminder_frequency'],
// //       lastPrunedAt = json['last_pruned_at'],
// //       nextPrunedAt = json['next_pruned_at'],

// //       /// FIX: string "falsa" → bool
// //       genericNotificationEnabled =
// //           json['generic_notification_enabled'] == true ||
// //           json['generic_notification_enabled'] == "true",

// //       genericCareReminderFrequency = json['generic_care_reminder_frequency'],
// //       lastGenericCareAt = json['last_generic_care_at'],
// //       nextGenericCareAt = json['next_generic_care_at'],

// //       createdAt = json['created_at'],
// //       updatedAt = json['updated_at'],
// //       isSelected = false;

// //   Map<String, dynamic> toJson() {
// //     return {
// //       "user_plant_id": userPlantId,
// //       "plant_id": plantId,
// //       "common_name": commonName,
// //       "scientific_name": scientificName,
// //       "family": family,
// //       "genus": genus,
// //       "image_url": imageUrl,
// //       "health_status": healthStatus,

// //       "watering_notification_enabled": wateringNotificationEnabled,
// //       "watering_preferred_time": wateringPreferredTime,
// //       "watering_reminder_frequency": wateringReminderFrequency,
// //       "last_watered_at": lastWateredAt,
// //       "next_watered_at": nextWateredAt,

// //       "fertilizer_notification_enabled": fertilizerNotificationEnabled,
// //       "fertilizer_preferred_time": fertilizerPreferredTime,
// //       "fertilizer_reminder_frequency": fertilizerReminderFrequency,
// //       "last_fertilized_at": lastFertilizedAt,
// //       "next_fertilized_at": nextFertilizedAt,

// //       "pruning_notification_enabled": pruningNotificationEnabled,
// //       "pruning_reminder_frequency": pruningReminderFrequency,
// //       "last_pruned_at": lastPrunedAt,
// //       "next_pruned_at": nextPrunedAt,

// //       "generic_notification_enabled": genericNotificationEnabled,
// //       "generic_care_reminder_frequency": genericCareReminderFrequency,
// //       "last_generic_care_at": lastGenericCareAt,
// //       "next_generic_care_at": nextGenericCareAt,

// //       "created_at": createdAt,
// //       "updated_at": updatedAt,
// //     };
// //   }
// // }

// // new model below
// // class PlantModel {
// //   String? id;
// //   String? speciesName;
// //   String? commonName;
// //   String? imageUrl;
// //   int? relevance;

// //   bool isSelected;

// //   PlantModel({
// //     this.id,
// //     this.speciesName,
// //     this.commonName,
// //     this.imageUrl,
// //     this.relevance,
// //     this.isSelected = false,
// //   });

// //   PlantModel.fromJson(Map<String, dynamic>? json)
// //     : id = json?['id']?.toString(),
// //       speciesName = json?['species_name']?.toString(),
// //       commonName = json?['common_name']?.toString(),
// //       imageUrl = json?['image_url']?.toString(),
// //       relevance = json?['relevance'] is num
// //           ? (json?['relevance'] as num).toInt()
// //           : int.tryParse(json?['relevance']?.toString() ?? '0'),
// //       isSelected = false;

// //   Map<String, dynamic> toJson() {
// //     return {
// //       "id": id,
// //       "species_name": speciesName,
// //       "common_name": commonName,
// //       "image_url": imageUrl,
// //       "relevance": relevance,
// //     };
// //   }
// // }
// // new new model
// // class PlantModel {
// //   String? userPlantId;

// //   /// UPDATED: int -> String
// //   String? id;

// //   /// UPDATED: int -> String
// //   String? plantId;

// //   String? commonName;
// //   String? scientificName;
// //   String? speciesName;
// //   String? family;
// //   String? genus;
// //   String? imageUrl;

// //   String? healthStatus;

// //   /// NEW
// //   String? addedAt;

// //   /// NEW
// //   int? relevance;

// //   /// Watering
// //   bool? wateringNotificationEnabled;
// //   String? wateringPreferredTime;
// //   int? wateringReminderFrequency;
// //   String? lastWateredAt;
// //   String? nextWateredAt;

// //   /// Fertilizer
// //   bool? fertilizerNotificationEnabled;
// //   String? fertilizerPreferredTime;
// //   int? fertilizerReminderFrequency;
// //   String? lastFertilizedAt;
// //   String? nextFertilizedAt;

// //   /// Pruning
// //   bool? pruningNotificationEnabled;
// //   int? pruningReminderFrequency;
// //   String? lastPrunedAt;
// //   String? nextPrunedAt;

// //   /// Generic care
// //   bool? genericNotificationEnabled;
// //   int? genericCareReminderFrequency;
// //   String? lastGenericCareAt;
// //   String? nextGenericCareAt;

// //   /// Dates
// //   String? createdAt;
// //   String? updatedAt;

// //   bool isSelected;

// //   PlantModel({
// //     this.id,
// //     this.userPlantId,
// //     this.plantId,
// //     this.speciesName,
// //     this.commonName,
// //     this.scientificName,
// //     this.family,
// //     this.genus,
// //     this.imageUrl,
// //     this.healthStatus,
// //     this.addedAt,
// //     this.relevance,
// //     this.wateringNotificationEnabled,
// //     this.wateringPreferredTime,
// //     this.wateringReminderFrequency,
// //     this.lastWateredAt,
// //     this.nextWateredAt,
// //     this.fertilizerNotificationEnabled,
// //     this.fertilizerPreferredTime,
// //     this.fertilizerReminderFrequency,
// //     this.lastFertilizedAt,
// //     this.nextFertilizedAt,
// //     this.pruningNotificationEnabled,
// //     this.pruningReminderFrequency,
// //     this.lastPrunedAt,
// //     this.nextPrunedAt,
// //     this.genericNotificationEnabled,
// //     this.genericCareReminderFrequency,
// //     this.lastGenericCareAt,
// //     this.nextGenericCareAt,
// //     this.createdAt,
// //     this.updatedAt,
// //     this.isSelected = false,
// //   });

// //   PlantModel.fromJson(Map<String, dynamic>? json)
// //     : id = json?['id']?.toString(),

// //       userPlantId = json?['user_plant_id']?.toString(),
// //       speciesName = json?['species_name']?.toString(),

// //       /// UPDATED
// //       plantId = json?['plant_id']?.toString(),

// //       commonName = json?['common_name']?.toString(),

// //       scientificName = json?['scientific_name']?.toString(),

// //       family = json?['family']?.toString(),

// //       genus = json?['genus']?.toString(),

// //       imageUrl = json?['image_url']?.toString(),

// //       healthStatus = json?['health_status']?.toString(),

// //       /// NEW
// //       addedAt = json?['added_at']?.toString(),

// //       /// NEW
// //       relevance = _parseInt(json?['relevance']),

// //       /// Watering
// //       wateringNotificationEnabled = _parseBool(
// //         json?['watering_notification_enabled'],
// //       ),

// //       wateringPreferredTime = json?['watering_preferred_time']?.toString(),

// //       wateringReminderFrequency = _parseInt(
// //         json?['watering_reminder_frequency'],
// //       ),

// //       lastWateredAt = json?['last_watered_at']?.toString(),

// //       nextWateredAt = json?['next_watered_at']?.toString(),

// //       /// Fertilizer
// //       fertilizerNotificationEnabled = _parseBool(
// //         json?['fertilizer_notification_enabled'],
// //       ),

// //       fertilizerPreferredTime = json?['fertilizer_preferred_time']?.toString(),

// //       fertilizerReminderFrequency = _parseInt(
// //         json?['fertilizer_reminder_frequency'],
// //       ),

// //       lastFertilizedAt = json?['last_fertilized_at']?.toString(),

// //       nextFertilizedAt = json?['next_fertilized_at']?.toString(),

// //       /// Pruning
// //       pruningNotificationEnabled = _parseBool(
// //         json?['pruning_notification_enabled'],
// //       ),

// //       pruningReminderFrequency = _parseInt(json?['pruning_reminder_frequency']),

// //       lastPrunedAt = json?['last_pruned_at']?.toString(),

// //       nextPrunedAt = json?['next_pruned_at']?.toString(),

// //       /// Generic Care
// //       genericNotificationEnabled = _parseBool(
// //         json?['generic_notification_enabled'],
// //       ),

// //       genericCareReminderFrequency = _parseInt(
// //         json?['generic_care_reminder_frequency'],
// //       ),

// //       lastGenericCareAt = json?['last_generic_care_at']?.toString(),

// //       nextGenericCareAt = json?['next_generic_care_at']?.toString(),

// //       /// Dates
// //       createdAt = json?['created_at']?.toString(),

// //       updatedAt = json?['updated_at']?.toString(),

// //       isSelected = false;

// //   Map<String, dynamic> toJson() {
// //     return {
// //       "id": id,
// //       "user_plant_id": userPlantId,
// //       "plant_id": plantId,
// //       "common_name": commonName,
// //       "species_name": speciesName,
// //       "scientific_name": scientificName,
// //       "family": family,
// //       "genus": genus,
// //       "image_url": imageUrl,
// //       "health_status": healthStatus,

// //       /// NEW
// //       "added_at": addedAt,
// //       "relevance": relevance,

// //       /// Watering
// //       "watering_notification_enabled": wateringNotificationEnabled,

// //       "watering_preferred_time": wateringPreferredTime,

// //       "watering_reminder_frequency": wateringReminderFrequency,

// //       "last_watered_at": lastWateredAt,
// //       "next_watered_at": nextWateredAt,

// //       /// Fertilizer
// //       "fertilizer_notification_enabled": fertilizerNotificationEnabled,

// //       "fertilizer_preferred_time": fertilizerPreferredTime,

// //       "fertilizer_reminder_frequency": fertilizerReminderFrequency,

// //       "last_fertilized_at": lastFertilizedAt,
// //       "next_fertilized_at": nextFertilizedAt,

// //       /// Pruning
// //       "pruning_notification_enabled": pruningNotificationEnabled,

// //       "pruning_reminder_frequency": pruningReminderFrequency,

// //       "last_pruned_at": lastPrunedAt,
// //       "next_pruned_at": nextPrunedAt,

// //       /// Generic Care
// //       "generic_notification_enabled": genericNotificationEnabled,

// //       "generic_care_reminder_frequency": genericCareReminderFrequency,

// //       "last_generic_care_at": lastGenericCareAt,

// //       "next_generic_care_at": nextGenericCareAt,

// //       /// Dates
// //       "created_at": createdAt,
// //       "updated_at": updatedAt,
// //     };
// //   }

// // again new new new model

// class PlantModel {
//   String? userPlantId;

//   /// UUID/String/Int SAFE
//   String? id;

//   /// OLD: int
//   /// NEW: sometimes int, sometimes uuid
//   dynamic plantId;

//   String? commonName;
//   String? scientificName;
//   String? speciesName;
//   String? family;
//   String? genus;

//   /// OLD
//   String? imageUrl;

//   /// NEW
//   String? imageOriginalUrl;

//   String? healthStatus;

//   /// NEW FIELDS
//   String? otherName;

//   bool? medicinal;
//   bool? edibleFruit;
//   bool? flowers;
//   bool? indoor;

//   /// NEW
//   String? addedAt;

//   /// NEW
//   int? relevance;

//   /// Watering
//   bool? wateringNotificationEnabled;
//   String? wateringPreferredTime;
//   int? wateringReminderFrequency;
//   String? lastWateredAt;
//   String? nextWateredAt;

//   /// Fertilizer
//   bool? fertilizerNotificationEnabled;
//   String? fertilizerPreferredTime;
//   int? fertilizerReminderFrequency;
//   String? lastFertilizedAt;
//   String? nextFertilizedAt;

//   /// Pruning
//   bool? pruningNotificationEnabled;
//   int? pruningReminderFrequency;
//   String? lastPrunedAt;
//   String? nextPrunedAt;

//   /// Generic care
//   bool? genericNotificationEnabled;
//   int? genericCareReminderFrequency;
//   String? lastGenericCareAt;
//   String? nextGenericCareAt;

//   /// Dates
//   String? createdAt;
//   String? updatedAt;

//   bool isSelected;

//   PlantModel({
//     this.id,
//     this.userPlantId,
//     this.plantId,
//     this.commonName,
//     this.scientificName,
//     this.speciesName,
//     this.family,
//     this.genus,
//     this.imageUrl,
//     this.imageOriginalUrl,
//     this.healthStatus,
//     this.otherName,
//     this.medicinal,
//     this.edibleFruit,
//     this.flowers,
//     this.indoor,
//     this.addedAt,
//     this.relevance,
//     this.wateringNotificationEnabled,
//     this.wateringPreferredTime,
//     this.wateringReminderFrequency,
//     this.lastWateredAt,
//     this.nextWateredAt,
//     this.fertilizerNotificationEnabled,
//     this.fertilizerPreferredTime,
//     this.fertilizerReminderFrequency,
//     this.lastFertilizedAt,
//     this.nextFertilizedAt,
//     this.pruningNotificationEnabled,
//     this.pruningReminderFrequency,
//     this.lastPrunedAt,
//     this.nextPrunedAt,
//     this.genericNotificationEnabled,
//     this.genericCareReminderFrequency,
//     this.lastGenericCareAt,
//     this.nextGenericCareAt,
//     this.createdAt,
//     this.updatedAt,
//     this.isSelected = false,
//   });

//   PlantModel.fromJson(Map<String, dynamic>? json)
//     : id = json?['id']?.toString(),

//       userPlantId = json?['user_plant_id']?.toString(),

//       /// SAFE FOR BOTH INT & UUID
//       plantId = json?['plant_id'],

//       commonName = json?['common_name']?.toString(),

//       scientificName = json?['scientific_name']?.toString(),

//       speciesName = json?['species_name']?.toString(),

//       family = json?['family']?.toString(),

//       genus = json?['genus']?.toString(),

//       /// OLD RESPONSE
//       imageUrl = json?['image_url']?.toString(),

//       /// NEW RESPONSE
//       imageOriginalUrl = json?['image_original_url']?.toString(),

//       healthStatus = json?['health_status']?.toString(),

//       /// NEW FIELDS
//       otherName = json?['other_name']?.toString(),

//       medicinal = _parseBool(json?['medicinal']),

//       edibleFruit = _parseBool(json?['edible_fruit']),

//       flowers = _parseBool(json?['flowers']),

//       indoor = _parseBool(json?['indoor']),

//       /// NEW
//       addedAt = json?['added_at']?.toString(),

//       relevance = _parseInt(json?['relevance']),

//       /// Watering
//       wateringNotificationEnabled = _parseBool(
//         json?['watering_notification_enabled'],
//       ),

//       wateringPreferredTime = json?['watering_preferred_time']?.toString(),

//       wateringReminderFrequency = _parseInt(
//         json?['watering_reminder_frequency'],
//       ),

//       lastWateredAt = json?['last_watered_at']?.toString(),

//       nextWateredAt = json?['next_watered_at']?.toString(),

//       /// Fertilizer
//       fertilizerNotificationEnabled = _parseBool(
//         json?['fertilizer_notification_enabled'],
//       ),

//       fertilizerPreferredTime = json?['fertilizer_preferred_time']?.toString(),

//       fertilizerReminderFrequency = _parseInt(
//         json?['fertilizer_reminder_frequency'],
//       ),

//       lastFertilizedAt = json?['last_fertilized_at']?.toString(),

//       nextFertilizedAt = json?['next_fertilized_at']?.toString(),

//       /// Pruning
//       pruningNotificationEnabled = _parseBool(
//         json?['pruning_notification_enabled'],
//       ),

//       pruningReminderFrequency = _parseInt(json?['pruning_reminder_frequency']),

//       lastPrunedAt = json?['last_pruned_at']?.toString(),

//       nextPrunedAt = json?['next_pruned_at']?.toString(),

//       /// Generic Care
//       genericNotificationEnabled = _parseBool(
//         json?['generic_notification_enabled'],
//       ),

//       genericCareReminderFrequency = _parseInt(
//         json?['generic_care_reminder_frequency'],
//       ),

//       lastGenericCareAt = json?['last_generic_care_at']?.toString(),

//       nextGenericCareAt = json?['next_generic_care_at']?.toString(),

//       /// Dates
//       createdAt = json?['created_at']?.toString(),

//       updatedAt = json?['updated_at']?.toString(),

//       isSelected = false;

//   Map<String, dynamic> toJson() {
//     return {
//       "id": id,
//       "user_plant_id": userPlantId,
//       "plant_id": plantId,
//       "common_name": commonName,
//       "scientific_name": scientificName,
//       "species_name": speciesName,
//       "family": family,
//       "genus": genus,

//       /// OLD
//       "image_url": imageUrl,

//       /// NEW
//       "image_original_url": imageOriginalUrl,

//       "health_status": healthStatus,

//       /// NEW FIELDS
//       "other_name": otherName,
//       "medicinal": medicinal,
//       "edible_fruit": edibleFruit,
//       "flowers": flowers,
//       "indoor": indoor,

//       "added_at": addedAt,
//       "relevance": relevance,

//       /// Watering
//       "watering_notification_enabled": wateringNotificationEnabled,

//       "watering_preferred_time": wateringPreferredTime,

//       "watering_reminder_frequency": wateringReminderFrequency,

//       "last_watered_at": lastWateredAt,

//       "next_watered_at": nextWateredAt,

//       /// Fertilizer
//       "fertilizer_notification_enabled": fertilizerNotificationEnabled,

//       "fertilizer_preferred_time": fertilizerPreferredTime,

//       "fertilizer_reminder_frequency": fertilizerReminderFrequency,

//       "last_fertilized_at": lastFertilizedAt,

//       "next_fertilized_at": nextFertilizedAt,

//       /// Pruning
//       "pruning_notification_enabled": pruningNotificationEnabled,

//       "pruning_reminder_frequency": pruningReminderFrequency,

//       "last_pruned_at": lastPrunedAt,

//       "next_pruned_at": nextPrunedAt,

//       /// Generic Care
//       "generic_notification_enabled": genericNotificationEnabled,

//       "generic_care_reminder_frequency": genericCareReminderFrequency,

//       "last_generic_care_at": lastGenericCareAt,

//       "next_generic_care_at": nextGenericCareAt,

//       /// Dates
//       "created_at": createdAt,
//       "updated_at": updatedAt,
//     };
//   }

//   /// =========================
//   /// SAFE HELPERS
//   /// =========================

//   static bool _parseBool(dynamic value) {
//     if (value == null) return false;

//     if (value is bool) return value;

//     final val = value.toString().toLowerCase();

//     return val == "true" || val == "1";
//   }

//   static int? _parseInt(dynamic value) {
//     if (value == null) return null;

//     if (value is int) return value;

//     return int.tryParse(value.toString());
//   }
// }
