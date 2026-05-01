import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/plants/allPlants/allPlantsDetails/all_plants_details_controller.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../../../base/widgets/base_text.dart';
import '../../../../l10n/app_localizations.dart';

class FrequencyBottomSheet extends StatelessWidget {
  final AllPlantsDetailsController controller;
  final CareType careType;

  const FrequencyBottomSheet({
    super.key,
    required this.controller,
    required this.careType,
  });

  static void show(AllPlantsDetailsController controller, CareType careType) {
    Get.bottomSheet(
      isScrollControlled: true,
      FrequencyBottomSheet(controller: controller, careType: careType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(spacerSize20),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        border: Border(
          top: BorderSide(color: AppColors.offWhite10, width: spacerSize2),
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(spacerSize28),
          topRight: Radius.circular(spacerSize28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaseText(
                text: AppLocalizations.of(context)!.selectFrequency,
                fontFamily: AppKeys.inter,
                fontWeight: FontWeight.w500,
                textColor: AppColors.darkGold,
                fontSize: fontSize16,
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),

      ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: controller.frequencyOptions.length,
        separatorBuilder: (context, index) =>
            Divider(color: AppColors.offWhite10),
        itemBuilder: (context, index) {
          final value = controller.frequencyOptions[index];

          return GestureDetector(
            onTap: () {
              updateFrequency(value);
              Get.back();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: spacerSize6),
              child: BaseText(
                text: _getFrequencyText(value),
                fontFamily: AppKeys.inter,
                fontWeight: FontWeight.w500,
                textColor: Colors.white,
                fontSize: fontSize15,
              ),
            ),
          );
        },
      ),
        ],
      ),
    );
  }

  String _getFrequencyText(int value) {
    final loc = AppLocalizations.of(Get.context!)!;
    final dayText = value == 1 ? loc.day : loc.days;
    return '${loc.every} $value $dayText';
  }

  String getSelectedValue() {
    switch (careType) {
      case CareType.watering:
        return controller.wateringFrequency.value.toString();
      case CareType.fertilizing:
        return controller.fertilizingFrequency.value.toString();
      case CareType.pruning:
        return controller.pruningFrequency.value.toString();
      case CareType.critical:
        return controller.criticalCareFrequency.value.toString();
    }
  }

  void updateFrequency(int value) {
    switch (careType) {
      case CareType.watering:
        controller.wateringFrequency.value = value;
        break;
      case CareType.fertilizing:
        controller.fertilizingFrequency.value = value;
        break;
      case CareType.pruning:
        controller.pruningFrequency.value = value;
        break;
      case CareType.critical:
        controller.criticalCareFrequency.value = value;
        break;
    }
  }
}
