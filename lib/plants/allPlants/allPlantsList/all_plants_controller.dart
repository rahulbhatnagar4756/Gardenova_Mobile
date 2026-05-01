import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kasagardem/plants/model/plant_model.dart';
import 'package:kasagardem/plants/plant_repository.dart';
import '../../../utils/constants/app_keys.dart';
import '../../../utils/routes.dart';
import '../../../utils/shared_prefs_service.dart';

class AllPlantsController extends GetxController {
  final RxBool isUserLoggedIn = false.obs;
  SharedPrefsService sharedPrefsService = SharedPrefsService();
  TextEditingController searchController = TextEditingController();
  PlantsRepository plantsRepository = PlantsRepository();
  RxList<PlantModel> allPlantList = <PlantModel>[].obs;
  RxBool isLoading = false.obs;
  RxInt pageNumber = 1.obs;
  int pageSize = 20;
  RxBool isLoadMoreVisible = false.obs;
  RxBool isSearching = false.obs;
  RxBool isLoadMoreRunning = false.obs;
  final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));

  @override
  void onInit() {
    isUserLoggedIn.value =
        sharedPrefsService.getBool(AppKeys.isLoggedIn) ?? false;
    callGetAllPlantListApi();
    super.onInit();
  }

  void selectPlant(int index) {
    for (var element in allPlantList) {
      element.isSelected = false;
    }
    allPlantList[index].isSelected = true;
    allPlantList.refresh();
    Get.toNamed(
      Routes.allPlantsDetails,
      arguments: {"plant_id": allPlantList[index].id, "screen_type": "add"},
    );
  }

  void navigateToNext(int index) {
    debugPrint("index:::$index");
    switch (index) {
      case 0:
        Get.back();
        Get.toNamed(Routes.dashboard);
        break;

      case 1:
        Get.back();
        Get.toNamed(
          Routes.recommendedProfessionals,
          arguments: {
            "lat": SharedPrefsService.instance.getString(AppKeys.currentLatKey) ?? 0.0,
            "lng": SharedPrefsService.instance.getString(AppKeys.currentLongKey) ?? 0.0,
          },
        );
        break;

      case 2:
        Get.back();
        Get.back();
        break;

      case 3:
        break;

      case 4:
        break;

      case 5:
        Get.back();
        Get.toNamed(Routes.settings);
        break;

      case 6:
        Get.back();
        Get.back();
        break;

      default:
        Get.back();
        break;
    }
  }

  void loadMorePlants() {
    isLoadMoreRunning.value = true;
    if (isSearching.value == false) {
      pageNumber.value++;
    }
    getAllPlantList().then((value) => isLoadMoreRunning.value = false);
  }

  Future<void> callGetAllPlantListApi({String searchName = ''}) async {
    allPlantList.clear();
    isLoading.value = true;
    await getAllPlantList(
      searchName: searchName,
    );
    isLoading.value = false;
  }

  Future getAllPlantList({String searchName = ''}) async {
    var response = await plantsRepository.fetchAllPlants(
      pageNumber: pageNumber.value.toString(),
      //pageNumber: searchName.isNotEmpty ? null : pageNumber.value.toString(),
      pageSize: pageSize.toString(),
      //pageSize: searchName.isNotEmpty ? null : pageSize.toString(),
      searchName: searchName,
    );
    if (response != null) {
      PlantResponseModel allPlantsResponse = PlantResponseModel.fromJson(
        response,
      );
      allPlantList.addAll(allPlantsResponse.data!.plants ?? []);
      isLoadMoreVisible.value =
          allPlantsResponse.data!.totalCount! > allPlantList.length
          ? true
          : false;
    }
  }
}
