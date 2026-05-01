import 'package:kasagardem/utils/network_services/api_repository.dart';

class PlantsCatalogRepository {
  final String _plantListEndPoint = "api/v1/admin/plants";

  String getPlantListEndPoint({
    String? pageNumber,
    String? pageSize,
    String? searchName,
  }) {
    var endUrl = "$_plantListEndPoint?page=$pageNumber&limit=$pageSize";
    if (searchName != null && searchName.isNotEmpty) {
      endUrl = "$endUrl&search=$searchName";
    }
    return endUrl;
  }

  fetchPlantList({
    String? pageNumber,
    String? pageSize,
    String? searchName,
  }) async {
    var plantsResponse = await ApiRepository.instance.get(
      getPlantListEndPoint(
        pageNumber: pageNumber,
        pageSize: pageSize,
        searchName: searchName,
      ),
    );
    return plantsResponse;
  }
}
