import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import '../components/full_drawer.dart';
import '../views/diagnosis_error_view.dart';
import '../views/diagnosis_loading_view.dart';
import '../views/diagnosis_success_view.dart';
import '../views/no_plant_detected_view.dart';

class PlantDiagnosisScreen extends GetWidget<PlantDiagnosisViewModel> {
  const PlantDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final response = controller.plantDiagnosisResponse.value;
      final data = response.data;

      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: AppColors.appColor,
          body: DiagnosisLoadingView(
            imageFile: controller.imageFile?.value,
            isApiComplete: controller.isApiComplete.value,
            onComplete: controller.onLoadingAnimationComplete,
          ),
        );
      }

      /// API FAILED
      if (data == null) {
        return Scaffold(
          backgroundColor: AppColors.appColor,
          body: DiagnosisErrorView(
            message: response.message ?? "Unable to analyze plant",
            onRetry: () {
              controller.diagnosePlant();
            },
          ),
        );
      }

      /// NOT A PLANT
      if (controller.isCurrentImagePlant.value == false) {
        return const Scaffold(
          backgroundColor: AppColors.appColor,
          body: NoPlantDetectedView(),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.appColor,
        drawer: SizedBox(
          child: FullScreenDrawer(
            onTap: (index) {
              controller.navigateToNext(index);
            },
          ),
        ),
        body: DiagnosisSuccessView(controller: controller),
      );
    });
  }
}
