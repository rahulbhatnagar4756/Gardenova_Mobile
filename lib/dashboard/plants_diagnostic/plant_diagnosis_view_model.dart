import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_request_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_response_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_repository.dart';

import '../../utils/constants/app_keys.dart';
import '../../utils/routes.dart';
import '../../utils/shared_prefs_service.dart';
import '../dashboard_controller.dart';

class PlantDiagnosisViewModel extends GetxController {
  PlantDiagnosisRepository plantDiagnosisRepository =
      PlantDiagnosisRepository();
  Rx<File>? imageFile = File('').obs;
  Rx<PlantDiagnosisResponseModel> plantDiagnosisResponse =
      PlantDiagnosisResponseModel().obs;
  RxBool isCurrentImagePlant = true.obs;
  RxBool isLoading = false.obs;
  RxString issue = "".obs;
  RxString automationFeature = "".obs;
  RxString howItHelps = "".obs;
  RxString benefits = "".obs;
  RxString setup = "".obs;
  RxList<String> issueList = <String>[].obs;
  RxList<String> automationFeatureList = <String>[].obs;
  RxList<String> howItHelpsList = <String>[].obs;
  RxList<String> benefitsList = <String>[].obs;
  RxList<String> howToSetupList = <String>[].obs;
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void onInit() {
    super.onInit();
    var data = Get.arguments;

    imageFile!.value = File(data['image_path']);
    latitude = data['latitude'];
    longitude = data['longitude'];
    diagnosePlant();
  }

  diagnosePlant() async {
    isLoading.value = true;
    List<int> imageBytes = await imageFile!.value.readAsBytes();
    String base64String = base64Encode(imageBytes);
    PlantDiagnosisRequestModel? plantDiagnosisRequest =
        PlantDiagnosisRequestModel()
          ..images = ["data:image/png;base64, $base64String"]
          ..latitude = latitude
          ..longitude = longitude;
    var response = await plantDiagnosisRepository.diagnosePlant(
      plantDiagnosisRequest: plantDiagnosisRequest,
    );
    if (response != null) {
      plantDiagnosisResponse.value = PlantDiagnosisResponseModel.fromJson(
        response,
      );
    }
    isCurrentImagePlant.value =
        plantDiagnosisResponse.value.data?.isPlant ?? false;

    if (isCurrentImagePlant.value) {
      getKasagardemData();
    }
    isLoading.value = false;
  }

  getKasagardemData() {
    for (var plantData
        in plantDiagnosisResponse.value.data!.kasagardemSolutions ?? []) {
      issueList.add(plantData.issue!);
      automationFeatureList.add(plantData.automationFeature!);
      howItHelpsList.add(plantData.howItHelps!);
      benefitsList.addAll(plantData.benefits!);
      howToSetupList.addAll(plantData.setupSteps!);
    }
    getDataFromList(data: issue, dataList: issueList);
    getDataFromList(data: automationFeature, dataList: automationFeatureList);
    getDataFromList(data: howItHelps, dataList: howItHelpsList);
    getDataFromList(data: benefits, dataList: benefitsList);
    getDataFromList(data: setup, dataList: howToSetupList);

    /* getIssues();
    getAutomationFeature();
    getHowItHelps();
    getBenefits();
    getHowToSetup();*/
  }

  getDataFromList({RxString? data, List<String>? dataList}) {
    for (var listData in dataList ?? []) {
      data!.value = "${data.value}$listData\n";
    }
  }

  getAutomationFeature() {
    for (var automationFeatureData in automationFeatureList) {
      automationFeature.value =
          "${automationFeature.value}$automationFeatureData\n";
    }
  }

  getHowItHelps() {
    for (var howItHelpsData in howItHelpsList) {
      howItHelps.value = "${howItHelps.value}$howItHelpsData\n";
    }
  }

  getBenefits() {
    for (var benefitsData in benefitsList) {
      benefits.value = "${benefits.value}$benefitsData\n";
    }
  }

  getHowToSetup() {
    for (var setupData in howToSetupList) {
      setup.value = "${setup.value}$setupData\n";
    }
  }

  void navigateToNext(int index) {
    debugPrint("index navigateToNext PlantDiagnosisViewModel:::$index");
    // if(Get.isRegistered<DashboardController>()){
    //   Get.find<DashboardController>().navigateToNext(index);
    //   return;
    // }
    switch (index) {
      case 0:
        // Get.back();
        // Get.back();
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().refreshSoilAnalysis.refresh();
        }
        Get.key.currentState?.popUntil(
          (route) => route.settings.name == Routes.dashboard,
        );
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
        Get.toNamed(Routes.settings);
        break;

      case 6:
        Get.back();
        Get.toNamed(Routes.myPlantsScreen);
        break;

      default:
        Get.back();
        break;
    }
  }
}
