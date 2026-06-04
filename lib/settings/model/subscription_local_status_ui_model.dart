class SubscriptionStatusUiModel {
  String? id;
  String? name;
  String? price;
  String? currency;
  String? description;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? trialDays;
  bool? isAutoRenew;
  bool? isTrialActive;
  bool? isActive;

  SubscriptionStatusUiModel({
    this.id,
    this.name,
    this.price,
    this.currency,
    this.description,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.trialDays,
    this.isAutoRenew,
    this.isTrialActive,
    this.isActive,
  });

  SubscriptionStatusUiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    currency = json['currency'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    trialDays = json['trialDays'];
    isAutoRenew = json['isAutoRenew'];
    isTrialActive = json['isTrialActive'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['currency'] = currency;
    data['description'] = description;
    data['status'] = status;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['trialDays'] = trialDays;
    data['isAutoRenew'] = isAutoRenew;
    data['isTrialActive'] = isTrialActive;
    data['isActive'] = isActive;

    return data;
  }
}

class FeatureList {
  String? feature;
  String? description;
  String? featureId;
  bool? isAccess;

  FeatureList({this.feature, this.description, this.featureId, this.isAccess});

  FeatureList.fromJson(Map<String, dynamic> json) {
    feature = json['feature'];
    description = json['description'];
    featureId = json['featureId'];
    isAccess = json['isAccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feature'] = feature;
    data['description'] = description;
    data['featureId'] = featureId;
    data['isAccess'] = isAccess;
    return data;
  }
}
