import 'package:kasagardem/utils/network_services/api_repository.dart';

class PlantsRepository {
  final String allPlantUrl = 'api/v1/allPlants';
  final String getAllPlantDetailUrl = 'api/v1/allPlants/';
  final String addPlantUrl = 'api/v1/allPlants/addplant';
  final String editPlantUrl = 'api/v1/allPlants/updatePlant/';
  final String myPlantUrl = 'api/v1/allPlants/user/myplants';
  final String getMyPlantDetailUrl = 'api/v1/allplants/user/plants/';
  final String deletePlantUrl = 'api/v1/allplants/deletePlant/';

  fetchAllPlants({
    String? pageNumber,
    String? pageSize,
    String? searchName,
    bool showDefaultLoader = true,
  }) async {
    var endUrl = "$allPlantUrl?page=$pageNumber&limit=$pageSize";
    if (searchName != null && searchName.isNotEmpty) {
      endUrl = "$endUrl&search=$searchName";
    }
    var plantsResponse = await ApiRepository.instance.get(
      endUrl,
      showDefaultLoader: showDefaultLoader,
    );
    return plantsResponse;
  }

  fetchPlantDetail({String? plantId}) async {
    var plantsDetailResponse = await ApiRepository.instance.get(
      "$getAllPlantDetailUrl$plantId",
      showDefaultLoader: false,
    );
    return plantsDetailResponse;
  }

  fetchMyPlantDetail({String? plantId}) async {
    var plantsDetailResponse = await ApiRepository.instance.get(
      "$getMyPlantDetailUrl$plantId",
      showDefaultLoader: false,
      showRunTimeError: false,
    );
    return plantsDetailResponse;
  }

  addPlant({Map? addPlantReq}) async {
    var addPlantsResponse = await ApiRepository.instance.post(addPlantUrl, body: addPlantReq);
    return addPlantsResponse;
  }

  editPlant({Map? editPlantReq, required String userPlantId}) async {
    var editPlantsResponse = await ApiRepository.instance.patch(
      editPlantUrl + userPlantId,
      editPlantReq,
    );
    return editPlantsResponse;
  }

  fetchMyPlants({
    String? pageNumber,
    String? pageSize,
    String? searchName,
    bool showDefaultLoader = true,
  }) async {
    var endUrl = "$myPlantUrl?page=$pageNumber&limit=$pageSize";
    if (searchName != null && searchName.isNotEmpty) {
      endUrl = "$endUrl&search=$searchName";
    }
    var plantsResponse = await ApiRepository.instance.get(
      endUrl,
      showDefaultLoader: showDefaultLoader,
    );
    return plantsResponse;
  }

  deletePlant({required int userPlantId}) async {
    var deleteResponse = await ApiRepository.instance.delete("$deletePlantUrl$userPlantId");
    return deleteResponse;
  }
}
