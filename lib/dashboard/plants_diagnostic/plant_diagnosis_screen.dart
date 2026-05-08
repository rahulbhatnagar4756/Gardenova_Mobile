import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
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
      final bool isSuccess = !controller.isLoading.value && 
                             data != null && 
                             controller.isCurrentImagePlant.value == true;

      return Scaffold(
        backgroundColor: AppColors.appColor,
        drawer: SizedBox(
          child: FullScreenDrawer(
            onTap: (index) {
              controller.navigateToNext(index);
            },
          ),
        ),
        appBar: isSuccess 
            ? null 
            : PreferredSize(
                preferredSize: Size.fromHeight(110.h + 30.h),
                child: Builder(
                  builder: (context) {
                    return CircularBottomAppBar(
                      isBackButtonVisible: true,
                      showMenuIcon: true,
                      onSettingPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
              ),
        body: isSuccess 
            ? DiagnosisSuccessView(controller: controller)
            : SafeArea(
                child: () {
                  if (controller.isLoading.value) {
                    return const DiagnosisLoadingView();
                  }

                  /// API FAILED
                  if (data == null) {
                    return DiagnosisErrorView(
                      message: response.message ?? "Unable to analyze plant",
                      onRetry: () {
                        controller.diagnosePlant();
                      },
                    );
                  }

                  /// NOT A PLANT
                  if (controller.isCurrentImagePlant.value == false) {
                    return const NoPlantDetectedView();
                  }

                  return const SizedBox();
                }(),
              ),
      );
    });
  }
}
