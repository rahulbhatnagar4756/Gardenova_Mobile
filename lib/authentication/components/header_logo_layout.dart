import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          child: Image.asset(AppAssets.appLogo, width: 60.w,
            height: 60.w,),
        ).marginOnly(top: 25.h),
        BaseText(
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w600,
          fontFamily: AppKeys.poppins,
          fontSize: 25.sp,
          text: title ?? "",
        ).marginOnly(top: 15.h,bottom: 2.h ),
        BaseText(
          textAlign: TextAlign.center,
          textColor: AppColors.liteGreyColor,
          fontWeight: FontWeight.w400,
          fontFamily: AppKeys.poppins,
          fontSize: 14.sp,
          text: subTitle ?? "",
        ).marginOnly(bottom: 40.h),
      ],
    );
  }
}
