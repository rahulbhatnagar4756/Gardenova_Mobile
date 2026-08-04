/// =========================================================
/// FILE: plants_diagnostic/widgets/diagnosis_chip.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

class DiagnosisChip extends StatelessWidget {
  final String label;

  const DiagnosisChip({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.toToLiteGreenColor,
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: BaseText(text: label),
    );
  }
}