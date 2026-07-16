import '../../base/widgets/base_calculate_remaining_days.dart';

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
  String? billingCycle;
  bool? cancelAtPeriodEnd;

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
    this.billingCycle,
    this.cancelAtPeriodEnd,
  });

  factory SubscriptionStatusUiModel.fromProfileSubscription(
    dynamic subscription,
  ) {
    final planId = subscription.planId?.toString();
    final planName = subscription.planName?.toString().trim() ?? '';
    final rawStatus = subscription.status?.toString().trim() ?? '';
    final normalizedStatus = rawStatus.toLowerCase();
    final billingCycle = subscription.billingCycle?.toString();
    final cancelAtPeriodEnd = subscription.cancelAtPeriodEnd == true;
    final startedAt = subscription.startedAt?.toString();
    final expiresAt = subscription.expiresAt?.toString();
    final isTrial = planName.toLowerCase() == 'trial';
    final isActive =
        normalizedStatus == 'active' || normalizedStatus == 'renewed';
    final hasRemainingAccess =
        expiresAt == null ||
        expiresAt.isEmpty ||
        BaseCalculateRemainingDays.daysUntilEndDate(expiresAt) > 0;

    return SubscriptionStatusUiModel(
      id: planId,
      name: planName.isNotEmpty ? planName : 'Free',
      status: cancelAtPeriodEnd && isActive ? 'Cancelled' : rawStatus,
      createdAt: startedAt,
      updatedAt: expiresAt,
      isActive: isActive && hasRemainingAccess,
      isTrialActive: isTrial && isActive,
      isAutoRenew: !cancelAtPeriodEnd,
      billingCycle: billingCycle,
      cancelAtPeriodEnd: cancelAtPeriodEnd,
    );
  }

  SubscriptionStatusUiModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['planId']?.toString();
    name = json['name'] ?? json['planName']?.toString();
    price = json['price'];
    currency = json['currency'];
    description = json['description'];
    status = json['status'];
    createdAt = json['createdAt'] ?? json['startedAt']?.toString();
    updatedAt = json['updatedAt'] ?? json['expiresAt']?.toString();
    trialDays = json['trialDays'];
    isAutoRenew = json['isAutoRenew'];
    isTrialActive = json['isTrialActive'];
    isActive = json['isActive'];
    billingCycle = json['billingCycle']?.toString();
    cancelAtPeriodEnd = json['cancelAtPeriodEnd'] == true;
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
    data['billingCycle'] = billingCycle;
    data['cancelAtPeriodEnd'] = cancelAtPeriodEnd;

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
