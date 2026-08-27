import 'package:kasagardem/utils/network_services/api_repository.dart';

class PlantAnalysisRepository {
  static const String _plantScansEndPoint = 'api/v1/plant-scans';

  Future<dynamic> fetchPlantScans({required int page, int limit = 10}) {
    return ApiRepository.instance.get(
      '$_plantScansEndPoint?page=$page&limit=$limit',
      showDefaultLoader: false,
    );
  }

  Future<dynamic> fetchPlantScanDetail({required String id}) {
    return ApiRepository.instance.get(
      '$_plantScansEndPoint/$id',
      showDefaultLoader: false,
    );
  }

  Future<dynamic> comparePlantScan({
    required String id,
    required String imageBase64,
  }) {
    return ApiRepository.instance.post(
      '$_plantScansEndPoint/$id/compare',
      body: {'image_base64': imageBase64},
      showDefaultLoader: false,
      showRunTimeError: false,
      rethrowExceptions: true,
    );
  }
}
