import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/components/header_logo_layout.dart';
import 'package:kasagardem/authentication/components/otp_field_layout.dart';
import 'package:kasagardem/authentication/forgotPassword/forgot_password_view_model.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../utils/routes.dart';

class VerifyOtp extends GetWidget<ForgotPasswordViewModel> {
  const VerifyOtp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: const BaseAppBar(
        isAppIconVisible: false,
        isBackButtonVisible: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                HeaderLogoLayout(
                  title: AppLocalizations.of(context)!.enterYourOtp,
                  subTitle: AppLocalizations.of(
                    context,
                  )!.checkYourEmailOrPhoneForTheOTPAndEnterItBelow,
                ),
                OtpLayout(forgotPasswordViewModel: controller),
                verifyOtp(context),
                didNotReceiveAnyCode(context),
              ],
            ),
          ),
        ],
      ).marginSymmetric(horizontal: spacerSize20, vertical: spacerSize10),
    );
  }

  verifyOtp(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BaseButton(
        backgroundColor: AppColors.burntGold,
        onPressed: () {
          if (controller.verifyOtpFormKey.currentState!.validate()) {
            controller.focusNode.unfocus();
            controller.verifyOtp();
          }
        },
        fontSize: fontSize18,
        buttonLabel: AppLocalizations.of(context)!.verifyOtp,
      ).marginOnly(bottom: 24.h, top: spacerSize25),
    );
  }

   didNotReceiveAnyCode(BuildContext context) {
    return Obx(
      () => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppLocalizations.of(context)!.didNotReceiveAnyCode,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.liteGreyColor,
                fontWeight: FontWeight.w400,
                fontFamily: AppKeys.inter,
              ),
            ),

            TextSpan(
              text: '\t${AppLocalizations.of(context)!.resendCode}',
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (controller.canResend.value) {
                    controller.sendOtp(isResend: true);
                  }
                },
              style: TextStyle(
                fontSize: 13.sp,
                color: controller.canResend.value
                    ? AppColors.greenColor
                    : AppColors.liteGreyColor,
                fontWeight: FontWeight.w400,
                fontFamily: AppKeys.inter,
              ),
            ),
            if (!controller.canResend.value)
              TextSpan(
                text: '\t${AppLocalizations.of(context)!.inText}',
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (controller.canResend.value) {
                      controller.sendOtp(isResend: true);
                    }
                  },
                style: TextStyle(
                  fontSize: 13.sp,
                  color: controller.canResend.value
                      ? AppColors.greenColor
                      : AppColors.liteGreyColor,
                  fontWeight: FontWeight.w500,
                  fontFamily: AppKeys.inter,
                ),
              ),
            if (!controller.canResend.value)
              TextSpan(
                text:
                    '\t${(controller.start ~/ 60).toString().padLeft(2, '0')}:${(controller.start.value % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.greenColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
