import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class HeaderLogoLayout extends StatelessWidget {
  const HeaderLogoLayout({super.key, this.title, this.subTitle});

  final String? title;
  final String? subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Image.asset(AppAssets.appLogo, scale: 2.2),
        ).marginOnly(top: Get.height * .01),
        BaseText(
          textAlign: TextAlign.center,
          textColor: AppColors.offWhite,
          fontWeight: FontWeight.w700,
          fontFamily: AppKeys.merriweather,
          fontSize: fontSize26,
          text: title ?? "",
        ).marginOnly(top: spacerSize30, bottom: spacerSize5),
        BaseText(
          textAlign: TextAlign.center,
          textColor: AppColors.offWhite,
          fontWeight: FontWeight.w400,
          fontFamily: AppKeys.inter,
          fontSize: fontSize16,
          text: subTitle ?? "",
        ).marginOnly(bottom: spacerSize30),
      ],
    );
  }
}
