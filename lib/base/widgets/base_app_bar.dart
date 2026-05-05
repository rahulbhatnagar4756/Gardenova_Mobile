import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';

import 'common_click_widget.dart';

// class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const BaseAppBar({
//     super.key,
//     this.isAppIconVisible = true,
//     this.isBackButtonVisible = true,
//     this.onBackPressed,
//     this.backgroundColor = AppColors.appColor,
//     this.title,
//     this.toolbarHeightScale = 1.3,
//     this.isTrailingButtonVisible = false,
//     this.topMargin = spacerSize10,
//   });
//
//   final bool? isAppIconVisible;
//   final bool? isBackButtonVisible;
//   final VoidCallback? onBackPressed;
//   final Color? backgroundColor;
//   final String? title;
//   final num? toolbarHeightScale;
//   final bool? isTrailingButtonVisible;
//   final double? topMargin;
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: backgroundColor,
//       foregroundColor: AppColors.offWhite,
//       elevation: 0.0,
//       actionsIconTheme: const IconThemeData(color: AppColors.offWhite),
//       actions: isTrailingButtonVisible!
//           ? [
//               PopupMenuButton(
//                 color: Colors.transparent,
//                 shadowColor: Colors.transparent,
//                 popUpAnimationStyle: AnimationStyle.noAnimation,
//                 offset: const Offset(0, kToolbarHeight * -0.5),
//                 itemBuilder: (context) => [
//                   PopupMenuItem(
//                     padding: EdgeInsets.all(spacerSize10),
//                     onTap: () {
//                       Get.toNamed(Routes.profile);
//                     },
//                     child: BaseText(
//                       text: AppLocalizations.of(context)!.editProfile,
//                       fontSize: fontSize13,
//                       textAlign: TextAlign.center,
//                       fontWeight: FontWeight.w500,
//                       textColor: AppColors.offWhite,
//                     ).marginOnly(right: spacerSize10, bottom: spacerSize10),
//                   ),
//                 ],
//               ).marginOnly(right: spacerSize10),
//             ]
//           : [],
//       title: title != null
//           ? BaseText(
//               text: title ?? "",
//               overflow: TextOverflow.ellipsis,
//               textColor: AppColors.offWhite,
//               fontWeight: FontWeight.w500,
//               fontFamily: AppKeys.inter,
//               fontSize: fontSize16,
//             )
//           : SizedBox(),
//       titleSpacing: spacerSize0,
//       centerTitle: false,
//       leading: isBackButtonVisible!
//           ?
//       CommonClickWidget(
//         test: false,
//         leftPadding: 20.w,
//         rightPadding: 10.w,
//         topPadding: 5.w,
//         bottomPadding: 5.w,
//
//         onTap: onBackPressed ?? () => Get.back(result: true),
//         child: Image.asset(AppAssets.backBtnIc,
//           width: 20.w,
//           height: 20.w,),
//       )
//       // IconButton(
//       //         icon: const Icon(Icons.arrow_back),
//       //         onPressed: onBackPressed ?? () => Get.back(result: true),
//       //       )
//           : null,
//       flexibleSpace: isAppIconVisible!
//           ? Image.asset(AppAssets.appLogo, scale: 2.8)
//           : const SizedBox(),
//       forceMaterialTransparency: true,
//       automaticallyImplyLeading: isBackButtonVisible!,
//     ).paddingOnly(top: topMargin!);
//   }
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight * toolbarHeightScale!);
// }

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({
    super.key,
    this.isAppIconVisible = true,
    this.isBackButtonVisible = true,
    this.onBackPressed,
    this.backgroundColor = AppColors.appColor,
    this.title,
    this.toolbarHeightScale = 1.5,
    this.isTrailingButtonVisible = false,
    this.topMargin = spacerSize10,
  });

  final bool? isAppIconVisible;
  final bool? isBackButtonVisible;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final String? title;
  final num? toolbarHeightScale;
  final bool? isTrailingButtonVisible;
  final double? topMargin;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      toolbarHeight: kToolbarHeight * (toolbarHeightScale ?? 1.5),

      /// ❌ Remove default leading (we handle manually)
      leading: null,
      automaticallyImplyLeading: false,

      /// ✅ Optional title (kept minimal)
      // title: title != null
      //     ? BaseText(
      //   text: title!,
      //   textColor: AppColors.offWhite,
      //   fontWeight: FontWeight.w500,
      //   fontFamily: AppKeys.inter,
      //   fontSize: fontSize16,
      // )
      //     : const SizedBox(),
      centerTitle: false,
      titleSpacing: spacerSize0,

      /// ✅ Trailing menu (unchanged)
      actions: isTrailingButtonVisible!
          ? [
              PopupMenuButton(
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                popUpAnimationStyle: AnimationStyle.noAnimation,
                offset: const Offset(0, kToolbarHeight * -0.5),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    padding: const EdgeInsets.all(spacerSize10),
                    onTap: () {
                      Get.toNamed(Routes.profile);
                    },
                    child: BaseText(
                      text: AppLocalizations.of(context)!.editProfile,
                      fontSize: fontSize13,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.offWhite,
                    ),
                  ),
                ],
              ).marginOnly(right: spacerSize10),
            ]
          : [],

      /// ✅ Custom layout using Stack
      flexibleSpace: SafeArea(
        child: Stack(
          children: [
            /// 🔹 Center logo (lower position)
            if (isAppIconVisible ?? false)
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // color: Colors.red,
                      child: Image.asset(
                        AppAssets.appLogo,
                        width: 60.w,
                        height: 60.w,
                      ),
                    ),
                  ],
                ),
              ),
            if (title?.isNotEmpty == true)
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(left: 48.w, bottom: (isAppIconVisible==true)?16.h:20.h),
                  // color: Colors.red,
                  child: BaseText(
                    text: title!,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize16,
                  ),
                ),
              ),

            /// 🔹 Back button (top-left)
            if (isBackButtonVisible ?? false)
              Align(
                alignment:(isAppIconVisible??false)==false && (title?.isEmpty??false) ?Alignment.centerLeft: Alignment.topLeft ,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, left: 12.w),
                  child: CommonClickWidget(
                    test: false,
                    onTap: onBackPressed ?? () => Get.back(result: true),
                    child: Image.asset(
                      AppAssets.backBtnIc,
                      width: 20.w,
                      height: 20.w,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ).paddingOnly(top: 5.h);
    // ).paddingOnly(top: topMargin!);
  }

  @override
  Size get preferredSize => Size.fromHeight(
    ((kToolbarHeight * (toolbarHeightScale ?? 1.5) + (topMargin ?? 0))) +
        (isAppIconVisible == true ? 20.h : -20.h),
  );
}
