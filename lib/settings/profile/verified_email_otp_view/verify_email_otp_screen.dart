import 'package:flutter/gestures.dart';
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
            securityBanner(context),
            SizedBox(height: spacerSize20),

            SizedBox(
              width: double.infinity,
              child: BaseButton(
                linearBackgroundColor: AppColors.linearGradientForBtn,
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
            SizedBox(height: spacerSize25),
            didNotReceiveAnyCode(context),
            otpExpiryBanner(context),
          ],
        ),
      ),
    );
  }

  Widget securityBanner(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF7),
        border: Border.all(color: const Color(0xFFE2EFE5), width: 1.w),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: AppColors.greenColor, size: 24.w),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              AppLocalizations.of(context)?.localeName == 'pt'
                  ? 'Para sua segurança, nunca compartilhe seu OTP com ninguém.'
                  : 'For your security, never share your OTP with anyone.',
              style: TextStyle(
                color: AppColors.liteGreyColor,
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                fontFamily: AppKeys.inter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget otpExpiryBanner(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isPt = locale?.localeName == 'pt';
    return Obx(() {
      final int minutes = controller.expiryStart.value ~/ 60;
      final int seconds = controller.expiryStart.value % 60;
      final String timeStr =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
      return Container(
        margin: EdgeInsets.only(top: 25.h, bottom: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FD),
          border: Border.all(color: const Color(0xFFEFF0F6), width: 1.w),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Icon(Icons.verified_user, color: AppColors.greenColor, size: 24.w),
            SizedBox(width: 14.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: isPt ? 'O OTP expirará em ' : 'OTP will expire in ',
                      style: TextStyle(
                        color: AppColors.liteGreyColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppKeys.inter,
                      ),
                    ),
                    TextSpan(
                      text: timeStr,
                      style: TextStyle(
                        color: AppColors.greenColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppKeys.inter,
                      ),
                    ),
                    TextSpan(
                      text: isPt ? ' minutos' : ' minutes',
                      style: TextStyle(
                        color: AppColors.liteGreyColor,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppKeys.inter,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget didNotReceiveAnyCode(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final isPt = locale?.localeName == 'pt';
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      locale?.didNotReceiveAnyCode ?? "Didn't receive any OTP?",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppKeys.inter,
                  ),
                ),
                TextSpan(
                  text: isPt ? ' Reenviar' : ' Resend',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (controller.countdownTimer.value == 0) {
                        controller.reSendVerificationTime();
                      }
                    },
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: controller.countdownTimer.value == 0
                        ? AppColors.greenColor
                        : AppColors.greenColor.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                    fontFamily: AppKeys.inter,
                  ),
                ),
              ],
            ),
          ),
          if (controller.countdownTimer.value > 0) ...[
            SizedBox(height: 8.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: isPt
                        ? 'Você pode reenviar o OTP em '
                        : 'You can resend OTP in ',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.liteGreyColor,
                      fontWeight: FontWeight.w400,
                      fontFamily: AppKeys.inter,
                    ),
                  ),
                  TextSpan(
                    text:
                        '0${controller.countdownTimer.value ~/ 60}:${(controller.countdownTimer.value % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.greenColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppKeys.inter,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
