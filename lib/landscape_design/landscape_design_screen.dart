import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';
import 'landscape_design_view_model.dart';
import 'views/error_view.dart';
import 'views/loading_view.dart';
import 'views/processing_view.dart';
import 'views/success_view.dart';

class LandscapeDesignScreen extends GetWidget<LandscapeDesignViewModel> {
  const LandscapeDesignScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return LandscapeDesignLoadingView(
          imageFile: controller.imageFile?.value,
          isApiComplete: controller.isApiComplete.value,
          onComplete: controller.onLoadingAnimationComplete,
        );
      }

      if (controller.isRegenerating.value) {
        return LandscapeDesignProcessingView(
          imageFile: controller.imageFile?.value,
          isApiComplete: controller.isApiComplete.value,
          onComplete: controller.onLoadingAnimationComplete,
        );
      }

      if (controller.errorMessage.isNotEmpty) {
        return LandscapeDesignErrorView(
          errorMessage: controller.errorMessage.value,
          onRetry: () => controller.generateLandscapeDesign(),
        );
      }

      if (controller.landscapeResponse.value.data == null) {
        return LandscapeDesignErrorView(
          errorMessage: AppStrings.noDesignDataFound.tr,
          onRetry: () => controller.generateLandscapeDesign(),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: LandscapeDesignSuccessView(controller: controller),
      );
    });
  }
}
