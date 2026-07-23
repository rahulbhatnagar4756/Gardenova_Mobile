class PlansResponseModel {
  bool? _success;
  String? _message;
  List<PlanModel>? _data;

  PlansResponseModel({bool? success, String? message, List<PlanModel>? data}) {
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
  List<PlanModel>? get data => _data;
  set data(List<PlanModel>? data) => _data = data;

  PlansResponseModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = <PlanModel>[];
      json['data'].forEach((v) {
        _data!.add(new PlanModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanModel {
  String? _id;
  String? _name;
  String? _tier;
  String? _billingPeriod;
  String? _productId;
  String? _price;
  String? _currency;
  int? _diagnosisScans;
  int? _landscapeGen;
  int? _maxPlants;
  bool? _aiAssistant;
  bool? _hdRenders;
  bool? _pdfExport;
  bool? _premiumStyles;
  bool? _beforeAfterDownload;
  bool? _basicReminders;
  bool? _priorityCustomerSupport;

  // UI / legacy fields
  bool? isSelect = false;
  String? priceMonthly;
  String? priceAnnual;
  int? citiesCoverage;
  bool? appearInSearch;
  int? leadsLimit;
  bool? premiumProfileBadge;
  bool? priorityCustomerSupport;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? description;

  // Consolidation helpers
  String? monthlyProductId;
  String? yearlyProductId;
  String? monthlyId;
  String? yearlyId;
  String? monthlyRazorpayPlanId;
  String? yearlyRazorpayPlanId;
  String? code;
  String? razorpayPlanId;
  List<PlanFeature>? features;

  PlanModel({
    String? id,
    String? planName,
    this.description,
    String? name,
    String? tier,
    String? billingPeriod,
    String? productId,
    String? price,
    String? currency,
    int? diagnosisScans,
    int? landscapeGen,
    int? maxPlants,
    bool? aiAssistant,
    bool? hdRenders,
    bool? pdfExport,
    bool? premiumStyles,
    bool? beforeAfterDownload,
    bool? basicReminders,
    this.isSelect = false,
    this.priceMonthly,
    this.priceAnnual,
    this.citiesCoverage,
    this.appearInSearch,
    this.leadsLimit,
    this.premiumProfileBadge,
    this.priorityCustomerSupport,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.monthlyProductId,
    this.yearlyProductId,
    this.monthlyId,
    this.yearlyId,
    this.monthlyRazorpayPlanId,
    this.yearlyRazorpayPlanId,
    this.code,
    this.razorpayPlanId,
    this.features,
  }) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    } else if (planName != null) {
      this._name = planName;
    }
    if (tier != null) {
      this._tier = tier;
    }
    if (billingPeriod != null) {
      this._billingPeriod = billingPeriod;
    }
    if (productId != null) {
      this._productId = productId;
    }
    if (price != null) {
      this._price = price;
    }
    if (currency != null) {
      this._currency = currency;
    }
    if (diagnosisScans != null) {
      this._diagnosisScans = diagnosisScans;
    }
    if (landscapeGen != null) {
      this._landscapeGen = landscapeGen;
    }
    if (maxPlants != null) {
      this._maxPlants = maxPlants;
    }
    if (aiAssistant != null) {
      this._aiAssistant = aiAssistant;
    }
    if (hdRenders != null) {
      this._hdRenders = hdRenders;
    }
    if (pdfExport != null) {
      this._pdfExport = pdfExport;
    }
    if (premiumStyles != null) {
      this._premiumStyles = premiumStyles;
    }
    if (beforeAfterDownload != null) {
      this._beforeAfterDownload = beforeAfterDownload;
    }
    if (basicReminders != null) {
      this._basicReminders = basicReminders;
    }
  }

  String? get id => _id;
  set id(String? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get planName => _name;
  set planName(String? planName) => _name = planName;
  String? get tier => _tier;
  set tier(String? tier) => _tier = tier;
  String? get billingPeriod => _billingPeriod;
  set billingPeriod(String? billingPeriod) => _billingPeriod = billingPeriod;
  String? get productId => _productId;
  set productId(String? productId) => _productId = productId;
  String? get price => _price;
  set price(String? price) => _price = price;
  String? get currency => _currency;
  set currency(String? currency) => _currency = currency;
  int? get diagnosisScans => _diagnosisScans;
  set diagnosisScans(int? diagnosisScans) => _diagnosisScans = diagnosisScans;
  int? get landscapeGen => _landscapeGen;
  set landscapeGen(int? landscapeGen) => _landscapeGen = landscapeGen;
  int? get maxPlants => _maxPlants;
  set maxPlants(int? maxPlants) => _maxPlants = maxPlants;
  bool? get aiAssistant => _aiAssistant;
  set aiAssistant(bool? aiAssistant) => _aiAssistant = aiAssistant;
  bool? get hdRenders => _hdRenders;
  set hdRenders(bool? hdRenders) => _hdRenders = hdRenders;
  bool? get pdfExport => _pdfExport;
  set pdfExport(bool? pdfExport) => _pdfExport = pdfExport;
  bool? get premiumStyles => _premiumStyles;
  set premiumStyles(bool? premiumStyles) => _premiumStyles = premiumStyles;
  bool? get beforeAfterDownload => _beforeAfterDownload;
  set beforeAfterDownload(bool? beforeAfterDownload) => _beforeAfterDownload = beforeAfterDownload;
  bool? get basicReminders => _basicReminders;
  set basicReminders(bool? basicReminders) => _basicReminders = basicReminders;

  set setSelect(bool? value) {
    isSelect = value;
  }

  PlanModel.fromJson(Map<String, dynamic> json) {
    _id = json['id']?.toString();
    code = json['code']?.toString();
    _name =
        json['name']?.toString() ??
        _displayNameFromCode(code) ??
        _displayNameFromTier(json['tier']);
    _tier = json['tier']?.toString();
    _billingPeriod = _normalizeBillingPeriod(json['billing_cycle'] ?? json['billing_period']);
    _productId = json['product_id']?.toString();
    razorpayPlanId = json['razorpay_plan_id']?.toString();
    _price = _parsePrice(json);
    _currency = json['currency']?.toString() ?? 'INR';

    if (json['features'] != null) {
      features = <PlanFeature>[];
      for (final feature in json['features']) {
        features!.add(PlanFeature.fromJson(feature));
        _applyFeature(feature);
      }
    }

    isSelect = false;
  }

  static String? _displayNameFromCode(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value == 'free') return 'Free';
    final tier = value.split('_').first;
    if (tier.isEmpty) return null;
    return tier[0].toUpperCase() + tier.substring(1);
  }

  static String? _displayNameFromTier(dynamic tier) {
    final value = tier?.toString();
    if (value == null || value.isEmpty) return null;
    return value[0].toUpperCase() + value.substring(1);
  }

  static String? _normalizeBillingPeriod(dynamic value) {
    final period = value?.toString().toLowerCase();
    if (period == null || period.isEmpty) return null;
    if (period == 'annual') return 'yearly';
    return period;
  }

  static String? _parsePrice(Map<String, dynamic> json) {
    final priceInr = json['price_inr'];
    if (priceInr != null) return priceInr.toString();
    final price = json['price'];
    if (price != null) return price.toString();
    return null;
  }

  void _applyFeature(dynamic feature) {
    final key = feature['key']?.toString();
    final label = feature['label']?.toString();
    final enabled = feature['enabled'] == true;

    switch (key) {
      case 'diagnosis_scans':
        final match = RegExp(r'\d+').firstMatch(label ?? '');
        if (match != null) {
          _diagnosisScans = int.tryParse(match.group(0)!);
        }
        break;
      case 'landscape_gen':
      case 'landscape_gens':
        final match = RegExp(r'\d+').firstMatch(label ?? '');
        if (match != null) {
          _landscapeGen = int.tryParse(match.group(0)!);
        }
        break;
      case 'max_plants':
      case 'saved_plants':
        if (label != null && label.toLowerCase().contains('unlimited')) {
          _maxPlants = -1;
        } else {
          final match = RegExp(r'\d+').firstMatch(label ?? '');
          if (match != null) {
            _maxPlants = int.tryParse(match.group(0)!);
          }
        }
        break;
      case 'ai_assistant':
      case 'ai_care_assistant':
        _aiAssistant = enabled;
        break;
      case 'hd_renders':
        _hdRenders = enabled;
        break;
      case 'pdf_export':
        _pdfExport = enabled;
        break;
      case 'premium_styles':
      case 'premium_themes':
        _premiumStyles = enabled;
        break;
      case 'before_after_download':
        _beforeAfterDownload = enabled;
        break;
      case 'basic_reminders':
        _basicReminders = enabled;
        break;
      case 'priority_support':
        _priorityCustomerSupport = enabled;
        break;
      case 'priority_generation':
      case 'ad_free':
        break;
    }
  }

  static String _formatPrice(String? priceStr) {
    if (priceStr == null) return '0';
    final value = double.tryParse(priceStr);
    if (value == null) return priceStr;
    return value.toStringAsFixed(0);
  }

  /// Build paid plans from Google Play / App Store product IDs.
  ///
  /// Expected SKUs: `starter_monthly`, `starter_annual`, `plus_*`, `pro_*`.
  static List<PlanModel> fromStoreProducts({
    required Map<String, ({String price, double rawPrice})> storeProducts,
    bool includeProfessionalFields = false,
  }) {
    const tiers = ['starter', 'plus', 'pro'];
    final plans = <PlanModel>[];

    for (final tier in tiers) {
      final monthlyId = '${tier}_monthly';
      final annualId = '${tier}_annual';
      final yearlyAltId = '${tier}_yearly';

      final monthly = storeProducts[monthlyId];
      final annual = storeProducts[annualId] ?? storeProducts[yearlyAltId];

      // Only include tiers that exist as real store products.
      if (monthly == null && annual == null) continue;

      final priceMonthly = monthly != null
          ? _formatPrice(monthly.rawPrice.toString())
          : '0';
      final priceAnnual = annual != null
          ? _formatPrice(annual.rawPrice.toString())
          : '0';

      final resolvedAnnualId = annual == null
          ? null
          : (storeProducts.containsKey(annualId) ? annualId : yearlyAltId);

      final plan = PlanModel(
        id: monthly != null ? monthlyId : resolvedAnnualId,
        planName: _displayNameFromTier(tier),
        tier: tier,
        currency: 'INR',
        status: 'active',
        isSelect: false,
        code: monthly != null ? monthlyId : resolvedAnnualId,
        priceMonthly: priceMonthly,
        priceAnnual: priceAnnual,
        monthlyProductId: monthly != null ? monthlyId : null,
        yearlyProductId: resolvedAnnualId,
        monthlyId: monthly != null ? monthlyId : null,
        yearlyId: resolvedAnnualId,
        features: _defaultFeaturesForTier(tier),
      );

      _applyDefaultLimits(plan, tier);

      if (includeProfessionalFields) {
        plan.citiesCoverage = switch (tier) {
          'starter' => 25,
          'plus' => 100,
          _ => 500,
        };
        plan.appearInSearch = true;
        plan.leadsLimit = tier == 'starter' ? 15 : 0;
        plan.premiumProfileBadge = tier == 'plus' || tier == 'pro';
        plan.priorityCustomerSupport = tier == 'pro';
      }

      plans.add(plan);
    }

    return plans;
  }

  static void _applyDefaultLimits(PlanModel plan, String tier) {
    switch (tier) {
      case 'starter':
        plan.diagnosisScans = 10;
        plan.landscapeGen = 5;
        plan.maxPlants = 25;
        plan.aiAssistant = true;
        plan.basicReminders = true;
        break;
      case 'plus':
        plan.diagnosisScans = 30;
        plan.landscapeGen = 20;
        plan.maxPlants = 100;
        plan.aiAssistant = true;
        plan.hdRenders = true;
        plan.pdfExport = true;
        plan.basicReminders = true;
        break;
      case 'pro':
        plan.diagnosisScans = 100;
        plan.landscapeGen = 50;
        plan.maxPlants = 500;
        plan.aiAssistant = true;
        plan.hdRenders = true;
        plan.pdfExport = true;
        plan.premiumStyles = true;
        plan.beforeAfterDownload = true;
        plan.basicReminders = true;
        plan.priorityCustomerSupport = true;
        break;
    }
  }

  static List<PlanFeature> _defaultFeaturesForTier(String tier) {
    switch (tier) {
      case 'starter':
        return [
          PlanFeature(key: 'diagnosis_scans', label: '10 diagnosis scans', enabled: true),
          PlanFeature(key: 'landscape_gens', label: '5 landscape generations', enabled: true),
          PlanFeature(key: 'saved_plants', label: '25 saved plants', enabled: true),
          PlanFeature(key: 'ai_assistant', label: 'AI assistant', enabled: true),
          PlanFeature(key: 'basic_reminders', label: 'Basic reminders', enabled: true),
        ];
      case 'plus':
        return [
          PlanFeature(key: 'diagnosis_scans', label: '30 diagnosis scans', enabled: true),
          PlanFeature(key: 'landscape_gens', label: '20 landscape generations', enabled: true),
          PlanFeature(key: 'saved_plants', label: '100 saved plants', enabled: true),
          PlanFeature(key: 'ai_assistant', label: 'AI assistant', enabled: true),
          PlanFeature(key: 'hd_renders', label: 'HD renders', enabled: true),
          PlanFeature(key: 'pdf_export', label: 'PDF export', enabled: true),
        ];
      case 'pro':
        return [
          PlanFeature(key: 'diagnosis_scans', label: '100 diagnosis scans', enabled: true),
          PlanFeature(key: 'landscape_gens', label: '50 landscape generations', enabled: true),
          PlanFeature(key: 'saved_plants', label: '500 saved plants', enabled: true),
          PlanFeature(key: 'ai_assistant', label: 'AI assistant', enabled: true),
          PlanFeature(key: 'hd_renders', label: 'HD renders', enabled: true),
          PlanFeature(key: 'pdf_export', label: 'PDF export', enabled: true),
          PlanFeature(key: 'premium_styles', label: 'Premium styles', enabled: true),
          PlanFeature(key: 'priority_support', label: 'Priority support', enabled: true),
        ];
      default:
        return [];
    }
  }

  static List<PlanModel> consolidateByTier(
    List<PlanModel> apiPlans, {
    bool includeProfessionalFields = false,
  }) {
    const tiers = ['free', 'starter', 'plus', 'pro'];
    final consolidatedPlans = <PlanModel>[];

    for (final tier in tiers) {
      final tierPlans = apiPlans.where((plan) => plan.tier == tier).toList();
      if (tierPlans.isEmpty) continue;

      final monthlyPlan = tierPlans.firstWhere(
        (plan) => plan.billingPeriod == 'monthly' || plan.billingPeriod == null,
        orElse: () => tierPlans.first,
      );
      PlanModel? yearlyPlan;
      for (final plan in tierPlans) {
        if (plan.billingPeriod == 'yearly') {
          yearlyPlan = plan;
          break;
        }
      }

      final template = monthlyPlan;
      final priceMonthly = _formatPrice(monthlyPlan.price ?? '0');
      final priceAnnual = _formatPrice(yearlyPlan?.price ?? priceMonthly);

      final plan = PlanModel(
        id: template.id,
        planName: _displayNameFromTier(tier),
        tier: tier,
        currency: template.currency ?? 'INR',
        status: 'active',
        isSelect: false,
        code: template.code,
        diagnosisScans: template.diagnosisScans,
        landscapeGen: template.landscapeGen,
        maxPlants: template.maxPlants,
        aiAssistant: template.aiAssistant,
        hdRenders: template.hdRenders,
        pdfExport: template.pdfExport,
        premiumStyles: template.premiumStyles,
        beforeAfterDownload: template.beforeAfterDownload,
        basicReminders: template.basicReminders,
        priorityCustomerSupport: template.priorityCustomerSupport,
        priceMonthly: priceMonthly,
        priceAnnual: priceAnnual,
        monthlyProductId: monthlyPlan.productId,
        yearlyProductId: yearlyPlan?.productId,
        monthlyId: monthlyPlan.id,
        yearlyId: yearlyPlan?.id,
        monthlyRazorpayPlanId: monthlyPlan.razorpayPlanId,
        yearlyRazorpayPlanId: yearlyPlan?.razorpayPlanId,
        features: template.features,
      );

      if (includeProfessionalFields) {
        plan.citiesCoverage = switch (tier) {
          'free' => 5,
          'starter' => 25,
          'plus' => 100,
          _ => 500,
        };
        plan.appearInSearch = tier != 'free';
        plan.leadsLimit = tier == 'starter' ? 15 : 0;
        plan.premiumProfileBadge = tier == 'plus' || tier == 'pro';
        plan.priorityCustomerSupport = tier == 'pro';
      }

      consolidatedPlans.add(plan);
    }

    return consolidatedPlans;
  }

  String resolvePlanCode({required bool isMonthly}) {
    final tierValue = tier ?? '';
    if (tierValue == 'free') return 'free';
    return '${tierValue}_${isMonthly ? 'monthly' : 'yearly'}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['tier'] = this._tier;
    data['billing_period'] = this._billingPeriod;
    data['product_id'] = this._productId;
    data['razorpay_plan_id'] = this.razorpayPlanId;
    data['price'] = this._price;
    data['currency'] = this._currency;
    data['diagnosis_scans'] = this._diagnosisScans;
    data['landscape_gen'] = this._landscapeGen;
    data['max_plants'] = this._maxPlants;
    data['ai_assistant'] = this._aiAssistant;
    data['hd_renders'] = this._hdRenders;
    data['pdf_export'] = this._pdfExport;
    data['premium_styles'] = this._premiumStyles;
    data['before_after_download'] = this._beforeAfterDownload;
    data['basic_reminders'] = this._basicReminders;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanFeature {
  String? key;
  String? label;
  bool? enabled;

  PlanFeature({this.key, this.label, this.enabled});

  PlanFeature.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    label = json['label'];
    enabled = json['enabled'] == true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = this.key;
    data['label'] = this.label;
    data['enabled'] = this.enabled;
    return data;
  }
}
