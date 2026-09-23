class DailyChallengesResponseModel {
  bool? success;
  String? message;
  DailyChallengesData? data;

  DailyChallengesResponseModel({this.success, this.message, this.data});

  DailyChallengesResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? DailyChallengesData.fromJson(json['data']) : null;
  }
}

class DailyChallengesData {
  List<DailyChallenge>? challenges;

  DailyChallengesData({this.challenges});

  DailyChallengesData.fromJson(Map<String, dynamic> json) {
    if (json['challenges'] != null) {
      challenges = <DailyChallenge>[];
      json['challenges'].forEach((v) {
        challenges!.add(DailyChallenge.fromJson(v));
      });
    }
  }
}

class DailyChallenge {
  String? id;
  String? code;
  String? title;
  String? description;
  String? category;
  int? points;
  int? targetCount;
  int? progressCount;
  String? status;

  DailyChallenge({
    this.id,
    this.code,
    this.title,
    this.description,
    this.category,
    this.points,
    this.targetCount,
    this.progressCount,
    this.status,
  });

  DailyChallenge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    title = json['title'];
    description = json['description'];
    category = json['category'];
    points = json['points'];
    targetCount = json['targetCount'];
    progressCount = json['progressCount'];
    status = json['status'];
  }

  bool get isCompleted {
    if (status?.toLowerCase() == 'completed') {
      return true;
    }
    if (targetCount != null && progressCount != null && targetCount! > 0) {
      return progressCount! >= targetCount!;
    }
    return false;
  }
}
