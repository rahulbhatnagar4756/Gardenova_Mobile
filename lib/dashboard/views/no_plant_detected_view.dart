/// =========================================================
/// FILE: plants_diagnostic/views/no_plant_detected_view.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class NoPlantDetectedView extends StatelessWidget {
  const NoPlantDetectedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(30.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_florist_outlined,
              size: 90.sp,
              color: AppColors.greenColor,
            ),

            SizedBox(height: 20.h),

            BaseText(
              text: "No Plant Detected",
              fontSize: fontSize24,
              fontWeight: FontWeight.bold,
              fontFamily: AppKeys.poppins,
            ),

            SizedBox(height: 12.h),

            BaseText(
              text: "Please upload a clearer plant image for better diagnosis.",
              textAlign: TextAlign.center,
              textColor: AppColors.liteGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
