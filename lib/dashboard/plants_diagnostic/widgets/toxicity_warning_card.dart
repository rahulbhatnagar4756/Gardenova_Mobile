/// =========================================================
/// FILE: widgets/toxicity_warning_card.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class ToxicityWarningCard extends StatelessWidget {
  final String toxicity;

  const ToxicityWarningCard({super.key, required this.toxicity});

  @override
  Widget build(BuildContext context) {
    if (toxicity.trim().isEmpty) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.red.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.red.withValues(alpha: .15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.red, size: 24.sp),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  text: AppStrings.toxicityWarning,
                  fontFamily: AppKeys.poppins,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize16,
                  textColor: AppColors.red,
                ),

                SizedBox(height: 8.h),

                BaseText(
                  text: toxicity,
                  fontSize: fontSize14,
                  textColor: Colors.black87,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
