import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasagardem/dashboard/components/bottom_navigation_widget.dart';
import 'package:kasagardem/dashboard/components/soil_analysis.dart';
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
import '../utils/location_helper/location_service.dart';
import '../utils/permission_manager.dart';

enum ImagePickerSource { diagnosis, landscape }

class DashboardController extends GetxController {
  RxList<PlantRecommendationsResponse> plantRecommendationList =
      <PlantRecommendationsResponse>[].obs;
  var plantRecController = ScrollController();
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
  var selectedNavType = BottomNavType.home.obs;

  var chartData = [
    ChartData('Organic', 1, AppColors.organicColor),
    ChartData('Sand', 1, AppColors.sandColor),
    ChartData('Salt', 1, AppColors.siltColor),
    ChartData('Clay', 1, AppColors.clayColor),
  ].obs;

  @override
  void onInit() {
    responseId = Get.arguments.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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

  void goToLandscapeDesign(XFile? pickedFile) {
    Get.toNamed(
      Routes.landscapeDesign,
      arguments: {ApiKeys.imagePath: pickedFile!.path},
    );
  }

  void onScreenClick() {
    // getPlantsRecommendations(responseId);
  }

  void getPlantsRecommendations(String responseId) async {
    String recommendationId =
        sharedPrefsService.getString(AppKeys.submissionResponseId) ?? '';
    if (recommendationId.trim().isEmpty) {
      recommendationId = responseId;
    }
    isLoading.value = true;
    var response = await dashboardRepository.fetchPlantRecommendation(
      recommendationId,
      showDefaultLoader: false,
    );
    PlantRecommendationsResponseModel recommendationsResponse =
        PlantRecommendationsResponseModel.fromJson(response);
    if (recommendationsResponse.data != null) {
      plantRecommendationList.value =
          recommendationsResponse.data!.plantRecommendations ?? [];
      _scrollToFirstIndex();
    }
    isLoading.value = false;
  }

  void _scrollToFirstIndex() {
    try {
      if (plantRecController.hasClients &&
          plantRecController.position.hasPixels) {
        plantRecController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      debugPrint("Scroll Error: $e");
    }
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
    print('getCurrentLocation t1');
    if (_isFetching) return;

    _isFetching = true;
    print('getCurrentLocation t2');
    try {
      position = await _locationService.getCurrentLocation();
      lat = position?.latitude ?? defaultLatitude;
      long = position?.longitude ?? defaultLongitude;
      // Save locally
      sharedPrefsService.setString(AppKeys.currentLatKey, lat.toString());
      sharedPrefsService.setString(AppKeys.currentLongKey, long.toString());
      await getSoilAnalysis(lat: lat, long: long);
      // sharedPrefsService.setString("lat", lat.toString());
      // sharedPrefsService.setString("long", long.toString());
      print('getCurrentLocation t3');
      if ((Get.isDialogOpen ?? false) == true) {
        print('getCurrentLocation t4');
        Get.back();
      }
      print('getCurrentLocation t5');

      debugPrint("LAT: $lat, LNG: $long");
    } catch (e) {
      print('getCurrentLocation t6');
      debugPrint("Final Error: $e");
    } finally {
      print('getCurrentLocation t7');
      _isFetching = false;
    }
  }

  Future<void> getSoilAnalysis({
    required double lat,
    required double long,
  }) async {
    // chartData.assignAll([
    //   ChartData('Organic', 15, AppColors.liteYellowColor),
    //   ChartData('Sand', 40, AppColors.darkGreenColor),
    //   ChartData('Salt', 25, AppColors.liteGreenColor),
    //   ChartData('Clay', 20, AppColors.toLiteGreenColor),
    // ]);
    chartData.assignAll([
      ChartData('Organic', 15, AppColors.organicColor),
      ChartData('Sand', 40, AppColors.sandColor),
      ChartData('Salt', 25, AppColors.siltColor),
      ChartData('Clay', 20, AppColors.clayColor),
    ]);
    refreshSoilAnalysis.refresh();
    return;
    // try {
    //   final response = await dashboardRepository.fetchSoilAnalysis(
    //     lat: lat,
    //     lon: long,
    //   );

    //   if (response == null) return;

    //   double clay = 1;
    //   double sand = 1;
    //   double silt = 1;
    //   double organic = 1;

    //   final layers = response.properties?.layers ?? [];

    //   for (var layer in layers) {
    //     num rawValue = (layer.depths?.first.values?.mean ?? 0) as num;
    //     int dFactor = layer.unitMeasure?.dFactor ?? 1;
    //     double value = rawValue.toDouble();

    //     if (dFactor != 0) {
    //       value = value / dFactor;
    //     }

    //     // If data is missing (0), default to 1 for visual representation if needed,
    //     // or keep as 0 if that's preferred. The user's original code used 1.
    //     if (value == 0) value = 1.0;

    //     switch (layer.name) {
    //       case "clay":
    //         clay = value;
    //         break;
    //       case "sand":
    //         sand = value;
    //         break;
    //       case "silt":
    //         silt = value;
    //         break;
    //       case "soc":
    //         organic = value;
    //         break;
    //     }
    //   }
    //   debugPrint(
    //     "Final Soil Analysis: clay=$clay, sand=$sand, silt=$silt, organic=$organic",
    //   );
    //   chartData.assignAll([
    //     ChartData('Organic', organic, AppColors.liteYellowColor),
    //     ChartData('Sand', sand, AppColors.darkGreenColor),
    //     ChartData('Silt', silt, AppColors.liteGreenColor),
    //     ChartData('Clay', clay, AppColors.toLiteGreenColor),
    //   ]);
    //   refreshSoilAnalysis.refresh();
    // } catch (e) {
    //   debugPrint("getSoilAnalysis Error ::: $e");
    // }
  }

  Future<void> pickImage({
    required bool isCamera,
    ImagePickerSource source = ImagePickerSource.diagnosis,
  }) async {
    try {
      print('pickImage t0 source: $source AND $isCamera');
      // Permission check
      if (isCamera) {
        bool hasPermission = await PermissionManager.handleCameraPermission();
        print('pickImage t0.5 hasPermission: $hasPermission');
        if (!hasPermission) {
          return;
        }
        print('pickImage t0.5 source: $source');
      }

      print('pickImage t1 source: $source');

      // Fetch location first if not available (only for diagnosis)
      if (source == ImagePickerSource.diagnosis && position == null) {
        print('pickImage t2');

        await getCurrentLocation();

        // Stop if still null
        if (position == null) {
          BaseSnackBar.show(
            title: 'Location Error',
            message: 'Unable to fetch location',
          );
          return;
        }
      }

      print('pickImage t3');

      if (isCamera && source == ImagePickerSource.diagnosis) {
        final result = await Get.toNamed(Routes.cameraCapture);
        if (result != null && result is XFile) {
          if (Get.isBottomSheetOpen ?? false) {
            Get.back();
          }
          goToPlantDiagnosis(result);
        }
        return;
      }

      final ImagePicker picker = ImagePicker();

      final XFile? pickedFile = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        requestFullMetadata: true,
        imageQuality: 10,
        preferredCameraDevice: CameraDevice.front,
      );

      print('pickImage t4');

      if (pickedFile != null && pickedFile.path.isNotEmpty) {
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }

        if (source == ImagePickerSource.diagnosis) {
          goToPlantDiagnosis(pickedFile);
        } else {
          goToLandscapeDesign(pickedFile);
        }
      }
    } catch (e) {
      print('pickImage t5');
      debugPrint("Error::: $e");
    }
  }

  // Future<void> pickImage({required bool isCamera}) async {
  //   try {
  //     print('getCurrentLocation t8');
  //     if (position != null || _isFetching) {
  //       print('getCurrentLocation t9');
  //       if (_isFetching && position == null) {
  //         BaseSnackBar.show(
  //           title: 'Please Wait',
  //           message: 'Location is being fetched. Please wait...',
  //         );
  //         print('getCurrentLocation t10');
  //         return;
  //       }
  //       print('getCurrentLocation t11');
  //       final ImagePicker picker = ImagePicker();
  //       final XFile? pickedFile = await picker.pickImage(
  //         source: isCamera ? ImageSource.camera : ImageSource.gallery,
  //         requestFullMetadata: true,
  //         imageQuality: 10,
  //         preferredCameraDevice: CameraDevice.front,
  //       );
  //       print('getCurrentLocation t12');
  //       if (pickedFile != null && pickedFile.path.isNotEmpty) {
  //         Get.back();
  //         if (position != null) {
  //           print('getCurrentLocation t13');
  //           goToPlantDiagnosis(pickedFile);
  //         } else {
  //           print('getCurrentLocation t14');
  //           await getCurrentLocation();
  //           goToPlantDiagnosis(pickedFile);
  //         }
  //       }
  //     } else {
  //       print('getCurrentLocation t15');
  //       getCurrentLocation();
  //     }
  //   } catch (e) {
  //     print('getCurrentLocation t16');
  //     debugPrint("Error:::$e");
  //   }
  // }
}
