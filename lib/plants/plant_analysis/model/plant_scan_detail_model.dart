import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_response_model.dart';

class PlantScanDetailResponse {
  final bool success;
  final String? message;
  final PlantScanDetail? data;

  const PlantScanDetailResponse({
    this.success = false,
    this.message,
    this.data,
  });

  factory PlantScanDetailResponse.fromJson(Map<String, dynamic> json) {
    return PlantScanDetailResponse(
      success: json['success'] == true,
      message: json['message'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? PlantScanDetail.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PlantScanDetail {
  final String id;
  final String imageUrl;
  final String plantName;
  final String kingdom;
  final String family;
  final String predictedDisease;
  final double confidenceScore;
  final bool isPlant;
  final bool isHealthy;
  final String createdAt;
  final Data? diagnosis;

  const PlantScanDetail({
    this.id = '',
    this.imageUrl = '',
    this.plantName = '',
    this.kingdom = '',
    this.family = '',
    this.predictedDisease = '',
    this.confidenceScore = 0,
    this.isPlant = true,
    this.isHealthy = false,
    this.createdAt = '',
    this.diagnosis,
  });

  factory PlantScanDetail.fromJson(Map<String, dynamic> json) {
    return PlantScanDetail(
      id: json['id']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      plantName: json['plantName']?.toString() ?? '',
      kingdom: json['kingdom']?.toString() ?? '',
      family: json['family']?.toString() ?? '',
      predictedDisease: json['predictedDisease']?.toString() ?? '',
      confidenceScore: _asDouble(json['confidenceScore']),
      isPlant: json['isPlant'] == true,
      isHealthy: json['isHealthy'] == true,
      createdAt: json['createdAt']?.toString() ?? '',
      diagnosis: json['diagnosis'] is Map<String, dynamic>
          ? Data.fromJson(json['diagnosis'])
          : null,
    );
  }

  bool get hasImage => imageUrl.trim().isNotEmpty;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
