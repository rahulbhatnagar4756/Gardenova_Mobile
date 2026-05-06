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
import '../utils/constants/app_color.dart';
import '../utils/constants/app_constants.dart';
import '../utils/location_service.dart';

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
  final LocationService _locationService = LocationService();
  bool _isFetching = false;
  var refreshSoilAnalysis = false.obs;

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
      case 0:
        // Get.offNamedUntil(
        //   Routes.dashboard,
        //       (route) => false,
        // );
        // Get.until((route) => route.settings.name == Routes.dashboard);
        refreshSoilAnalysis.refresh();
        Get.back();
        break;
      case 1:
        if (isUserLoggedIn.value) {
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
        //  Get.toNamed(Routes.plantsCatalog);
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
      showDefaultLoader: false,
    );
    PlantRecommendationsResponseModel recommendationsResponse =
        PlantRecommendationsResponseModel.fromJson(response);
    if (recommendationsResponse.data != null) {
      plantRecommendationList.value =
          recommendationsResponse.data!.plantRecommendations ?? [];
    }
    isLoading.value = false;
  }

  // Future getCurrentLocation() async {
  //   // position = await _determinePosition();
  //   position = await _locationService.getCurrentLocation();
  //   lat = position?.latitude??0.0;
  //   long = position?.longitude??0.0;
  //   sharedPrefsService.setString(AppKeys.currentLatKey, lat.toString());
  //   sharedPrefsService.setString(AppKeys.currentLongKey, long.toString());
  //   return position;
  // }
  Future<void> getCurrentLocation() async {
    if (_isFetching) return;

    _isFetching = true;

    try {
      position = await _locationService.getCurrentLocation();

      lat = position?.latitude ?? defaultLatitude;
      long = position?.longitude ?? defaultLongitude;
      // Save locally
      sharedPrefsService.setString(AppKeys.currentLatKey, lat.toString());
      sharedPrefsService.setString(AppKeys.currentLongKey, long.toString());
      // sharedPrefsService.setString("lat", lat.toString());
      // sharedPrefsService.setString("long", long.toString());
      if ((Get.isDialogOpen ?? false) == true) {
        Get.back();
      }

      debugPrint("LAT: $lat, LNG: $long");
    } catch (e) {
      debugPrint("Final Error: $e");
    } finally {
      _isFetching = false;
    }
  }

  Future<void> pickImage({required bool isCamera}) async {
    try {
      if (position != null ||_isFetching) {

        if(_isFetching && position == null){
          BaseSnackBar.show(
            title: 'Please Wait',
            message: 'Location is being fetched. Please wait...',
          );
          return;
        }
        final ImagePicker picker = ImagePicker();
        final XFile? pickedFile = await picker.pickImage(
          source: isCamera ? ImageSource.camera : ImageSource.gallery,
          requestFullMetadata: true,
          imageQuality: 10,
          preferredCameraDevice: CameraDevice.front,
        );

        if (pickedFile != null && pickedFile.path.isNotEmpty) {
          Get.back();
          if (position != null) {
            goToPlantDiagnosis(pickedFile);
          } else {
            await getCurrentLocation();
            goToPlantDiagnosis(pickedFile);
          }
        }
      } else {
        getCurrentLocation();
      }
    } catch (e) {
      debugPrint("Error:::$e");
    }
  }

}
