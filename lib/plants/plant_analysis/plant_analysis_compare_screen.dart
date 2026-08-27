import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/dashboard/views/diagnosis_error_view.dart';
import 'package:kasagardem/dashboard/views/diagnosis_loading_view.dart';
import 'package:kasagardem/plants/plant_analysis/components/plant_scan_compare_sheet.dart';
import 'package:kasagardem/plants/plant_analysis/plant_analysis_compare_controller.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

class PlantAnalysisCompareScreen extends GetView<PlantAnalysisCompareController> {
  const PlantAnalysisCompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: AppColors.appColor,
          body: DiagnosisLoadingView(
            imageFile: controller.imageFile.value,
            isApiComplete: controller.isApiComplete.value,
            onComplete: controller.onLoadingAnimationComplete,
          ),
        );
      }

      final previousPlant = controller.previousPlant.value;
      final currentPlant = controller.currentPlant.value;
      if (previousPlant == null || currentPlant == null) {
        return Scaffold(
          backgroundColor: AppColors.appColor,
          body: DiagnosisErrorView(
            message: controller.errorMessage.value.isNotEmpty
                ? controller.errorMessage.value
                : 'Unable to compare plant scans',
            onRetry: controller.compareScans,
          ),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.appColor,
        body: PlantScanCompareView(controller: controller),
      );
    });
  }
}
