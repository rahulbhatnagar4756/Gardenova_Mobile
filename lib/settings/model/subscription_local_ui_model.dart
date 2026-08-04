class SubscriptionLocalUiModel {
  String? name;
  String? description;
  String? price;
  String? currency;
  String? id;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? trialDays;
  bool? isActive;
  bool? isTrialActive;
  List<FeatureList>? featureList;

  SubscriptionLocalUiModel({
    this.name,
    this.description,
    this.price,
    this.currency,
    this.id,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.trialDays,
    this.isActive,
    this.isTrialActive,
    this.featureList,
  });

  SubscriptionLocalUiModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    price = json['price'];
    currency = json['currency'];
    id = json['id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    trialDays = json['trialDays'];
    isActive = json['isActive'];
    isTrialActive = json['isTrialActive'];
    if (json['featureList'] != null) {
      featureList = <FeatureList>[];
      json['featureList'].forEach((v) {
        featureList!.add(FeatureList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['currency'] = currency;
    data['id'] = id;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['trialDays'] = trialDays;
    data['isActive'] = isActive;
    data['isTrialActive'] = isTrialActive;
    if (featureList != null) {
      data['featureList'] = featureList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FeatureList {
  String? feature;
  String? description;
  String? featureId;
  bool? isAccess;
  bool? isSubFeatureAccess;

  FeatureList({
    this.feature,
    this.description,
    this.featureId,
    this.isAccess,
    this.isSubFeatureAccess,
  });

  FeatureList.fromJson(Map<String, dynamic> json) {
    feature = json['feature'];
    description = json['description'];
    featureId = json['featureId'];
    isAccess = json['isAccess'];
    isSubFeatureAccess = json['isSubFeatureAccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feature'] = feature;
    data['description'] = description;
    data['featureId'] = featureId;
    data['isAccess'] = isAccess;
    data['isSubFeatureAccess'] = isSubFeatureAccess;
    return data;
  }
}
