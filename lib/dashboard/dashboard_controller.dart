import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/dashboard_repository.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plant_recommendations_response_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import '../base/dialogs/base_dialog.dart';

class DashboardController extends GetxController {
  RxList<PlantRecommendationsResponse> plantRecommendationList =
      <PlantRecommendationsResponse>[].obs;
  SharedPrefsService sharedPrefsService = SharedPrefsService();
  DashboardRepository dashboardRepository = DashboardRepository();
  RxBool isUserLoggedIn = false.obs;
  RxBool isLoading = false.obs;
  String responseId = "";
  double lat = 0.0;
  double long = 0.0;
  Position? position;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      responseId = Get.arguments.toString();
      getPlantsRecommendations(responseId);
      isUserLoggedIn.value =
          sharedPrefsService.getBool(AppKeys.isLoggedIn) ?? false;
    });
    getCurrentLocation();

    super.onInit();
  }

  void navigateToNext(int index) {
    debugPrint("index:::$index");
    switch (index) {
      case 1:
        if (isUserLoggedIn.value) {
          Get.back();
          Get.toNamed(
            Routes.recommendedProfessionals,
            arguments: {"lat": lat, "lng": long},
          );
        } else {
          BaseDialog.showAlertDialog(
            context: Get.context!,
            onButtonPressed: () {
              Get.back();
              Get.toNamed(
                Routes.login,
                arguments: {"question_state_passed": true},
              );
            },
            title: AppLocalizations.of(Get.context!)!.login.toUpperCase(),
            description: AppLocalizations.of(
              Get.context!,
            )!.pleaseLoginToSeeRecommendedProfessionals,
            buttonLabel: AppLocalizations.of(Get.context!)!.login.toUpperCase(),
          );
        }
        break;

      case 2:
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

  void goToPlantDiagnosis(XFile? pickedFile) {
    Get.toNamed(
      Routes.plantDiagnosis,
      arguments: {
        ApiKeys.latitude: position!.latitude,
        ApiKeys.longitude: position!.longitude,
        ApiKeys.imagePath: pickedFile!.path,
      },
    );
  }

  void getPlantsRecommendations(String responseId) async {
    isLoading.value = true;
    var response = await dashboardRepository.fetchPlantRecommendation(
      responseId,
    );
    PlantRecommendationsResponseModel recommendationsResponse =
        PlantRecommendationsResponseModel.fromJson(response);
    if (recommendationsResponse.data != null) {
      plantRecommendationList.value =
          recommendationsResponse.data!.plantRecommendations ?? [];
    }
    isLoading.value = false;
  }

  Future getCurrentLocation() async {
    position = await _determinePosition();
    lat = position!.latitude;
    long = position!.longitude;
    sharedPrefsService.setString(AppKeys.currentLatKey, lat.toString());
    sharedPrefsService.setString(AppKeys.currentLongKey, long.toString());
    return position;
  }

  Future<void> pickImage({required bool isCamera}) async {
    try {
      if (position != null) {
        final ImagePicker picker = ImagePicker();
        final XFile? pickedFile = await picker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          requestFullMetadata: true,
          imageQuality: 10,
          preferredCameraDevice: CameraDevice.front,
        );
        Get.back();
        if (pickedFile != null) {
          if (position != null) {
            goToPlantDiagnosis(pickedFile);
          } else {
            getCurrentLocation();
            goToPlantDiagnosis(pickedFile);
          }
        }
      } else {
        getCurrentLocation().then((value) => pickImage(isCamera: isCamera));
      }
    } catch (e) {
      debugPrint("Error:::$e");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (Platform.isIOS) {
        await Get.dialog(
          AlertDialog(
            title: BaseText(
              text: AppLocalizations.of(
                Get.context!,
              )!.locationPermissionRequired,
            ),
            content: BaseText(
              text: AppLocalizations.of(
                Get.context!,
              )!.locationPermissionsAreDenied,
            ),
            actions: [
              TextButton(
                child: BaseText(
                  text: AppLocalizations.of(Get.context!)!.cancel,
                ),
                onPressed: () => Get.back(),
              ),
              TextButton(
                child: BaseText(
                  text: AppLocalizations.of(Get.context!)!.openSettings,
                ),
                onPressed: () {
                  Geolocator.openAppSettings();
                  Get.back();
                },
              ),
            ],
          ),
        );
        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.',
        );
      }

      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    return await Geolocator.getCurrentPosition();
  }
}
