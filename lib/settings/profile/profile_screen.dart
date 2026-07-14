import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/open_image_pciker_bottom_sheet.dart';
import 'package:kasagardem/base/widgets/full_screen_image_preview.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/settings/components/profile_icon_layout.dart';
import 'package:kasagardem/settings/components/settings_item_layout.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';
import 'package:kasagardem/utils/routes.dart';

import '../../base/widgets/subscription_status_view_widget.dart';

class ProfileScreen extends GetWidget<SettingsViewModel> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greenColor,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          color: AppColors.offWhite,
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProfileIconLayout(
                  isEnableEditable: true,
                  isProfileEditable: false,
                  onClickEditPencil: () {
                    OpenImagePickerBottomSheet(
                      onPickImage: (isCamera) {
                        controller.pickImage(isCamera: isCamera, directApiCall: true);
                      },
                      onThenCall: () {},
                    ).show();
                  },
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
                  title: AppLocalizations.of(context)!.myProfile,
                ),
                SizedBox(height: 24.h),
                subscriptionPlanCard(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: buildCategoryCard([
                    SettingsItemLayout(
                      icon: Icons.person_outline_rounded,
                      title: AppLocalizations.of(context)!.editProfile,
                      subtitle: "Update name, email and phone",
                      onTap: () {
                        controller.getProfileDetail(showloader: true);
                        Get.toNamed(Routes.editProfile);
                      },
                    ),
                    Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
                    Obx(
                      () => SettingsItemLayout(
                        icon: Icons.lock_outline_rounded,
                        title: controller.isEmailLogedInUser.value
                            ? AppLocalizations.of(context)!.changePassword
                            : AppStrings.setPwd,
                        subtitle: controller.isEmailLogedInUser.value
                            ? AppStrings.changePwdMsg
                            : AppStrings.setPwdMsg,
                        onTap: () {
                          controller.confirmPasswordController.clear();
                          controller.newPasswordController.clear();
                          Get.toNamed(Routes.changePassword);
                        },
                      ),
                    ),
                    Divider(color: Colors.grey.shade100, height: 1, thickness: 1),
                    SettingsItemLayout(
                      icon: Icons.history,
                      title: AppStrings.changeDiagnosis,
                      subtitle: "Retake your evaluation answers",
                      onTap: () => Get.toNamed(Routes.question, arguments: true),
                    ),
                  ]),
                ),
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

  Widget subscriptionPlanCard() {
    return Obx(
      () => controller.currentSubscriptionStatusModel.value != null
          ? SubscriptionStatusViewWidget(
              controller.currentSubscriptionStatusModel.value!,
              onUpgradeRefresh: () {
                controller.getSubcriptionDetail();
                controller.getProfileDetail();
              },
            ).paddingSymmetric(horizontal: 16.w)
          : Container(),
    );
  }
}
