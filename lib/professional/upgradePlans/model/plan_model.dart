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
  set beforeAfterDownload(bool? beforeAfterDownload) =>
      _beforeAfterDownload = beforeAfterDownload;
  bool? get basicReminders => _basicReminders;
  set basicReminders(bool? basicReminders) => _basicReminders = basicReminders;

  set setSelect(bool? value) {
    isSelect = value;
  }

  PlanModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _tier = json['tier'];
    _billingPeriod = json['billing_period'];
    _productId = json['product_id'];
    _price = json['price'];
    _currency = json['currency'];
    _diagnosisScans = json['diagnosis_scans'];
    _landscapeGen = json['landscape_gen'];
    _maxPlants = json['max_plants'];
    _aiAssistant = json['ai_assistant'];
    _hdRenders = json['hd_renders'];
    _pdfExport = json['pdf_export'];
    _premiumStyles = json['premium_styles'];
    _beforeAfterDownload = json['before_after_download'];
    _basicReminders = json['basic_reminders'];

    if (json['features'] != null) {
      features = <PlanFeature>[];
      json['features'].forEach((v) {
        features!.add(PlanFeature.fromJson(v));
      });
      json['features'].forEach((f) {
        final key = f['key'];
        final label = f['label'];
        final enabled = f['enabled'] == true;

        switch (key) {
          case 'diagnosis_scans':
            final match = RegExp(r'\d+').firstMatch(label ?? '');
            if (match != null) {
              _diagnosisScans = int.tryParse(match.group(0)!);
            }
            break;
          case 'landscape_gen':
            final match = RegExp(r'\d+').firstMatch(label ?? '');
            if (match != null) {
              _landscapeGen = int.tryParse(match.group(0)!);
            }
            break;
          case 'max_plants':
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
            _aiAssistant = enabled;
            break;
          case 'hd_renders':
            _hdRenders = enabled;
            break;
          case 'pdf_export':
            _pdfExport = enabled;
            break;
          case 'premium_styles':
            _premiumStyles = enabled;
            break;
          case 'before_after_download':
            _beforeAfterDownload = enabled;
            break;
          case 'basic_reminders':
            _basicReminders = enabled;
            break;
        }
      });
    }

    isSelect = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['tier'] = this._tier;
    data['billing_period'] = this._billingPeriod;
    data['product_id'] = this._productId;
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
