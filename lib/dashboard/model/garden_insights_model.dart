class GardenInsightsResponseModel {
  bool? success;
  String? message;
  GardenInsightsData? data;

  GardenInsightsResponseModel({this.success, this.message, this.data});

  GardenInsightsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message']?.toString();
    if (json['data'] is Map) {
      data = GardenInsightsData.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class GardenInsightsData {
  int? plantCount;
  bool? hasPlants;
  double? totalPercent;
  List<GardenInsightChartItem>? chart;

  GardenInsightsData({
    this.plantCount,
    this.hasPlants,
    this.totalPercent,
    this.chart,
  });

  GardenInsightsData.fromJson(Map<String, dynamic> json) {
    plantCount = int.tryParse(json['plantCount']?.toString() ?? '');
    hasPlants = json['hasPlants'];
    totalPercent = double.tryParse(json['totalPercent']?.toString() ?? '');
    if (json['chart'] is List) {
      chart = <GardenInsightChartItem>[];
      for (final item in json['chart']) {
        if (item is Map) {
          chart!.add(
            GardenInsightChartItem.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'plantCount': plantCount,
      'hasPlants': hasPlants,
      'totalPercent': totalPercent,
      if (chart != null) 'chart': chart!.map((item) => item.toJson()).toList(),
    };
  }
}

class GardenInsightChartItem {
  String? key;
  String? label;
  double? percent;
  double? piePercent;

  GardenInsightChartItem({this.key, this.label, this.percent, this.piePercent});

  GardenInsightChartItem.fromJson(Map<String, dynamic> json) {
    key = json['key']?.toString();
    label = json['label']?.toString();
    percent = double.tryParse(json['percent']?.toString() ?? '');
    piePercent = double.tryParse(json['piePercent']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'label': label,
      'percent': percent,
      'piePercent': piePercent,
    };
  }
}
