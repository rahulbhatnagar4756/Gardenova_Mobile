import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class ProfileIconLayout extends GetWidget<SettingsViewModel> {
  const ProfileIconLayout({super.key, this.isProfileEditable = false});

  final bool? isProfileEditable;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        GestureDetector(
          onTap: isProfileEditable == true ? openImagePickerBottomSheet : null,
          child: Stack(
            alignment: Alignment.center,
            children: [


              Obx(
                () => CircleAvatar(
                  backgroundColor: AppColors.antiqueWhite,
                  radius: isProfileEditable! ? spacerSize60 : spacerSize40,
                  child: ClipOval(
                    child: controller.imageFile.value.path.isNotEmpty
                        ? Image.file(
                            controller.imageFile.value,
                            fit: BoxFit.fill,
                            width:
                                (isProfileEditable!
                                    ? spacerSize60
                                    : spacerSize40) *
                                2,
                            height:
                                (isProfileEditable!
                                    ? spacerSize60
                                    : spacerSize40) *
                                2,
                            errorBuilder: (c, s, o) {
                              return Center(
                                child: BaseText(
                                  text: controller.name.value.substring(0, 1),
                                  textColor: AppColors.charcoalGrey,
                                  fontFamily: AppKeys.poppins,
                                  fontWeight: FontWeight.w700,
                                  fontSize: fontSize40,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          )
                        : (controller.profileImage.value.isNotEmpty ||
                              (controller
                                      .professionalProfileData
                                      .value
                                      ?.data
                                      ?.imageUrl
                                      ?.isNotEmpty ??
                                  false))
                        ? CachedNetworkImage(
                            fit: BoxFit.fill,
                            useOldImageOnUrlChange: true,
                            imageUrl:
                                controller.screenType.value ==
                                    AppKeys.professional
                                ? controller
                                      .professionalProfileData
                                      .value!
                                      .data!
                                      .imageUrl!
                                : controller.profileImage.value,
                            width:
                                (isProfileEditable!
                                    ? spacerSize60
                                    : spacerSize40) *
                                2,
                            height:
                                (isProfileEditable!
                                    ? spacerSize60
                                    : spacerSize40) *
                                2,
                            placeholder: (context, url) => BaseShimmer(
                              backgroundColor: AppColors.antiqueWhite,
                              height:
                                  (isProfileEditable!
                                      ? spacerSize60
                                      : spacerSize40) *
                                  2,
                              width:
                                  (isProfileEditable!
                                      ? spacerSize60
                                      : spacerSize40) *
                                  2,
                            ),
                            errorWidget: (context, url, error) {
                              return Center(
                                child: BaseText(
                                  text: controller.name.value.substring(0, 1),
                                  textColor: AppColors.charcoalGrey,
                                  fontFamily: AppKeys.poppins,
                                  fontWeight: FontWeight.w700,
                                  fontSize: fontSize40,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: BaseText(
                              text: controller.name.value.isEmpty
                                  ? ""
                                  : controller.name.value
                                        .substring(0, 1)
                                        .toUpperCase(),
                              textColor: AppColors.charcoalGrey,
                              fontFamily: AppKeys.poppins,
                              fontWeight: FontWeight.w700,
                              fontSize: fontSize40,
                              textAlign: TextAlign.center,
                            ),
                          ),
                  ),
                ),
              ),
              if (isProfileEditable!)
                Positioned(
                  right: Get.width * .38,
                  top: Get.height * .110,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(spacerSize50),
                      color: AppColors.offWhite,
                    ),
                    child: Image.asset(
                      AppAssets.edit,
                      scale: 3,
                    ).paddingAll(spacerSize6),
                  ),
                ),
            ],
          ).marginOnly(bottom: spacerSize10, top: spacerSize10),
        ),
        nameAndEmailFields(),
      ],
    );
  }

  nameAndEmailFields() {
    return !isProfileEditable!
        ? Obx(
            () => Column(
              children: [
                BaseText(
                  text: controller.name.value,
                  textColor: AppColors.offWhite,
                  fontFamily: AppKeys.poppins,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize20,
                  textAlign: TextAlign.center,
                ),
                BaseText(
                  text: controller.email.value,
                  textColor: AppColors.burntGold,
                  fontFamily: AppKeys.inter,
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize13,
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
              leading: Icon(Icons.camera_alt, color: AppColors.burntGold),
              title: BaseText(text: AppLocalizations.of(Get.context!)!.camera),
              onTap: () async {
                controller.pickImage(isCamera: true);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.burntGold),
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
