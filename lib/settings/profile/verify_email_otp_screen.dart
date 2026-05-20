import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:pinput/pinput.dart';

class VerifyEmailOtpScreen extends GetView<SettingsViewModel> {
  const VerifyEmailOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: spacerSize75,
      height: spacerSize55,
      textStyle: TextStyle(color: AppColors.blackColor, fontSize: 18.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(spacerSize10),
        border: Border.all(color: AppColors.borderGreyColor),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: const BaseAppBar(
        isBackButtonVisible: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: spacerSize20, vertical: spacerSize10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: spacerSize20),
            Text(
              "Verify Email Address",
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.blackColor,
                fontFamily: AppKeys.inter,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacerSize10),
            Obx(() => Text(
              "Please enter the 4-digit code sent to\n${controller.emailController.text}",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.liteGreyColor,
                fontFamily: AppKeys.inter,
              ),
              textAlign: TextAlign.center,
            )),
            SizedBox(height: spacerSize40),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                controller: controller.otpController,
                length: 4,
                defaultPinTheme: defaultPinTheme,
                separatorBuilder: (index) => const SizedBox(width: spacerSize8),
                validator: (value) {
                  return value != null && value.length == 4
                      ? null
                      : "Please enter the 4-digit OTP code";
                },
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                cursor: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: spacerSize10),
                      width: spacerSize24,
                      height: spacerSize1,
                      color: AppColors.greenColor,
                    ),
                  ],
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    borderRadius: BorderRadius.circular(spacerSize10),
                    color: Colors.white,
                    border: Border.all(color: AppColors.greenColor),
                  ),
                ),
                submittedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(spacerSize10),
                    border: Border.all(color: AppColors.greenColor),
                  ),
                ),
                errorPinTheme: defaultPinTheme.copyBorderWith(
                  border: Border.all(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(height: spacerSize40),
            SizedBox(
              width: double.infinity,
              child: BaseButton(
                bottomPadding: true,
                backgroundColor: AppColors.burntGold,
                onPressed: () {
                  final code = controller.otpController.text.trim();
                  if (code.length == 4) {
                    controller.verifyEmailOtp(code);
                  } else {
                    BaseSnackBar.show(
                      title: "Error",
                      message: "Please enter a valid 4-digit OTP code.",
                    );
                  }
                },
                fontSize: fontSize18,
                buttonLabel: AppLocalizations.of(context)!.verifyOtp,
              ),
            ),
            SizedBox(height: spacerSize20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive code? ",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.liteGreyColor,
                    fontFamily: AppKeys.inter,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    controller.sendEmailVerification();
                  },
                  child: Text(
                    "Resend",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.greenColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppKeys.inter,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
