import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/expansion_tile_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/plant_detail_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/plant_health_and_prevention_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/similar_plants_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/title_and_description_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_view_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';

class PlantDiagnosisScreen extends GetWidget<PlantDiagnosisViewModel> {
  const PlantDiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: Obx(
        () => Stack(
          children: [
            controller.plantDiagnosisResponse.value.data != null &&
                    controller.isCurrentImagePlant.value
                ? CachedNetworkImage(
                    imageUrl:
                        controller.plantDiagnosisResponse.value.data != null
                        ? controller
                              .plantDiagnosisResponse
                              .value
                              .data!
                              .plantInfo!
                              .images![0]
                        : "",
                    height: Get.height * .45,
                    placeholder: (context, url) =>
                        BaseShimmer(height: Get.height * .45),
                    errorWidget: (context, url, error) {
                      return BaseBorderedContainer(
                        height: Get.height * .335,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(spacerSize10),
                        childWidget: Icon(
                          Icons.broken_image_rounded,
                          size: spacerSize40,
                          color: AppColors.offWhite10,
                        ),
                      );
                    },
                    useOldImageOnUrlChange: true,
                    width: Get.width,
                    fit: BoxFit.fill,
                  )
                : controller.isLoading.value
                ? BaseShimmer()
                : SizedBox(),
            CircularBottomAppBar(
              backgroundColor: AppColors.darkGreen,
              onSettingPressed: () {
                Get.toNamed(Routes.settings);
              },
            ),
          ],
        ),
      ),
      bottomSheet: BottomSheet(
        backgroundColor: AppColors.appColor,
        builder: (context) => Obx(
          () => controller.isLoading.value
              ? SizedBox()
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: Get.width,
                  child: SingleChildScrollView(
                    child:
                        controller.isLoading.value == false &&
                            controller.isCurrentImagePlant.value == false
                        ? Center(
                            child: BaseText(
                              text: AppLocalizations.of(
                                context,
                              )!.noPlantDataAvailable,
                              fontSize: fontSize20,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                              textColor: AppColors.offWhite,
                              fontFamily: AppKeys.merriweather,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: spacerSize15,
                            children: [
                              PlantDetailLayout(
                                plantDiagnosisViewModel: controller,
                              ),
                              SimilarPlantsLayout(
                                plantDiagnosisViewModel: controller,
                              ),

                              TitleAndDescriptionLayout(
                                title: AppLocalizations.of(Get.context!)!.uses,
                                description:
                                    controller
                                            .plantDiagnosisResponse
                                            .value
                                            .data !=
                                        null
                                    ? controller
                                          .plantDiagnosisResponse
                                          .value
                                          .data!
                                          .plantInfo!
                                          .uses
                                    : "",
                              ),
                              TitleAndDescriptionLayout(
                                title: AppLocalizations.of(
                                  Get.context!,
                                )!.toxicity,
                                description:
                                    controller
                                            .plantDiagnosisResponse
                                            .value
                                            .data !=
                                        null
                                    ? controller
                                          .plantDiagnosisResponse
                                          .value
                                          .data!
                                          .plantInfo!
                                          .toxicity
                                    : "",
                              ),

                              if (controller
                                          .plantDiagnosisResponse
                                          .value
                                          .data!
                                          .healthStatus!
                                          .isHealthy ==
                                      false &&
                                  controller
                                      .plantDiagnosisResponse
                                      .value
                                      .data!
                                      .healthStatus!
                                      .issues!
                                      .isNotEmpty)
                                PlantHealthAndPreventionLayout(
                                  plantDiagnosisViewModel: controller,
                                ),
                              ExpansionTileLayout(
                                childWidget: diagnosisLayout(),
                                title: AppLocalizations.of(
                                  Get.context!,
                                )!.kasagardemPlantDiagnosis,
                              ),
                            ],
                          ),
                  ).marginAll(spacerSize20),
                ),
        ),
        enableDrag: false,
        onClosing: () {},
      ),
    );
  }

  diagnosisLayout() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TitleAndDescriptionLayout(
            title: AppLocalizations.of(Get.context!)!.issue,
            spacing: spacerSize5,
            description: controller.issue.value,
          ),
          TitleAndDescriptionLayout(
            title: AppLocalizations.of(Get.context!)!.automationFeature,
            spacing: spacerSize5,
            description: controller.automationFeature.value,
          ),
          TitleAndDescriptionLayout(
            title: AppLocalizations.of(Get.context!)!.howItHelps,
            spacing: spacerSize5,
            description: controller.howItHelps.value,
          ),
          TitleAndDescriptionLayout(
            title: AppLocalizations.of(Get.context!)!.benefits,
            spacing: spacerSize5,
            description: controller.benefits.value,
          ),
          TitleAndDescriptionLayout(
            title: AppLocalizations.of(Get.context!)!.howToSetup,
            spacing: spacerSize5,
            description: controller.setup.value,
          ),
        ],
      ),
    );
  }
}
