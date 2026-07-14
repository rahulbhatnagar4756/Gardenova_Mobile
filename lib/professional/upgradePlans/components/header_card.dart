import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            child: Image.asset(AppAssets.appLogo, width: 60.w, height: 60.w),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseText(
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w400,
                fontFamily: AppKeys.poppins,
                fontSize: fontSize15,
                text: "${AppLocalizations.of(context)!.yourPlanEnds}\tin\t",
              ),
              BaseText(
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
                fontFamily: AppKeys.poppins,
                fontSize: fontSize18,
                text: "${controller.remainingDays.value}\t${AppLocalizations.of(context)!.days}",
              ),
            ],
          ).marginOnly(bottom: spacerSize5),
          BaseText(
            textAlign: TextAlign.center,
            textColor: AppColors.liteGreyColor,
            fontWeight: FontWeight.w400,
            fontFamily: AppKeys.inter,
            fontSize: fontSize14,
            text: AppLocalizations.of(context)!.yourPlanEndsDesc,
          ).marginOnly(bottom: spacerSize25),
        ],
      ),
    );
  }
}
