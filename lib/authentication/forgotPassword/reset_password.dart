import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/components/header_logo_layout.dart';
import 'package:kasagardem/authentication/forgotPassword/forgot_password_view_model.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../base/widgets/base_form.dart';

class ResetPassword extends GetWidget<ForgotPasswordViewModel> {
  const ResetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: const BaseAppBar(
        // isAppIconVisible: false,
        isBackButtonVisible: true,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: BaseForm(
              formKey: controller.resetPasswordFormKey,
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
                  confirmPasswordField(
                    AppLocalizations.of(context)!.confirmNewPassword,
                    controller.isConfirmPasswordObscure,
                    controller.confirmPasswordController,
                    context,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: resetPassword(context),
          ),
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
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: AppColors.greenColor,
        ),
        hintText: hintText,
        keyboardType: TextInputType.visiblePassword,
        isTextObscure: isPasswordObscure.value,
        textEditingController: textEditingController,
        errorText: AppLocalizations.of(context)!.passwordCannotBeEmpty,
        suffixIcon: IconButton(
          color: AppColors.liteGreyColor,
          onPressed: () {
            isPasswordObscure.value = !isPasswordObscure.value;
          },
          icon: isPasswordObscure.value
              ? Icon(Icons.visibility_outlined)
              : Icon(Icons.visibility_off_outlined),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.passwordFieldCannotBeEmpty;
          }

          // Minimum 8 characters
          if (value.length < 8) {
            return 'Password must be at least 8 characters';
          }

          // At least one uppercase letter
          if (!RegExp(r'[A-Z]').hasMatch(value)) {
            return 'Password must contain at least one capital letter';
          }

          // At least one special character
          if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
            return 'Password must contain at least one special character';
          }

          return null;
        },
      ),
    );
  }

  confirmPasswordField(
    String hintText,
    RxBool isPasswordObscure,
    TextEditingController textEditingController,
    BuildContext context,
  ) {
    return Obx(
      () => BaseTextField(
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: AppColors.greenColor,
        ),
        hintText: hintText,
        keyboardType: TextInputType.visiblePassword,
        isTextObscure: isPasswordObscure.value,
        textEditingController: textEditingController,
        errorText: AppLocalizations.of(context)!.passwordCannotBeEmpty,
        suffixIcon: IconButton(
          color: AppColors.liteGreyColor,
          onPressed: () {
            isPasswordObscure.value = !isPasswordObscure.value;
          },
          icon: isPasswordObscure.value
              ? Icon(Icons.visibility_outlined)
              : Icon(Icons.visibility_off_outlined),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.passwordFieldCannotBeEmpty;
          }

          if (value != controller.newPasswordController.text) {
            return AppLocalizations.of(context)!.passwordsDoNotMatch;
          }

          return null;
        },
      ),
    );
  }

  resetPassword(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BaseButton(
        bottomPadding: true,
        backgroundColor: AppColors.burntGold,
        onPressed: () {
          if (controller.resetPasswordFormKey.currentState!.validate()) {
            controller.resetPassword();
          }
        },
        fontSize: fontSize18,
        buttonLabel: AppLocalizations.of(context)!.resetPassword,
      ).marginOnly(top: spacerSize25),
    );
  }
}
