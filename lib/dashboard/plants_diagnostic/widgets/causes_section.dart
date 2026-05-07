/// =========================================================
/// FILE: widgets/causes_section.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class CausesSection extends StatelessWidget {
  final List<String> causes;

  const CausesSection({super.key, required this.causes});

  @override
  Widget build(BuildContext context) {
    if (causes.isEmpty) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: .12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: "Possible Causes",
            fontFamily: AppKeys.poppins,
            fontWeight: FontWeight.w700,
            fontSize: fontSize18,
            textColor: AppColors.greenColor,
          ),

          SizedBox(height: 14.h),

          ...List.generate(
            causes.length,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, size: 8.sp, color: AppColors.greenColor),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: BaseText(
                      text: causes[index],
                      fontSize: fontSize14,
                      textColor: AppColors.liteGreyColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
