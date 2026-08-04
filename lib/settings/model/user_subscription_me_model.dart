class UserSubscriptionMeResponse {
  final bool? success;
  final String? message;
  final UserSubscriptionMeData? data;

  UserSubscriptionMeResponse({this.success, this.message, this.data});

  factory UserSubscriptionMeResponse.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionMeResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? UserSubscriptionMeData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class UserSubscriptionMeData {
  final UserSubscriptionPlanInfo? plan;
  final String? status;
  final String? currentPeriodEnd;
  final bool? cancelAtPeriodEnd;
  final UserSubscriptionPlanInfo? pendingPlan;
  final String? pendingEffectiveAt;
  final UserSubscriptionUsage? usage;
  final String? billingProvider;
  final String? razorpaySubscriptionId;
  final String? productId;

  UserSubscriptionMeData({
    this.plan,
    this.status,
    this.currentPeriodEnd,
    this.cancelAtPeriodEnd,
    this.pendingPlan,
    this.pendingEffectiveAt,
    this.usage,
    this.billingProvider,
    this.razorpaySubscriptionId,
    this.productId,
  });

  factory UserSubscriptionMeData.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionMeData(
      plan: json['plan'] is Map<String, dynamic>
          ? UserSubscriptionPlanInfo.fromJson(json['plan'] as Map<String, dynamic>)
          : null,
      status: json['status']?.toString(),
      currentPeriodEnd:
          json['current_period_end']?.toString() ?? json['currentPeriodEnd']?.toString(),
      cancelAtPeriodEnd: json['cancel_at_period_end'] == true || json['cancelAtPeriodEnd'] == true,
      pendingPlan: json['pending_plan'] is Map<String, dynamic>
          ? UserSubscriptionPlanInfo.fromJson(json['pending_plan'] as Map<String, dynamic>)
          : json['pendingPlan'] is Map<String, dynamic>
          ? UserSubscriptionPlanInfo.fromJson(json['pendingPlan'] as Map<String, dynamic>)
          : null,
      pendingEffectiveAt:
          json['pending_effective_at']?.toString() ?? json['pendingEffectiveAt']?.toString(),
      usage: json['usage'] is Map<String, dynamic>
          ? UserSubscriptionUsage.fromJson(json['usage'] as Map<String, dynamic>)
          : null,
      billingProvider: _normalizeBillingProvider(
        json['billing_provider'] ??
            json['billingProvider'] ??
            json['provider'] ??
            json['payment_provider'],
      ),
      razorpaySubscriptionId:
          json['razorpay_subscription_id']?.toString() ??
          json['razorpaySubscriptionId']?.toString() ??
          json['subscription_id']?.toString(),
      productId:
          json['product_id']?.toString() ??
          json['productId']?.toString() ??
          json['play_product_id']?.toString(),
    );
  }

  static String? _normalizeBillingProvider(dynamic value) {
    final raw = value?.toString().trim().toLowerCase();
    if (raw == null || raw.isEmpty) return null;
    if (raw.contains('play') || raw == 'google' || raw == 'iap' || raw == 'store') {
      return 'google_play';
    }
    if (raw.contains('razor') || raw == 'alternate' || raw == 'external') {
      return 'razorpay';
    }
    return raw;
  }
}

class UserSubscriptionPlanInfo {
  final String? code;
  final String? tier;
  final String? billingCycle;
  final UserSubscriptionFeatures? features;

  UserSubscriptionPlanInfo({this.code, this.tier, this.billingCycle, this.features});

  factory UserSubscriptionPlanInfo.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionPlanInfo(
      code: json['code']?.toString(),
      tier: json['tier']?.toString(),
      billingCycle: json['billing_cycle']?.toString() ?? json['billingCycle']?.toString(),
      features: json['features'] is Map<String, dynamic>
          ? UserSubscriptionFeatures.fromJson(json['features'] as Map<String, dynamic>)
          : null,
    );
  }

  String get displayName {
    final value = (tier ?? code?.split('_').first ?? '').trim();
    if (value.isEmpty) return 'Plan';
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  String get billingLabel {
    final cycle = (billingCycle ?? '').trim().toLowerCase();
    if (cycle == 'yearly' || cycle == 'annual' || cycle == 'annually') {
      return 'Yearly';
    }
    if (cycle == 'monthly' || cycle == 'month' || cycle == 'mo') {
      return 'Monthly';
    }
    return cycle.isEmpty ? '' : cycle[0].toUpperCase() + cycle.substring(1);
  }
}

class UserSubscriptionFeatures {
  final bool? adFree;
  final bool? hdRenders;
  final bool? pdfExport;
  final int? savedPlants;
  final int? landscapeGens;
  final bool? premiumThemes;
  final int? diagnosisScans;
  final bool? prioritySupport;
  final bool? aiCareAssistant;
  final bool? priorityGeneration;
  final bool? beforeAfterDownload;

  UserSubscriptionFeatures({
    this.adFree,
    this.hdRenders,
    this.pdfExport,
    this.savedPlants,
    this.landscapeGens,
    this.premiumThemes,
    this.diagnosisScans,
    this.prioritySupport,
    this.aiCareAssistant,
    this.priorityGeneration,
    this.beforeAfterDownload,
  });

  factory UserSubscriptionFeatures.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionFeatures(
      adFree: json['ad_free'] == true,
      hdRenders: json['hd_renders'] == true,
      pdfExport: json['pdf_export'] == true,
      savedPlants: _asInt(json['saved_plants']),
      landscapeGens: _asInt(json['landscape_gens']),
      premiumThemes: json['premium_themes'] == true,
      diagnosisScans: _asInt(json['diagnosis_scans']),
      prioritySupport: json['priority_support'] == true,
      aiCareAssistant: json['ai_care_assistant'] == true,
      priorityGeneration: json['priority_generation'] == true,
      beforeAfterDownload: json['before_after_download'] == true,
    );
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}

class UserSubscriptionUsage {
  final int? diagnosisScansUsed;
  final int? landscapeGensUsed;

  UserSubscriptionUsage({this.diagnosisScansUsed, this.landscapeGensUsed});

  factory UserSubscriptionUsage.fromJson(Map<String, dynamic> json) {
    return UserSubscriptionUsage(
      diagnosisScansUsed: _asInt(json['diagnosis_scans_used'] ?? json['diagnosisScansUsed']),
      landscapeGensUsed: _asInt(json['landscape_gens_used'] ?? json['landscapeGensUsed']),
    );
  }

  static int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
