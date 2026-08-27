import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class PlantAnalysisDetailErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const PlantAnalysisDetailErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.blackColor),
          onPressed: Get.back,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(spacerSize24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 80.sp,
                color: AppColors.red,
              ),
              SizedBox(height: spacerSize16),
              BaseText(
                text: message,
                fontFamily: AppKeys.poppins,
                fontSize: fontSize16,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: spacerSize24),
              BaseButton(buttonLabel: AppStrings.tryAgain, onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}
