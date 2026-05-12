import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
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
import '../utils/constants/app_assets.dart';
import '../utils/utils.dart';

class SettingsScreen extends GetWidget<SettingsViewModel> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenColor,

      body: SafeArea(
        child: Container(
          color: AppColors.whiteColor,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileIconLayout(
                  isEnableEditable: true,
                  title: AppLocalizations.of(context)!.settings,
                  isProfileEditable: false,
                  onClickEditPencil: () {
                    Get.toNamed(Routes.profile);
                  },
                ),
                SizedBox(height: 34.h),
                settingItemsLayout(context),
              ],
            ),
          ),
        ),
      ),
      // bottomSheet: BottomSheetLayout(
      //   buttonLabel: AppLocalizations.of(context)!.logout.toUpperCase(),
      //   childLayout: settingItemsLayout(context),
      //   onButtonTap: logout,
      // ),
    );
  }

  Widget settingItemsLayout(BuildContext context) {
    if (SharedPrefsService.instance.getString(AppKeys.role) !=
        AppKeys.professional) {
      return Column(
        children: [
          SettingsItemLayout(
            icon: Icons.lock_outline_rounded,
            title: AppLocalizations.of(context)!.changePassword,
            onTap: () {
              controller.confirmPasswordController.clear();
              controller.newPasswordController.clear();
              Get.toNamed(Routes.changePassword);
            },
          ),
          // SizedBox(height: 10.h,),

          // SettingsItemLayout(
          //   icon: Icons.translate,
          //   title: getTitle(),
          //   onTap: () => _changeLanguage(),
          // ),
          SizedBox(height: 10.h),
          SettingsItemLayout(
            icon: Icons.sticky_note_2_outlined,
            title: AppLocalizations.of(context)!.termsAndCondition,
            onTap: () => Get.toNamed(Routes.termsAndConditions),
          ),
          SizedBox(height: 10.h),
          SettingsItemLayout(
            icon: Icons.privacy_tip_outlined,
            title: AppLocalizations.of(context)!.privacyPolicy,
            onTap: () => Get.toNamed(Routes.privacyPolicy),
          ),
          SizedBox(height: 10.h),
          SettingsItemLayout(
            icon: Icons.power_settings_new_rounded,
            title: AppLocalizations.of(context)!.logout,
            onTap: () => logout(),
          ),

          /*     SettingsItemLayout(
            icon: Icons.delete_forever,
            title: AppLocalizations.of(context)!.deleteAccount,
            onTap: () {
              deleteAccountDialog();
            },
          ),*/

          /*   SettingsItemLayout(
          icon: Icons.share_outlined,
          title: AppLocalizations.of(context)!.referAFriend,
          onTap: () {
            // if (controller.isShareInProgress.value) return;
            //  controller.isShareInProgress.value = true;
            try {
              Get.toNamed(Routes.plantDetail);
                           ShareParams share = ShareParams(uri: Uri.tryParse("www.google.com"));
              SharePlus.instance
                  .share(share)
                  .whenComplete(() => controller.isShareInProgress.value = false);
            } catch (e) {
              controller.isShareInProgress.value = false;
            }
          },
        ),*/
        ],
      ).paddingSymmetric(horizontal: 20.w);
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            subscriptionPlanCard(),

            SettingsItemLayout(
              icon: Icons.lock_outline_rounded,
              title: AppLocalizations.of(context)!.changePassword,
              onTap: () {
                controller.confirmPasswordController.clear();
                controller.newPasswordController.clear();
                Get.toNamed(Routes.changePassword);
              },
            ),
            // SizedBox(height: 10.h,),
            // SettingsItemLayout(
            //   icon: Icons.translate,
            //   title: getTitle(),
            //   onTap: () => _changeLanguage(),
            // ),
            SizedBox(height: 10.h),
            SettingsItemLayout(
              icon: Icons.sticky_note_2_outlined,
              title: AppLocalizations.of(context)!.termsAndCondition,
              onTap: () => Get.toNamed(Routes.termsAndConditions),
            ),
            SizedBox(height: 10.h),
            SettingsItemLayout(
              icon: Icons.privacy_tip_outlined,
              title: AppLocalizations.of(context)!.privacyPolicy,
              onTap: () => Get.toNamed(Routes.privacyPolicy),
            ),
            SizedBox(height: 10.h),
            SettingsItemLayout(
              icon: Icons.power_settings_new_rounded,
              title: AppLocalizations.of(context)!.logout,
              onTap: () => logout(),
            ),

            /*     SettingsItemLayout(
              icon: Icons.delete_forever,
              title: AppLocalizations.of(context)!.deleteAccount,
              onTap: () {
                deleteAccountDialog();


              },
            ),
*/
            SizedBox(height: spacerSize60),

            /*   SettingsItemLayout(
            icon: Icons.share_outlined,
            title: AppLocalizations.of(context)!.referAFriend,
            onTap: () {
              // if (controller.isShareInProgress.value) return;
              //  controller.isShareInProgress.value = true;
              try {
                Get.toNamed(Routes.plantDetail);
                             ShareParams share = ShareParams(uri: Uri.tryParse("www.google.com"));
                SharePlus.instance
                    .share(share)
                    .whenComplete(() => controller.isShareInProgress.value = false);
              } catch (e) {
                controller.isShareInProgress.value = false;
              }
            },
          ),*/
          ],
        ).paddingSymmetric(horizontal: 20.w),
      );
    }
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
                      /// 🔹 TOP ROW (Status + Plan)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// STATUS
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

                          /// PLAN BADGE
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

                              /// 🔹 RENEW / UPGRADE
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

                      /// 🔹 INNER CARD
                      Container(
                        padding: EdgeInsets.all(spacerSize14),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(spacerSize16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// SUBSCRIPTION LABEL
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

                            /// DAYS LEFT + EXPIRY
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// DAYS LEFT
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

                                /// EXPIRY DATE
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

  // void _changeLanguage() {
  //   BaseDialog.showAlertDialog(
  //     context: Get.context!,
  //     buttonLabel: AppLocalizations.of(Get.context!)!.confirm,
  //     title: AppLocalizations.of(Get.context!)!.changeLanguage,
  //     description: AppLocalizations.of(
  //       Get.context!,
  //     )!.areYouSureYouWantToChangeTheLanguage,
  //     onButtonPressed: () {
  //       Get.updateLocale(Get.locale == enUS ? ptBR : enUS);
  //       Get.reloadAll();
  //       SharedPrefsService.instance.setString(
  //         AppKeys.selectedLang,
  //         Get.locale!.languageCode.toString(),
  //       );

  //       if (SharedPrefsService.instance.getString(AppKeys.role) ==
  //           AppKeys.professional) {
  //         Get.back(result: true);
  //         Get.back(result: true);
  //       } else {
  //         Get.back(result: true);
  //         if (Get.arguments == 'question') {
  //           Get.offAllNamed(Routes.introduction);
  //         } else {
  //           Get.back(result: true);
  //         }
  //       }
  //     },
  //   );
  // }

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
        // Get.offAllNamed(Routes.chooseAccountType);
        SharedPrefsService.instance.setString(AppKeys.role, AppKeys.user);
        Get.offAllNamed(Routes.introduction);
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
