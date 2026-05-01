import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/components/header_logo_layout.dart';
import 'package:kasagardem/authentication/forgotPassword/forgot_password_view_model.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_form.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

import '../../utils/routes.dart';
import '../../utils/utils.dart';

class ForgotPassword extends GetWidget<ForgotPasswordViewModel> {
  const ForgotPassword({super.key});

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
          BaseForm(
            formKey: controller.sendOtpFormKey,
            child: Column(
              children: [
                HeaderLogoLayout(
                  title: AppLocalizations.of(context)!.forgotPasswordNew,
                  subTitle: AppLocalizations.of(
                    context,
                  )!.forgotPasswordSubTitle,
                ),
                emailField(context),
              ],
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: sendOtp(context),
          )
        ],
      ).marginSymmetric(horizontal: spacerSize20, vertical: spacerSize10),
    );
  }

  emailField(BuildContext context) {
    return BaseTextField(
      hintText: AppLocalizations.of(context)!.enterYourEmail,
      hintColor: AppColors.mediumGrey,
      keyboardType: TextInputType.emailAddress,
      textEditingController: controller.emailController,
      errorText: AppLocalizations.of(context)!.pleaseEnterValidEmailId,
    );
  }

  sendOtp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15.h),
      width: double.infinity,
      child: BaseButton(
        textColor: AppColors.offWhite,
        buttonLabel: AppLocalizations.of(context)!.sendOtp,
        onPressed: () {
          if (controller.sendOtpFormKey.currentState!.validate() &&
              RegExp(
                emailRegexPattern,
              ).hasMatch(controller.emailController.text)) {
            controller.sendOtp();
          } else {
            BaseSnackBar.show(
              title: AppStrings.exception,
              message: AppLocalizations.of(context)!.pleaseEnterValidEmailId,
            );
          }
        },
      ).marginOnly(top: spacerSize25),
    );
  }
}
