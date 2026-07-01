import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
import 'package:kasagardem/plants/myPlants/myPlantsList/model/my_plants_listing_model.dart';

import '../../../services/admob_service.dart';
import '../../../utils/constants/app_keys.dart';
import '../../../utils/routes.dart';
import '../../../utils/shared_prefs_service.dart';
import '../../../utils/utils.dart';
import '../../plant_repository.dart';

class MyPlantsController extends GetxController {
  final RxBool isUserLoggedIn = false.obs;
  SharedPrefsService sharedPrefsService = SharedPrefsService();
  TextEditingController searchController = TextEditingController();
  PlantsRepository plantsRepository = PlantsRepository();
  RxList<Plants> myPlantList = <Plants>[].obs;
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
  ScrollController scrollController = ScrollController();

  /* BannerAd? bannerAd;*/
  RxBool isAdLoaded = false.obs;

  @override
  void onInit() {
    isUserLoggedIn.value = sharedPrefsService.getBool(AppKeys.isLoggedIn) ?? false;
    scrollController.addListener(() {
      if (scrollController.hasClients &&
          scrollController.position.pixels >= scrollController.position.maxScrollExtent - 150 &&
          !isLoadMoreRunning.value &&
          isLoadMoreVisible.value) {
        loadMorePlants();
      }
    });

    callGetMyPlantListApi();
    //loadBannerAd();
    super.onInit();
  }

  void loadBannerAd() {
    if (!AdMobService.instance.shouldShowBanners) {
      isAdLoaded.value = false;
      return;
    }
    /*    bannerAd = AdMobService.instance.loadBannerAd(
      onAdLoaded: (ad) {
        isAdLoaded.value = true;
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        isAdLoaded.value = false;
        debugPrint('BannerAd failed to load: $error');
      },
    );*/
  }

  @override
  void onClose() {
    /*    bannerAd?.dispose();*/
    super.onClose();
  }

  void navigateToNext(int index) {
    debugPrint("index navigateToNext MyPlantsController:::$index");
    // if (Get.isRegistered<DashboardController>()) {
    //   Get.find<DashboardController>().navigateToNext(index);
    //   return;
    // }
    switch (index) {
      case 0:
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().refreshSoilAnalysis.refresh();
        }
        Get.until((route) => route.settings.name == Routes.dashboard);
        break;
      case 1:
        Get.back();
        Get.toNamed(
          Routes.recommendedProfessionals,
          arguments: {
            "lat": SharedPrefsService.instance.getString(AppKeys.currentLatKey) ?? "0.0",
            "lng": SharedPrefsService.instance.getString(AppKeys.currentLongKey) ?? "0.0",
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
        Get.toNamed(Routes.profile)!.then((value) {
          if (value == true) {
            // callGetMyPlantListApi();
          }
        });
        break;

      case 6:
        Get.back();
        callGetMyPlantListApi();
        break;

      case 7:
        Get.back();
        Utils.callSettingBasicApi();
        Get.toNamed(Routes.settings);
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
    getMyPlantList().then((value) => isLoadMoreRunning.value = false);
  }

  void callGetMyPlantListApi({String searchName = ''}) {
    myPlantList.clear();
    isLoading.value = true;
    getMyPlantList(searchName: searchName).then((value) => isLoading.value = false);
  }

  Future getMyPlantList({String searchName = ''}) async {
    var response = await plantsRepository.fetchMyPlants(
      pageNumber: pageNumber.value.toString(),
      pageSize: pageSize.toString(),
      searchName: searchName,
      showDefaultLoader: false,
    );
    if (response != null) {
      debugPrint("response:::$response");
      MyPlantsListingModel allPlantsResponse = MyPlantsListingModel.fromJson(response);

      myPlantList.addAll(allPlantsResponse.data!.plants ?? []);

      // final List<PlantModel> mockData = List.generate(20, (index) {
      //   return PlantModel(
      //     id: index,
      //     plantId: index,
      //     commonName:
      //         "Plant ${index + 1} slkdfja lwks;fj alksdfjlk;asdfj;lkasjdf ;lkajsdf;l kajsfdsadf",
      //     scientificName:
      //         "Scientific ${index + 1} asdlkf.jaskl;dfjaslkdfjsa; dfj;lkasjdf;lksajfk;lajs;lfkjasd;lfkjsa",
      //     imageUrl: "https://picsum.photos/200/300?random=$index",
      //     wateringReminderFrequency: (index % 5) + 1,
      //   );
      // });
      //
      // myPlantList.addAll(mockData);

      isLoadMoreVisible.value = allPlantsResponse.data!.totalCount! > myPlantList.length
          ? true
          : false;
    }
  }

  Future<bool> deletePlant(int userPlantId) async {
    isLoading.value = true;
    try {
      var response = await plantsRepository.deletePlant(userPlantId: userPlantId);
      if (response != null) {
        callGetMyPlantListApi();
        return true;
      }
    } catch (e) {
      debugPrint("MyPlantsController deletePlant error: $e");
    } finally {
      isLoading.value = false;
    }
    return false;
  }
}
