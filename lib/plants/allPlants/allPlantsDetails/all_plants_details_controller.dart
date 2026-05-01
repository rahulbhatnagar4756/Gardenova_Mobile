import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import '../../../base/widgets/base_date_format.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_constants.dart';
import '../../model/plant_details_model.dart';
import '../../plant_repository.dart';
import 'components/plant_add_success_dialog.dart';

enum CareType { watering, fertilizing, pruning, critical }

class AllPlantsDetailsController extends GetxController {
  RxBool isWateringOn = false.obs;
  RxBool isFertilizingOn = false.obs;
  RxBool isPruningOn = false.obs;
  RxBool isCriticalOn = false.obs;
  RxString plantId = "".obs;
  RxString screenType = "".obs;
  RxInt wateringFrequency = 0.obs;
  RxInt fertilizingFrequency = 0.obs;
  RxInt pruningFrequency = 0.obs;
  RxInt criticalCareFrequency = 0.obs;
  RxString wateringTime = "".obs;
  RxString fertilizingTime = "".obs;
  RxString userPlantId = "".obs;
  PlantsRepository plantsRepository = PlantsRepository();
  Rx<PlantDetailsResponseModel> plantDetailData =
      PlantDetailsResponseModel().obs;
  final List<int> frequencyOptions = [1, 2, 3, 5, 7, 10, 15, 20, 30, 45, 60, 90];

  @override
  void onInit() {
    if (Get.arguments != null) {
      plantId.value = Get.arguments['plant_id'].toString();
      screenType.value = Get.arguments['screen_type'].toString();
    }
    if (screenType.value == "add") {
      callGetPlantDetailsApi();
    } else {
      callGetMyPlantDetailsApi();
    }
    super.onInit();
  }

  void toggleWatering(bool value) {
    isWateringOn.value = !isWateringOn.value;
    wateringFrequency.value = 0;
    wateringTime.value = "";
  }

  void toggleFertilizing(bool value) {
    isFertilizingOn.value = !isFertilizingOn.value;
    fertilizingFrequency.value = 0;
    fertilizingTime.value = "";
  }

  void togglePruning(bool value) {
    isPruningOn.value = !isPruningOn.value;
    pruningFrequency.value = 0;
  }

  void toggleCritical(bool value) {
    isCriticalOn.value = !isCriticalOn.value;
    criticalCareFrequency.value = 0;
  }

  void validateAndSubmit(BuildContext context) {
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
    }

    if (isCriticalOn.value) {
      if (criticalCareFrequency.value == 0) {
        BaseSnackBar.show(
          title: appName,
          message: AppLocalizations.of(context)!.selectGeneralFrequency,
        );
        return;
      }
    }
    if (screenType.value == "add") {
      callAddPlantApi();
    } else {
      callEditPlantApi();
    }
  }

  void setDataForUpdate() {
    isWateringOn.value =
        plantDetailData.value.data?.reminder?.wateringNotificationEnabled ??
        false;
    isFertilizingOn.value =
        plantDetailData.value.data?.reminder?.fertilizerNotificationEnabled ??
        false;
    isPruningOn.value =
        plantDetailData.value.data?.reminder?.pruningNotificationEnabled ??
        false;
    isCriticalOn.value =
        plantDetailData.value.data?.reminder?.genericNotificationEnabled ??
        false;
    wateringFrequency.value =
        plantDetailData.value.data?.reminder?.wateringReminderFrequency ?? 0;
    fertilizingFrequency.value =
        plantDetailData.value.data?.reminder?.fertilizerReminderFrequency ?? 0;
    pruningFrequency.value =
        plantDetailData.value.data?.reminder?.pruningReminderFrequency ?? 0;
    criticalCareFrequency.value =
        plantDetailData.value.data?.reminder?.genericCareReminderFrequency ?? 0;
    wateringTime.value =
        plantDetailData.value.data?.reminder?.wateringPreferredTime ?? "";
    fertilizingTime.value =
        plantDetailData.value.data?.reminder?.fertilizerPreferredTime ?? "";
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
                dialBackgroundColor: AppColors.darkGreen.withValues(
                  alpha: 0.08,
                ),
                dialHandColor: AppColors.darkGreen,
                dialTextColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return Colors.black87;
                }),
                hourMinuteColor: AppColors.darkGreen.withValues(alpha: 0.12),
                hourMinuteTextColor: Colors.black87,
                dayPeriodColor: AppColors.darkGreen.withValues(alpha: 0.12),
                dayPeriodTextColor: Colors.black87,
                confirmButtonStyle: TextButton.styleFrom(
                  foregroundColor: AppColors.darkGreen,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                cancelButtonStyle: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade600,
                ),
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
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      picked.hour,
      picked.minute,
    );
    final formatted = BaseDateTimeFormat.format(
      dateTime: dateTime.toString(),
      format: "hh:mm:ss",
    );

    switch (careType) {
      case CareType.watering:
        wateringTime.value = formatted;
        break;
      case CareType.fertilizing:
        fertilizingTime.value = formatted;
        break;
      case CareType.pruning:
        break;
      case CareType.critical:
        break;
    }
  }

  Future callGetPlantDetailsApi() async {
    var response = await plantsRepository.fetchPlantDetail(
      plantId: plantId.value,
    );
    if (response != null) {
      plantDetailData.value = PlantDetailsResponseModel.fromJson(response);
    }
  }

  Future callGetMyPlantDetailsApi() async {
    var response = await plantsRepository.fetchMyPlantDetail(
      plantId: plantId.value,
    );
    if (response != null) {
      userPlantId.value = response['data']['user_plant_id'].toString();
      debugPrint("userPlantId:::: ${userPlantId.value}");
      plantDetailData.value = PlantDetailsResponseModel.fromJson(response);
      setDataForUpdate();
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
      PlantAddSuccessDialog.show(
        Get.context!,
        title: plantDetailData.value.data!.plant!.commonName ?? "",
        image: plantDetailData.value.data!.plant!.imageUrl ?? "",
        description: plantDetailData.value.data!.plant!.description ?? "",
        buttonLabel: AppLocalizations.of(Get.context!)!.gotoMyPlants,
        onButtonPressed: () => Get.back(),
      );
    }
  }

  Future<void> callEditPlantApi() async {
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
      "generic_notification_enabled": isCriticalOn.value,
      "generic_care_reminder_frequency": criticalCareFrequency.value,
    };
    debugPrint("Filtered map :::::: $map");
    final response = await plantsRepository.editPlant(
      userPlantId: userPlantId.value,
      editPlantReq: map,
    );
    debugPrint("response:::::$response");
    if (response != null) {
      Get.back(result: true);
    }
  }
}
