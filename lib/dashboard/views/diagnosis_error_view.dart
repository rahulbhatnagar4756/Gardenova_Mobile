// =========================================================
// FILE: plants_diagnostic/views/diagnosis_error_view.dart
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

class DiagnosisErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const DiagnosisErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.red,
                  size: 70.sp,
                ),

                SizedBox(height: 20.h),

                BaseText(
                  text: AppStrings.somethingWentWrong,
                  fontSize: fontSize22,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppKeys.poppins,
                ),

                SizedBox(height: 10.h),

                BaseText(
                  text: message,
                  textAlign: TextAlign.center,
                  textColor: AppColors.liteGreyColor,
                ),

                SizedBox(height: 30.h),

                BaseButton(
                  onPressed: onRetry,
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
