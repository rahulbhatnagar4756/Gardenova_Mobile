/// =========================================================
/// FILE: plants_diagnostic/widgets/health_score_card.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_response_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/diagnosis_section_card.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class HealthScoreCard extends StatelessWidget {
  final HealthStatus? healthStatus;

  const HealthScoreCard({super.key, required this.healthStatus});

  @override
  Widget build(BuildContext context) {
    final score = (healthStatus?.healthProbability ?? 0).toDouble();

    return DiagnosisSectionCard(
      child: Column(
        children: [
          BaseText(
            text: (healthStatus?.isHealthy ?? false) == true
                ? AppStrings.plantLooksHealthyWithEmoji
                : AppStrings.plantNeedsAttention,
            fontFamily: AppKeys.poppins,
            fontWeight: FontWeight.w700,
            fontSize: fontSize18,
          ),

          SizedBox(height: 18.h),

          LinearProgressIndicator(
            value: score / 100,
            minHeight: 12.h,
            borderRadius: BorderRadius.circular(30.r),
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(
              (healthStatus?.isHealthy ?? false) == true
                  ? AppColors.greenColor
                  : AppColors.orangeColor,
            ),
          ),

          SizedBox(height: 10.h),

          BaseText(
            text: "${score.toStringAsFixed(0)}% ${AppStrings.healthScore}",
            textColor: AppColors.liteGreyColor,
          ),
        ],
      ),
    );
  }
}
