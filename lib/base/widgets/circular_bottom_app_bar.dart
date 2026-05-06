import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/generated/assets.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import '../../utils/shared_prefs_service.dart';
import 'common_click_widget.dart';
class CircularBottomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CircularBottomAppBar({
    super.key,
    this.onSettingPressed,
    this.showMenuIcon = false,
    this.isBackButtonVisible = false,
    this.backgroundColor = Colors.transparent,
  });

  final VoidCallback? onSettingPressed;
  final bool? showMenuIcon;
  final Color? backgroundColor;
  final bool? isBackButtonVisible;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            left: BorderSide(color: AppColors.backgroundGrey),
            right: BorderSide(color: AppColors.backgroundGrey),
            bottom: BorderSide(color: AppColors.backgroundGrey),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Back button
            if (isBackButtonVisible ?? false)
              CommonClickWidget(
                onTap: () => Get.back(result: true),
                child: Padding(
                  padding: EdgeInsets.only(left: 12.w, bottom: 6.h),
                  child: Image.asset(
                    AppAssets.backBtnIc,
                    width: 20.w,
                    height: 16.w,
                  ),
                ),
              ),

            /// 🔹 Main Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Logo
                  Image.asset(
                    AppAssets.appLogo,
                    width: 45.w,
                    height: 45.w,
                  ),

                  SizedBox(width: spacerSize10),

                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseText(
                          fontWeight: FontWeight.w700,
                          fontFamily: AppKeys.poppins,
                          fontSize: fontSize14,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text:
                          '${AppLocalizations.of(Get.context!)!.hi}, ${SharedPrefsService.instance.getString(AppKeys.name) ?? ""}!',
                        ),

                        SizedBox(height: 2),

                        SharedPrefsService.instance.getString(AppKeys.role) ==
                            AppKeys.professional
                            ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacerSize8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.toLiteGreenColor,
                            borderRadius: BorderRadius.circular(spacerSize20),
                          ),
                          child: BaseText(
                            text:
                            "${SharedPrefsService.instance.getString(AppKeys.remainingDays)} ${AppLocalizations.of(Get.context!)!.days} ${AppLocalizations.of(Get.context!)!.left}",
                            fontSize: fontSize10,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: AppKeys.inter,
                            fontWeight: FontWeight.w400,
                            textColor: AppColors.offWhite,
                          ),
                        )
                            : BaseText(
                          fontWeight: FontWeight.w400,
                          fontFamily: AppKeys.inter,
                          fontSize: fontSize12,
                          textColor: AppColors.liteGreyColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: getGreeting(),
                        ),
                      ],
                    ),
                  ),
                  /// Menu Icon

                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onSettingPressed,
                    icon: Image.asset(
                      Assets.drawerIc,
                      height: 45.w,
                      width: 45.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔥 Increased safe height to prevent overflow
  @override
  Size get preferredSize =>
      Size.fromHeight(110.h + ((isBackButtonVisible ?? false) ? 30.h : 0));
}

String getGreeting() {
  DateTime now = DateTime.now();
  int hour = now.hour;
  String greeting;
  if (hour >= 0 && hour < 12) {
    greeting = AppLocalizations.of(Get.context!)!.goodMorning;
  } else if (hour >= 12 && hour < 17) {
    greeting = AppLocalizations.of(Get.context!)!.goodAfternoon;
  } else {
    greeting = AppLocalizations.of(Get.context!)!.goodEvening;
  }
  return greeting;
}
