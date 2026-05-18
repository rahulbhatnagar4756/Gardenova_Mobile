import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
import 'package:kasagardem/dashboard/components/ai_plan_diagnosis.dart';
import 'package:kasagardem/dashboard/components/bottom_navigation_widget.dart';
import 'package:kasagardem/dashboard/components/landscape_design_card.dart';
import 'package:kasagardem/dashboard/components/full_drawer.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plant_recommendations.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import '../base/dialogs/base_dialog.dart';
import '../base/widgets/base_text.dart';
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
        onTap: () => controller.onScreenClick(),
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
                  onBackPressed: () {
                    Get.offAllNamed(
                      Routes.login,
                      arguments: {"question_state_passed": true},
                    );
                  },
                ),

          body: SizedBox(
            // color: Colors.red,
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Obx(() {
                        controller.refreshSoilAnalysis.value;
                        return HeadingUiLayout(
                          sectionTitle: AppLocalizations.of(context)!.overview,
                          child: SoilAnalysis(chartData: controller.chartData),
                        ).marginOnly(left: spacerSize20, right: spacerSize20);
                      }),
                      // const SizedBox(height: spacerSize15),
                      // HeadingUiLayout(
                      //   sectionTitle: AppLocalizations.of(
                      //     context,
                      //   )!.automationSuggestions,
                      //   child: AutomationSuggestions(),
                      // ),|
                      const SizedBox(height: spacerSize15),
                      AiPlantDiagnosisCard(
                        onTap: () {
                          openImagePickerBottomSheet(
                            source: ImagePickerSource.diagnosis,
                          );
                        },
                      ).marginOnly(left: spacerSize20, right: spacerSize20),
                      const SizedBox(height: spacerSize15),
                      LandscapeDesignCard(
                        onTap: () {
                          openImagePickerBottomSheet(
                            source: ImagePickerSource.landscape,
                          );
                        },
                      ).marginOnly(left: spacerSize20, right: spacerSize20),
                      const SizedBox(height: spacerSize15),
                      HeadingUiLayout(
                        titleLeftPadding: spacerSize20,
                        sectionTitle: AppLocalizations.of(
                          context,
                        )!.plantRecommendations,
                        child: Column(
                          children: [
                            PlantRecommendations(controller: controller),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.h),
                      Obx(
                        () => controller.isUserLoggedIn.value == false
                            ? SizedBox()
                            : Container(
                                width: double.infinity,
                                color: AppColors.blackColor.withValues(
                                  alpha: 0.6,
                                ),
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: BaseButton(
                                  bottomPadding: false,
                                  buttonLabel: AppLocalizations.of(
                                    context,
                                  )!.addPlant,
                                  buttonWidth: Get.width,
                                  fontSize: fontSize15,
                                  onPressed: () {
                                    Get.toNamed(Routes.allPlantsScreen);
                                    return;
                                  },
                                ).paddingSymmetric(horizontal: spacerSize20),
                              ),
                      ),
                      SizedBox(height: 110.h),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8.h,
                  left: 0,
                  right: 0,
                  child: Obx(() {
                    return BottomNavigationWidget(
                      selectNavType: controller.selectedNavType.value,
                      needToShow: controller.isUserLoggedIn.value,
                      onAddPlantClick: (p0) {
                        if (p0 != BottomNavType.scan &&
                            p0 != BottomNavType.report) {
                          controller.selectedNavType.value = p0;
                        }
                        if (p0 == BottomNavType.report) {
                          BaseSnackBar.show(
                            title: 'Temporarily Unavailable',
                            message:
                                'The Report section is currently on hold. We’ll be back soon with updates.',
                          );
                        }
                        switch (p0) {
                          case BottomNavType.home:
                            break;
                          case BottomNavType.scan:
                            openImagePickerBottomSheet(
                              source: ImagePickerSource.diagnosis,
                            );
                            break;
                          case BottomNavType.plant:
                            Get.toNamed(Routes.myPlantsScreen)?.then((value) {
                              controller.selectedNavType.value =
                                  BottomNavType.home;
                            });
                            break;
                          case BottomNavType.report:
                            break;
                          case BottomNavType.profile:
                            Get.toNamed(Routes.settings)?.then((value) {
                              controller.selectedNavType.value =
                                  BottomNavType.home;
                            });
                            break;
                        }
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openImagePickerBottomSheet({
    ImagePickerSource source = ImagePickerSource.diagnosis,
  }) {
    if (controller.isUserLoggedIn.value == false) {
      BaseDialog.showAlertDialog(
        context: Get.context!,
        onButtonPressed: () {
          Get.back();
          Get.offAllNamed(
            Routes.login,
            arguments: {"question_state_passed": true},
          );
        },
        title: AppLocalizations.of(Get.context!)!.login.toUpperCase(),
        description: source == ImagePickerSource.diagnosis
            ? AppStrings.pleaseLoginToSeeAiDiagnosis
            : AppStrings.pleaseLoginToMakeAiLandscapeDesign,
        buttonLabel: AppLocalizations.of(Get.context!)!.login.toUpperCase(),
      );
      return;
    }

    Get.bottomSheet(
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
                Get.back();
                await Future.delayed(Duration(milliseconds: 200));
                controller.pickImage(isCamera: true, source: source);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.greenColor),
              title: BaseText(text: AppLocalizations.of(Get.context!)!.gallery),
              onTap: () async {
                Get.back();
                await Future.delayed(Duration(milliseconds: 200));
                controller.pickImage(isCamera: false, source: source);
              },
            ),
          ],
        ),
      ),
    ).then((value) {
      controller.selectedNavType.value = BottomNavType.home;
      controller.selectedNavType.refresh();
    });
  }
}
