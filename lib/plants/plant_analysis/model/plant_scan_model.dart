class PlantScansResponseModel {
  final bool success;
  final String? message;
  final PlantScansData? data;

  const PlantScansResponseModel({
    this.success = false,
    this.message,
    this.data,
  });

  factory PlantScansResponseModel.fromJson(Map<String, dynamic> json) {
    return PlantScansResponseModel(
      success: json['success'] == true,
      message: json['message'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? PlantScansData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PlantScansData {
  final List<PlantScan> scans;
  final PlantScanPagination? pagination;

  const PlantScansData({this.scans = const [], this.pagination});

  factory PlantScansData.fromJson(Map<String, dynamic> json) {
    final scansJson = json['scans'];
    return PlantScansData(
      scans: scansJson is List
          ? scansJson
                .whereType<Map<String, dynamic>>()
                .map(PlantScan.fromJson)
                .toList()
          : const [],
      pagination: json['pagination'] is Map<String, dynamic>
          ? PlantScanPagination.fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class PlantScanPagination {
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int limit;

  const PlantScanPagination({
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalCount = 0,
    this.limit = 10,
  });

  factory PlantScanPagination.fromJson(Map<String, dynamic> json) {
    return PlantScanPagination(
      currentPage: _asInt(json['currentPage'], fallback: 1),
      totalPages: _asInt(json['totalPages'], fallback: 1),
      totalCount: _asInt(json['totalCount']),
      limit: _asInt(json['limit'], fallback: 10),
    );
  }

  bool get hasMore => currentPage < totalPages;
}

class PlantScan {
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

  const PlantScan({
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
  });

  factory PlantScan.fromJson(Map<String, dynamic> json) {
    return PlantScan(
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
    );
  }

  bool get hasImage => imageUrl.trim().isNotEmpty;
}

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? fallback;
}

double _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '') ?? 0;
}
