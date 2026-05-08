import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_view_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/ai_solution_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/care_info_tile.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/diagnosis_header.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/diagnosis_summary_card.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/similar_images_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/symptoms_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/taxonomy_section.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/treatment_section.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

import '../../base/widgets/clickable_image.dart';

class DiagnosisSuccessView extends StatelessWidget {
  final PlantDiagnosisViewModel controller;

  const DiagnosisSuccessView({super.key, required this.controller});

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
        : "Unknown Plant";

    /// 🛡️ SAFE IMAGE ACCESS
    final imageUrl = (plant.images != null && plant.images!.isNotEmpty)
        ? plant.images!.first
        : "";

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 30.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// =====================================================
          /// TOP IMAGE
          /// =====================================================
          if (imageUrl.isNotEmpty)
            ClickableImage(
              imageUrl: imageUrl,
              height: 320.h,
              width: double.infinity,
              fit: BoxFit.cover,
              heroTag: "diagnosis_main_image",
              borderRadius: BorderRadius.zero,
            )
          else
            Container(
              height: 320.h,
              width: double.infinity,
              color: AppColors.greenColor.withValues(alpha: .08),
              alignment: Alignment.center,
              child: Icon(
                Icons.image_not_supported_outlined,
                size: 50.sp,
                color: AppColors.greenColor,
              ),
            ),

          /// =====================================================
          /// MAIN CONTENT
          /// =====================================================
          Container(
            transform: Matrix4.translationValues(0, -30, 0),
            decoration: BoxDecoration(
              color: AppColors.appColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// =================================================
                  /// HEADER
                  /// =================================================
                  DiagnosisHeader(plant: plant),

                  SizedBox(height: 20.h),

                  /// =================================================
                  /// SUMMARY CARD
                  /// =================================================
                  DiagnosisSummaryCard(
                    plantName: plantName,
                    isHealthy: health?.isHealthy ?? false,
                    issueName: firstIssue?.name ?? "No disease detected",
                    confidence: data.confidence ?? 0,
                  ),

                  SizedBox(height: 20.h),

                  /// =================================================
                  /// TAXONOMY
                  /// =================================================
                  if (plant.taxonomy != null) ...[
                    TaxonomySection(taxonomy: plant.taxonomy),

                    SizedBox(height: 20.h),
                  ],

                  /// =================================================
                  /// SYMPTOMS
                  /// =================================================
                  if (firstIssue != null) ...[
                    SymptomsSection(issue: firstIssue),

                    SizedBox(height: 20.h),
                  ],

                  /// =================================================
                  /// TREATMENT
                  /// =================================================
                  if (firstIssue?.treatment != null) ...[
                    TreatmentSection(treatment: firstIssue!.treatment),

                    SizedBox(height: 20.h),
                  ],

                  /// =================================================
                  /// CARE GUIDE
                  /// =================================================
                  CareInfoTile(
                    title: "Watering",
                    value: (plant.careGuide?.watering ?? "").trim().isEmpty
                        ? "-"
                        : plant.careGuide!.watering!,
                    icon: Icons.water_drop_outlined,
                  ),

                  SizedBox(height: 12.h),

                  CareInfoTile(
                    title: "Light Condition",
                    value:
                        (plant.careGuide?.lightCondition ?? "").trim().isEmpty
                        ? "-"
                        : plant.careGuide!.lightCondition!,
                    icon: Icons.sunny,
                  ),

                  SizedBox(height: 12.h),

                  CareInfoTile(
                    title: "Soil Type",
                    value: (plant.careGuide?.soilType ?? "").trim().isEmpty
                        ? "-"
                        : plant.careGuide!.soilType!,
                    icon: Icons.grass,
                  ),

                  SizedBox(height: 20.h),

                  /// =================================================
                  /// SIMILAR IMAGES
                  /// =================================================
                  if (plant.images != null && plant.images!.isNotEmpty) ...[
                    SimilarImagesSection(images: plant.images!),

                    SizedBox(height: 20.h),
                  ],

                  /// =================================================
                  /// AI SOLUTIONS
                  /// =================================================
                  if (data.kasagardemSolutions != null &&
                      data.kasagardemSolutions!.isNotEmpty)
                    AiSolutionSection(solutions: data.kasagardemSolutions!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
