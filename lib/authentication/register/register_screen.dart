import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/components/header_logo_layout.dart';
import 'package:kasagardem/authentication/register/register_view_model.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_form.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/validation_healper.dart';

import '../../utils/constants/app_strings.dart';
import '../components/social_login_layout.dart';

class RegisterScreen extends GetWidget<RegisterViewModel> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: const BaseAppBar(
        // isAppIconVisible: false,
        isBackButtonVisible: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: BaseForm(
                formKey: controller.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    HeaderLogoLayout(
                      title: AppLocalizations.of(context)!.welcome,
                      subTitle: AppLocalizations.of(context)!.loginOrRegisterToContinue,
                    ),
                    nameField(context),
                    emailField(context),
                    phoneNoField(context),
                    passwordField(context),
                    termOfUseAndPrivacyPolicy(context),
                    register(context),
                    orRegisterWith(context),
                    /*  orRegisterWith(context),
                  ,*/
                    SocialLoginLayout(
                      registerController: controller,
                      type: AppStrings.register,
                    ).paddingOnly(bottom: 25.h),
                  ],
                ),
              ).marginSymmetric(horizontal: spacerSize20, vertical: spacerSize0),
            ),
          ),
          alreadyHaveAnAccount(context),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget nameField(BuildContext context) {
    return BaseTextField(
      prefixIcon: Icon(Icons.person_2_outlined, color: AppColors.greenColor),
      textEditingController: controller.nameController,
      hintText: AppLocalizations.of(context)!.enterYourName,
      errorText: AppLocalizations.of(context)!.pleaseEnterValidName,
      validator: ValidationHelper.validateName,
    ).marginOnly(top: 0, bottom: spacerSize10);
  }

  Widget passwordField(BuildContext context) {
    return Obx(
      () => BaseTextField(
        prefixIcon: Icon(Icons.lock_outline_rounded, color: AppColors.greenColor),
        hintText: AppLocalizations.of(context)!.enterYourPassword,
        keyboardType: TextInputType.visiblePassword,
        isTextObscure: controller.isPasswordObscure.value,
        textEditingController: controller.passwordController,
        errorText: AppLocalizations.of(context)!.passwordCannotBeEmpty,
        suffixIcon: IconButton(
          color: AppColors.liteGreyColor,
          onPressed: () {
            controller.isPasswordObscure.value = !controller.isPasswordObscure.value;
          },
          icon: controller.isPasswordObscure.value
              ? Icon(Icons.visibility_outlined)
              : Icon(Icons.visibility_off_outlined),
        ),
        validator: ValidationHelper.validatePassword,
      ),
    );
  }

  Widget emailField(BuildContext context) {
    return BaseTextField(
      hintText: AppLocalizations.of(context)!.enterYourEmail,
      textEditingController: controller.emailController,
      errorText: AppLocalizations.of(context)!.pleaseEnterValidEmailId,
      prefixIcon: Icon(Icons.mail_outline, color: AppColors.greenColor),
      validator: ValidationHelper.validateEmail,
    ).marginOnly(bottom: spacerSize10);
  }

  // need to change
  Widget phoneNoField(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(spacerSize10),
            border: Border.all(color: AppColors.borderGreyColor),
          ),
          alignment: Alignment.center,
          child: BaseText(
            text: '+91',
            fontFamily: AppKeys.inter,
            fontWeight: FontWeight.w500,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: BaseTextField(
            maxLength: 10,
            prefixIcon: Icon(Icons.phone_outlined, color: AppColors.greenColor),
            hintText: AppLocalizations.of(context)!.enterYourPhoneNo,
            keyboardType: TextInputType.phone,
            textEditingController: controller.phoneNoController,
            errorText: AppLocalizations.of(context)!.pleaseEnterValidPhoneNo,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            
            validator: ValidationHelper.validatePhone,
          ),
        ),
      ],
    ).marginOnly(bottom: spacerSize10);
  }

  Widget termOfUseAndPrivacyPolicy(BuildContext context) {
    return GestureDetector(
      onTap: controller.onCheckTermsAndCondition,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        spacing: spacerSize10,
        children: [
          Obx(
            () => SizedBox(
              width: 0.055 * Get.width,
              child: Checkbox(
                tristate: true,
                value: controller.isUserAgreedToTerms.value,
                activeColor: AppColors.greenColor,

                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spacerSize10)),
                onChanged: (bool? value) {
                  controller.onCheckTermsAndCondition();
                },
              ),
            ),
          ),
          Expanded(
            child: RichText(
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.iHaveAgreeTo,
                    style: TextStyle(
                      fontSize: fontSize13,
                      fontFamily: AppKeys.inter,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackColor,
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.toNamed(Routes.termsAndConditions);
                      },
                    text: "\t${AppLocalizations.of(context)!.termsOfUse}",
                    style: TextStyle(
                      fontSize: fontSize13,
                      fontFamily: AppKeys.inter,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greenColor,
                    ),
                  ),
                  TextSpan(
                    text: "\t${AppLocalizations.of(context)!.and}",
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: fontSize13,
                      fontFamily: AppKeys.inter,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Get.toNamed(Routes.privacyPolicy);
                      },
                    text: "\t${AppLocalizations.of(context)!.privacyPolicy}",
                    style: TextStyle(
                      color: AppColors.greenColor,
                      fontSize: fontSize13,
                      fontFamily: AppKeys.inter,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ).marginOnly(bottom: spacerSize15),
    );
  }

  Widget register(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BaseButton(
        bottomPadding: true,
        onPressed: () {
          if (controller.formKey.currentState!.validate()) {
            if (controller.isUserAgreedToTerms.value) {
              // Register API first, then email OTP verification screen.
              controller.registerUser();
            } else {
              BaseSnackBar.show(
                title: appName,
                message: AppLocalizations.of(context)!.pleaseAcceptTermsAndConditions,
              );
            }
          }
        },
        fontSize: fontSize18,
        buttonLabel: AppLocalizations.of(context)!.register,
      ).marginOnly(bottom: 0),
    );
  }

  Widget orRegisterWith(BuildContext context) {
    return Row(
      spacing: spacerSize6,
      children: [
        divider(),
        BaseText(
          text: AppLocalizations.of(context)!.orRegisterWith,
          fontFamily: AppKeys.inter,
          fontSize: 13.sp,
        ),
        divider(),
      ],
    ).marginOnly(bottom: 22.h, top: 0);
  }

  Widget divider() {
    return Expanded(
      child: Divider(thickness: spacerSize1, height: spacerSize1, color: AppColors.liteGreyColor),
    );
  }

  Widget alreadyHaveAnAccount(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.alreadyHaveAnAccount,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w400,
              fontFamily: AppKeys.inter,
            ),
          ),
          TextSpan(
            text: '\t${AppLocalizations.of(context)!.logInNow}',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Get.toNamed(Routes.login);
                Get.back();
              },
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.greenColor,
              fontWeight: FontWeight.w500,
              fontFamily: AppKeys.inter,
            ),
          ),
        ],
      ),
    ).marginSymmetric(horizontal: spacerSize20, vertical: spacerSize20);
  }
}
