import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_response_model.dart';
import 'package:kasagardem/plants/plant_analysis/model/plant_scan_detail_model.dart';

class PlantScanCompareResponse {
  final bool success;
  final String? message;
  final List<PlantScanCompareItem> plants;

  const PlantScanCompareResponse({
    this.success = false,
    this.message,
    this.plants = const [],
  });

  factory PlantScanCompareResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final plantsJson = data is Map<String, dynamic> ? data['plants'] : null;
    return PlantScanCompareResponse(
      success: json['success'] == true,
      message: json['message'] as String?,
      plants: plantsJson is List
          ? plantsJson
                .whereType<Map<String, dynamic>>()
                .map(PlantScanCompareItem.fromJson)
                .toList()
          : const [],
    );
  }
}

class PlantScanCompareItem {
  final String scanId;
  final String imageUrl;
  final String plantName;
  final String kingdom;
  final String family;
  final String predictedDisease;
  final double confidenceScore;
  final List<String> commonNames;
  final double confidence;
  final HealthStatus? healthStatus;

  const PlantScanCompareItem({
    this.scanId = '',
    this.imageUrl = '',
    this.plantName = '',
    this.kingdom = '',
    this.family = '',
    this.predictedDisease = '',
    this.confidenceScore = 0,
    this.commonNames = const [],
    this.confidence = 0,
    this.healthStatus,
  });

  factory PlantScanCompareItem.fromJson(Map<String, dynamic> json) {
    final names = json['commonNames'];
    return PlantScanCompareItem(
      scanId: json['scanId']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      plantName: json['plantName']?.toString() ?? '',
      kingdom: json['kingdom']?.toString() ?? '',
      family: json['family']?.toString() ?? '',
      predictedDisease: json['predictedDisease']?.toString() ?? '',
      confidenceScore: _asDouble(json['confidenceScore']),
      commonNames: names is List
          ? names.map((name) => name.toString()).toList()
          : const [],
      confidence: _asDouble(json['confidence']),
      healthStatus: json['healthStatus'] is Map<String, dynamic>
          ? HealthStatus.fromJson(json['healthStatus'])
          : null,
    );
  }

  factory PlantScanCompareItem.fromDetail(PlantScanDetail detail) {
    return PlantScanCompareItem(
      scanId: detail.id,
      imageUrl: detail.imageUrl,
      plantName: detail.plantName,
      kingdom: detail.kingdom,
      family: detail.family,
      predictedDisease: detail.predictedDisease,
      confidenceScore: detail.confidenceScore,
      commonNames: detail.diagnosis?.plantInfo?.commonNames ?? const [],
      confidence: (detail.diagnosis?.confidence ?? detail.confidenceScore)
          .toDouble(),
      healthStatus: detail.diagnosis?.healthStatus,
    );
  }

  bool get hasImage => imageUrl.trim().isNotEmpty;

  List<Issues> get issues => healthStatus?.issues ?? const [];

  Issues? get primaryIssue => issues.isNotEmpty ? issues.first : null;

  bool get isHealthy {
    if (healthStatus?.isHealthy == true) return true;
    if (healthStatus?.isHealthy == false) return false;
    return issues.isEmpty && predictedDisease.trim().isEmpty;
  }

  String get displayName {
    if (plantName.trim().isNotEmpty) return plantName;
    if (commonNames.isNotEmpty) return commonNames.first;
    return '';
  }

  String get displayDisease {
    if (predictedDisease.trim().isNotEmpty) return predictedDisease;
    return primaryIssue?.name ?? '';
  }
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
