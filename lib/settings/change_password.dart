import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_form.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/settings/components/bottom_sheet_layout.dart';
import 'package:kasagardem/settings/components/profile_icon_layout.dart';
import 'package:kasagardem/settings/components/text_field_layout.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';


class ChangePassword extends GetWidget<SettingsViewModel> {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      appBar: BaseAppBar(
        isAppIconVisible: false,
        title: AppLocalizations.of(context)!.changePassword,
        toolbarHeightScale: 1,
      ),
      body: ProfileIconLayout(),
      bottomSheet: BottomSheetLayout(
        childLayout: BaseForm(
          formKey: controller.changePasswordFormKey,
          child: Column(
            children: [
              TextFieldLayout(
                editTextTitle: AppLocalizations.of(context)!.currentPassword,
                textEditingController: controller.oldPasswordController,
                isTextObscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(
                      context,
                    )!.passwordFieldCannotBeEmpty;
                  }
                  return null;
                },
              ),

              TextFieldLayout(
                editTextTitle: AppLocalizations.of(context)!.newPassword,
                textEditingController: controller.newPasswordController,
                isTextObscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(
                      context,
                    )!.passwordFieldCannotBeEmpty;
                  }
                  return null;
                },
              ),
              TextFieldLayout(
                editTextTitle: AppLocalizations.of(context)!.confirmNewPassword,
                textEditingController: controller.confirmPasswordController,
                isTextObscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(
                      context,
                    )!.passwordFieldCannotBeEmpty;
                  }

                  if (value != controller.newPasswordController.text) {
                    return AppLocalizations.of(context)!.passwordsDoNotMatch;
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
        buttonLabel: AppLocalizations.of(context)!.saveChanges.toUpperCase(),
        onButtonTap: () {
          if (controller.changePasswordFormKey.currentState!.validate()) {
            controller.updatePassword();
          }
        },
      ),
    );
  }
}
