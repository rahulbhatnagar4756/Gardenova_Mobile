import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

import '../../../base/widgets/base_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';
import '../upgrade_plan_controller.dart';

class HeaderCard extends StatelessWidget {
  final UpgradePlanController controller;

  const HeaderCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spacerSize8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(AppAssets.appLogo, scale: 2.2),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseText(
                textAlign: TextAlign.center,
                textColor: AppColors.offWhite50,
                fontWeight: FontWeight.w400,
                fontFamily: AppKeys.merriweather,
                fontSize: fontSize15,
                text: "${AppLocalizations.of(context)!.yourPlanEnds}\t\t",
              ),
              BaseText(
                textAlign: TextAlign.center,
                textColor: AppColors.offWhite,
                fontWeight: FontWeight.w700,
                fontFamily: AppKeys.merriweather,
                fontSize: fontSize18,
                text:
                    "${controller.remainingDays.value}\t${AppLocalizations.of(context)!.days}",
              ),
            ],
          ).marginOnly(top: spacerSize30, bottom: spacerSize5),
          BaseText(
            textAlign: TextAlign.center,
            textColor: AppColors.offWhite50,
            fontWeight: FontWeight.w400,
            fontFamily: AppKeys.inter,
            fontSize: fontSize14,
            text: AppLocalizations.of(context)!.yourPlanEndsDesc,
          ).marginOnly(bottom: spacerSize30),
        ],
      ),
    );
  }
}
