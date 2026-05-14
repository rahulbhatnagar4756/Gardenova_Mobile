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
              child:
                  BaseForm(
                    formKey: controller.formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        HeaderLogoLayout(
                          title: AppLocalizations.of(context)!.welcome,
                          subTitle: AppLocalizations.of(
                            context,
                          )!.loginOrRegisterToContinue,
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
                  ).marginSymmetric(
                    horizontal: spacerSize20,
                    vertical: spacerSize0,
                  ),
            ),
          ),
          alreadyHaveAnAccount(context),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  nameField(BuildContext context) {
    return BaseTextField(
      textEditingController: controller.nameController,
      hintText: AppLocalizations.of(context)!.enterYourName,
      errorText: AppLocalizations.of(context)!.pleaseEnterValidName,
    ).marginOnly(top: spacerSize10, bottom: spacerSize10);
  }

  passwordField(BuildContext context) {
    return Obx(
      () => BaseTextField(
        hintText: AppLocalizations.of(context)!.enterYourPassword,
        keyboardType: TextInputType.visiblePassword,
        isTextObscure: controller.isPasswordObscure.value,
        textEditingController: controller.passwordController,
        errorText: AppLocalizations.of(context)!.passwordCannotBeEmpty,
        suffixIcon: IconButton(
          color: AppColors.liteGreyColor,
          onPressed: () {
            controller.isPasswordObscure.value =
                !controller.isPasswordObscure.value;
          },
          icon: controller.isPasswordObscure.value
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

  emailField(BuildContext context) {
    return BaseTextField(
      hintText: AppLocalizations.of(context)!.enterYourEmail,
      textEditingController: controller.emailController,
      errorText: AppLocalizations.of(context)!.pleaseEnterValidEmailId,
      validator: (value) {
        // if (value == null || value.isEmpty) {
        //   return AppLocalizations.of(context)!.pleaseEnterValidEmailId;
        // }
        // if (!GetUtils.isEmail(value)) {
        //   return AppLocalizations.of(context)!.pleaseEnterValidEmailId;
        // }
        // return null;
        final email = value?.trim() ?? '';

        if (email.isEmpty) {
          return AppLocalizations.of(context)!.pleaseEnterValidEmailId;
        }

        // No spaces allowed
        if (email.contains(' ')) {
          return AppLocalizations.of(context)!.pleaseEnterValidEmailId;
        }

        // Strong email regex
        final emailRegex = RegExp(
          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|in|org|net|edu|gov|co|io|info|biz)$",
        );

        if (!emailRegex.hasMatch(email)) {
          return AppLocalizations.of(context)!.pleaseEnterValidEmailId;
        }

        // Prevent consecutive dots
        if (email.contains('..')) {
          return AppLocalizations.of(context)!.pleaseEnterValidEmailId;
        }

        return null;
      },
    ).marginOnly(bottom: spacerSize10);
  }

  // need to change
  phoneNoField(BuildContext context) {
    return BaseTextField(
      hintText: AppLocalizations.of(context)!.enterYourPhoneNo,
      keyboardType: TextInputType.phone,
      textEditingController: controller.phoneNoController,
      errorText: AppLocalizations.of(context)!.pleaseEnterValidPhoneNo,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.pleaseEnterValidPhoneNo;
        }
        if (value.length < 7) {
          return "Phone number is too short";
        }
        return null;
      },
    ).marginOnly(bottom: spacerSize10);
  }

  termOfUseAndPrivacyPolicy(BuildContext context) {
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

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(spacerSize10),
                ),
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
                        //  Get.toNamed(Routes.termsAndConditions);
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

  register(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BaseButton(
        bottomPadding: true,
        onPressed: () {
          if (controller.formKey.currentState!.validate()) {
            if (controller.isUserAgreedToTerms.value) {
              controller.registerUser();
            } else {
              BaseSnackBar.show(
                title: appName,
                message: AppLocalizations.of(
                  context,
                )!.pleaseAcceptTermsAndConditions,
              );
            }
          }
        },
        fontSize: fontSize18,
        buttonLabel: AppLocalizations.of(context)!.register,
      ).marginOnly(bottom: 25.h),
    );
  }

  orRegisterWith(BuildContext context) {
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
    ).marginOnly(bottom: 15.h, top: 28.h);
  }

  divider() {
    return Expanded(
      child: Divider(
        thickness: spacerSize1,
        height: spacerSize1,
        color: AppColors.liteGreyColor,
      ),
    );
  }

  alreadyHaveAnAccount(BuildContext context) {
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
                Get.toNamed(Routes.login);
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
