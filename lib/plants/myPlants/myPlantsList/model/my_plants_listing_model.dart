class MyPlantsListingModel {
  bool? _success;
  String? _message;
  Data? _data;

  MyPlantsListingModel({bool? success, String? message, Data? data}) {
    if (success != null) {
      this._success = success;
    }
    if (message != null) {
      this._message = message;
    }
    if (data != null) {
      this._data = data;
    }
  }

  bool? get success => _success;
  set success(bool? success) => _success = success;
  String? get message => _message;
  set message(String? message) => _message = message;
  Data? get data => _data;
  set data(Data? data) => _data = data;

  MyPlantsListingModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data!.toJson();
    }
    return data;
  }
}

class Data {
  int? _currentPage;
  int? _totalPages;
  int? _totalCount;
  int? _limit;
  List<Plants>? _plants;

  Data({
    int? currentPage,
    int? totalPages,
    int? totalCount,
    int? limit,
    List<Plants>? plants,
  }) {
    if (currentPage != null) {
      this._currentPage = currentPage;
    }
    if (totalPages != null) {
      this._totalPages = totalPages;
    }
    if (totalCount != null) {
      this._totalCount = totalCount;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (plants != null) {
      this._plants = plants;
    }
  }

  int? get currentPage => _currentPage;
  set currentPage(int? currentPage) => _currentPage = currentPage;
  int? get totalPages => _totalPages;
  set totalPages(int? totalPages) => _totalPages = totalPages;
  int? get totalCount => _totalCount;
  set totalCount(int? totalCount) => _totalCount = totalCount;
  int? get limit => _limit;
  set limit(int? limit) => _limit = limit;
  List<Plants>? get plants => _plants;
  set plants(List<Plants>? plants) => _plants = plants;

  Data.fromJson(Map<String, dynamic> json) {
    _currentPage = json['currentPage'];
    _totalPages = json['totalPages'];
    _totalCount = json['totalCount'];
    _limit = json['limit'];
    if (json['plants'] != null) {
      _plants = <Plants>[];
      json['plants'].forEach((v) {
        _plants!.add(new Plants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this._currentPage;
    data['totalPages'] = this._totalPages;
    data['totalCount'] = this._totalCount;
    data['limit'] = this._limit;
    if (this._plants != null) {
      data['plants'] = this._plants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plants {
  String? _id;
  int? _plantId;
  String? _commonName;
  String? _family;
  String? _genus;
  String? _scientificName;
  String? _otherName;
  bool? _medicinal;
  bool? _edibleFruit;
  bool? _flowers;
  bool? _indoor;

  String? _imageUrl;
  String? _imageOriginalUrl;
  String? _healthStatus;
  bool? _wateringNotificationEnabled;
  String? _wateringPreferredTime;
  int? _wateringReminderFrequency;
  String? _lastWateredAt;
  String? _nextWateredAt;
  bool? _fertilizerNotificationEnabled;
  String? _fertilizerPreferredTime;
  int? _fertilizerReminderFrequency;
  String? _lastFertilizedAt;
  String? _nextFertilizedAt;
  bool? _pruningNotificationEnabled;
  int? _pruningReminderFrequency;
  String? _lastPrunedAt;
  String? _nextPrunedAt;
  bool? _genericNotificationEnabled;
  int? _genericCareReminderFrequency;
  String? _lastGenericCareAt;
  String? _nextGenericCareAt;
  String? _addedAt;
  String? _createdAt;
  String? _updatedAt;
  int? _relevance;

  Plants({
    String? id,
    int? plantId,
    String? commonName,
    String? family,
    String? genus,
    String? scientificName,
    String? otherName,
    bool? medicinal,
    bool? edibleFruit,
    bool? flowers,
    bool? indoor,
    String? imageurl,
    String? imageOriginalUrl,
    String? healthStatus,
    bool? wateringNotificationEnabled,
    String? wateringPreferredTime,
    int? wateringReminderFrequency,
    String? lastWateredAt,
    String? nextWateredAt,
    bool? fertilizerNotificationEnabled,
    String? fertilizerPreferredTime,
    int? fertilizerReminderFrequency,
    String? lastFertilizedAt,
    String? nextFertilizedAt,
    bool? pruningNotificationEnabled,
    int? pruningReminderFrequency,
    String? lastPrunedAt,
    String? nextPrunedAt,
    bool? genericNotificationEnabled,
    int? genericCareReminderFrequency,
    String? lastGenericCareAt,
    String? nextGenericCareAt,
    String? addedAt,
    String? createdAt,
    String? updatedAt,
    int? relevance,
  }) {
    if (id != null) {
      this._id = id;
    }
    if (plantId != null) {
      this._plantId = plantId;
    }
    if (commonName != null) {
      this._commonName = commonName;
    }
    if (family != null) {
      this._family = family;
    }
    if (genus != null) {
      this._genus = genus;
    }
    if (scientificName != null) {
      this._scientificName = scientificName;
    }
    if (otherName != null) {
      this._otherName = otherName;
    }
    if (medicinal != null) {
      this._medicinal = medicinal;
    }
    if (edibleFruit != null) {
      this._edibleFruit = edibleFruit;
    }
    if (flowers != null) {
      this._flowers = flowers;
    }
    if (indoor != null) {
      this._indoor = indoor;
    }
    if (imageOriginalUrl != null) {
      this._imageOriginalUrl = imageOriginalUrl;
    }
    if (imageUrl != null) {
      this._imageUrl = imageUrl;
    }
    if (healthStatus != null) {
      this._healthStatus = healthStatus;
    }
    if (wateringNotificationEnabled != null) {
      this._wateringNotificationEnabled = wateringNotificationEnabled;
    }
    if (wateringPreferredTime != null) {
      this._wateringPreferredTime = wateringPreferredTime;
    }
    if (wateringReminderFrequency != null) {
      this._wateringReminderFrequency = wateringReminderFrequency;
    }
    if (lastWateredAt != null) {
      this._lastWateredAt = lastWateredAt;
    }
    if (nextWateredAt != null) {
      this._nextWateredAt = nextWateredAt;
    }
    if (fertilizerNotificationEnabled != null) {
      this._fertilizerNotificationEnabled = fertilizerNotificationEnabled;
    }
    if (fertilizerPreferredTime != null) {
      this._fertilizerPreferredTime = fertilizerPreferredTime;
    }
    if (fertilizerReminderFrequency != null) {
      this._fertilizerReminderFrequency = fertilizerReminderFrequency;
    }
    if (lastFertilizedAt != null) {
      this._lastFertilizedAt = lastFertilizedAt;
    }
    if (nextFertilizedAt != null) {
      this._nextFertilizedAt = nextFertilizedAt;
    }
    if (pruningNotificationEnabled != null) {
      this._pruningNotificationEnabled = pruningNotificationEnabled;
    }
    if (pruningReminderFrequency != null) {
      this._pruningReminderFrequency = pruningReminderFrequency;
    }
    if (lastPrunedAt != null) {
      this._lastPrunedAt = lastPrunedAt;
    }
    if (nextPrunedAt != null) {
      this._nextPrunedAt = nextPrunedAt;
    }
    if (genericNotificationEnabled != null) {
      this._genericNotificationEnabled = genericNotificationEnabled;
    }
    if (genericCareReminderFrequency != null) {
      this._genericCareReminderFrequency = genericCareReminderFrequency;
    }
    if (lastGenericCareAt != null) {
      this._lastGenericCareAt = lastGenericCareAt;
    }
    if (nextGenericCareAt != null) {
      this._nextGenericCareAt = nextGenericCareAt;
    }
    if (addedAt != null) {
      this._addedAt = addedAt;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (relevance != null) {
      this._relevance = relevance;
    }
  }

  String? get id => _id;
  set id(String? id) => _id = id;
  int? get plantId => _plantId;
  set plantId(int? plantId) => _plantId = plantId;
  String? get commonName => _commonName;
  set commonName(String? commonName) => _commonName = commonName;
  String? get family => _family;
  set family(String? family) => _family = family;
  String? get genus => _genus;
  set genus(String? genus) => _genus = genus;
  String? get scientificName => _scientificName;
  set scientificName(String? scientificName) =>
      _scientificName = scientificName;
  String? get otherName => _otherName;
  set otherName(String? otherName) => _otherName = otherName;
  bool? get medicinal => _medicinal;
  set medicinal(bool? medicinal) => _medicinal = medicinal;
  bool? get edibleFruit => _edibleFruit;
  set edibleFruit(bool? edibleFruit) => _edibleFruit = edibleFruit;
  bool? get flowers => _flowers;
  set flowers(bool? flowers) => _flowers = flowers;
  bool? get indoor => _indoor;
  set indoor(bool? indoor) => _indoor = indoor;

  String? get imageOriginalUrl => _imageOriginalUrl;
  set imageOriginalUrl(String? imageOriginalUrl) =>
      _imageOriginalUrl = imageOriginalUrl;
  String? get imageUrl => _imageUrl;
  set imageUrl(String? imageUrl) => _imageUrl = imageUrl;



  String? get healthStatus => _healthStatus;
  set healthStatus(String? healthStatus) => _healthStatus = healthStatus;
  bool? get wateringNotificationEnabled => _wateringNotificationEnabled;
  set wateringNotificationEnabled(bool? wateringNotificationEnabled) =>
      _wateringNotificationEnabled = wateringNotificationEnabled;
  String? get wateringPreferredTime => _wateringPreferredTime;
  set wateringPreferredTime(String? wateringPreferredTime) =>
      _wateringPreferredTime = wateringPreferredTime;
  int? get wateringReminderFrequency => _wateringReminderFrequency;
  set wateringReminderFrequency(int? wateringReminderFrequency) =>
      _wateringReminderFrequency = wateringReminderFrequency;
  String? get lastWateredAt => _lastWateredAt;
  set lastWateredAt(String? lastWateredAt) => _lastWateredAt = lastWateredAt;
  String? get nextWateredAt => _nextWateredAt;
  set nextWateredAt(String? nextWateredAt) => _nextWateredAt = nextWateredAt;
  bool? get fertilizerNotificationEnabled => _fertilizerNotificationEnabled;
  set fertilizerNotificationEnabled(bool? fertilizerNotificationEnabled) =>
      _fertilizerNotificationEnabled = fertilizerNotificationEnabled;
  String? get fertilizerPreferredTime => _fertilizerPreferredTime;
  set fertilizerPreferredTime(String? fertilizerPreferredTime) =>
      _fertilizerPreferredTime = fertilizerPreferredTime;
  int? get fertilizerReminderFrequency => _fertilizerReminderFrequency;
  set fertilizerReminderFrequency(int? fertilizerReminderFrequency) =>
      _fertilizerReminderFrequency = fertilizerReminderFrequency;
  String? get lastFertilizedAt => _lastFertilizedAt;
  set lastFertilizedAt(String? lastFertilizedAt) =>
      _lastFertilizedAt = lastFertilizedAt;
  String? get nextFertilizedAt => _nextFertilizedAt;
  set nextFertilizedAt(String? nextFertilizedAt) =>
      _nextFertilizedAt = nextFertilizedAt;
  bool? get pruningNotificationEnabled => _pruningNotificationEnabled;
  set pruningNotificationEnabled(bool? pruningNotificationEnabled) =>
      _pruningNotificationEnabled = pruningNotificationEnabled;
  int? get pruningReminderFrequency => _pruningReminderFrequency;
  set pruningReminderFrequency(int? pruningReminderFrequency) =>
      _pruningReminderFrequency = pruningReminderFrequency;
  String? get lastPrunedAt => _lastPrunedAt;
  set lastPrunedAt(String? lastPrunedAt) => _lastPrunedAt = lastPrunedAt;
  String? get nextPrunedAt => _nextPrunedAt;
  set nextPrunedAt(String? nextPrunedAt) => _nextPrunedAt = nextPrunedAt;
  bool? get genericNotificationEnabled => _genericNotificationEnabled;
  set genericNotificationEnabled(bool? genericNotificationEnabled) =>
      _genericNotificationEnabled = genericNotificationEnabled;
  int? get genericCareReminderFrequency => _genericCareReminderFrequency;
  set genericCareReminderFrequency(int? genericCareReminderFrequency) =>
      _genericCareReminderFrequency = genericCareReminderFrequency;
  String? get lastGenericCareAt => _lastGenericCareAt;
  set lastGenericCareAt(String? lastGenericCareAt) =>
      _lastGenericCareAt = lastGenericCareAt;
  String? get nextGenericCareAt => _nextGenericCareAt;
  set nextGenericCareAt(String? nextGenericCareAt) =>
      _nextGenericCareAt = nextGenericCareAt;
  String? get addedAt => _addedAt;
  set addedAt(String? addedAt) => _addedAt = addedAt;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  int? get relevance => _relevance;
  set relevance(int? relevance) => _relevance = relevance;

  Plants.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _plantId = json['plant_id'];
    _commonName = json['common_name'];
    _family = json['family'];
    _genus = json['genus'];
    _scientificName = json['scientific_name'];
    _otherName = json['other_name'];
    _medicinal = json['medicinal'];
    _edibleFruit = json['edible_fruit'];
    _flowers = json['flowers'];
    _indoor = json['indoor'];
    _imageOriginalUrl = json['image_original_url'];
    _imageUrl = json['image_url'];
    _healthStatus = json['health_status'];
    _wateringNotificationEnabled = json['watering_notification_enabled'];
    _wateringPreferredTime = json['watering_preferred_time'];
    _wateringReminderFrequency = json['watering_reminder_frequency'];
    _lastWateredAt = json['last_watered_at'];
    _nextWateredAt = json['next_watered_at'];
    _fertilizerNotificationEnabled = json['fertilizer_notification_enabled'];
    _fertilizerPreferredTime = json['fertilizer_preferred_time'];
    _fertilizerReminderFrequency = json['fertilizer_reminder_frequency'];
    _lastFertilizedAt = json['last_fertilized_at'];
    _nextFertilizedAt = json['next_fertilized_at'];
    _pruningNotificationEnabled = json['pruning_notification_enabled'];
    _pruningReminderFrequency = json['pruning_reminder_frequency'];
    _lastPrunedAt = json['last_pruned_at'];
    _nextPrunedAt = json['next_pruned_at'];
    _genericNotificationEnabled = json['generic_notification_enabled'];
    _genericCareReminderFrequency = json['generic_care_reminder_frequency'];
    _lastGenericCareAt = json['last_generic_care_at'];
    _nextGenericCareAt = json['next_generic_care_at'];
    _addedAt = json['added_at'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _relevance = json['relevance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['plant_id'] = this._plantId;
    data['common_name'] = this._commonName;
    data['family'] = this._family;
    data['genus'] = this._genus;
    data['scientific_name'] = this._scientificName;
    data['other_name'] = this._otherName;
    data['medicinal'] = this._medicinal;
    data['edible_fruit'] = this._edibleFruit;
    data['flowers'] = this._flowers;
    data['indoor'] = this._indoor;
    data['image_original_url'] = this._imageOriginalUrl;
    data['image_url'] = this._imageUrl;
    data['health_status'] = this._healthStatus;
    data['watering_notification_enabled'] = this._wateringNotificationEnabled;
    data['watering_preferred_time'] = this._wateringPreferredTime;
    data['watering_reminder_frequency'] = this._wateringReminderFrequency;
    data['last_watered_at'] = this._lastWateredAt;
    data['next_watered_at'] = this._nextWateredAt;
    data['fertilizer_notification_enabled'] =
        this._fertilizerNotificationEnabled;
    data['fertilizer_preferred_time'] = this._fertilizerPreferredTime;
    data['fertilizer_reminder_frequency'] = this._fertilizerReminderFrequency;
    data['last_fertilized_at'] = this._lastFertilizedAt;
    data['next_fertilized_at'] = this._nextFertilizedAt;
    data['pruning_notification_enabled'] = this._pruningNotificationEnabled;
    data['pruning_reminder_frequency'] = this._pruningReminderFrequency;
    data['last_pruned_at'] = this._lastPrunedAt;
    data['next_pruned_at'] = this._nextPrunedAt;
    data['generic_notification_enabled'] = this._genericNotificationEnabled;
    data['generic_care_reminder_frequency'] =
        this._genericCareReminderFrequency;
    data['last_generic_care_at'] = this._lastGenericCareAt;
    data['next_generic_care_at'] = this._nextGenericCareAt;
    data['added_at'] = this._addedAt;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['relevance'] = this._relevance;
    return data;
  }
}
