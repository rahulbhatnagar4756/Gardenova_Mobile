import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import '../../../utils/constants/app_keys.dart';
import '../../../utils/routes.dart';
import '../../../utils/shared_prefs_service.dart';
import '../../model/plant_model.dart';
import '../../plant_repository.dart';

class MyPlantsController extends GetxController {
  final RxBool isUserLoggedIn = false.obs;
  SharedPrefsService sharedPrefsService = SharedPrefsService();
  TextEditingController searchController = TextEditingController();
  PlantsRepository plantsRepository = PlantsRepository();
  RxList<PlantModel> myPlantList = <PlantModel>[].obs;
  RxBool isLoading = false.obs;
  RxInt pageNumber = 1.obs;
  int pageSize = 20;
  RxBool isLoadMoreVisible = false.obs;
  RxBool isSearching = false.obs;
  RxBool isLoadMoreRunning = false.obs;
  final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));
  String get plant => "plant";
  String get plantPlural => "plants";
  String get andCounting => "and counting";

  @override
  void onInit() {
    isUserLoggedIn.value = sharedPrefsService.getBool(AppKeys.isLoggedIn) ?? false;
    callGetMyPlantListApi();
    super.onInit();
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
            "lat":
                SharedPrefsService.instance.getString(AppKeys.currentLatKey) ??
                "0.0",
            "lng":
                SharedPrefsService.instance.getString(AppKeys.currentLongKey) ??
                "0.0",
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
        Get.toNamed(Routes.settings)!.then((value) {
          if (value == true) {
            callGetMyPlantListApi();
          }
        });
        break;

      case 6:
        Get.back();
        callGetMyPlantListApi();
        break;

      default:
        Get.back();
        break;
    }
  }

  loadMorePlants() {
    isLoadMoreRunning.value = true;
    if (isSearching.value == false) {
      pageNumber.value++;
    }
    getMyPlantList().then((value) => isLoadMoreRunning.value = false);
  }

  callGetMyPlantListApi({String searchName = ''}) {
    myPlantList.clear();
    isLoading.value = true;
    getMyPlantList(
      searchName: searchName,
    ).then((value) => isLoading.value = false);
  }

  Future getMyPlantList({String searchName = ''}) async {
    var response = await plantsRepository.fetchMyPlants(
      pageNumber: pageNumber.value.toString(),
      //pageNumber: searchName.isNotEmpty ? null : pageNumber.value.toString(),
      pageSize: pageSize.toString(),
      //pageSize: searchName.isNotEmpty ? null : pageSize.toString(),
      searchName: searchName,
    );
    if (response != null) {
      debugPrint("response:::$response");
      PlantResponseModel allPlantsResponse = PlantResponseModel.fromJson(response);
      myPlantList.addAll(allPlantsResponse.data!.plants ?? []);
      isLoadMoreVisible.value = allPlantsResponse.data!.totalCount! > myPlantList.length ? true : false;
    }
  }

}
