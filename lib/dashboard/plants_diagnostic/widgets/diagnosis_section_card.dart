
/// =========================================================
/// FILE: plants_diagnostic/widgets/diagnosis_section_card.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

class DiagnosisSectionCard extends StatelessWidget {
  final Widget child;

  const DiagnosisSectionCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: AppColors.liteGreenColor.withValues(alpha: .3),
        ),
      ),
      child: child,
    );
  }
}