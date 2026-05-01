import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plants_catalog/plants_catalog_repository.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plants_catalog/plants_list_response_model.dart';

class PlantsCatalogViewModel extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  RxBool isLoadMoreRunning = false.obs;
  RxList<Plants> plantsList = <Plants>[].obs;
  PlantsCatalogRepository plantsCatalogRepository = PlantsCatalogRepository();
  RxInt pageNumber = 1.obs;
  int pageSize = 8;
  RxBool isLoadMoreVisible = false.obs;
  final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));

  @override
  void onInit() {
    super.onInit();
    getPlantsListing();
  }

  getPlantsListing({String searchName = ''}) {
    plantsList.clear();
    isLoading.value = true;
    fetchPlantsListing(
      searchName: searchName,
    ).then((value) => isLoading.value = false);
  }

  Future fetchPlantsListing({String searchName = ''}) async {
    var response = await plantsCatalogRepository.fetchPlantList(
      pageNumber: searchName.isNotEmpty ? null : pageNumber.value.toString(),
      pageSize: searchName.isNotEmpty ? null : pageSize.toString(),
      searchName: searchName,
    );
    if (response != null) {
      PlantsListResponseModel plantsCatalogResponse =
          PlantsListResponseModel.fromJson(response);
      plantsList.addAll(plantsCatalogResponse.data!.plants ?? []);
      isLoadMoreVisible.value =
          plantsCatalogResponse.data!.totalCount! > plantsList.length
          ? true
          : false;
    }
  }

  loadMorePlants() {
    isLoadMoreRunning.value = true;
    if (isSearching.value == false) {
      pageNumber.value++;
    }
    fetchPlantsListing().then((value) => isLoadMoreRunning.value = false);
  }
}
