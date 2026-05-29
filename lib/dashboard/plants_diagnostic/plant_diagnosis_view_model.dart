import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_request_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_response_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_repository.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/permission_manager.dart';
import 'package:kasagardem/utils/network_services/app_exceptions.dart';

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
  RxString errorMessage = "".obs;

  /// Flips to true the moment the API call finishes.
  /// The loading view watches this and fast-forwards its animation to 100 %
  /// before calling [onLoadingAnimationComplete] to dismiss itself.
  RxBool isApiComplete = false.obs;
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
    errorMessage.value = "";
    try {
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
        if (plantDiagnosisResponse.value.success != true) {
          errorMessage.value = _cleanErrorMessage(
            plantDiagnosisResponse.value.message ?? "Unable to analyze plant",
          );
        }
      } else {
        errorMessage.value = "Unable to analyze plant";
      }
      isCurrentImagePlant.value =
          plantDiagnosisResponse.value.data?.isPlant ?? false;

      if (isCurrentImagePlant.value) {
        getKasagardemData();
      }
    } catch (e) {
      if (e is BadRequestException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is FetchDataException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is UnauthorisedException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is NotFoundException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is ConflictException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else {
        errorMessage.value = _cleanErrorMessage("An error occurred: $e");
      }
      plantDiagnosisResponse.value = PlantDiagnosisResponseModel();
    } finally {
      // Signal the loading view that the API is done.
      // isLoading will be cleared by onLoadingAnimationComplete() once the
      // progress bar reaches 100 % and the view is ready to dismiss.
      isApiComplete.value = true;
    }
  }

  /// Called by DiagnosisLoadingView after it has animated to 100 %.
  void onLoadingAnimationComplete() {
    isLoading.value = false;
    isApiComplete.value = false; // reset for potential retry
  }

  void rescanImage() {
    Get.bottomSheet(
      Container(
        height: Get.height * .2,
        color: AppColors.offWhite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: AppColors.greenColor,
              ),
              title: BaseText(text: AppLocalizations.of(Get.context!)!.camera),
              onTap: () async {
                Get.back();
                await Future.delayed(const Duration(milliseconds: 200));

                // Camera Permission
                bool hasPermission =
                    await PermissionManager.handleCameraPermission();
                if (!hasPermission) return;

                final result = await Get.toNamed(Routes.cameraCapture);
                if (result != null && result is XFile) {
                  imageFile!.value = File(result.path);
                  isApiComplete.value = false;
                  diagnosePlant();
                }
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppColors.greenColor,
              ),
              title: BaseText(text: AppLocalizations.of(Get.context!)!.gallery),
              onTap: () async {
                Get.back();
                await Future.delayed(const Duration(milliseconds: 200));

                final ImagePicker picker = ImagePicker();
                final XFile? pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                  requestFullMetadata: true,
                  imageQuality: 10,
                );
                if (pickedFile != null && pickedFile.path.isNotEmpty) {
                  imageFile!.value = File(pickedFile.path);
                  isApiComplete.value = false;
                  diagnosePlant();
                }
              },
            ),
          ],
        ),
      ),
    );
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
        Get.toNamed(Routes.profile);
        break;

      case 6:
        Get.back();
        Get.toNamed(Routes.myPlantsScreen);
        break;
        
      case 7:
        Get.back();
        Get.toNamed(Routes.settings);
        break;

      default:
        Get.back();
        break;
    }
  }

  String _cleanErrorMessage(String errorMsg) {
    if (errorMsg.contains('{') && errorMsg.contains('}')) {
      try {
        final startIndex = errorMsg.indexOf('{');
        final endIndex = errorMsg.lastIndexOf('}');
        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
          final jsonPart = errorMsg.substring(startIndex, endIndex + 1);
          final decoded = jsonDecode(jsonPart);
          if (decoded is Map) {
            if (decoded.containsKey('message')) {
              return decoded['message'].toString();
            } else if (decoded.containsKey('error')) {
              return decoded['error'].toString();
            }
          }
        }
      } catch (_) {}
    }

    final messageMatch = RegExp(
      r'"message"\s*:\s*"([^"]+)"',
    ).firstMatch(errorMsg);
    if (messageMatch != null && messageMatch.groupCount >= 1) {
      return messageMatch.group(1)!;
    }

    final errorMatch = RegExp(r'"error"\s*:\s*"([^"]+)"').firstMatch(errorMsg);
    if (errorMatch != null && errorMatch.groupCount >= 1) {
      return errorMatch.group(1)!;
    }

    return errorMsg;
  }
}
