import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kasagardem/plants/allPlants/add_plants_list/add_plants_controller.dart';
import 'package:kasagardem/plants/model/plant_info_item.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

import '../../../base/widgets/base_date_format.dart';
import '../../../dashboard/dashboard_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/admob_service.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/routes.dart';
import '../../model/plant_details_model.dart';
import '../../myPlants/myPlantsList/my_plants_controller.dart';
import '../../plant_repository.dart';
import 'components/plant_add_success_dialog.dart';

enum CareType { watering, fertilizing, pruning, critical }

class AllPlantsDetailsController extends GetxController {
  RxBool isWateringOn = false.obs;
  RxBool isFertilizingOn = false.obs;
  RxBool isPruningOn = false.obs;
  RxBool isCriticalOn = false.obs;
  RxBool isLoading = false.obs;
  RxBool isAdLoaded = false.obs;
  bool showMore = false;
  RxString plantId = "".obs;
  RxString screenType = "".obs;
  RxInt wateringFrequency = 0.obs;
  RxInt fertilizingFrequency = 0.obs;
  RxInt pruningFrequency = 0.obs;
  RxInt criticalCareFrequency = 0.obs;
  RxString wateringTime = "".obs;
  RxString fertilizingTime = "".obs;
  RxString pruningTime = "".obs;
  RxString criticalTime = "".obs;
  RxString userPlantId = "".obs;
  RxString errorMessage = "".obs;
  RxString wateringNote = "".obs;
  RxString fertilizingNote = "".obs;
  RxString pruningNote = "".obs;
  RxString criticalNote = "".obs;

  PlantsRepository plantsRepository = PlantsRepository();
  Rx<PlantDetailsResponseModel> plantDetailData = PlantDetailsResponseModel().obs;
  final List<int> frequencyOptions = [1, 2, 3, 5, 7, 10, 15, 20, 30, 45, 60, 90];
  RxList<PlantInfoItem> plantInfoList = <PlantInfoItem>[].obs;
  BannerAd? bannerAd;

  TextEditingController pruningController = TextEditingController();
  TextEditingController fertilizeController = TextEditingController();
  TextEditingController wateringController = TextEditingController();
  TextEditingController criticalController = TextEditingController();

  @override
  void onInit() {
    if (Get.arguments != null) {
      plantId.value = Get.arguments['plant_id'].toString();
      screenType.value = Get.arguments['screen_type'].toString();

      print("value screenType ${screenType.value}");
    }
    debugPrint('AllPlantsDetailsController plantId $plantId and screenType $screenType');
    if (screenType.value == "add") {
      callGetPlantDetailsApi();
    } else {
      callGetMyPlantDetailsApi();
    }
    //   loadBannerAd();
    super.onInit();
  }

  void loadBannerAd() {
    if (!AdMobService.instance.shouldShowBanners) {
      isAdLoaded.value = false;
      return;
    }
    bannerAd = AdMobService.instance.loadBannerAd(
      onAdLoaded: (ad) {
        isAdLoaded.value = true;
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        isAdLoaded.value = false;
        debugPrint('BannerAd failed to load: $error');
      },
    );
  }

  void setPlantInfoData(PlantModelDetails plantDetails) {
    plantInfoList.add(
      PlantInfoItem(icon: Icons.eco_outlined, label: 'Type', value: plantDetails.type ?? ''),
    );

    plantInfoList.add(
      PlantInfoItem(
        icon: Icons.keyboard_arrow_down,
        label: 'Height',
        value: "${plantDetails.dimensionMinValue} - ${plantDetails.dimensionMaxValue} ft",
      ),
    );

    plantInfoList.add(
      PlantInfoItem(
        icon: Icons.wb_sunny_outlined,
        label: 'Sunlight',
        value: (plantDetails.sunlight?.toString() ?? "").capitalizeFirst ?? "",
      ),
    );
    plantInfoList.add(
      PlantInfoItem(
        icon: Icons.thermostat,
        label: 'Hardiness',
        value: "USDA ${plantDetails.hardinessMin ?? ""} - ${plantDetails.hardinessMax ?? ""}",
      ),
    );
  }

  @override
  void onClose() {
    bannerAd?.dispose();
    super.onClose();
  }

  void toggleWatering(bool value) {
    isWateringOn.value = !isWateringOn.value;
    wateringFrequency.value = 0;
    wateringTime.value = "";
    wateringController.clear();
    wateringNote.value = "";
  }

  void toggleFertilizing(bool value) {
    isFertilizingOn.value = !isFertilizingOn.value;
    fertilizingFrequency.value = 0;
    fertilizingTime.value = "";
    fertilizeController.clear();
    fertilizingNote.value = "";
  }

  void togglePruning(bool value) {
    isPruningOn.value = !isPruningOn.value;
    pruningFrequency.value = 0;
    pruningTime.value = "";
    pruningController.clear();
    pruningNote.value = "";
  }

  void toggleCritical(bool value) {
    isCriticalOn.value = !isCriticalOn.value;
    criticalCareFrequency.value = 0;
    criticalTime.value = "";
    criticalController.clear();
    criticalNote.value = "";
  }

  void validateAndSubmit(BuildContext context) {
    if (screenType.value != "add") {
      if (!isWateringOn.value &&
          !isFertilizingOn.value &&
          !isPruningOn.value &&
          !isCriticalOn.value) {
        BaseSnackBar.show(
          title: appName,
          message: AppLocalizations.of(context)!.selectAtLeastOneReminder,
        );
        return;
      }

      if (isWateringOn.value) {
        if (wateringFrequency.value == 0) {
          BaseSnackBar.show(
            title: appName,
            message: AppLocalizations.of(context)!.selectWateringFrequency,
          );
          return;
        }
        if (wateringTime.isEmpty) {
          BaseSnackBar.show(
            title: appName,
            message: AppLocalizations.of(context)!.selectWateringTime,
          );
          return;
        }
      }

      if (isFertilizingOn.value) {
        if (fertilizingFrequency.value == 0) {
          BaseSnackBar.show(
            title: appName,
            message: AppLocalizations.of(context)!.selectFertilizerFrequency,
          );
          return;
        }
        if (fertilizingTime.isEmpty) {
          BaseSnackBar.show(
            title: appName,
            message: AppLocalizations.of(context)!.selectFertilizerTime,
          );
          return;
        }
      }

      if (isPruningOn.value) {
        if (pruningFrequency.value == 0) {
          BaseSnackBar.show(
            title: appName,
            message: AppLocalizations.of(context)!.selectPruningFrequency,
          );
          return;
        }
        if (pruningTime.isEmpty) {
          BaseSnackBar.show(title: appName, message: AppStrings.selectPruningTime);
          return;
        }
      }

      if (isCriticalOn.value) {
        if (criticalCareFrequency.value == 0) {
          BaseSnackBar.show(
            title: appName,
            message: AppLocalizations.of(context)!.selectGeneralFrequency,
          );
          return;
        }
        if (criticalTime.isEmpty) {
          BaseSnackBar.show(title: appName, message: AppStrings.selectCriticalCareTime);
          return;
        }
      }
    }
    if (screenType.value == "add") {
      callAddPlantApi();
    } else {
      callEditPlantApi();
    }
  }

  void setDataForUpdate() {
    setPlantInfoData(plantDetailData.value.data!.plant!);
    isWateringOn.value = plantDetailData.value.data?.reminder?.wateringNotificationEnabled ?? false;
    isFertilizingOn.value =
        plantDetailData.value.data?.reminder?.fertilizerNotificationEnabled ?? false;
    isPruningOn.value = plantDetailData.value.data?.reminder?.pruningNotificationEnabled ?? false;
    isCriticalOn.value = plantDetailData.value.data?.reminder?.genericNotificationEnabled ?? false;
    wateringFrequency.value = plantDetailData.value.data?.reminder?.wateringReminderFrequency ?? 0;
    wateringNote.value = plantDetailData.value.data?.reminder?.wateringNote ?? "";
    fertilizingNote.value = plantDetailData.value.data?.reminder?.fertilizerNote ?? "";
    pruningNote.value = plantDetailData.value.data?.reminder?.pruningNote ?? "";
    wateringController.text = plantDetailData.value.data?.reminder?.wateringNote ?? "";
    fertilizeController.text = plantDetailData.value.data?.reminder?.fertilizerNote ?? "";
    pruningController.text = plantDetailData.value.data?.reminder?.pruningNote ?? "";

    fertilizingFrequency.value =
        plantDetailData.value.data?.reminder?.fertilizerReminderFrequency ?? 0;
    pruningFrequency.value = plantDetailData.value.data?.reminder?.pruningReminderFrequency ?? 0;
    criticalCareFrequency.value =
        plantDetailData.value.data?.reminder?.genericCareReminderFrequency ?? 0;
    wateringTime.value = plantDetailData.value.data?.reminder?.wateringPreferredTime ?? "";
    fertilizingTime.value = plantDetailData.value.data?.reminder?.fertilizerPreferredTime ?? "";
    pruningTime.value = plantDetailData.value.data?.reminder?.pruningPreferredTime ?? "";
    criticalTime.value = plantDetailData.value.data?.reminder?.genericPreferredTime ?? "";
  }

  Future<void> pickerTime(BuildContext context, CareType careType) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),

      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.white,
                dialBackgroundColor: AppColors.darkGreen.withValues(alpha: 0.08),
                dialHandColor: AppColors.darkGreen,
                dialTextColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return Colors.green;
                }),
                hourMinuteColor: AppColors.darkGreen.withValues(alpha: 0.12),
                hourMinuteTextColor: Colors.green,
                dayPeriodColor: AppColors.darkGreen.withValues(alpha: 0.12),
                dayPeriodTextColor: Colors.green,
                confirmButtonStyle: TextButton.styleFrom(
                  foregroundColor: AppColors.darkGreen,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                cancelButtonStyle: TextButton.styleFrom(foregroundColor: Colors.green.shade600),
              ),
              colorScheme: const ColorScheme.light(
                primary: AppColors.darkGreen,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),

            child: Localizations.override(
              context: context,
              locale: const Locale('en', 'US'),
              child: child!,
            ),
          ),
        );
      },
    );

    if (picked == null) return;

    print(picked);
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
    final formatted = BaseDateTimeFormat.format(dateTime: dateTime.toString(), format: "HH:mm");

    switch (careType) {
      case CareType.watering:
        wateringTime.value = formatted;
        break;
      case CareType.fertilizing:
        fertilizingTime.value = formatted;
        break;
      case CareType.pruning:
        pruningTime.value = formatted;
        break;
      case CareType.critical:
        criticalTime.value = formatted;
        break;
    }
  }

  Future callGetPlantDetailsApi() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      var response = await plantsRepository.fetchPlantDetail(plantId: plantId.value);
      if (response != null) {
        plantDetailData.value = PlantDetailsResponseModel.fromJson(response);
        if (plantDetailData.value.data == null) {
          errorMessage.value = "No plant details found";
        }
      } else {
        errorMessage.value = "Failed to fetch plant details";
      }
    } catch (e) {
      errorMessage.value = "Something went wrong: $e";
    } finally {
      isLoading.value = false;
    }
  }

  String getType(CareType type) {
    switch (type) {
      case CareType.watering:
        return "Watering";
      case CareType.fertilizing:
        return "Fertilizing";
      case CareType.pruning:
        return "Pruning";
      case CareType.critical:
        return "Generic Care";
    }
  }

  Future callGetMyPlantDetailsApi() async {
    isLoading.value = true;
    errorMessage.value = "";
    try {
      var response = await plantsRepository.fetchMyPlantDetail(plantId: plantId.value);
      if (response != null) {
        userPlantId.value = response['data']['user_plant_id'].toString();
        debugPrint("userPlantId:::: ${userPlantId.value}");
        plantDetailData.value = PlantDetailsResponseModel.fromJson(response);
        debugPrint("response of plantDetailData::::: ${plantDetailData.value.data!.toJson()}");
        if (plantDetailData.value.data == null) {
          errorMessage.value = "No plant details found";
        } else {
          setDataForUpdate();
        }
      } else {
        errorMessage.value = "Failed to fetch plant details";
      }
    } catch (e) {
      errorMessage.value = "Something went wrong: $e";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> callAddPlantApi() async {
    final map = <String, dynamic>{
      "plant_id": plantId.value,
      "watering_notification_enabled": isWateringOn.value,
      "watering_reminder_frequency": wateringFrequency.value,
      "watering_preferred_time": wateringTime.value,
      "fertilizer_notification_enabled": isFertilizingOn.value,
      "fertilizer_reminder_frequency": fertilizingFrequency.value,
      "fertilizer_preferred_time": fertilizingTime.value,
      "pruning_notification_enabled": isPruningOn.value,
      "pruning_reminder_frequency": pruningFrequency.value,
      "pruning_preferred_time": pruningTime.value,
      "generic_notification_enabled": isCriticalOn.value,
      "generic_care_reminder_frequency": criticalCareFrequency.value,
    };
    map.removeWhere((key, value) {
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      if (value is int && value == 0) return true;
      if (value is bool && value == false) return true;
      return false;
    });
    debugPrint("Filtered map :::::: $map");
    final response = await plantsRepository.addPlant(addPlantReq: map);
    if (response != null) {
      AllPlantsController? myPlantsController;
      if (Get.isRegistered<AllPlantsController>()) {
        myPlantsController = Get.find<AllPlantsController>();
        myPlantsController.allPlantList.removeWhere(
          (element) => element.id?.toString() == plantId.value,
        );
        myPlantsController.allPlantList.refresh();
      }
      if (Get.isRegistered<DashboardController>()) {
        var dashboardController = Get.find<DashboardController>();
        dashboardController.plantRecommendationList.removeWhere(
          (element) => element.id?.toString() == plantId.value,
        );
        dashboardController.plantRecommendationList.refresh();
      }
      plantDetailData.value.data?.alreadyAdded = true;
      plantDetailData.refresh();
      PlantAddSuccessDialog.show(
        Get.context!,
        title: plantDetailData.value.data!.plant!.commonName ?? "",
        image: plantDetailData.value.data!.plant!.imageUrl ?? "",
        description: "",
        // description: plantDetailData.value.data!.plant!.description ?? "",
        buttonLabel: AppLocalizations.of(Get.context!)!.gotoMyPlants,
        onButtonPressed: () async {
          if (Get.isRegistered<MyPlantsController>()) {
            // Get.back();
            // Get.back();
            // Get.back();
            Get.until((route) => route.settings.name == Routes.allPlantsScreen);
          } else {
            Get.back();
            await Future.delayed(Duration(milliseconds: 100));
            Get.offNamed(Routes.myPlantsScreen);
          }
        },
      );
    }
    if (Get.isRegistered<MyPlantsController>()) {
      Get.find<MyPlantsController>().callGetMyPlantListApi();
    }
  }

  Future<void> callEditPlantApi() async {
    final map = _buildChangedBlockEditPlantMap();

    debugPrint("Filtered map :::::: $map");

    if (map.isEmpty) {
      Get.back(result: true);
      return;
    }

    final response = await plantsRepository.editPlant(
      userPlantId: userPlantId.value,
      editPlantReq: map,
    );
    debugPrint("response::::: callEditPlantApi $response");
    if (response != null) {
      Get.back(result: true);
      if (Get.isRegistered<MyPlantsController>()) {
        Get.find<MyPlantsController>().callGetMyPlantListApi();
      }
    }
  }

  static const List<String> _wateringEditKeys = [
    'watering_notification_enabled',
    'watering_reminder_frequency',
    'watering_preferred_time',
    'watering_note',
  ];

  static const List<String> _fertilizerEditKeys = [
    'fertilizer_notification_enabled',
    'fertilizer_reminder_frequency',
    'fertilizer_preferred_time',
    'fertilizer_note',
  ];

  static const List<String> _pruningEditKeys = [
    'pruning_notification_enabled',
    'pruning_reminder_frequency',
    'pruning_preferred_time',
    'pruning_note',
  ];

  static const List<String> _genericEditKeys = [
    'generic_notification_enabled',
    'generic_care_reminder_frequency',
    'generic_care_preferred_time',
    'generic_note',
  ];

  Map<String, dynamic> _buildChangedBlockEditPlantMap() {
    final current = _buildEditPlantRequestMap();
    final original = _buildOriginalEditPlantMap();
    final changedMap = <String, dynamic>{};

    void addBlockIfChanged(List<String> keys) {
      final hasChange = keys.any((key) => !_isSameEditPlantValue(current[key], original[key]));
      if (!hasChange) return;

      for (final key in keys) {
        changedMap[key] = current[key];
      }
    }

    addBlockIfChanged(_wateringEditKeys);
    addBlockIfChanged(_fertilizerEditKeys);
    addBlockIfChanged(_pruningEditKeys);
    addBlockIfChanged(_genericEditKeys);

    return changedMap;
  }

  Map<String, dynamic> _buildEditPlantRequestMap() {
    return {
      "plant_id": plantId.value,
      "watering_notification_enabled": isWateringOn.value,
      "watering_reminder_frequency": wateringFrequency.value,
      "watering_preferred_time": wateringTime.value,
      "fertilizer_notification_enabled": isFertilizingOn.value,
      "fertilizer_reminder_frequency": fertilizingFrequency.value,
      "fertilizer_preferred_time": fertilizingTime.value,
      "pruning_preferred_time": pruningTime.value,
      "generic_care_preferred_time": criticalTime.value,
      "pruning_notification_enabled": isPruningOn.value,
      "pruning_reminder_frequency": pruningFrequency.value,
      "generic_notification_enabled": isCriticalOn.value,
      "generic_care_reminder_frequency": criticalCareFrequency.value,
      "watering_note": wateringController.text,
      "fertilizer_note": fertilizeController.text,
      "pruning_note": pruningController.text,
      "generic_note": criticalController.text,
    };
  }

  Map<String, dynamic> _buildOriginalEditPlantMap() {
    final reminder = plantDetailData.value.data?.reminder;

    return {
      "plant_id": plantId.value,
      "watering_notification_enabled": reminder?.wateringNotificationEnabled ?? false,
      "watering_reminder_frequency": reminder?.wateringReminderFrequency ?? 0,
      "watering_preferred_time": reminder?.wateringPreferredTime ?? "",
      "fertilizer_notification_enabled": reminder?.fertilizerNotificationEnabled ?? false,
      "fertilizer_reminder_frequency": reminder?.fertilizerReminderFrequency ?? 0,
      "fertilizer_preferred_time": reminder?.fertilizerPreferredTime ?? "",
      "pruning_preferred_time": reminder?.pruningPreferredTime ?? "",
      "generic_care_preferred_time": reminder?.genericPreferredTime ?? "",
      "pruning_notification_enabled": reminder?.pruningNotificationEnabled ?? false,
      "pruning_reminder_frequency": reminder?.pruningReminderFrequency ?? 0,
      "generic_notification_enabled": reminder?.genericNotificationEnabled ?? false,
      "generic_care_reminder_frequency": reminder?.genericCareReminderFrequency ?? 0,
      "watering_note": reminder?.wateringNote ?? "",
      "fertilizer_note": reminder?.fertilizerNote ?? "",
      "pruning_note": reminder?.pruningNote ?? "",
      "generic_note": reminder?.genericCareNote ?? "",
    };
  }

  bool _isSameEditPlantValue(dynamic current, dynamic original) {
    if (current is String || original is String) {
      return _normalizeEditPlantString(current) == _normalizeEditPlantString(original);
    }

    if (current is bool || original is bool) {
      return _toBool(current) == _toBool(original);
    }

    if (current is num || original is num) {
      return _toNum(current) == _toNum(original);
    }

    return current == original;
  }

  String _normalizeEditPlantString(dynamic value) {
    final text = (value ?? '').toString().trim();
    final parts = text.split(':');

    if (parts.length >= 2) {
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour != null && minute != null) {
        return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      }
    }

    return text;
  }

  bool _toBool(dynamic value) => value == true;

  num _toNum(dynamic value) {
    if (value is num) return value;
    return num.tryParse(value?.toString() ?? '') ?? 0;
  }
}
