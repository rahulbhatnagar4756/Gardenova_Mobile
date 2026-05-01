import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/components/header_logo_layout.dart';
import 'package:kasagardem/authentication/forgotPassword/forgot_password_view_model.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class ResetPassword extends GetWidget<ForgotPasswordViewModel> {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: const BaseAppBar(
        isAppIconVisible: false,
        isBackButtonVisible: true,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                HeaderLogoLayout(
                  title: AppLocalizations.of(context)!.createNewPassword,
                  subTitle: AppLocalizations.of(
                    context,
                  )!.setAStrongPasswordToSecureYourAccount,
                ),
                passwordField(
                  AppLocalizations.of(context)!.newPassword,
                  controller.isNewPasswordObscure,
                  controller.newPasswordController,
                  context,
                ),
                SizedBox(height: spacerSize10),
                passwordField(
                  AppLocalizations.of(context)!.confirmNewPassword,
                  controller.isConfirmPasswordObscure,
                  controller.confirmPasswordController,
                  context,
                ),

              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child:
            resetPassword(context),
          )
        ],
      ).marginSymmetric(horizontal: spacerSize20, vertical: spacerSize10),
    );
  }

  passwordField(
    String hintText,
    RxBool isPasswordObscure,
    TextEditingController textEditingController,
    BuildContext context,
  ) {
    return Obx(
      () => BaseTextField(
        hintText: AppLocalizations.of(context)!.enterYourPassword,
        keyboardType: TextInputType.visiblePassword,
        isTextObscure: isPasswordObscure.value,
        textEditingController: textEditingController,
        errorText: AppLocalizations.of(context)!.passwordCannotBeEmpty,
        suffixIcon: IconButton(
          color: AppColors.offWhite,
          onPressed: () {
            isPasswordObscure.value = !isPasswordObscure.value;
          },
          icon: isPasswordObscure.value
              ? Icon(Icons.visibility_outlined)
              : Icon(Icons.visibility_off_outlined),
        ),
      ),
    );
  }

  resetPassword(BuildContext context) {
    return SizedBox(width: double.infinity,
      child: BaseButton(
        backgroundColor: AppColors.burntGold,
        onPressed: () {
          controller.resetPassword();
        },
        fontSize: fontSize18,
        buttonLabel: AppLocalizations.of(context)!.resetPassword.toUpperCase(),
      ).paddingOnly(bottom: 15.h).marginOnly(top: spacerSize25),
    );
  }
}
