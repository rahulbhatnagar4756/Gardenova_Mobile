import '../../base/widgets/base_calculate_remaining_days.dart';

import 'user_subscription_me_model.dart';

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
  String? planCode;
  String? pendingPlanCode;
  String? pendingPlanName;
  String? pendingBillingCycle;
  String? pendingEffectiveAt;

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
    this.planCode,
    this.pendingPlanCode,
    this.pendingPlanName,
    this.pendingBillingCycle,
    this.pendingEffectiveAt,
  });

  bool get hasPendingPlan {
    final code = (pendingPlanCode ?? '').trim();
    final planName = (pendingPlanName ?? '').trim();
    return code.isNotEmpty || planName.isNotEmpty;
  }

  String get pendingPlanDisplayLabel {
    final planName = (pendingPlanName ?? '').trim();
    final cycle = (pendingBillingCycle ?? '').trim();
    if (planName.isEmpty) return 'Plan';
    if (cycle.isEmpty) return '$planName Plan';
    return '$planName ($cycle)';
  }

  factory SubscriptionStatusUiModel.fromMeApi(UserSubscriptionMeData data) {
    final plan = data.plan;
    final pending = data.pendingPlan;
    final planName = plan?.displayName ?? 'Free';
    final rawStatus = data.status?.toString().trim() ?? '';
    final normalizedStatus = rawStatus.toLowerCase();
    final cancelAtPeriodEnd = data.cancelAtPeriodEnd == true;
    final expiresAt = data.currentPeriodEnd;
    final isTrial = planName.toLowerCase() == 'trial';
    final isActive =
        normalizedStatus == 'active' || normalizedStatus == 'renewed';
    final hasRemainingAccess =
        expiresAt == null ||
        expiresAt.isEmpty ||
        BaseCalculateRemainingDays.daysUntilEndDate(expiresAt) > 0;

    return SubscriptionStatusUiModel(
      id: plan?.code,
      name: planName,
      planCode: plan?.code,
      status: cancelAtPeriodEnd && isActive && pending == null
          ? 'Cancelled'
          : rawStatus,
      updatedAt: expiresAt,
      isActive: isActive && hasRemainingAccess,
      isTrialActive: isTrial && isActive,
      isAutoRenew: !cancelAtPeriodEnd,
      billingCycle: plan?.billingCycle,
      cancelAtPeriodEnd: cancelAtPeriodEnd,
      pendingPlanCode: pending?.code,
      pendingPlanName: pending?.displayName,
      pendingBillingCycle: pending?.billingLabel,
      pendingEffectiveAt: data.pendingEffectiveAt,
    );
  }

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
    planCode = json['planCode']?.toString();
    pendingPlanCode = json['pendingPlanCode']?.toString();
    pendingPlanName = json['pendingPlanName']?.toString();
    pendingBillingCycle = json['pendingBillingCycle']?.toString();
    pendingEffectiveAt = json['pendingEffectiveAt']?.toString();
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
    data['planCode'] = planCode;
    data['pendingPlanCode'] = pendingPlanCode;
    data['pendingPlanName'] = pendingPlanName;
    data['pendingBillingCycle'] = pendingBillingCycle;
    data['pendingEffectiveAt'] = pendingEffectiveAt;

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
