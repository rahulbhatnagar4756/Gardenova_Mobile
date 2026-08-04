import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_form.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/settings/components/bottom_sheet_layout.dart';
import 'package:kasagardem/settings/components/profile_icon_layout.dart';
import 'package:kasagardem/settings/components/text_field_layout.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/validation_healper.dart';
import '../utils/constants/app_strings.dart';

class ChangePassword extends GetWidget<SettingsViewModel> {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          controller.oldPasswordController.clear();
          controller.newPasswordController.clear();
          controller.confirmPasswordController.clear();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.darkGreen,
        body: Container(
          height: double.infinity,
          color: AppColors.greenColor,
          child: SafeArea(
            child: Container(
              color: AppColors.whiteColor,
              child: Column(
                children: [
                  Obx(
                    () => ProfileIconLayout(
                      isEnableEditable: false,
                      title: controller.isEmailLogedInUser.value
                          ? AppLocalizations.of(context)!.changePassword
                          : AppStrings.setPwd,
                    ),
                  ),
                  Expanded(
                    child: Obx(
                      () => BottomSheetLayout(
                        childLayout: BaseForm(
                          formKey: controller.changePasswordFormKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                if (controller.isEmailLogedInUser.value)
                                  TextFieldLayout(
                                    prefixIcon: Icon(
                                      Icons.lock_outline_rounded,
                                      color: AppColors.greenColor,
                                    ),
                                    editTextTitle: AppLocalizations.of(
                                      context,
                                    )!.currentPassword,
                                    textEditingController:
                                        controller.oldPasswordController,
                                    hintText: AppLocalizations.of(
                                      context,
                                    )!.currentPassword,
                                    isTextObscure: true,

                                    validator:
                                        ValidationHelper.validatePassword,
                                  ),

                                TextFieldLayout(
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color: AppColors.greenColor,
                                  ),
                                  editTextTitle: AppLocalizations.of(
                                    context,
                                  )!.newPassword,
                                  hintText: AppLocalizations.of(
                                    context,
                                  )!.newPassword,
                                  textEditingController:
                                      controller.newPasswordController,
                                  isTextObscure: true,
                                  validator: ValidationHelper.validatePassword,
                                ),
                                TextFieldLayout(
                                  prefixIcon: Icon(
                                    Icons.lock_outline_rounded,
                                    color: AppColors.greenColor,
                                  ),
                                  editTextTitle: AppLocalizations.of(
                                    context,
                                  )!.confirmNewPassword,
                                  hintText: AppLocalizations.of(
                                    context,
                                  )!.confirmNewPassword,
                                  textEditingController:
                                      controller.confirmPasswordController,
                                  isTextObscure: true,
                                  validator: (value) =>
                                      ValidationHelper.validateConfirmPassword(
                                        password: controller
                                            .newPasswordController
                                            .text,
                                        confirmPassword: value,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        buttonLabel: controller.isEmailLogedInUser.value
                            ? AppLocalizations.of(context)!.saveChanges
                            : AppStrings.setPwdBtnMsg,
                        onButtonTap: () {
                          if (controller.changePasswordFormKey.currentState!
                              .validate()) {
                            if (controller.isEmailLogedInUser.value) {
                              controller.updatePassword();
                            } else {
                              controller.setPassword();
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
