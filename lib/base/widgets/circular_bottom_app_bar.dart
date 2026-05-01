import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/generated/assets.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import '../../utils/shared_prefs_service.dart';

class CircularBottomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CircularBottomAppBar({
    super.key,
    this.onSettingPressed,
    this.showMenuIcon = false,
    this.backgroundColor = Colors.transparent,
  });

  final VoidCallback? onSettingPressed;
  final bool? showMenuIcon;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: spacerSize80,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(spacerSize35),
          bottomRight: Radius.circular(spacerSize35),
        ),
        color: backgroundColor,
        border: Border.all(color: AppColors.backgroundGrey),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: spacerSize5,
        children: [
          Expanded(
            flex: 5,
            child: Column(
              spacing: spacerSize2,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  fontWeight: FontWeight.w700,
                  fontFamily: AppKeys.poppins,
                  fontSize: fontSize14,
                  textColor: AppColors.offWhite,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text:
                      '${AppLocalizations.of(Get.context!)!.hi}, ${SharedPrefsService.instance.getString(AppKeys.name) ?? ""}!',
                ),
                SharedPrefsService.instance.getString(AppKeys.role) ==
                        AppKeys.professional
                    ? Container(
                        margin: EdgeInsets.only(top: spacerSize2),
                        padding: EdgeInsets.symmetric(
                          horizontal: spacerSize10,
                          vertical: spacerSize2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.harvestGold.withValues(alpha: .4),
                          borderRadius: BorderRadius.circular(spacerSize20),
                        ),
                        child: BaseText(
                          text:
                              "${SharedPrefsService.instance.getString(AppKeys.remainingDays)}\t${AppLocalizations.of(Get.context!)!.days}\t${AppLocalizations.of(Get.context!)!.left}",
                          fontSize: fontSize10,
                          fontFamily: AppKeys.inter,
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.offWhite,
                        ),
                      )
                    : BaseText(
                        fontWeight: FontWeight.w400,
                        fontFamily: AppKeys.inter,
                        fontSize: fontSize12,
                        textColor: AppColors.darkGold,
                        text: getGreeting(),
                      ),
              ],
            ).marginOnly(left: spacerSize15),
          ),
          Center(child: Image.asset(AppAssets.appLogo)),
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                onPressed: onSettingPressed,
                icon: Image.asset(
                  showMenuIcon! ? Assets.imagesMenu : Assets.imagesSettings,
                  height: spacerSize24,
                  width: spacerSize24,
                ).marginOnly(right: spacerSize30),
              ),
            ),
          ),
          /*Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                style: IconButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                onPressed: onSettingPressed,
                icon: Image.asset(AppAssets.settings, scale: 3.2).marginOnly(right: spacerSize30),
              ),
            ),
          ),*/
        ],
      ).marginOnly(top: spacerSize20, bottom: spacerSize15),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(spacerSize90);
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
