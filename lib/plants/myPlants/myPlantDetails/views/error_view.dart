import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class MyPlantDetailsErrorView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const MyPlantDetailsErrorView({
    super.key,
    required this.errorMessage,
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
          onPressed: () => Navigator.of(context).pop(),
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
              SizedBox(height: spacerSize24),
              BaseText(
                text: "Oops!",
                fontSize: fontSize24,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: spacerSize12),
              BaseText(
                text: errorMessage,
                textAlign: TextAlign.center,
                textColor: AppColors.liteGreyColor,
              ),
              SizedBox(height: 24.h),
              BaseButton(
                buttonLabel: AppStrings.retry,
                onPressed: onRetry,
                buttonWidth: 150.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
