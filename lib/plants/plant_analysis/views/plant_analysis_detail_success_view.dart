import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_date_format.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/clickable_image.dart';
import 'package:kasagardem/base/widgets/expandable_text.dart';
import 'package:kasagardem/base/widgets/full_screen_image_preview.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/title_and_description_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_response_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/care_info_tile.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/causes_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/diagnosis_summary_card.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/similar_images_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/symptoms_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/taxonomy_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/toxicity_warning_card.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/treatment_section.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/base/widgets/status_bar_overlap_scroll_view.dart';
import 'package:kasagardem/plants/plant_analysis/model/plant_scan_detail_model.dart';
import 'package:kasagardem/plants/plant_analysis/plant_analysis_detail_controller.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class PlantAnalysisDetailSuccessView extends StatelessWidget {
  final PlantAnalysisDetailController controller;

  const PlantAnalysisDetailSuccessView({super.key, required this.controller});

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
    final detail = controller.detail.value!;
    final l10n = AppLocalizations.of(context)!;
    final diagnosis = detail.diagnosis;
    final plant = diagnosis?.plantInfo;
    final health = diagnosis?.healthStatus;
    final firstIssue = (health?.issues != null && health!.issues!.isNotEmpty)
        ? health.issues!.first
        : null;

    final plantName = detail.plantName.trim().isNotEmpty
        ? detail.plantName
        : (plant?.commonNames?.isNotEmpty == true
              ? plant!.commonNames!.first
              : AppStrings.unknownPlant);

    final heroTag = 'plant_scan_detail_${detail.id}';

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _heroImage(heroTag, detail),
        ),
        StatusBarOverlapScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (detail.hasImage) {
                    FullScreenImageView.open(
                      imageUrl: detail.imageUrl,
                      heroTag: heroTag,
                    );
                  }
                },
                child: Container(
                  height: spacerSize300,
                  color: Colors.transparent,
                ),
              ),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BaseText(
                                text: _toTitleCase(plantName),
                                fontFamily: AppKeys.poppins,
                                fontSize: fontSize20,
                                fontWeight: FontWeight.w700,
                              ),
                              if ((plant?.scientificName ?? '').isNotEmpty)
                                BaseText(
                                  text: plant!.scientificName!,
                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize14,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.greenColor,
                                ),
                            ],
                          ),
                        ),
                        SizedBox(width: spacerSize8),
                        CommonClickWidget(
                          onTap: controller.onCompareTap,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.linearGradientForBtn,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.greenColor.withValues(
                                    alpha: 0.25,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.compare_arrows_rounded,
                                  color: Colors.white,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  l10n.compare,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (detail.createdAt.isNotEmpty) ...[
                      SizedBox(height: spacerSize4),
                      BaseText(
                        text: timeAgo(detail.createdAt),
                        fontFamily: AppKeys.inter,
                        fontSize: fontSize12,
                        textColor: AppColors.liteGreyColor,
                      ),
                    ],
                    SizedBox(height: spacerSize16),
                    if ((plant?.description ?? '').isNotEmpty)
                      ExpandableText(
                        text: plant!.description!,
                        trimLines: 4,
                        textColor: AppColors.liteGreyColor,
                        lineHeight: 1.5,
                      ),
                    SizedBox(height: spacerSize24),
                    DiagnosisSummaryCard(
                      plantName: _toTitleCase(plantName),
                      isHealthy: health?.isHealthy ?? detail.isHealthy,
                      issueName:
                          firstIssue?.name ??
                          (detail.predictedDisease.isNotEmpty
                              ? detail.predictedDisease
                              : AppStrings.noDiseaseDetected),
                      confidence:
                          diagnosis?.confidence ?? detail.confidenceScore,
                    ),
                    if (plant?.taxonomy != null) ...[
                      SizedBox(height: spacerSize24),
                      TaxonomySection(taxonomy: plant!.taxonomy),
                    ],
                    if (firstIssue != null) ...[
                      SizedBox(height: spacerSize24),
                      SymptomsSection(issue: firstIssue),
                    ],
                    if (firstIssue?.causes?.isNotEmpty == true) ...[
                      SizedBox(height: spacerSize24),
                      CausesSection(causes: firstIssue!.causes!),
                    ],
                    if (firstIssue?.treatment != null) ...[
                      SizedBox(height: spacerSize24),
                      TreatmentSection(treatment: firstIssue!.treatment),
                    ],
                    if (plant?.careGuide != null) ...[
                      SizedBox(height: spacerSize24),
                      _careGuideSection(plant!),
                    ],
                    if ((plant?.uses ?? '').isNotEmpty) ...[
                      SizedBox(height: spacerSize24),
                      TitleAndDescriptionLayout(
                        title: AppLocalizations.of(context)!.uses,
                        description: plant!.uses,
                      ),
                    ],
                    if ((plant?.toxicity ?? '').isNotEmpty) ...[
                      SizedBox(height: spacerSize24),
                      ToxicityWarningCard(toxicity: plant!.toxicity!),
                    ],
                    if (plant?.images?.isNotEmpty == true) ...[
                      SizedBox(height: spacerSize24),
                      SimilarImagesSection(images: plant!.images!),
                    ],

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: spacerSize10,
              top: spacerSize16,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.black38,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: Get.back,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _heroImage(String heroTag, PlantScanDetail detail) {
    if (!detail.hasImage) {
      return Container(
        height: spacerSize350,
        width: double.infinity,
        color: AppColors.greenColor.withValues(alpha: 0.08),
        alignment: Alignment.center,
        child: Image.asset(
          AppAssets.appLogo,
          height: 72.w,
          width: 72.w,
          fit: BoxFit.contain,
        ),
      );
    }

    return ClickableImage(
      imageUrl: detail.imageUrl,
      height: spacerSize350,
      width: double.infinity,
      fit: BoxFit.cover,
      heroTag: heroTag,
      errorWidget: Container(
        color: AppColors.greenColor.withValues(alpha: 0.08),
        alignment: Alignment.center,
        child: Image.asset(
          AppAssets.appLogo,
          height: 72.w,
          width: 72.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _careGuideSection(PlantInfo plant) {
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
          value: (plant.careGuide?.watering ?? '').trim().isEmpty
              ? '-'
              : plant.careGuide!.watering!,
          icon: Icons.water_drop_outlined,
        ),
        SizedBox(height: 12.h),
        CareInfoTile(
          title: AppStrings.lightCondition,
          value: (plant.careGuide?.lightCondition ?? '').trim().isEmpty
              ? '-'
              : plant.careGuide!.lightCondition!,
          icon: Icons.sunny,
        ),
        SizedBox(height: 12.h),
        CareInfoTile(
          title: AppStrings.soilType,
          value: (plant.careGuide?.soilType ?? '').trim().isEmpty
              ? '-'
              : plant.careGuide!.soilType!,
          icon: Icons.grass,
        ),
      ],
    );
  }
}
