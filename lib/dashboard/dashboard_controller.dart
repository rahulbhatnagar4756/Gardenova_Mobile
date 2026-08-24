import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasagardem/dashboard/components/bottom_navigation_widget.dart';
import 'package:kasagardem/dashboard/components/soil_analysis.dart';
import 'package:kasagardem/dashboard/dashboard_repository.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plant_recommendations_response_model.dart';
import 'package:kasagardem/dashboard/model/garden_insights_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

import '../base/dialogs/base_dialog.dart';
import '../services/admob_service.dart';
import '../services/subscription_service.dart';
import '../settings/settings_view_model.dart';
import '../utils/constants/app_color.dart';
import '../utils/constants/app_constants.dart';
import '../utils/location_helper/location_service.dart';
import '../utils/permission_manager.dart';
import '../utils/utils.dart';

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

  var chartData = <ChartData>[].obs;
  var isLoadingGardenInsights = true.obs;

  BannerAd? bannerAd;
  RxBool isAdLoaded = false.obs;

  @override
  void onInit() {
    SubscriptionService.instance.checkAndRecoverPendingPurchases();
    responseId = Get.arguments.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupBannerAds();
      getPlantsRecommendations(responseId);
      getGardenInsights();
      isUserLoggedIn.value = sharedPrefsService.getBool(AppKeys.isLoggedIn) ?? false;
    });

    super.onInit();
  }

  void _setupBannerAds() {
    if (Get.isRegistered<SettingsViewModel>()) {
      final settingsVm = Get.find<SettingsViewModel>();
      ever(settingsVm.currentSubscriptionStatusModel, (_) => loadBannerAd());
    }
    loadBannerAd();
  }

  void loadBannerAd() async {
    if (!AdMobService.instance.shouldShowBanners) {
      bannerAd?.dispose();
      bannerAd = null;
      isAdLoaded.value = false;
      return;
    }

    isAdLoaded.value = false;
    final ad = await AdMobService.instance.loadBannerAd(
      existingAd: bannerAd,
      onAdLoaded: (ad) {
        bannerAd = ad as BannerAd;
        isAdLoaded.value = true;
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        bannerAd = null;
        isAdLoaded.value = false;
        debugPrint('BannerAd failed to load: $error');
      },
    );
    if (ad != null) {
      bannerAd = ad;
    }
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }

  void navigateToNext(int index) {
    debugPrint("index:::$index");
    switch (index) {
      case 0:
        refreshSoilAnalysis.refresh();
        getGardenInsights();
        Get.back();
        break;
      case 1:
        if (isUserLoggedIn.value) {
          Get.toNamed(Routes.recommendedProfessionals, arguments: {"lat": lat, "lng": long});
        } else {
          BaseDialog.showAlertDialog(
            context: Get.context!,
            onButtonPressed: () {
              Get.back();
              Get.toNamed(Routes.login, arguments: {"question_state_passed": true});
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
        Utils.callSettingBasicApi();
        Get.toNamed(Routes.profile);
        break;
      case 7:
        Get.back();
        Utils.callSettingBasicApi();
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
        /*ApiKeys.latitude: position!.latitude,
        ApiKeys.longitude: position!.longitude,*/
        ApiKeys.imagePath: pickedFile!.path,
      },
    );
  }

  void goToLandscapeDesign(XFile? pickedFile, String? selectedStyle) {
    Get.toNamed(
      Routes.landscapeDesign,
      arguments: {ApiKeys.imagePath: pickedFile!.path, "selected_style": selectedStyle},
    );
  }

  void getPlantsRecommendations(String responseId) async {
    String recommendationId = sharedPrefsService.getString(AppKeys.submissionResponseId) ?? '';
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
      plantRecommendationList.value = recommendationsResponse.data!.plantRecommendations ?? [];
      _scrollToFirstIndex();
    }
    isLoading.value = false;
  }

  void _scrollToFirstIndex() {
    try {
      if (plantRecController.hasClients && plantRecController.position.hasPixels) {
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

  Future<void> getGardenInsights() async {
    isLoadingGardenInsights.value = true;
    try {
      final response = await dashboardRepository.fetchGardenInsights();
      if (response == null) return;

      final model = GardenInsightsResponseModel.fromJson(
        Map<String, dynamic>.from(response),
      );
      if (model.success != true || model.data?.chart == null) return;

      final mapped = <ChartData>[];
      final items = model.data!.chart!;
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final label = item.label?.trim().isNotEmpty == true
            ? item.label!.trim()
            : (item.key ?? '');
        if (label.isEmpty) continue;
        mapped.add(
          ChartData(label, item.percent ?? 0, _colorForInsight(item.key, i)),
        );
      }
      chartData.assignAll(mapped);
      refreshSoilAnalysis.refresh();
    } catch (e) {
      debugPrint('Garden insights error: $e');
    } finally {
      isLoadingGardenInsights.value = false;
    }
  }

  Color _colorForInsight(String? key, int index) {
    switch (key) {
      case 'lightFit':
        return AppColors.organicColor;
      case 'waterConsistency':
        return AppColors.liteGreenColor;
      case 'experienceReadiness':
        return AppColors.sandColor;
      case 'spaceUtilization':
        return AppColors.siltColor;
      case 'growthPotential':
        return AppColors.clayColor;
      default:
        const fallback = [
          AppColors.sandColor,
          AppColors.liteGreenColor,
          AppColors.organicColor,
          AppColors.siltColor,
          AppColors.clayColor,
        ];
        return fallback[index % fallback.length];
    }
  }

  Future<void> getSoilAnalysis({required double lat, required double long}) async {
    return getGardenInsights();
  }

  Future<void> pickImage({
    required bool isCamera,
    ImagePickerSource source = ImagePickerSource.diagnosis,
    String? selectedStyle,
  }) async {
    try {
      // Permission check
      if (isCamera) {
        bool hasPermission = await PermissionManager.handleCameraPermission();
        if (!hasPermission) {
          return;
        }
      }

      // Fetch location first if not available (only for diagnosis)
      if (source == ImagePickerSource.diagnosis && position == null) {
        // await getCurrentLocation();

        // Stop if still null
        /*  if (position == null) {
          BaseSnackBar.show(title: 'Location Error', message: 'Unable to fetch location');
          return;
        }*/
      }

      if (isCamera && source == ImagePickerSource.diagnosis) {
        final result = await Get.toNamed(Routes.cameraCapture);
        if (result != null && result is XFile) {
          if (Get.isBottomSheetOpen ?? false) {
            Get.back();
          }
          _showAdAndProceed(() {
            goToPlantDiagnosis(result);
          });
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

      if (pickedFile != null && pickedFile.path.isNotEmpty) {
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }

        _showAdAndProceed(() {
          if (source == ImagePickerSource.diagnosis) {
            goToPlantDiagnosis(pickedFile);
          } else {
            goToLandscapeDesign(pickedFile, selectedStyle);
          }
        });
      }
    } catch (e) {
      debugPrint("Error::: $e");
    }
  }

  void _showAdAndProceed(VoidCallback onProceed) {
    if (!AdMobService.instance.shouldShowRewarded) {
      onProceed();
      return;
    }

    // Show loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: AppColors.greenColor)),
      barrierDismissible: false,
    );

    bool hasProceeded = false;
    bool earnedReward = false;

    // Helper to dismiss loading and proceed
    void proceed() {
      if (!hasProceeded) {
        hasProceeded = true;
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
        onProceed();
      }
    }

    // Helper to just close loading dialog (without proceeding)
    void cancel() {
      if (!hasProceeded) {
        hasProceeded = true; // prevent any subsequent actions
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      }
    }

    AdMobService.instance.showRewardedAd(
      onUserEarnedReward: () {
        earnedReward = true;
      },
      onAdDismissed: () {
        if (earnedReward) {
          proceed();
        } else {
          cancel();
        }
      },
      onAdFailedToShow: () {
        proceed();
      },
    );
  }
}
