/// =========================================================
/// FILE: plants_diagnostic/widgets/ai_solution_section.dart
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

class AiSolutionSection extends StatelessWidget {
  final List<KasagardemSolutions> solutions;

  const AiSolutionSection({
    super.key,
    required this.solutions,
  });

  @override
  Widget build(BuildContext context) {
    if (solutions.isEmpty) return const SizedBox();

    return Column(
      children: List.generate(
        solutions.length,
            (index) {
          final item = solutions[index];

          return Padding(
            padding: EdgeInsets.only(bottom: 18.h),
            child: DiagnosisSectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    text: item.automationFeature ?? "",
                    fontWeight: FontWeight.bold,
                    fontFamily: AppKeys.poppins,
                    fontSize: fontSize18,
                  ),

                  SizedBox(height: 12.h),

                  BaseText(
                    text: item.howItHelps ?? "",
                    textColor: AppColors.liteGreyColor,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}