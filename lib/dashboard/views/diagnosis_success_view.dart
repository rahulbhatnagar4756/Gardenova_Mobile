import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/base/widgets/full_screen_image_preview.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_view_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/ai_solution_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/care_info_tile.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/diagnosis_summary_card.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/similar_images_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/symptoms_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/taxonomy_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/treatment_section.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

import '../../base/widgets/clickable_image.dart';
import '../../base/widgets/expandable_text.dart';
import '../../base/widgets/status_bar_overlap_scroll_view.dart';

class DiagnosisSuccessView extends StatelessWidget {
  final PlantDiagnosisViewModel controller;

  const DiagnosisSuccessView({super.key, required this.controller});

  String _toTitleCase(String text) {
    if (text.isEmpty) return text;
    return text
        .split(RegExp(r'\s+|-'))
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final data = controller.plantDiagnosisResponse.value.data;

    /// 🛡️ SAFETY CHECK
    if (data == null || data.plantInfo == null) {
      return const SizedBox();
    }

    final plant = data.plantInfo!;
    final health = data.healthStatus;

    /// 🛡️ SAFE ISSUE ACCESS
    final firstIssue = (health?.issues != null && health!.issues!.isNotEmpty)
        ? health.issues!.first
        : null;

    /// 🛡️ SAFE NAME ACCESS
    final plantName =
        (plant.commonNames != null && plant.commonNames!.isNotEmpty)
        ? plant.commonNames!.first
        : AppStrings.unknownPlant;

    /// 🛡️ SAFE IMAGE ACCESS
    final imageUrl = (plant.images != null && plant.images!.isNotEmpty)
        ? plant.images!.first
        : "";

    return Stack(
      children: [
        /// =====================================================
        /// TOP IMAGE
        /// =====================================================
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              if (imageUrl.isNotEmpty) {
                FullScreenImageView.open(
                  imageUrl: imageUrl,
                  heroTag: "diagnosis_main_image",
                );
              }
            },
            child: imageCard(imageUrl),
          ),
        ),

        /// =====================================================
        /// MAIN CONTENT (SCROLLABLE)
        /// =====================================================
        StatusBarOverlapScrollView(
          child: Column(
            children: [
              // Transparent spacer to allow image to show
              GestureDetector(
                onTap: () {
                  if (imageUrl.isNotEmpty) {
                    FullScreenImageView.open(
                      imageUrl: imageUrl,
                      heroTag: "diagnosis_main_image",
                    );
                  }
                },
                child: Container(
                  height: spacerSize300,
                  color: Colors.transparent,
                ),
              ),

              // Content Card
              Container(
                padding: EdgeInsets.all(spacerSize20),
                decoration: const BoxDecoration(
                  color: AppColors.appColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(spacerSize30),
                  ),
                  border: Border(
                    top: BorderSide(color: AppColors.greenColor, width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// =================================================
                    /// HEADER (Name & Add Plant Button)
                    /// =================================================
                    plantTitleRow(context, plant),

                    SizedBox(height: spacerSize16),

                    /// =================================================
                    /// DESCRIPTION
                    /// =================================================
                    if (plant.description != null &&
                        plant.description!.isNotEmpty)
                      ExpandableText(
                        text: plant.description!,
                        trimLines: 4,
                        textColor: AppColors.liteGreyColor,
                        lineHeight: 1.5,
                      ),

                    SizedBox(height: spacerSize24),

                    /// =================================================
                    /// TAXONOMY
                    /// =================================================
                    if (plant.taxonomy != null) ...[
                      TaxonomySection(taxonomy: plant.taxonomy),
                      SizedBox(height: spacerSize24),
                    ],

                    /// =================================================
                    /// SUMMARY CARD
                    /// =================================================
                    DiagnosisSummaryCard(
                      plantName: plantName,
                      isHealthy: health?.isHealthy ?? false,
                      issueName:
                          firstIssue?.name ?? AppStrings.noDiseaseDetected,
                      confidence: data.confidence ?? 0,
                    ),

                    SizedBox(height: spacerSize24),

                    /// =================================================
                    /// SYMPTOMS
                    /// =================================================
                    if (firstIssue != null) ...[
                      SymptomsSection(issue: firstIssue),
                      SizedBox(height: spacerSize24),
                    ],

                    /// =================================================
                    /// TREATMENT
                    /// =================================================
                    if (firstIssue?.treatment != null) ...[
                      TreatmentSection(treatment: firstIssue!.treatment),
                      SizedBox(height: spacerSize24),
                    ],

                    /// =================================================
                    /// CARE GUIDE SECTION
                    /// =================================================
                    careGuideSection(context, plant),

                    SizedBox(height: spacerSize24),

                    /// =================================================
                    /// SIMILAR IMAGES
                    /// =================================================
                    if (plant.images != null && plant.images!.isNotEmpty) ...[
                      SimilarImagesSection(images: plant.images!),
                      SizedBox(height: spacerSize24),
                    ],

                    /// =================================================
                    /// AI SOLUTIONS
                    /// =================================================
                    if (data.kasagardemSolutions != null &&
                        data.kasagardemSolutions!.isNotEmpty)
                      AiSolutionSection(solutions: data.kasagardemSolutions!),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// =====================================================
        /// BACK BUTTON
        /// =====================================================
        backButton(),
      ],
    );
  }

  Widget imageCard(String imageUrl) {
    return Container(
      color: AppColors.charcoalGrey,
      child: imageUrl.isNotEmpty
          ? ClickableImage(
              imageUrl: imageUrl,
              height: spacerSize350,
              width: double.infinity,
              fit: BoxFit.cover,
              heroTag: "diagnosis_main_image",
            )
          : Container(
              height: spacerSize350,
              width: double.infinity,
              color: AppColors.greenColor.withValues(alpha: .08),
              alignment: Alignment.center,
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 50.sp,
                color: AppColors.greenColor,
              ),
            ),
    );
  }

  Widget plantTitleRow(BuildContext context, dynamic plant) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseText(
                text: _toTitleCase(
                  plant.commonNames?.join(", ") ?? AppStrings.unknownPlant,
                ),
                fontFamily: AppKeys.poppins,
                fontSize: fontSize20,
                fontWeight: FontWeight.w700,
              ),
              if (plant.scientificName != null)
                BaseText(
                  text: plant.scientificName!,
                  fontFamily: AppKeys.inter,
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.greenColor,
                ),
            ],
          ),
        ),

        // Add Plant Button (UI Only for now)
        CommonClickWidget(
          onTap: () {
            // Functionality to be implemented in the future
            BaseSnackBar.show(
              title: AppStrings.comingSoon,
              message: AppStrings.addPlantFunctionalityWillBeAvailableSoon,
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            decoration: BoxDecoration(
              gradient: AppColors.linearGradientForBtn,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greenColor.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Text(
              AppLocalizations.of(context)!.addPlant,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget careGuideSection(BuildContext context, dynamic plant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText(
          text: AppStrings.careGuide,
          fontSize: fontSize18,
          fontWeight: FontWeight.bold,
          fontFamily: AppKeys.poppins,
        ),
        SizedBox(height: spacerSize12),
        CareInfoTile(
          title: AppStrings.watering,
          value: (plant.careGuide?.watering ?? "").trim().isEmpty
              ? "-"
              : plant.careGuide!.watering!,
          icon: Icons.water_drop_outlined,
        ),
        SizedBox(height: 12.h),
        CareInfoTile(
          title: AppStrings.lightCondition,
          value: (plant.careGuide?.lightCondition ?? "").trim().isEmpty
              ? "-"
              : plant.careGuide!.lightCondition!,
          icon: Icons.sunny,
        ),
        SizedBox(height: 12.h),
        CareInfoTile(
          title: AppStrings.soilType,
          value: (plant.careGuide?.soilType ?? "").trim().isEmpty
              ? "-"
              : plant.careGuide!.soilType!,
          icon: Icons.grass,
        ),
      ],
    );
  }

  Widget backButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: spacerSize10, top: spacerSize16),
        child: CircleAvatar(
          backgroundColor: Colors.black38,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
      ),
    );
  }
}
