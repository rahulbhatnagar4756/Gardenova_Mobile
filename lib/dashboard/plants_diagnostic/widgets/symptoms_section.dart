/// =========================================================
/// FILE: plants_diagnostic/widgets/symptoms_section.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_response_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/diagnosis_chip.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/diagnosis_section_card.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class SymptomsSection extends StatelessWidget {
  final Issues issue;

  const SymptomsSection({
    super.key,
    required this.issue,
  });

  @override
  Widget build(BuildContext context) {
    return DiagnosisSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: issue.name ?? "Issue",
            fontFamily: AppKeys.poppins,
            fontWeight: FontWeight.bold,
            fontSize: fontSize18,
          ),

          SizedBox(height: 12.h),

          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              ...(issue.symptoms ?? [])
                  .map((e) => DiagnosisChip(label: e))
            ],
          ),
        ],
      ),
    );
  }
}