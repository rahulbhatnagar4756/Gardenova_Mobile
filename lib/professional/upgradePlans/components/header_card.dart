import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

import '../../../base/widgets/base_calculate_remaining_days.dart';
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
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: spacerSize8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(AppAssets.appLogo, width: 60.w, height: 60.w),
          ),
          Obx(() {
            final endDate = controller.currentModel?.updatedAt;
            final isFree = controller.currentModel?.isFreePlan == true;
            final isExpired =
                isFree || BaseCalculateRemainingDays.isExpired(endDate);
            final isExpiringToday = !isFree &&
                (BaseCalculateRemainingDays.isExpiringToday(endDate) ||
                    BaseCalculateRemainingDays.isZeroRemainingDays(
                      controller.remainingDays.value,
                    ));

            if (isExpired) {
              return BaseText(
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
                fontFamily: AppKeys.poppins,
                fontSize: fontSize18,
                textColor: AppColors.red,
                text: l10n.planExpired,
              ).marginOnly(bottom: spacerSize5);
            }

            if (isExpiringToday) {
              return BaseText(
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
                fontFamily: AppKeys.poppins,
                fontSize: fontSize18,
                textColor: AppColors.greenColor,
                text: l10n.planExpiringToday,
              ).marginOnly(bottom: spacerSize5);
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BaseText(
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppKeys.poppins,
                  fontSize: fontSize15,
                  text: "${l10n.yourPlanEnds}\tin\t",
                ),
                BaseText(
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700,
                  fontFamily: AppKeys.poppins,
                  fontSize: fontSize18,
                  text: "${controller.remainingDays.value}\t${l10n.days}",
                ),
              ],
            ).marginOnly(bottom: spacerSize5);
          }),
          Obx(() {
            final endDate = controller.currentModel?.updatedAt;
            final isFree = controller.currentModel?.isFreePlan == true;
            final isExpired =
                isFree || BaseCalculateRemainingDays.isExpired(endDate);
            final isExpiringToday = !isFree &&
                (BaseCalculateRemainingDays.isExpiringToday(endDate) ||
                    BaseCalculateRemainingDays.isZeroRemainingDays(
                      controller.remainingDays.value,
                    ));
            return BaseText(
              textAlign: TextAlign.center,
              textColor: AppColors.liteGreyColor,
              fontWeight: FontWeight.w400,
              fontFamily: AppKeys.inter,
              fontSize: fontSize14,
              text: isExpired
                  ? l10n.planExpiredDesc
                  : isExpiringToday
                      ? l10n.planExpiringTodayDesc
                      : l10n.yourPlanEndsDesc,
            ).marginOnly(bottom: spacerSize25);
          }),
        ],
      ),
    );
  }
}
