import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/settings/profile/verified_email_otp_view/verified_email_otp_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import '../../../authentication/components/header_logo_layout.dart';
import '../../../authentication/components/otp_field_layout.dart';
import '../../../utils/constants/app_strings.dart';

class VerifyEmailOtpScreen extends GetView<VerifiedEmailOtpViewModel> {
  const VerifyEmailOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: const BaseAppBar(isBackButtonVisible: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: spacerSize20,
          vertical: spacerSize10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(
              () => HeaderLogoLayout(
                title: AppStrings.verifyEmailAddress,
                subTitle: AppStrings.verifyEmailSubTxt.replaceAll(
                  'EMAIL_ADDRESS',
                  controller.parsingArgument.value?.email ?? '',
                ),
              ),
            ),
            OtpLayout(
              lengthOtp: 4,
              widgetKey: controller.verifyEmailFormKey,
              focusNode: controller.focusNode,
              pinController: controller.pinController,
            ),
            SizedBox(height: spacerSize20),

            SizedBox(
              width: double.infinity,
              child: BaseButton(
                backgroundColor: AppColors.burntGold,
                onPressed: () {
                  final code = controller.pinController.text.trim();
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
            SizedBox(height: spacerSize15),
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
                Obx(
                  () => controller.countdownTimer.value > 0
                      ? Text(
                          "0${controller.countdownTimer.value ~/ 60}:${(controller.countdownTimer.value % 60).toString().padLeft(2, '0')}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: AppColors.burntGold,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppKeys.inter,
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            controller.reSendVerificationTime();
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
