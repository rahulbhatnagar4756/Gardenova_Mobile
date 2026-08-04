class SoilAnalysisModel {
  String? _type;
  Geometry? _geometry;
  Properties? _properties;
  double? _queryTimeS;

  SoilAnalysisModel({
    String? type,
    Geometry? geometry,
    Properties? properties,
    double? queryTimeS,
  }) {
    if (type != null) {
      this._type = type;
    }
    if (geometry != null) {
      this._geometry = geometry;
    }
    if (properties != null) {
      this._properties = properties;
    }
    if (queryTimeS != null) {
      this._queryTimeS = queryTimeS;
    }
  }

  String? get type => _type;

  set type(String? type) => _type = type;

  Geometry? get geometry => _geometry;

  set geometry(Geometry? geometry) => _geometry = geometry;

  Properties? get properties => _properties;

  set properties(Properties? properties) => _properties = properties;

  double? get queryTimeS => _queryTimeS;

  set queryTimeS(double? queryTimeS) => _queryTimeS = queryTimeS;

  SoilAnalysisModel.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    _properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
    _queryTimeS = json['query_time_s'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    if (this._geometry != null) {
      data['geometry'] = this._geometry!.toJson();
    }
    if (this._properties != null) {
      data['properties'] = this._properties!.toJson();
    }
    data['query_time_s'] = this._queryTimeS;
    return data;
  }
}

class Geometry {
  String? _type;
  List<double>? _coordinates;

  Geometry({String? type, List<double>? coordinates}) {
    if (type != null) {
      this._type = type;
    }
    if (coordinates != null) {
      this._coordinates = coordinates;
    }
  }

  String? get type => _type;

  set type(String? type) => _type = type;

  List<double>? get coordinates => _coordinates;

  set coordinates(List<double>? coordinates) => _coordinates = coordinates;

  Geometry.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    if (json['coordinates'] != null) {
      _coordinates = (json['coordinates'] as List).map((e) => (e as num).toDouble()).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['coordinates'] = this._coordinates;
    return data;
  }
}

class Properties {
  List<Layers>? _layers;

  Properties({List<Layers>? layers}) {
    if (layers != null) {
      this._layers = layers;
    }
  }

  List<Layers>? get layers => _layers;

  set layers(List<Layers>? layers) => _layers = layers;

  Properties.fromJson(Map<String, dynamic> json) {
    if (json['layers'] != null) {
      _layers = <Layers>[];
      json['layers'].forEach((v) {
        _layers!.add(new Layers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._layers != null) {
      data['layers'] = this._layers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Layers {
  String? _name;
  UnitMeasure? _unitMeasure;
  List<Depths>? _depths;

  Layers({String? name, UnitMeasure? unitMeasure, List<Depths>? depths}) {
    if (name != null) {
      this._name = name;
    }
    if (unitMeasure != null) {
      this._unitMeasure = unitMeasure;
    }
    if (depths != null) {
      this._depths = depths;
    }
  }

  String? get name => _name;

  set name(String? name) => _name = name;

  UnitMeasure? get unitMeasure => _unitMeasure;

  set unitMeasure(UnitMeasure? unitMeasure) => _unitMeasure = unitMeasure;

  List<Depths>? get depths => _depths;

  set depths(List<Depths>? depths) => _depths = depths;

  Layers.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _unitMeasure = json['unit_measure'] != null
        ? new UnitMeasure.fromJson(json['unit_measure'])
        : null;
    if (json['depths'] != null) {
      _depths = <Depths>[];
      json['depths'].forEach((v) {
        _depths!.add(new Depths.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    if (this._unitMeasure != null) {
      data['unit_measure'] = this._unitMeasure!.toJson();
    }
    if (this._depths != null) {
      data['depths'] = this._depths!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UnitMeasure {
  int? _dFactor;
  String? _mappedUnits;
  String? _targetUnits;
  String? _uncertaintyUnit;

  UnitMeasure({
    int? dFactor,
    String? mappedUnits,
    String? targetUnits,
    String? uncertaintyUnit,
  }) {
    if (dFactor != null) {
      this._dFactor = dFactor;
    }
    if (mappedUnits != null) {
      this._mappedUnits = mappedUnits;
    }
    if (targetUnits != null) {
      this._targetUnits = targetUnits;
    }
    if (uncertaintyUnit != null) {
      this._uncertaintyUnit = uncertaintyUnit;
    }
  }

  int? get dFactor => _dFactor;

  set dFactor(int? dFactor) => _dFactor = dFactor;

  String? get mappedUnits => _mappedUnits;

  set mappedUnits(String? mappedUnits) => _mappedUnits = mappedUnits;

  String? get targetUnits => _targetUnits;

  set targetUnits(String? targetUnits) => _targetUnits = targetUnits;

  String? get uncertaintyUnit => _uncertaintyUnit;

  set uncertaintyUnit(String? uncertaintyUnit) =>
      _uncertaintyUnit = uncertaintyUnit;

  UnitMeasure.fromJson(Map<String, dynamic> json) {
    _dFactor = json['d_factor'];
    _mappedUnits = json['mapped_units'];
    _targetUnits = json['target_units'];
    _uncertaintyUnit = json['uncertainty_unit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['d_factor'] = this._dFactor;
    data['mapped_units'] = this._mappedUnits;
    data['target_units'] = this._targetUnits;
    data['uncertainty_unit'] = this._uncertaintyUnit;
    return data;
  }
}

class Depths {
  Range? _range;
  String? _label;
  Values? _values;

  Depths({Range? range, String? label, Values? values}) {
    if (range != null) {
      this._range = range;
    }
    if (label != null) {
      this._label = label;
    }
    if (values != null) {
      this._values = values;
    }
  }

  Range? get range => _range;

  set range(Range? range) => _range = range;

  String? get label => _label;

  set label(String? label) => _label = label;

  Values? get values => _values;

  set values(Values? values) => _values = values;

  Depths.fromJson(Map<String, dynamic> json) {
    _range = json['range'] != null ? new Range.fromJson(json['range']) : null;
    _label = json['label'];
    _values = json['values'] != null
        ? new Values.fromJson(json['values'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._range != null) {
      data['range'] = this._range!.toJson();
    }
    data['label'] = this._label;
    if (this._values != null) {
      data['values'] = this._values!.toJson();
    }
    return data;
  }
}

class Range {
  int? _topDepth;
  int? _bottomDepth;
  String? _unitDepth;

  Range({int? topDepth, int? bottomDepth, String? unitDepth}) {
    if (topDepth != null) {
      this._topDepth = topDepth;
    }
    if (bottomDepth != null) {
      this._bottomDepth = bottomDepth;
    }
    if (unitDepth != null) {
      this._unitDepth = unitDepth;
    }
  }

  int? get topDepth => _topDepth;

  set topDepth(int? topDepth) => _topDepth = topDepth;

  int? get bottomDepth => _bottomDepth;

  set bottomDepth(int? bottomDepth) => _bottomDepth = bottomDepth;

  String? get unitDepth => _unitDepth;

  set unitDepth(String? unitDepth) => _unitDepth = unitDepth;

  Range.fromJson(Map<String, dynamic> json) {
    _topDepth = json['top_depth'];
    _bottomDepth = json['bottom_depth'];
    _unitDepth = json['unit_depth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['top_depth'] = this._topDepth;
    data['bottom_depth'] = this._bottomDepth;
    data['unit_depth'] = this._unitDepth;
    return data;
  }
}

class Values {
  num? _q005;
  num? _q05;
  num? _q095;
  num? _mean;
  num? _uncertainty;

  Values({num? q005, num? q05, num? q095, num? mean, num? uncertainty}) {
    if (q005 != null) {
      this._q005 = q005;
    }
    if (q05 != null) {
      this._q05 = q05;
    }
    if (q095 != null) {
      this._q095 = q095;
    }
    if (mean != null) {
      this._mean = mean;
    }
    if (uncertainty != null) {
      this._uncertainty = uncertainty;
    }
  }

  num? get q005 => _q005;

  set q005(num? q005) => _q005 = q005;

  num? get q05 => _q05;

  set q05(num? q05) => _q05 = q05;

  num? get q095 => _q095;

  set q095(num? q095) => _q095 = q095;

  num? get mean => _mean;

  set mean(num? mean) => _mean = mean;

  num? get uncertainty => _uncertainty;

  set uncertainty(num? uncertainty) => _uncertainty = uncertainty;

  Values.fromJson(Map<String, dynamic> json) {
    _q005 = json['Q0.05'];
    _q05 = json['Q0.5'];
    _q095 = json['Q0.95'];
    _mean = json['mean'];
    _uncertainty = json['uncertainty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Q0.05'] = this._q005;
    data['Q0.5'] = this._q05;
    data['Q0.95'] = this._q095;
    data['mean'] = this._mean;
    data['uncertainty'] = this._uncertainty;
    return data;
  }
}
