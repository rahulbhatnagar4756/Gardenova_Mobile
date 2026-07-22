import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/services/reminder_push_notification_service.dart';
import 'package:kasagardem/settings/components/profile_icon_layout.dart';
import 'package:kasagardem/settings/components/settings_item_layout.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

import '../base/widgets/full_screen_image_preview.dart';
import '../base/widgets/subscription_status_view_widget.dart';
import '../subscription/subscription_navigation.dart';
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
                  isEnableEditable: false,
                  title: AppLocalizations.of(context)!.settings,
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
    final bool isProfessional = SubscriptionNavigation.isProfessional;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          if (!isProfessional) subscriptionPlanCard(),

          // GENERAL / PROFILE SECTION
          buildSectionHeader("General", icon: Icons.settings_outlined),
          buildCategoryCard([
            SettingsItemLayout(
              icon: Icons.person_outline_rounded,
              title: AppLocalizations.of(context)!.myProfile,
              subtitle: "View profile details and settings",
              onTap: () {
                controller.getProfileDetail(showloader: true);
                Utils.callSettingBasicApi();
                Get.toNamed(Routes.profile);
              },
            ),
            Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
            buildNotificationItem(context),
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
          buildSectionHeader(AppStrings.accountAction, icon: Icons.shield_outlined),
          buildCategoryCard([
            SettingsItemLayout(
              icon: Icons.delete_outline_rounded,
              title: AppLocalizations.of(context)!.deleteAccount,
              subtitle: "Permanently delete your account",
              onTap: () => deleteAccountDialog(),
              iconColor: AppColors.red,
              iconBgColor: AppColors.red.withValues(alpha: 0.1),
              titleColor: AppColors.red,
              trailingIconColor: AppColors.red.withValues(alpha: 0.5),
            ),
            Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
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

  Widget buildNotificationItem(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.w,
              decoration: BoxDecoration(
                color: AppColors.greenColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.greenColor,
                  size: 20.w,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BaseText(
                    text: "Notifications",
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize14.sp,
                    textColor: AppColors.blackColor,
                  ),
                  SizedBox(height: 4.h),
                  BaseText(
                    text: "Enable or disable app alerts",
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp,
                    textColor: AppColors.liteGreyColor,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Obx(
              () => Switch(
                value: controller.notificationsEnabled.value,
                onChanged: (val) {
                  controller.toggleNotifications(val);
                },
                activeTrackColor: AppColors.greenColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget subscriptionPlanCard() {
    return Obx(
      () => controller.currentSubscriptionStatusModel.value != null
          ? SubscriptionStatusViewWidget(
              controller.currentSubscriptionStatusModel.value!,
              showCancelAction: controller.canCancelSubscription,
              isCancellingSubscription: controller.isCancellingSubscription.value,
              onCancelSubscription: controller.showCancelSubscriptionDialog,
              onUpgradeRefresh: () {
                controller.getProfileDetail();
              },
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
      onButtonPressed: () async {
        await ReminderPushNotificationService.instance.onUserLogout();
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
      description: AppLocalizations.of(Get.context!)!.areYouSureYouWantToDeleteYourAccount,
      onButtonPressed: () {
        controller.callDeleteAccountApi();
      },
    );
  }
}
