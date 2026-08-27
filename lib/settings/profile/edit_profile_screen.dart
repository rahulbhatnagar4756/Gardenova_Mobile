import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/open_image_pciker_bottom_sheet.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/settings/components/bottom_sheet_layout.dart';
import 'package:kasagardem/settings/components/profile_icon_layout.dart';
import 'package:kasagardem/settings/components/text_field_layout.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';
import 'package:kasagardem/utils/validation_healper.dart';

class EditProfileScreen extends GetWidget<SettingsViewModel> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: SafeArea(
        top: false,
        child: Container(
          color: AppColors.whiteColor,
          height: double.infinity,
          child: Column(
              children: [
                ProfileIconLayout(
                  isEnableEditable: true,
                  isProfileEditable: true,
                  onClickEditPencil: () {
                    log('inside the on Click Edit pencil');
                  },
                  onClickPictureView: () {
                    OpenImagePickerBottomSheet(
                      onPickImage: (isCamera) {
                        controller.pickImage(isCamera: isCamera, directApiCall: false);
                      },
                      onThenCall: () {},
                    ).show();
                  },
                  title: AppLocalizations.of(context)!.editProfile,
                ),
                SizedBox(height: 14.h),
                Expanded(
                  child: Form(
                    key: controller.profileFormKey,
                    child: Obx(() {
                      return controller.screenType.value == AppKeys.professional
                          ? BottomSheetLayout(
                              childLayout: Obx(
                                () => SingleChildScrollView(
                                  padding: const EdgeInsets.only(bottom: spacerSize100),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextFieldLayout(
                                        prefixIcon: Icon(
                                          Icons.person_outline_rounded,
                                          color: AppColors.greenColor,
                                        ),
                                        editTextTitle: AppLocalizations.of(context)!.yourName,
                                        textEditingController: TextEditingController(
                                          text: controller.name.value,
                                        ),
                                        isTextFieldEnabled: false,
                                      ),

                                      TextFieldLayout(
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: AppColors.greenColor,
                                        ),
                                        editTextTitle: AppLocalizations.of(context)!.yourEmailId,
                                        textEditingController: TextEditingController(
                                          text: controller.email.value,
                                        ),
                                        isTextFieldEnabled: false,
                                      ),
                                      phoneNoField(context),
                                      if (controller.screenType.value == AppKeys.professional)
                                        TextFieldLayout(
                                          editTextTitle: AppLocalizations.of(context)!.description,
                                          textEditingController: controller.descriptionController,
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
                                          editTextTitle: AppLocalizations.of(context)!.specialty,
                                          textEditingController: controller.specialtyController,
                                          isTextFieldEnabled: true,
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              buttonLabel: AppLocalizations.of(context)!.saveChanges,
                              onButtonTap: () => _onSaveChanges(context),
                            )
                          : BottomSheetLayout(
                              childLayout: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BaseText(
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppKeys.poppins,
                                      fontSize: 13.sp,
                                      text: AppLocalizations.of(context)!.yourName,
                                    ).paddingOnly(bottom: 3.h),
                                    BaseTextField(
                                      prefixIcon: Icon(
                                        Icons.person_outline_rounded,
                                        color: AppColors.greenColor,
                                      ),
                                      hintText: AppLocalizations.of(context)!.name,
                                      keyboardType: TextInputType.name,
                                      textEditingController: controller.nameController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]')),
                                      ],
                                      validator: ValidationHelper.validateName,
                                    ),
                                    SizedBox(height: 15.h),

                                    BaseText(
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppKeys.poppins,
                                      fontSize: 13.sp,
                                      text: AppLocalizations.of(context)!.yourEmailId,
                                    ).paddingOnly(bottom: 3.h),
                                    BaseTextField(
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: AppColors.greenColor,
                                      ),
                                      hintText: AppLocalizations.of(context)!.yourEmailId,
                                      keyboardType: TextInputType.emailAddress,
                                      textEditingController: controller.emailController,
                                      isTextFieldEnabled: true,
                                      validator: ValidationHelper.validateEmail,
                                      onChanged: controller.onEmailChanged,
                                      suffixIcon: Obx(() {
                                        if (controller.showVerifyButton.value) {
                                          if (controller.countdownTimer.value > 0) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "0${controller.countdownTimer.value ~/ 60}:${(controller.countdownTimer.value % 60).toString().padLeft(2, '0')}",
                                                    style: TextStyle(
                                                      color: AppColors.burntGold,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          return TextButton(
                                            onPressed: () {
                                              controller.sendEmailVerification();
                                            },
                                            child: Text(
                                              'Verify',
                                              style: TextStyle(
                                                color: AppColors.greenColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      }),
                                    ),
                                    SizedBox(height: 15.h),
                                    BaseText(
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppKeys.poppins,
                                      fontSize: 13.sp,
                                      text: AppStrings.yourPhoneNo,
                                    ).paddingOnly(bottom: 3.h),
                                    phoneNoField(context),
                                  ],
                                ),
                              ),
                              buttonLabel: AppLocalizations.of(context)!.saveChanges,
                              onButtonTap: () => _onSaveChanges(context),
                            );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  void _onSaveChanges(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(context).unfocus();
    if (controller.profileFormKey.currentState!.validate()) {
      if (controller.screenType.value == AppKeys.professional) {
        controller.updateProfessionalProfile();
      } else {
        controller.updateProfile();
      }
    }
  }

  Widget phoneNoField(BuildContext context) {
    return BaseTextField(
      prefixIcon: Icon(Icons.phone_outlined, color: AppColors.greenColor),
      hintText: AppLocalizations.of(context)!.enterYourPhoneNo,
      keyboardType: TextInputType.phone,
      textEditingController: controller.phoneNoController,
      isTextFieldEnabled: true,
      maxLength: 10,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      validator: ValidationHelper.validatePhone,
    );
  }
}
