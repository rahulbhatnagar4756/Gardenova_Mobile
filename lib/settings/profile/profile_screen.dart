import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/settings/components/bottom_sheet_layout.dart';
import 'package:kasagardem/settings/components/profile_icon_layout.dart';
import 'package:kasagardem/settings/components/text_field_layout.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../utils/constants/app_keys.dart';

class ProfileScreen extends GetWidget<SettingsViewModel> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGreen,
      appBar: BaseAppBar(
        isAppIconVisible: false,
        title: AppLocalizations.of(context)!.editProfile,
        toolbarHeightScale: 1,
      ),
      body: ProfileIconLayout(isProfileEditable: true),

      bottomSheet: controller.screenType.value == AppKeys.professional
          ? BottomSheetLayout(
              childLayout: Obx(
                () => SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: spacerSize100),
                  child: Column(
                    children: [
                      TextFieldLayout(
                        editTextTitle: AppLocalizations.of(context)!.yourName,
                        textEditingController: TextEditingController(
                          text: controller.name.value,
                        ),
                        isTextFieldEnabled: false,
                      ),

                      TextFieldLayout(
                        editTextTitle: AppLocalizations.of(
                          context,
                        )!.yourEmailId,
                        textEditingController: TextEditingController(
                          text: controller.email.value,
                        ),
                        isTextFieldEnabled: false,
                      ),

                      if (controller.screenType.value == AppKeys.professional)
                        TextFieldLayout(
                          editTextTitle: AppLocalizations.of(
                            context,
                          )!.description,
                          textEditingController:
                              controller.descriptionController,
                          isTextFieldEnabled: true,
                        ),

                      if (controller.screenType.value == AppKeys.professional)
                        TextFieldLayout(
                          editTextTitle: AppLocalizations.of(context)!.region,
                          textEditingController: controller.regionController,
                          isTextFieldEnabled: true,
                        ),

                      if (controller.screenType.value == AppKeys.professional)
                        TextFieldLayout(
                          editTextTitle: AppLocalizations.of(
                            context,
                          )!.specialty,
                          textEditingController: controller.specialtyController,
                          isTextFieldEnabled: true,
                        ),
                    ],
                  ),
                ),
              ),

              buttonLabel: AppLocalizations.of(
                context,
              )!.saveChanges.toUpperCase(),
              onButtonTap: () {
                if (controller.screenType.value == AppKeys.professional) {
                  controller.updateProfessionalProfile();
                } else {
                  controller.updateProfile();
                }
              },
            )
          : BottomSheetLayout(
              childLayout: Obx(
                () => Column(
                  children: [
                    TextFieldLayout(
                      editTextTitle: AppLocalizations.of(context)!.yourName,
                      textEditingController: TextEditingController(
                        text: controller.name.value,
                      ),
                      hintText: AppLocalizations.of(context)!.enterYourName,
                      isTextFieldEnabled: false,
                    ),

                    TextFieldLayout(
                      editTextTitle: AppLocalizations.of(context)!.yourEmailId,
                      textEditingController: TextEditingController(
                        text: controller.email.value,
                      ),
                      isTextFieldEnabled: false,
                      hintText: AppLocalizations.of(context)!.enterYourEmail,
                    ),
                  ],
                ),
              ),
              buttonLabel: AppLocalizations.of(
                context,
              )!.saveChanges.toUpperCase(),
              onButtonTap: () {
                if (controller.screenType.value == AppKeys.professional) {
                  controller.updateProfessionalProfile();
                } else {
                  controller.updateProfile();
                }
              },
            ),
    );
  }
}
