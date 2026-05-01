import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_view_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class SimilarPlantsLayout extends StatelessWidget {
  const SimilarPlantsLayout({super.key, this.plantDiagnosisViewModel});

  final PlantDiagnosisViewModel? plantDiagnosisViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText(
          text: AppLocalizations.of(context)!.similarPlants,
          fontFamily: AppKeys.poppins,
          fontWeight: FontWeight.bold,
          textColor: AppColors.burntGoldLight,
          textAlign: TextAlign.left,
          fontSize: fontSize18,
        ),

        Obx(
          () => BaseBorderedContainer(
            height: Get.height * .23,
            padding: EdgeInsets.all(spacerSize5),
            childWidget:
                plantDiagnosisViewModel!.plantDiagnosisResponse.value.data !=
                    null
                ? plantDiagnosisViewModel!
                              .plantDiagnosisResponse
                              .value
                              .data!
                              .plantInfo!
                              .images!
                              .isEmpty &&
                          !plantDiagnosisViewModel!.isLoading.value
                      ? Center(
                          child: BaseText(
                            text: AppLocalizations.of(
                              context,
                            )!.noPlantRecommendationsFound,
                            textAlign: TextAlign.center,
                            fontFamily: AppKeys.poppins,
                            textColor: Colors.white,
                            fontSize: fontSize15,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      : GridView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: plantDiagnosisViewModel!.isLoading.value
                              ? 5
                              : plantDiagnosisViewModel!
                                    .plantDiagnosisResponse
                                    .value
                                    .data!
                                    .plantInfo!
                                    .images!
                                    .length,
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(spacerSize15),
                              child: plantDiagnosisViewModel!.isLoading.value
                                  ? const BaseShimmer()
                                  : CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: plantDiagnosisViewModel!
                                          .plantDiagnosisResponse
                                          .value
                                          .data!
                                          .plantInfo!
                                          .images![index],
                                      placeholder: (context, url) =>
                                          const BaseShimmer(),
                                      errorWidget: (context, url, error) {
                                        return BaseBorderedContainer(
                                          height: Get.height * .23,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(spacerSize10),
                                          childWidget: Icon(
                                            Icons.broken_image_rounded,
                                            size: spacerSize40,
                                            color: AppColors.offWhite10,
                                          ),
                                        );
                                      },
                                    ).marginAll(spacerSize2),
                            );
                          },
                          shrinkWrap: true,
                          physics: const AlwaysScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                              ),
                        )
                : SizedBox(),
          ),
        ),
      ],
    );
  }
}
