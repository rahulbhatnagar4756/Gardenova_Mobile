import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
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
    required this.title,
  });

  final String title;
  final bool? isProfileEditable;
  final Function? onClickEditPencil;
  final bool? isEnableEditable;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
          color: AppColors.greenColor,
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
            GestureDetector(
              onTap: isProfileEditable == true
                  ? openImagePickerBottomSheet
                  : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(bottom: 2.0),
                      //   child: Obx(
                      //     () => Container(
                      //       decoration: BoxDecoration(
                      //         color: AppColors.antiqueWhite,
                      //         borderRadius: BorderRadiusGeometry.circular(100),
                      //       ),
                      //       width: 108.w,
                      //       height: 108.w,
                      //       child: CircleAvatar(
                      //         backgroundColor: AppColors.antiqueWhite,
                      //         radius: isProfileEditable!
                      //             ? spacerSize60
                      //             : spacerSize40,
                      //         child: ClipOval(
                      //           child:
                      //               controller.imageFile.value.path.isNotEmpty
                      //               ? Image.file(
                      //                   controller.imageFile.value,
                      //                   fit: BoxFit.fill,
                      //                   width: 108.w,
                      //                   height: 108.w,
                      //                   errorBuilder: (c, s, o) {
                      //                     return Center(
                      //                       child: BaseText(
                      //                         text: controller.name.value
                      //                             .substring(0, 1),
                      //                         textColor: AppColors.charcoalGrey,
                      //                         fontFamily: AppKeys.poppins,
                      //                         fontWeight: FontWeight.w700,
                      //                         fontSize: fontSize40,
                      //                         textAlign: TextAlign.center,
                      //                       ),
                      //                     );
                      //                   },
                      //                 )
                      //               : (controller
                      //                         .profileImage
                      //                         .value
                      //                         .isNotEmpty ||
                      //                     (controller
                      //                             .professionalProfileData
                      //                             .value
                      //                             ?.data
                      //                             ?.imageUrl
                      //                             ?.isNotEmpty ??
                      //                         false))
                      //               ? CachedNetworkImage(
                      //                   fit: BoxFit.fill,
                      //                   useOldImageOnUrlChange: true,
                      //                   imageUrl:
                      //                       controller.screenType.value ==
                      //                           AppKeys.professional
                      //                       ? controller
                      //                             .professionalProfileData
                      //                             .value!
                      //                             .data!
                      //                             .imageUrl!
                      //                       : controller.profileImage.value,
                      //                   width: 108.w,
                      //                   height: 108.w,
                      //                   placeholder: (context, url) =>
                      //                       BaseShimmer(
                      //                         backgroundColor:
                      //                             AppColors.antiqueWhite,
                      //                         height:
                      //                             (isProfileEditable!
                      //                                 ? spacerSize60
                      //                                 : spacerSize40) *
                      //                             2,
                      //                         width:
                      //                             (isProfileEditable!
                      //                                 ? spacerSize60
                      //                                 : spacerSize40) *
                      //                             2,
                      //                       ),
                      //                   errorWidget: (context, url, error) {
                      //                     return Center(
                      //                       child: BaseText(
                      //                         text: controller.name.value
                      //                             .substring(0, 1),
                      //                         textColor: AppColors.charcoalGrey,
                      //                         fontFamily: AppKeys.poppins,
                      //                         fontWeight: FontWeight.w700,
                      //                         fontSize: fontSize40,
                      //                         textAlign: TextAlign.center,
                      //                       ),
                      //                     );
                      //                   },
                      //                 )
                      //               : Center(
                      //                   child: BaseText(
                      //                     text: controller.name.value.isEmpty
                      //                         ? ""
                      //                         : controller.name.value
                      //                               .substring(0, 1)
                      //                               .toUpperCase(),
                      //                     textColor: AppColors.whiteColor,
                      //                     fontFamily: AppKeys.poppins,
                      //                     fontWeight: FontWeight.w700,
                      //                     fontSize: fontSize40,
                      //                     textAlign: TextAlign.center,
                      //                   ),
                      //                 ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.0),
                        child: Obx(
                          () => Container(
                            decoration: BoxDecoration(
                              color: AppColors.antiqueWhite,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            width: 108.w,
                            height: 108.w,
                            child: CircleAvatar(
                              backgroundColor: AppColors.antiqueWhite,
                              child: ClipOval(
                                child: _buildProfileImage(controller),
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
                                  onTap: () => onClickEditPencil?.call(),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      right: 10.w,
                                      left: 10.w,
                                      top: 10.w,
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
                  ),
                  // if (isProfileEditable!)
                  //   Positioned(
                  //     right: Get.width * .38,
                  //     top: Get.height * .110,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(spacerSize50),
                  //         color: AppColors.offWhite,
                  //       ),
                  //       child: Image.asset(
                  //         AppAssets.edit,
                  //         scale: 3,
                  //       ).paddingAll(spacerSize6),
                  //     ),
                  //   ),
                ],
              ).marginOnly(bottom: spacerSize10, top: spacerSize10),
            ),
            nameAndEmailFields(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage(SettingsViewModel controller) {
    // 1️⃣ Local file image (highest priority)
    if (controller.imageFile.value.path.isNotEmpty) {
      return Image.file(
        controller.imageFile.value,
        fit: BoxFit.cover,
        width: 108.w,
        height: 108.w,
        errorBuilder: (_, __, ___) => _defaultImage(),
      );
    }

    // 2️⃣ Network image (user profile / professional)
    final url = controller.screenType.value == AppKeys.professional
        ? controller.professionalProfileData.value?.data?.imageUrl
        : controller.profileImage.value;

    if (url != null && url.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        width: 108.w,
        height: 108.w,
        placeholder: (_, __) => BaseShimmer(
          backgroundColor: AppColors.antiqueWhite,
          height: 108.w,
          width: 108.w,
        ),
        errorWidget: (_, __, ___) => _defaultImage(),
      );
    }

    // 3️⃣ Default fallback
    return _defaultImage();
  }

  Widget _defaultImage() {
    return Image.asset(
      AppAssets.appLogo,
      fit: BoxFit.cover,
      width: 108.w,
      height: 108.w,
    );
  }

  nameAndEmailFields() {
    return !(isProfileEditable!)
        ? Obx(
            () => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BaseText(
                      text: controller.name.value,
                      textColor: AppColors.whiteColor,

                      fontFamily: AppKeys.poppins,
                      fontWeight: FontWeight.w700,
                      fontSize: fontSize20,
                      textAlign: TextAlign.center,
                    ),
                    isEnableEditable == true
                        ? Row(
                            children: [
                              SizedBox(width: 5.w),
                              Image.asset(
                                AppAssets.verifiedIc,
                                width: 20.w,
                                height: 20.w,
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
                BaseText(
                  text: controller.email.value,
                  textColor: AppColors.whiteColor.withValues(alpha: .6),
                  fontFamily: AppKeys.inter,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize16,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        : SizedBox.shrink();
  }

  openImagePickerBottomSheet() {
    return Get.bottomSheet(
      Container(
        height: Get.height * .2,
        color: AppColors.offWhite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.greenColor),
              title: BaseText(text: AppLocalizations.of(Get.context!)!.camera),
              onTap: () async {
                controller.pickImage(isCamera: true);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.greenColor),
              title: BaseText(text: AppLocalizations.of(Get.context!)!.gallery),
              onTap: () async {
                controller.pickImage(isCamera: false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
