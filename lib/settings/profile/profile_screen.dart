import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/settings/components/bottom_sheet_layout.dart';
import 'package:kasagardem/settings/components/profile_icon_layout.dart';
import 'package:kasagardem/settings/components/text_field_layout.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../base/widgets/base_text_field.dart';
import '../../utils/constants/app_keys.dart';

class ProfileScreen extends GetWidget<SettingsViewModel> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      // appBar: BaseAppBar(
      //   isAppIconVisible: false,
      //   title: AppLocalizations.of(context)!.editProfile,
      //   toolbarHeightScale: 1,
      // ),
      body: Container(
        color: AppColors.greenColor,
        child: SafeArea(
          child: Container(
            color: AppColors.whiteColor,
            height: double.infinity,
            child: Column(
              children: [
                ProfileIconLayout(
                  isEnableEditable: true,
                  isProfileEditable: true,
                  onClickEditPencil: () {
                    print('inside the on Click Edit pencil');

                  },
                  title: AppLocalizations.of(context)!.editProfile,
                ),
                SizedBox(height: 34.h),
                Expanded(
                  child: Obx(() {
                    return controller.screenType.value == AppKeys.professional
                        ? BottomSheetLayout(
                            childLayout: Obx(
                              () => SingleChildScrollView(
                                padding: const EdgeInsets.only(
                                  bottom: spacerSize100,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFieldLayout(
                                      editTextTitle: AppLocalizations.of(
                                        context,
                                      )!.yourName,
                                      textEditingController:
                                          TextEditingController(
                                            text: controller.name.value,
                                          ),
                                      isTextFieldEnabled: false,
                                    ),

                                    TextFieldLayout(
                                      editTextTitle: AppLocalizations.of(
                                        context,
                                      )!.yourEmailId,
                                      textEditingController:
                                          TextEditingController(
                                            text: controller.email.value,
                                          ),
                                      isTextFieldEnabled: false,
                                    ),

                                    // if (controller.screenType.value == AppKeys.professional)
                                    //   TextFieldLayout(
                                    //     editTextTitle: AppLocalizations.of(
                                    //       context,
                                    //     )!.description,
                                    //     textEditingController:
                                    //     controller.descriptionController,
                                    //     isTextFieldEnabled: true,
                                    //   ),

                                    // TextFieldLayout(
                                    //   editTextTitle: AppLocalizations.of(context)!.yourName,
                                    //   textEditingController: TextEditingController(
                                    //     text: controller.name.value,
                                    //   ),
                                    //   isTextFieldEnabled: false,
                                    // ),
                                    // BaseTextField(
                                    //   hintText: AppLocalizations.of(context)!.name,
                                    //   keyboardType: TextInputType.name,
                                    //   textEditingController: TextEditingController(
                                    //     text: controller.name.value,
                                    //   ),
                                    //   isTextObscure: true,
                                    // ),
                                    // // TextFieldLayout(
                                    // //   editTextTitle: AppLocalizations.of(context)!.yourName,
                                    // //   textEditingController: TextEditingController(
                                    // //     text: controller.name.value,
                                    // //   ),
                                    // //   isTextFieldEnabled: false,
                                    // // ),
                                    //
                                    // TextFieldLayout(
                                    //   editTextTitle: AppLocalizations.of(
                                    //     context,
                                    //   )!.yourEmailId,
                                    //   textEditingController: TextEditingController(
                                    //     text: controller.email.value,
                                    //   ),
                                    //   isTextFieldEnabled: false,
                                    // ),
                                    if (controller.screenType.value ==
                                        AppKeys.professional)
                                      TextFieldLayout(
                                        editTextTitle: AppLocalizations.of(
                                          context,
                                        )!.description,
                                        textEditingController:
                                            controller.descriptionController,
                                        isTextFieldEnabled: true,
                                      ),

                                    if (controller.screenType.value ==
                                        AppKeys.professional)
                                      TextFieldLayout(
                                        editTextTitle: AppLocalizations.of(
                                          context,
                                        )!.region,
                                        textEditingController:
                                            controller.regionController,
                                        isTextFieldEnabled: true,
                                      ),

                                    if (controller.screenType.value ==
                                        AppKeys.professional)
                                      TextFieldLayout(
                                        editTextTitle: AppLocalizations.of(
                                          context,
                                        )!.specialty,
                                        textEditingController:
                                            controller.specialtyController,
                                        isTextFieldEnabled: true,
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            buttonLabel: AppLocalizations.of(
                              context,
                            )!.saveChanges,
                            onButtonTap: () {
                              if (controller.screenType.value ==
                                  AppKeys.professional) {
                                controller.updateProfessionalProfile();
                              } else {
                                controller.updateProfile();
                              }
                            },
                          )
                        : BottomSheetLayout(
                            childLayout: Obx(
                              () => SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // TextFieldLayout(
                                    //   editTextTitle: AppLocalizations.of(context)!.yourName,
                                    //   textEditingController: TextEditingController(
                                    //     text: controller.name.value,
                                    //   ),
                                    //   hintText: AppLocalizations.of(context)!.enterYourName,
                                    //   isTextFieldEnabled: false,
                                    // ),
                                    BaseText(
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppKeys.poppins,
                                      fontSize: 13.sp,
                                      text: AppLocalizations.of(
                                        context,
                                      )!.yourName,
                                    ).paddingOnly(bottom: 3.h),
                                    BaseTextField(
                                      // labelText:AppLocalizations.of(context)!.yourName ,
                                      hintText: AppLocalizations.of(
                                        context,
                                      )!.name,
                                      keyboardType: TextInputType.name,
                                      textEditingController:
                                          TextEditingController(
                                            text: controller.name.value,
                                          ),
                                      isTextFieldEnabled: false,
                                    ),
                                    SizedBox(height: 15.h),
                                    // TextFieldLayout(
                                    //   editTextTitle: AppLocalizations.of(context)!.yourEmailId,
                                    //   textEditingController: TextEditingController(
                                    //     text: controller.email.value,
                                    //   ),
                                    //   isTextFieldEnabled: false,
                                    //   hintText: AppLocalizations.of(context)!.enterYourEmail,
                                    // ),
                                    BaseText(
                                      textAlign: TextAlign.start,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: AppKeys.poppins,
                                      fontSize: 13.sp,
                                      text: AppLocalizations.of(
                                        context,
                                      )!.yourEmailId,
                                    ).paddingOnly(bottom: 3.h),
                                    BaseTextField(
                                      // labelText:AppLocalizations.of(context)!.yourName ,
                                      hintText: AppLocalizations.of(
                                        context,
                                      )!.yourEmailId,
                                      keyboardType: TextInputType.emailAddress,
                                      textEditingController:
                                          TextEditingController(
                                            text: controller.email.value,
                                          ),
                                      isTextFieldEnabled: false,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            buttonLabel: AppLocalizations.of(
                              context,
                            )!.saveChanges,
                            onButtonTap: () {
                              if (controller.screenType.value ==
                                  AppKeys.professional) {
                                controller.updateProfessionalProfile();
                              } else {
                                controller.updateProfile();
                              }
                            },
                          );
                  }),
                ),

                // settingItemsLayout(context)
              ],
            ),
          ),
        ),
      ),

      // bottomSheet: controller.screenType.value == AppKeys.professional
      //     ? BottomSheetLayout(
      //         childLayout: Obx(
      //           () => SingleChildScrollView(
      //             padding: const EdgeInsets.only(bottom: spacerSize100),
      //             child: Column(
      //               children: [
      //                 TextFieldLayout(
      //                   editTextTitle: AppLocalizations.of(context)!.yourName,
      //                   textEditingController: TextEditingController(
      //                     text: controller.name.value,
      //                   ),
      //                   isTextFieldEnabled: false,
      //                 ),
      //
      //                 TextFieldLayout(
      //                   editTextTitle: AppLocalizations.of(
      //                     context,
      //                   )!.yourEmailId,
      //                   textEditingController: TextEditingController(
      //                     text: controller.email.value,
      //                   ),
      //                   isTextFieldEnabled: false,
      //                 ),
      //
      //                 if (controller.screenType.value == AppKeys.professional)
      //                   TextFieldLayout(
      //                     editTextTitle: AppLocalizations.of(
      //                       context,
      //                     )!.description,
      //                     textEditingController:
      //                         controller.descriptionController,
      //                     isTextFieldEnabled: true,
      //                   ),
      //
      //                 if (controller.screenType.value == AppKeys.professional)
      //                   TextFieldLayout(
      //                     editTextTitle: AppLocalizations.of(context)!.region,
      //                     textEditingController: controller.regionController,
      //                     isTextFieldEnabled: true,
      //                   ),
      //
      //                 if (controller.screenType.value == AppKeys.professional)
      //                   TextFieldLayout(
      //                     editTextTitle: AppLocalizations.of(
      //                       context,
      //                     )!.specialty,
      //                     textEditingController: controller.specialtyController,
      //                     isTextFieldEnabled: true,
      //                   ),
      //               ],
      //             ),
      //           ),
      //         ),
      //
      //         buttonLabel: AppLocalizations.of(
      //           context,
      //         )!.saveChanges.toUpperCase(),
      //         onButtonTap: () {
      //           if (controller.screenType.value == AppKeys.professional) {
      //             controller.updateProfessionalProfile();
      //           } else {
      //             controller.updateProfile();
      //           }
      //         },
      //       )
      //     : BottomSheetLayout(
      //         childLayout: Obx(
      //           () => Column(
      //             children: [
      //               TextFieldLayout(
      //                 editTextTitle: AppLocalizations.of(context)!.yourName,
      //                 textEditingController: TextEditingController(
      //                   text: controller.name.value,
      //                 ),
      //                 hintText: AppLocalizations.of(context)!.enterYourName,
      //                 isTextFieldEnabled: false,
      //               ),
      //
      //               TextFieldLayout(
      //                 editTextTitle: AppLocalizations.of(context)!.yourEmailId,
      //                 textEditingController: TextEditingController(
      //                   text: controller.email.value,
      //                 ),
      //                 isTextFieldEnabled: false,
      //                 hintText: AppLocalizations.of(context)!.enterYourEmail,
      //               ),
      //             ],
      //           ),
      //         ),
      //         buttonLabel: AppLocalizations.of(
      //           context,
      //         )!.saveChanges.toUpperCase(),
      //         onButtonTap: () {
      //           if (controller.screenType.value == AppKeys.professional) {
      //             controller.updateProfessionalProfile();
      //           } else {
      //             controller.updateProfile();
      //           }
      //         },
      //       ),
    );
  }
}
