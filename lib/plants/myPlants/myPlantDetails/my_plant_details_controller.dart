import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kasagardem/plants/myPlants/myPlantDetails/model/my_plant_detail_model.dart';

import '../../../services/admob_service.dart';
import '../../plant_repository.dart';
import '../myPlantsList/my_plants_controller.dart';

class MyPlantDetailsController extends GetxController {
  RxString plantId = "".obs;
  PlantsRepository plantsRepository = PlantsRepository();
  Rx<MyPlantDetailModel> plantDetailData = MyPlantDetailModel().obs;

  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  BannerAd? bannerAd;
  RxBool isAdLoaded = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      plantId.value = Get.arguments.toString();
    }
    callGetMyPlantDetailsApi();
    loadBannerAd();
    super.onInit();
  }

  void loadBannerAd() async {
    isAdLoaded.value = false;
    final ad = await AdMobService.instance.loadBannerAd(
      existingAd: bannerAd,
      onAdLoaded: (ad) {
        isAdLoaded.value = true;
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        bannerAd = null;
        isAdLoaded.value = false;
        debugPrint('BannerAd failed to load: $error');
      },
    );
    bannerAd = ad;
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }

  Future callGetMyPlantDetailsApi() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      var response = await plantsRepository.fetchMyPlantDetail(plantId: plantId.value);
      if (response != null) {
        plantDetailData.value = MyPlantDetailModel.fromJson(response);
      } else {
        errorMessage.value = "No plant data found";
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      debugPrint("MyPlantDetailsController callGetMyPlantDetailsApi: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> callDeletePlantApi() async {
    final userPlantId = plantDetailData.value.data?.userPlantId;
    if (userPlantId == null || userPlantId == 0) {
      return false;
    }
    isLoading.value = true;
    errorMessage.value = "";
    try {
      var response = await plantsRepository.deletePlant(userPlantId: userPlantId);
      if (response != null) {
        if (Get.isRegistered<MyPlantsController>()) {
          Get.find<MyPlantsController>().callGetMyPlantListApi();
        }
        return true;
      }
    } catch (e) {
      debugPrint("callDeletePlantApi MyPlantDetailsController callDeletePlantApi error: $e");
    } finally {
      isLoading.value = false;
    }
    return false;
  }
}
