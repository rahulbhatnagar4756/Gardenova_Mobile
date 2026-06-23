class NotificationResponseModel {
  NotificationResponseModel({bool? success, String? message, Data? data}) {
    _success = success;
    _message = message;
    _data = data;
  }

  NotificationResponseModel.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  String? _message;
  Data? _data;

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
  Data({Counts? counts, UpcomingIn5Hours? upcomingIn5Hours, List<Tasks>? tasks}) {
    _counts = counts;
    _upcomingIn5Hours = upcomingIn5Hours;
    _tasks = tasks;
  }

  Data.fromJson(dynamic json) {
    _counts = json['counts'] != null ? Counts.fromJson(json['counts']) : null;
    _upcomingIn5Hours = json['upcoming_in_5_hours'] != null
        ? UpcomingIn5Hours.fromJson(json['upcoming_in_5_hours'])
        : null;
    if (json['tasks'] != null) {
      _tasks = [];
      json['tasks'].forEach((v) {
        _tasks?.add(Tasks.fromJson(v));
      });
    }
  }
  Counts? _counts;
  UpcomingIn5Hours? _upcomingIn5Hours;
  List<Tasks>? _tasks;

  Counts? get counts => _counts;
  UpcomingIn5Hours? get upcomingIn5Hours => _upcomingIn5Hours;
  List<Tasks>? get tasks => _tasks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_counts != null) {
      map['counts'] = _counts?.toJson();
    }
    if (_upcomingIn5Hours != null) {
      map['upcoming_in_5_hours'] = _upcomingIn5Hours?.toJson();
    }
    if (_tasks != null) {
      map['tasks'] = _tasks?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Tasks {
  Tasks({
    String? userPlantId,
    num? plantId,
    String? commonName,
    String? scientificName,
    String? activityType,
    String? nextAt,
    dynamic lastAt,
    dynamic note,
    num? frequencyDays,
    String? preferredTime,
    String? eventType,
    bool? isUpcomingIn5Hours,
  }) {
    _userPlantId = userPlantId;
    _plantId = plantId;
    _commonName = commonName;
    _scientificName = scientificName;
    _activityType = activityType;
    _nextAt = nextAt;
    _lastAt = lastAt;
    _note = note;
    _frequencyDays = frequencyDays;
    _preferredTime = preferredTime;
    _eventType = eventType;
    _isUpcomingIn5Hours = isUpcomingIn5Hours;
  }

  Tasks.fromJson(dynamic json) {
    _userPlantId = json['user_plant_id'];
    _plantId = json['plant_id'];
    _commonName = json['common_name'];
    _scientificName = json['scientific_name'];
    _activityType = json['activity_type'];
    _nextAt = json['next_at'];
    _lastAt = json['last_at'];
    _note = json['note'];
    _frequencyDays = json['frequency_days'];
    _preferredTime = json['preferred_time'];
    _eventType = json['event_type'];
    _isUpcomingIn5Hours = json['is_upcoming_in_5_hours'];
  }
  String? _userPlantId;
  num? _plantId;
  String? _commonName;
  String? _scientificName;
  String? _activityType;
  String? _nextAt;
  dynamic _lastAt;
  dynamic _note;
  num? _frequencyDays;
  String? _preferredTime;
  String? _eventType;
  bool? _isUpcomingIn5Hours;

  String? get userPlantId => _userPlantId;
  num? get plantId => _plantId;
  String? get commonName => _commonName;
  String? get scientificName => _scientificName;
  String? get activityType => _activityType;
  String? get nextAt => _nextAt;
  dynamic get lastAt => _lastAt;
  dynamic get note => _note;
  num? get frequencyDays => _frequencyDays;
  String? get preferredTime => _preferredTime;
  String? get eventType => _eventType;
  bool? get isUpcomingIn5Hours => _isUpcomingIn5Hours;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_plant_id'] = _userPlantId;
    map['plant_id'] = _plantId;
    map['common_name'] = _commonName;
    map['scientific_name'] = _scientificName;
    map['activity_type'] = _activityType;
    map['next_at'] = _nextAt;
    map['last_at'] = _lastAt;
    map['note'] = _note;
    map['frequency_days'] = _frequencyDays;
    map['preferred_time'] = _preferredTime;
    map['event_type'] = _eventType;
    map['is_upcoming_in_5_hours'] = _isUpcomingIn5Hours;
    return map;
  }
}

class UpcomingIn5Hours {
  UpcomingIn5Hours({num? count, List<Tasks>? tasks}) {
    _count = count;
    _tasks = tasks;
  }

  UpcomingIn5Hours.fromJson(dynamic json) {
    _count = json['count'];
    if (json['tasks'] != null) {
      _tasks = [];
      json['tasks'].forEach((v) {
        _tasks?.add(Tasks.fromJson(v));
      });
    }
  }
  num? _count;
  List<Tasks>? _tasks;

  num? get count => _count;
  List<Tasks>? get tasks => _tasks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = _count;
    if (_tasks != null) {
      map['tasks'] = _tasks?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Counts {
  Counts({num? all, num? upcoming, num? missed, num? completed}) {
    _all = all;
    _upcoming = upcoming;
    _missed = missed;
    _completed = completed;
  }

  Counts.fromJson(dynamic json) {
    _all = json['all'];
    _upcoming = json['upcoming'];
    _missed = json['missed'];
    _completed = json['completed'];
  }
  num? _all;
  num? _upcoming;
  num? _missed;
  num? _completed;

  num? get all => _all;
  num? get upcoming => _upcoming;
  num? get missed => _missed;
  num? get completed => _completed;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['all'] = _all;
    map['upcoming'] = _upcoming;
    map['missed'] = _missed;
    map['completed'] = _completed;
    return map;
  }
}
