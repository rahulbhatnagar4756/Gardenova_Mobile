import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
import 'package:kasagardem/dashboard/components/full_drawer.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plant_recommendations.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

import '../base/widgets/base_text.dart';
import 'components/ai_plan_diagnosis.dart';
import 'components/heading_ui_layout.dart';
import 'components/soil_analysis.dart';

class DashboardScreen extends GetWidget<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isUserLoggedIn.value =
          SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false;
    });
    return Obx(
      () => GestureDetector(
        onTap: () => controller.getCurrentLocation(),
        child: Scaffold(
          backgroundColor: AppColors.appColor,
          drawer: SizedBox(
            // width: MediaQuery.of(context).size.width * 0.9,
            child: FullScreenDrawer(
              onTap: (index) {
                controller.navigateToNext(index);
              },
            ),
          ),
          appBar: controller.isUserLoggedIn.value
              ? PreferredSize(
                  preferredSize: Size.fromHeight(spacerSize80),
                  child: Builder(
                    builder: (context) {
                      return CircularBottomAppBar(
                        showMenuIcon: true,
                        onSettingPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    },
                  ),
                )
              : BaseAppBar(
                  isBackButtonVisible: true,
                  title: AppLocalizations.of(context)!.report,
                  isAppIconVisible: false,
                ),

          body: Container(
            // color: Colors.red,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Obx(() {
                    controller.refreshSoilAnalysis.value;
                    return HeadingUiLayout(
                      sectionTitle: AppLocalizations.of(context)!.overview,
                      child: SoilAnalysis(chartData: controller.chartData),
                    );
                  }),
                  // const SizedBox(height: spacerSize15),
                  // HeadingUiLayout(
                  //   sectionTitle: AppLocalizations.of(
                  //     context,
                  //   )!.automationSuggestions,
                  //   child: AutomationSuggestions(),
                  // ),|
                  const SizedBox(height: spacerSize15),
                  HeadingUiLayout(
                    sectionTitle: AppLocalizations.of(
                      context,
                    )!.aIPlantDiagnosis,
                    child: AiPlantDiagnosisCard(
                      onTap: () {
                        openImagePickerBottomSheet();
                      },
                    ),
                  ),
                  const SizedBox(height: spacerSize15),
                  HeadingUiLayout(
                    sectionTitle: AppLocalizations.of(
                      context,
                    )!.plantRecommendations,
                    child: Column(
                      children: [PlantRecommendations(controller: controller)],
                    ),
                  ),
                ],
              ).marginOnly(left: spacerSize20, right: spacerSize20),
            ),
          ),

          bottomNavigationBar: Wrap(
            runSpacing: spacerSize5,
            children: [
              BaseButton(
                bottomPadding: true,
                buttonLabel: AppLocalizations.of(context)!.addPlant,
                // )!.viewRecommendedProfessionals,
                buttonWidth: Get.width,
                fontSize: fontSize15,
                onPressed: () {
                  Get.toNamed(Routes.allPlantsScreen);
                  return;
                  if (controller.isUserLoggedIn.value) {
                    Get.toNamed(
                      Routes.recommendedProfessionals,
                      arguments: {
                        "lat": controller.lat,
                        "lng": controller.long,
                      },
                      // arguments: controller.responseId,
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
                      title: AppLocalizations.of(
                        Get.context!,
                      )!.login.toUpperCase(),
                      description: AppLocalizations.of(
                        Get.context!,
                      )!.pleaseLoginToSeeRecommendedProfessionals,
                      buttonLabel: AppLocalizations.of(
                        Get.context!,
                      )!.login.toUpperCase(),
                    );
                  }
                },
              ),
              // BaseBackButton(),
            ],
          ).marginSymmetric(horizontal: spacerSize20),
        ),
      ),
    );
  }

  openImagePickerBottomSheet() {
    return Get.bottomSheet(
      Container(
        height: Get.height * .2,
        color: AppColors.offWhite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.greenColor),
              title: BaseText(text: AppLocalizations.of(Get.context!)!.camera),
              onTap: () async {
                // Get.back();
                controller.pickImage(isCamera: true);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.greenColor),
              title: BaseText(text: AppLocalizations.of(Get.context!)!.gallery),
              onTap: () async {
                // Get.back();
                controller.pickImage(isCamera: false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
