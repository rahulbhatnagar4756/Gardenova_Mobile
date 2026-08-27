import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/plants/plant_analysis/plant_analysis_detail_controller.dart';
import 'package:kasagardem/plants/plant_analysis/views/plant_analysis_detail_error_view.dart';
import 'package:kasagardem/plants/plant_analysis/views/plant_analysis_detail_loading_view.dart';
import 'package:kasagardem/plants/plant_analysis/views/plant_analysis_detail_success_view.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

class PlantAnalysisDetailScreen extends GetView<PlantAnalysisDetailController> {
  const PlantAnalysisDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const PlantAnalysisDetailLoadingView();
      }

      final error = controller.errorMessage.value;
      if (error != null && error.isNotEmpty) {
        return PlantAnalysisDetailErrorView(
          message: error,
          onRetry: controller.fetchDetail,
        );
      }

      final detail = controller.detail.value;
      if (detail == null) {
        return PlantAnalysisDetailErrorView(
          message: 'Unable to load plant analysis',
          onRetry: controller.fetchDetail,
        );
      }

      return Scaffold(
        backgroundColor: AppColors.appColor,
        body: PlantAnalysisDetailSuccessView(controller: controller),
      );
    });
  }
}
