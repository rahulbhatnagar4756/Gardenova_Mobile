import 'package:kasagardem/base/widgets/safe_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/clickable_image.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../base/widgets/common_click_widget.dart';

class ProfileIconLayout extends GetWidget<SettingsViewModel> {
  const ProfileIconLayout({
    super.key,
    this.isProfileEditable = false,
    required this.isEnableEditable,
    this.onClickEditPencil,
    this.onClickPictureView,
    required this.title,
  });

  final String title;
  final bool? isProfileEditable;
  final Function? onClickPictureView;
  final Function? onClickEditPencil;
  final bool? isEnableEditable;

  static const double _identityAvatarSize = 76;
  static const double _editAvatarSize = 108;

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: darkHeaderSystemOverlayStyle,
      child: Container(
        padding: EdgeInsets.only(bottom: 20.h, top: 5.h + statusBarHeight),
        decoration: BoxDecoration(
          gradient: AppColors.linearGradientForBtn,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.r),
            bottomRight: Radius.circular(25.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                CommonClickWidget(
                  // test: true,
                  onTap: () => Get.back(result: true),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 8.h,
                      left: 12.w,
                      right: 15.w,
                      bottom: 10.h,
                    ),
                    child: Image.asset(
                      color: AppColors.whiteColor,
                      AppAssets.backBtnIc,
                      width: 20.w,
                      height: 20.w,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 17.w, top: 7.h, bottom: 10.w),

                  // color: Colors.red,
                  child: BaseText(
                    text: title,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize16,
                    textColor: AppColors.whiteColor,
                  ),
                ),
              ],
            ),
            (isProfileEditable == true)
                ? _buildCenteredAvatar()
                    .marginOnly(bottom: spacerSize10, top: spacerSize10)
                : _buildIdentityRow()
                    .marginOnly(bottom: spacerSize10, top: spacerSize6),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildAvatar(size: _identityAvatarSize.w),
          SizedBox(width: 14.w),
          Expanded(child: nameAndEmailFields()),
        ],
      ),
    );
  }

  Widget _buildCenteredAvatar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildAvatar(size: _editAvatarSize.w),
      ],
    );
  }

  Widget _buildAvatar({required double size}) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 2.0),
          child: Obx(
            () => Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(100),
              ),
              padding: EdgeInsets.all(3.w),
              width: size,
              height: size,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: isProfileEditable == true
                    ? GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => onClickPictureView?.call(),
                        child: _buildProfileImage(controller, size: size),
                      )
                    : ClickableImage(
                        imageUrl: _profileImageUrl,
                        height: size,
                        width: size,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(100),
                        heroTag: "profile_image_appbar",
                        errorWidget: _defaultImage(size),
                      ),
              ),
            ),
          ),
        ),
        (isEnableEditable == true)
            ? Positioned(
                bottom: 0,
                right: 0,
                child: IgnorePointer(
                  ignoring: isProfileEditable ?? false,
                  child: CommonClickWidget(
                    // test: true,
                    onTap: () => onClickEditPencil?.call(),
                    child: Container(
                      padding: EdgeInsets.only(
                        right: size > 90.w ? 10.w : 2.w,
                        left: size > 90.w ? 15.w : 8.w,
                        top: size > 90.w ? 20.w : 10.w,
                      ),
                      child: Image.asset(
                        AppAssets.editPencilIc,
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  String get _profileImageUrl {
    if (controller.imageFile.value.path.isNotEmpty) {
      return controller.imageFile.value.path;
    }
    final url = controller.screenType.value == AppKeys.professional
        ? controller.professionalProfileData.value?.data?.imageUrl
        : controller.profileImage.value;
    if (url != null && url.isNotEmpty) return url;
    return AppAssets.appLogo;
  }

  Widget _buildProfileImage(SettingsViewModel controller, {required double size}) {
    // 1️⃣ Local file image (highest priority)
    if (controller.imageFile.value.path.isNotEmpty) {
      return Image.file(
        controller.imageFile.value,
        fit: BoxFit.cover,
        width: size,
        height: size,
        errorBuilder: (_, error, errorThird) => _defaultImage(size),
      );
    }

    // 2️⃣ Network image (user profile / professional)
    final url = controller.screenType.value == AppKeys.professional
        ? controller.professionalProfileData.value?.data?.imageUrl
        : controller.profileImage.value;

    if (url != null && url.isNotEmpty) {
      return SafeCachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: size,
        height: size,
        placeholder: (_, second) => BaseShimmer(
          backgroundColor: AppColors.antiqueWhite,
          height: size,
          width: size,
        ),
        errorWidget: (_, error, errorThird) => _defaultImage(size),
      );
    }

    // 3️⃣ Default fallback
    return _defaultImage(size);
  }

  Widget _defaultImage(double size) {
    return Image.asset(
      AppAssets.appLogo,
      fit: BoxFit.cover,
      width: size,
      height: size,
    );
  }

  Widget nameAndEmailFields() {
    return !(isProfileEditable!)
        ? Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: BaseText(
                        text: controller.name.value,
                        textColor: AppColors.whiteColor,
                        fontFamily: AppKeys.poppins,
                        fontWeight: FontWeight.w700,
                        fontSize: fontSize18,
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isEnableEditable == true) ...[
                      SizedBox(width: 5.w),
                      Image.asset(
                        AppAssets.verifiedIc,
                        width: 18.w,
                        height: 18.w,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                BaseText(
                  text: controller.email.value,
                  textColor: AppColors.whiteColor.withValues(alpha: .7),
                  fontFamily: AppKeys.inter,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize13,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }
}
