import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:kasagardem/plants/plant_repository.dart';
import '../../../dashboard/dashboard_controller.dart';
import '../../../utils/constants/app_keys.dart';
import '../../../utils/routes.dart';
import '../../../utils/shared_prefs_service.dart';
import '../../../utils/utils.dart';
import '../../model/add_plants_model.dart';
import '../../myPlants/myPlantsList/my_plants_controller.dart';

class AllPlantsController extends GetxController {
  final RxBool isUserLoggedIn = false.obs;
  SharedPrefsService sharedPrefsService = SharedPrefsService();
  TextEditingController searchController = TextEditingController();
  PlantsRepository plantsRepository = PlantsRepository();
  RxList<Plants> allPlantList = <Plants>[].obs;
  RxBool isLoading = false.obs;
  RxBool isRefreshing = false.obs;
  RxInt pageNumber = 1.obs;
  int pageSize = 20;
  RxBool isLoadMoreVisible = false.obs;
  RxBool isSearching = false.obs;
  RxBool isLoadMoreRunning = false.obs;
  final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));
  ScrollController scrollController = ScrollController();

  final RxBool hasMyPlants = false.obs;

  @override
  void onInit() {
    isUserLoggedIn.value =
        sharedPrefsService.getBool(AppKeys.isLoggedIn) ?? false;
    scrollController.addListener(_onScroll);
    _loadHasMyPlants();
    callGetAllPlantListApi();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }

  /// True only when this controller is attached to exactly one scroll view.
  /// Accessing [ScrollController.position] with 0 clients throws, and with
  /// more than one throws "Bad state: Too many elements".
  bool get _hasSingleScrollClient =>
      scrollController.hasClients && scrollController.positions.length == 1;

  void _onScroll() {
    if (!_hasSingleScrollClient) return;
    if (isRefreshing.value || isLoading.value) return;
    if (isLoadMoreRunning.value || !isLoadMoreVisible.value) return;

    final position = scrollController.positions.first;
    if (position.pixels >= position.maxScrollExtent - 200) {
      loadMorePlants();
    }
  }

  /// Rejects empty, relative, and host-less URLs that would crash
  /// [CachedNetworkImage] with "No host specified in URI".
  static bool isValidNetworkImageUrl(String? url) {
    return Utils.isValidNetworkImageUrl(url);
  }

  String? resolvedPlantImageUrl(Plants plant) {
    if (isValidNetworkImageUrl(plant.imageUrl)) {
      return plant.imageUrl!.trim();
    }
    if (isValidNetworkImageUrl(plant.imageOriginalUrl)) {
      return plant.imageOriginalUrl!.trim();
    }
    return null;
  }

  Plants _sanitizePlantImages(Plants plant) {
    if (!isValidNetworkImageUrl(plant.imageUrl)) {
      plant.imageUrl = null;
    } else {
      plant.imageUrl = plant.imageUrl!.trim();
    }
    if (!isValidNetworkImageUrl(plant.imageOriginalUrl)) {
      plant.imageOriginalUrl = null;
    } else {
      plant.imageOriginalUrl = plant.imageOriginalUrl!.trim();
    }
    return plant;
  }

  Future<void> _loadHasMyPlants() async {
    if (Get.isRegistered<MyPlantsController>() &&
        Get.find<MyPlantsController>().myPlantList.isNotEmpty) {
      hasMyPlants.value = true;
      return;
    }
    if (!isUserLoggedIn.value) {
      hasMyPlants.value = false;
      return;
    }
    hasMyPlants.value = await plantsRepository.userHasMyPlants();
  }

  void selectPlant(int index) {
    // for (var element in allPlantList) {
    //   element.isSelected = false;
    // }
    // allPlantList[index].isSelected = true;
    // allPlantList.refresh();
    Utils.hideKeyboard();
    Get.toNamed(
      Routes.allPlantsDetails,
      arguments: {"plant_id": allPlantList[index].id, "screen_type": "add"},
    )?.then((value) {
      Utils.hideKeyboard();
    });
  }

  void navigateToNext(int index) {
    debugPrint("index navigateToNext AllPlantsController:::$index");
    // return;
    switch (index) {
      case 0:
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().getGardenInsights();
        }
        Get.until((route) => route.settings.name == Routes.dashboard);
        break;

      case 1:
        Get.back();
        Get.toNamed(
          Routes.recommendedProfessionals,
          arguments: {
            "lat":
                SharedPrefsService.instance.getString(AppKeys.currentLatKey) ??
                0.0,
            "lng":
                SharedPrefsService.instance.getString(AppKeys.currentLongKey) ??
                0.0,
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
        Utils.callSettingBasicApi();
        Get.toNamed(Routes.profile);
        break;
      case 6:
        // Get.back();
        // Get.back();
        if (Get.isRegistered<MyPlantsController>()) {
          // var con = Get.find<MyPlantsController>();
          // con.searchController.text = '';
          // con.myPlantList.clear();
          // con.callGetMyPlantListApi();
          Get.until((route) => route.settings.name == Routes.myPlantsScreen);
        } else {
          Get.back();
          Get.offNamed(Routes.myPlantsScreen);
          // Get.back();
        }
        break;

      case 7:
        Get.back();
        // if (Get.isRegistered<DashboardController>()) {
        //   Get.find<DashboardController>().refreshSoilAnalysis.refresh();
        // }
        // Get.until((route) => route.settings.name == Routes.settings);
        Utils.callSettingBasicApi();
        Get.toNamed(Routes.settings);
        break;

      default:
        Get.back();
        break;
    }
  }

  Future<void> loadMorePlants() async {
    if (isRefreshing.value) return;

    if (isLoading.value) return;

    isLoadMoreRunning.value = true;

    if (!isSearching.value) {
      pageNumber.value++;
    }

    await getAllPlantList(showDefaultLoader: false);

    isLoadMoreRunning.value = false;
  }

  Future<void> callGetAllPlantListApi({String searchName = ''}) async {
    allPlantList.clear();
    isLoading.value = true;
    if (searchName.isEmpty) {
      isLoadMoreRunning.value = false;
    }
    await getAllPlantList(searchName: searchName, showDefaultLoader: false);
    isLoading.value = false;
  }

  Future getAllPlantList({
    String searchName = '',
    bool showDefaultLoader = true,
  }) async {
    var response = await plantsRepository.fetchAllPlants(
      pageNumber: pageNumber.value.toString(),
      pageSize: pageSize.toString(),
      searchName: searchName,
      showDefaultLoader: showDefaultLoader,
    );
    if (response != null) {
      AddPlantsModel allPlantsResponse = AddPlantsModel.fromJson(response);
      final plants = (allPlantsResponse.data?.plants ?? [])
          .map(_sanitizePlantImages)
          .toList();
      allPlantList.addAll(plants);
      isLoadMoreVisible.value =
          (allPlantsResponse.data?.totalCount ?? 0) > allPlantList.length;
    }
  }
}
