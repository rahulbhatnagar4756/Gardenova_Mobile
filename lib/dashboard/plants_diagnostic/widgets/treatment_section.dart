/// =========================================================
/// FILE: plants_diagnostic/widgets/treatment_section.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_response_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/diagnosis_section_card.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/treatment_step_tile.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class TreatmentSection extends StatelessWidget {
  final Treatment? treatment;

  const TreatmentSection({
    super.key,
    required this.treatment,
  });

  @override
  Widget build(BuildContext context) {
    if (treatment == null) return const SizedBox();

    return DiagnosisSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: "Treatment Guide",
            fontWeight: FontWeight.w700,
            fontFamily: AppKeys.poppins,
            fontSize: fontSize18,
          ),

          SizedBox(height: 16.h),

          ...List.generate(
            treatment!.immediate?.length ?? 0,
                (index) => TreatmentStepTile(
              step: treatment!.immediate![index],
            ),
          ),
        ],
      ),
    );
  }
}