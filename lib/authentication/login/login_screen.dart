import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/authentication/components/header_logo_layout.dart';
import 'package:kasagardem/authentication/login/login_view_model.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_form.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';
import 'package:kasagardem/utils/routes.dart';

import '../../base/widgets/base_back_button.dart';
import '../../base/widgets/base_bback_button.dart';
import '../../utils/app_config.dart';
import '../components/social_login_layout.dart';

class LoginScreen extends GetWidget<LoginViewModel> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
print('sdf ${AppLocalizations.of(
  context,
)!.loginAccountSubTitle}');
    return PopScope(
      canPop: true,
      /* onPopInvokedWithResult: (result, didPop) {
          if (!Navigator.of(Get.context!).canPop()){
        BaseDialog.showAlertDialog(
          context: context,
          title: appName,
          description: AppLocalizations.of(context)!.exitAppContent,
          buttonLabel: AppLocalizations.of(context)!.exit,
          onButtonPressed: () {
            SystemNavigator.pop();
          },
        );
      }else{
          Get.back();
        }},*/
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        appBar: const BaseAppBar(
          isAppIconVisible: false,
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
                          // BasBBackButton(),
                          HeaderLogoLayout(
                            title: AppLocalizations.of(context)!.loginAccount,
                            subTitle: AppLocalizations.of(
                              context,
                            )!.loginAccountSubTitle,
                          ),
                          emailField(context),
                          passwordField(context),
                          forgotPassword(context),
                          login(context),
                          Visibility(
                            visible:
                                controller.accountType.value !=
                                AppKeys.professional,
                            child: orLoginWith(context),
                          ),

                          Visibility(
                            visible:
                                controller.accountType.value !=
                                AppKeys.professional,
                            child: SocialLoginLayout(
                              loginController: controller,
                              type: AppStrings.login,
                            ),
                          ),
                          Visibility(
                            visible: controller.accountType.value != AppKeys.professional,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: dontHaveAnAccount(context),
                            ).marginOnly(top: 130.h),
                          ),

                        ],
                      ),
                    ).marginSymmetric(
                      horizontal: spacerSize20,
                      vertical: spacerSize0,
                    ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget emailField(BuildContext context) {
    return BaseTextField(
      hintText: AppLocalizations.of(context)!.enterYourEmail,
      keyboardType: TextInputType.emailAddress,
      textEditingController: controller.emailController,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return AppLocalizations.of(context)!.enterYourEmail;
        }
        if (value.contains(' ')) {
          return AppLocalizations.of(context)!.pleaseEnterValidEmailId;
        }
        if (!emailRegex.hasMatch(value.trim())) {
          return AppLocalizations.of(context)!.pleaseEnterValidEmailId;
        }

        return null;
      },
    ).marginOnly(bottom: 10.h);
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
      ),
    );
  }

  forgotPassword(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.forgotPassword);
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: BaseText(
          textAlign: TextAlign.right,
          text: AppLocalizations.of(context)!.forgotPassword,
          fontFamily: AppKeys.inter,
          fontWeight: FontWeight.w500,
          fontSize: 13.sp,
          textColor: AppColors.greenColor,
        ),
      ).marginOnly(top:  10.h),
    );
  }

  login(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BaseButton(
        backgroundColor: AppColors.burntGold,
        onPressed: () {
          FocusScope.of(context).requestFocus(FocusNode());

          if (controller.formKey.currentState!.validate()) {
            controller.login();
          }
        },
        buttonLabel: AppLocalizations.of(context)!.login,
      ).marginOnly(bottom: spacerSize30, top: spacerSize25),
    );
  }

  orLoginWith(BuildContext context) {
    return Row(
      spacing: spacerSize6,
      children: [
        divider(),
        BaseText(
          text: AppLocalizations.of(context)!.orLoginWith,
          textColor: AppColors.blackColor,
          fontFamily: AppKeys.inter,
          fontWeight: FontWeight.w400,
          fontSize: 13.sp,
        ),
        divider(),
      ],
    ).marginOnly(bottom: 15.h);
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

  dontHaveAnAccount(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: AppLocalizations.of(context)!.dontHaveAnAccount,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: AppKeys.inter,
              color: AppColors.blackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: '\t${AppLocalizations.of(context)!.registerNow}',
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(Routes.signUp);
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
    ).marginOnly(bottom: spacerSize14);
  }
}
