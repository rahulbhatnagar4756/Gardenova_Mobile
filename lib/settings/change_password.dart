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

class ChangePassword extends GetWidget<SettingsViewModel> {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      body: Container(
        height: double.infinity,
        color: AppColors.greenColor,
        child: SafeArea(
          child: Container(
            color: AppColors.whiteColor,
            child: Column(
              children: [
                ProfileIconLayout(
                  isEnableEditable: false,
                  title: AppLocalizations.of(context)!.changePassword,
                ),
                Expanded(
                  child: BottomSheetLayout(
                    childLayout: BaseForm(
                      formKey: controller.changePasswordFormKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
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

                              validator: ValidationHelper.validatePassword,
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
                              validator: (value) => ValidationHelper.validateConfirmPassword(
                                password: controller.newPasswordController.text,
                                confirmPassword: value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    buttonLabel: AppLocalizations.of(context)!.saveChanges,
                    onButtonTap: () {
                      if (controller.changePasswordFormKey.currentState!
                          .validate()) {
                        controller.updatePassword();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // bottomSheet: BottomSheetLayout(
      //   childLayout: BaseForm(
      //     formKey: controller.changePasswordFormKey,
      //     child: Column(
      //       children: [
      //         TextFieldLayout(
      //           editTextTitle: AppLocalizations.of(context)!.currentPassword,
      //           textEditingController: controller.oldPasswordController,
      //           isTextObscure: true,
      //           validator: (value) {
      //             if (value == null || value.isEmpty) {
      //               return AppLocalizations.of(
      //                 context,
      //               )!.passwordFieldCannotBeEmpty;
      //             }
      //             return null;
      //           },
      //         ),
      //
      //         TextFieldLayout(
      //           editTextTitle: AppLocalizations.of(context)!.newPassword,
      //           textEditingController: controller.newPasswordController,
      //           isTextObscure: true,
      //           validator: (value) {
      //             if (value == null || value.isEmpty) {
      //               return AppLocalizations.of(
      //                 context,
      //               )!.passwordFieldCannotBeEmpty;
      //             }
      //             return null;
      //           },
      //         ),
      //         TextFieldLayout(
      //           editTextTitle: AppLocalizations.of(context)!.confirmNewPassword,
      //           textEditingController: controller.confirmPasswordController,
      //           isTextObscure: true,
      //           validator: (value) {
      //             if (value == null || value.isEmpty) {
      //               return AppLocalizations.of(
      //                 context,
      //               )!.passwordFieldCannotBeEmpty;
      //             }
      //
      //             if (value != controller.newPasswordController.text) {
      //               return AppLocalizations.of(context)!.passwordsDoNotMatch;
      //             }
      //
      //             return null;
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      //   buttonLabel: AppLocalizations.of(context)!.saveChanges.toUpperCase(),
      //   onButtonTap: () {
      //     if (controller.changePasswordFormKey.currentState!.validate()) {
      //       controller.updatePassword();
      //     }
      //   },
      // ),
    );
  }
}
