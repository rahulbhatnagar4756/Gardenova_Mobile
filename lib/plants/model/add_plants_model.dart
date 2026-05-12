class AddPlantsModel {
  bool? _success;
  String? _message;
  Data? _data;

  AddPlantsModel({bool? success, String? message, Data? data}) {
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
  Data? get data => _data;
  set data(Data? data) => _data = data;

  AddPlantsModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data!.toJson();
    }
    return data;
  }
}

class Data {
  int? _currentPage;
  int? _totalPages;
  int? _totalCount;
  int? _limit;
  List<Plants>? _plants;
  

  Data(
      {int? currentPage,
      int? totalPages,
      int? totalCount,
      int? limit,
      List<Plants>? plants}) {
    if (currentPage != null) {
      this._currentPage = currentPage;
    }
    if (totalPages != null) {
      this._totalPages = totalPages;
    }
    if (totalCount != null) {
      this._totalCount = totalCount;
    }
    if (limit != null) {
      this._limit = limit;
    }
    if (plants != null) {
      this._plants = plants;
    }
  }

  int? get currentPage => _currentPage;
  set currentPage(int? currentPage) => _currentPage = currentPage;
  int? get totalPages => _totalPages;
  set totalPages(int? totalPages) => _totalPages = totalPages;
  int? get totalCount => _totalCount;
  set totalCount(int? totalCount) => _totalCount = totalCount;
  int? get limit => _limit;
  set limit(int? limit) => _limit = limit;
  List<Plants>? get plants => _plants;
  set plants(List<Plants>? plants) => _plants = plants;

  Data.fromJson(Map<String, dynamic> json) {
    _currentPage = json['currentPage'];
    _totalPages = json['totalPages'];
    _totalCount = json['totalCount'];
    _limit = json['limit'];
    if (json['plants'] != null) {
      _plants = <Plants>[];
      json['plants'].forEach((v) {
        _plants!.add(new Plants.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentPage'] = this._currentPage;
    data['totalPages'] = this._totalPages;
    data['totalCount'] = this._totalCount;
    data['limit'] = this._limit;
    if (this._plants != null) {
      data['plants'] = this._plants!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plants {
  int? _id;
  String? _commonName;
  String? _scientificName;
  String? _imageOriginalUrl;
  String? _family;
  String? _type;
  String? _cycle;
  String? _watering;
  bool? _indoor;
  bool? _medicinal;
  bool? _edibleFruit;
  int? _relevance;

  Plants(
      {int? id,
      String? commonName,
      String? scientificName,
      String? imageOriginalUrl,
      String? family,
      String? type,
      String? cycle,
      String? watering,
      bool? indoor,
      bool? medicinal,
      bool? edibleFruit,
      int? relevance}) {
    if (id != null) {
      this._id = id;
    }
    if (commonName != null) {
      this._commonName = commonName;
    }
    if (scientificName != null) {
      this._scientificName = scientificName;
    }
    if (imageOriginalUrl != null) {
      this._imageOriginalUrl = imageOriginalUrl;
    }
    if (family != null) {
      this._family = family;
    }
    if (type != null) {
      this._type = type;
    }
    if (cycle != null) {
      this._cycle = cycle;
    }
    if (watering != null) {
      this._watering = watering;
    }
    if (indoor != null) {
      this._indoor = indoor;
    }
    if (medicinal != null) {
      this._medicinal = medicinal;
    }
    if (edibleFruit != null) {
      this._edibleFruit = edibleFruit;
    }
    if (relevance != null) {
      this._relevance = relevance;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get commonName => _commonName;
  set commonName(String? commonName) => _commonName = commonName;
  String? get scientificName => _scientificName;
  set scientificName(String? scientificName) =>
      _scientificName = scientificName;
  String? get imageOriginalUrl => _imageOriginalUrl;
  set imageOriginalUrl(String? imageOriginalUrl) =>
      _imageOriginalUrl = imageOriginalUrl;
  String? get family => _family;
  set family(String? family) => _family = family;
  String? get type => _type;
  set type(String? type) => _type = type;
  String? get cycle => _cycle;
  set cycle(String? cycle) => _cycle = cycle;
  String? get watering => _watering;
  set watering(String? watering) => _watering = watering;
  bool? get indoor => _indoor;
  set indoor(bool? indoor) => _indoor = indoor;
  bool? get medicinal => _medicinal;
  set medicinal(bool? medicinal) => _medicinal = medicinal;
  bool? get edibleFruit => _edibleFruit;
  set edibleFruit(bool? edibleFruit) => _edibleFruit = edibleFruit;
  int? get relevance => _relevance;
  set relevance(int? relevance) => _relevance = relevance;

  Plants.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _commonName = json['common_name'];
    _scientificName = json['scientific_name'];
    _imageOriginalUrl = json['image_original_url'];
    _family = json['family'];
    _type = json['type'];
    _cycle = json['cycle'];
    _watering = json['watering'];
    _indoor = json['indoor'];
    _medicinal = json['medicinal'];
    _edibleFruit = json['edible_fruit'];
    _relevance = json['relevance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['common_name'] = this._commonName;
    data['scientific_name'] = this._scientificName;
    data['image_original_url'] = this._imageOriginalUrl;
    data['family'] = this._family;
    data['type'] = this._type;
    data['cycle'] = this._cycle;
    data['watering'] = this._watering;
    data['indoor'] = this._indoor;
    data['medicinal'] = this._medicinal;
    data['edible_fruit'] = this._edibleFruit;
    data['relevance'] = this._relevance;
    return data;
  }
}
