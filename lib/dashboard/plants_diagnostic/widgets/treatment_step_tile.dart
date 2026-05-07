/// =========================================================
/// FILE: plants_diagnostic/widgets/treatment_step_tile.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

class TreatmentStepTile extends StatelessWidget {
  final String step;

  const TreatmentStepTile({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12.r,
            backgroundColor: AppColors.greenColor,
            child: Icon(
              Icons.check,
              size: 14.sp,
              color: Colors.white,
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: BaseText(text: step),
          ),
        ],
      ),
    );
  }
}