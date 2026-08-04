// =========================================================
// FILE: plants_diagnostic/views/no_plant_detected_view.dart
// CREATE NEW FILE
// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class NoPlantDetectedView extends StatelessWidget {
  final VoidCallback onRescan;

  const NoPlantDetectedView({
    super.key,
    required this.onRescan,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
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
                  text: AppStrings.noPlantDetected,
                  fontSize: fontSize24,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppKeys.poppins,
                ),

                SizedBox(height: 12.h),

                BaseText(
                  text: AppStrings.pleaseUpload,
                  textAlign: TextAlign.center,
                  textColor: AppColors.liteGreyColor,
                ),

                SizedBox(height: 30.h),

                BaseButton(
                  onPressed: onRescan,
                  buttonLabel: AppStrings.tryAgain,
                  backgroundColor: AppColors.greenColor,
                ),
              ],
            ),
          ),
        ),

        // ── BACK BUTTON ──────────────────────────────────────────────────
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: spacerSize10,
              top: spacerSize16,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.black38,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
