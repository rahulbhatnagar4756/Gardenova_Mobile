import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/base/open_image_pciker_bottom_sheet.dart';
import 'package:kasagardem/base/widgets/base_date_format.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/settings/components/profile_icon_layout.dart';
import 'package:kasagardem/settings/components/settings_item_layout.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import '../base/widgets/common_click_widget.dart';
import '../base/widgets/full_screen_image_preview.dart';
import '../utils/constants/app_assets.dart';
import '../utils/constants/app_strings.dart';
import '../utils/utils.dart';

class SettingsScreen extends GetWidget<SettingsViewModel> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenColor,
      body: SafeArea(
        child: Container(
          color: AppColors.offWhite,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileIconLayout(
                  isEnableEditable: true,
                  title: AppStrings.profile,
                  isProfileEditable: false,
                  onClickPictureView: () {
                    String profileImage = controller.profileImage.value;
                    if (profileImage.trim().isEmpty) {
                      profileImage = AppAssets.appLogo;
                    }
                    FullScreenImageView.open(
                      imageUrl: profileImage,
                      heroTag: "profile_image_appbar",
                    );
                  },
                  onClickEditPencil: () {
                    // Get.toNamed(Routes.profile);
                    OpenImagePickerBottomSheet(
                      onPickImage: (isCamera) {
                        controller.pickImage(
                          isCamera: isCamera,
                          directApiCall: true,
                        );
                      },
                      onThenCall: () {},
                    ).show();
                  },
                ),
                SizedBox(height: 16.h),
                settingItemsLayout(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCategoryCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget buildSectionHeader(String title, {IconData? icon}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16.sp, color: AppColors.greenColor),
              SizedBox(width: 6.w),
            ],
            BaseText(
              text: title,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              textColor: AppColors.liteGreyColor.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    ).marginOnly(top: 18.h);
  }

  Widget settingItemsLayout(BuildContext context) {
    final bool isProfessional =
        SharedPrefsService.instance.getString(AppKeys.role) ==
        AppKeys.professional;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          if (isProfessional) ...[
            subscriptionPlanCard(),
            SizedBox(height: 10.h),
          ],

          // ACCOUNT SECTION
          buildSectionHeader(
            AppStrings.myProfile,
            icon: Icons.person_outline_rounded,
          ),
          buildCategoryCard([
            SettingsItemLayout(
              icon: Icons.person_outline_rounded,
              title: AppLocalizations.of(context)!.editProfile,
              subtitle: "Update name, email and phone",
              onTap: () {
                controller.getProfileDetail(showloader: true);
                Get.toNamed(Routes.profile);
              },
            ),
            Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
            SettingsItemLayout(
              icon: Icons.lock_outline_rounded,
              title: AppLocalizations.of(context)!.changePassword,
              subtitle: "Update your security password",
              onTap: () {
                controller.confirmPasswordController.clear();
                controller.newPasswordController.clear();
                Get.toNamed(Routes.changePassword);
              },
            ),
            Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
            SettingsItemLayout(
              icon: Icons.history,
              title: AppStrings.changeDiagnosis,
              subtitle: "Retake your evaluation answers",
              onTap: () => Get.toNamed(Routes.question, arguments: true),
            ),
          ]),

          // LEGAL SECTION
          buildSectionHeader(AppStrings.legal, icon: Icons.gavel_rounded),
          buildCategoryCard([
            SettingsItemLayout(
              icon: Icons.sticky_note_2_outlined,
              title: AppLocalizations.of(context)!.termsAndCondition,
              subtitle: "Read terms of use details",
              onTap: () => Get.toNamed(Routes.termsAndConditions),
            ),
            Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
            SettingsItemLayout(
              icon: Icons.privacy_tip_outlined,
              title: AppLocalizations.of(context)!.privacyPolicy,
              subtitle: "Check how we protect your data",
              onTap: () => Get.toNamed(Routes.privacyPolicy),
            ),
          ]),

          // ACTIONS SECTION
          buildSectionHeader(AppStrings.accountAction, icon: Icons.settings),
          buildCategoryCard([
            SettingsItemLayout(
              icon: Icons.power_settings_new_rounded,
              title: AppLocalizations.of(context)!.logout,
              subtitle: "Sign out of your active session",
              onTap: () => logout(),
              iconColor: AppColors.red,
              iconBgColor: AppColors.red.withValues(alpha: 0.1),
              titleColor: AppColors.red,
              trailingIconColor: AppColors.red.withValues(alpha: 0.5),
            ),
          ]),

          // VERSION FOOTER
          Obx(
            () => Container(
              margin: EdgeInsets.only(top: 32.h, bottom: 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.appLogo, width: 20.w, height: 20.w),
                      SizedBox(width: 8.w),
                      BaseText(
                        text: "Gardenova",
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        textColor: AppColors.blackColor.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  BaseText(
                    text: "Version ${controller.appVersion.value}",
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp,
                    textColor: AppColors.liteGreyColor.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget subscriptionPlanCard() {
    return Obx(
      () => controller.professionalProfileData.value != null
          ? Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(spacerSize16),
                  margin: EdgeInsets.only(bottom: spacerSize18),
                  decoration: BoxDecoration(
                    color: AppColors.greenColor,
                    borderRadius: BorderRadius.circular(spacerSize20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 4,
                                backgroundColor: AppColors.whiteColor,
                              ),
                              SizedBox(width: spacerSize6),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BaseText(
                                    text: AppLocalizations.of(
                                      Get.context!,
                                    )!.status.toUpperCase(),
                                    fontFamily: AppKeys.inter,
                                    textColor: AppColors.offWhite70,
                                    fontSize: fontSize10,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  Row(
                                    children: [
                                      BaseText(
                                        text: Utils.capitalize(
                                          controller
                                                  .professionalProfileData
                                                  .value!
                                                  .data!
                                                  .accountStatus ??
                                              "",
                                        ),
                                        fontFamily: AppKeys.inter,
                                        textColor: AppColors.whiteColor,
                                        fontSize: fontSize16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: spacerSize8,
                                  vertical: spacerSize6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColor,
                                  borderRadius: BorderRadius.circular(
                                    spacerSize20,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      AppAssets.crownIc,
                                      width: 11.w,
                                      height: 11.w,
                                    ),
                                    SizedBox(width: spacerSize6),
                                    BaseText(
                                      text:
                                          '${(controller.professionalProfileData.value!.data!.subscriptionPlan!)} Plan',
                                      fontSize: fontSize12,
                                      fontFamily: AppKeys.inter,
                                      fontWeight: FontWeight.w600,
                                      textColor: AppColors.greenColor,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: spacerSize8),
                              Align(
                                alignment: Alignment.centerRight,
                                child: CommonClickWidget(
                                  onTap: () {
                                    Get.toNamed(
                                      Routes.upgradePlan,
                                      arguments: {
                                        AppKeys.screenType: AppKeys.dashboard,
                                      },
                                    )!.then((val) {
                                      if (val == true) {
                                        controller
                                            .getProfessionalProfileDetail();
                                      }
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.sync,
                                        size: 11.w,
                                        color: AppColors.whiteColor,
                                      ),
                                      SizedBox(width: spacerSize4),
                                      BaseText(
                                        text:
                                            controller
                                                    .professionalProfileData
                                                    .value!
                                                    .data!
                                                    .subscriptionPlan ==
                                                "trial"
                                            ? AppLocalizations.of(
                                                Get.context!,
                                              )!.upgradeNow
                                            : AppLocalizations.of(
                                                Get.context!,
                                              )!.renewPlan,
                                        fontFamily: AppKeys.inter,
                                        fontSize: fontSize10,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppColors.whiteColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: spacerSize8),
                      Divider(
                        color: AppColors.whiteColor.withValues(alpha: 0.6),
                        thickness: 0.8,
                      ),
                      SizedBox(height: spacerSize8),
                      Container(
                        padding: EdgeInsets.all(spacerSize14),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(spacerSize16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: AppColors.whiteColor,
                                ),
                                SizedBox(width: spacerSize6),
                                BaseText(
                                  text: AppLocalizations.of(
                                    Get.context!,
                                  )!.subscriptionRemaining.toUpperCase(),
                                  fontFamily: AppKeys.inter,
                                  textColor: AppColors.whiteColor,
                                  fontSize: fontSize10,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                            SizedBox(height: spacerSize6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: SharedPrefsService.instance
                                            .getString(AppKeys.remainingDays),
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.whiteColor,
                                          fontFamily: AppKeys.inter,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            " ${AppLocalizations.of(Get.context!)!.days} ${AppLocalizations.of(Get.context!)!.left}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.offWhite70,
                                          fontFamily: AppKeys.inter,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    BaseText(
                                      text: AppLocalizations.of(
                                        Get.context!,
                                      )!.expDate,
                                      fontFamily: AppKeys.inter,
                                      textColor: AppColors.whiteColor,
                                      fontSize: fontSize10,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    SizedBox(height: spacerSize2),
                                    BaseText(
                                      text: BaseDateTimeFormat.format(
                                        dateTime:
                                            controller
                                                .professionalProfileData
                                                .value!
                                                .data!
                                                .endDate ??
                                            "",
                                        format: "MMM dd, yyyy",
                                      ),
                                      fontFamily: AppKeys.inter,
                                      textColor: AppColors.offWhite70,
                                      fontSize: fontSize12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 4,
                  margin: EdgeInsets.only(top: 0.3, left: 10.w, right: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(spacerSize24),
                    gradient: AppColors.linearGradientForBtn,
                  ),
                ),
              ],
            )
          : Container(),
    );
  }

  String getTitle() {
    return Get.locale == enUS
        ? AppLocalizations.of(Get.context!)!.changeToPortugese
        : AppLocalizations.of(Get.context!)!.changeToEnglish;
  }

  void logout() {
    BaseDialog.showAlertDialog(
      context: Get.context!,
      buttonLabel: AppLocalizations.of(Get.context!)!.confirm,
      title: AppLocalizations.of(Get.context!)!.logout,
      description: AppLocalizations.of(Get.context!)!.areYouSureYouWantToLogout,
      onButtonPressed: () {
        SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, false);
        SharedPrefsService.instance.clear();
        SharedPrefsService.instance.setString(AppKeys.role, AppKeys.user);
        Get.offAllNamed(Routes.login);
      },
    );
  }

  void deleteAccountDialog() {
    BaseDialog.showAlertDialog(
      context: Get.context!,
      buttonLabel: AppLocalizations.of(Get.context!)!.confirm,
      title: AppLocalizations.of(Get.context!)!.deleteAccount,
      description: AppLocalizations.of(
        Get.context!,
      )!.areYouSureYouWantToDeleteYourAccount,
      onButtonPressed: () {
        controller.callDeleteAccountApi();
      },
    );
  }
}
