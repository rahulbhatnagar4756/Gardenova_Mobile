import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

import '../../../base/widgets/base_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';
import '../upgrade_plan_controller.dart';

class PlanCard extends StatelessWidget {
  final UpgradePlanController controller;

  const PlanCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacerSize20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseText(
              textAlign: TextAlign.center,
              textColor: AppColors.offWhite50,
              fontWeight: FontWeight.w400,
              fontFamily: AppKeys.poppins,
              fontSize: fontSize15,
              text: AppLocalizations.of(context)!.selectYourPlan,
            ).marginOnly(top: spacerSize25, bottom: spacerSize15),

            Column(
              children: List.generate(controller.planList.length, (index) {
                return planCardItem(context, index);
              }),
            ),
          ],
        ),
      ),
    );
  }
  //
  Widget planCardItem(BuildContext context, int index) {
    final plan = controller.planList[index];
    return GestureDetector(
      onTap: () {
        controller.selectPlan(index);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: spacerSize12),
        padding: const EdgeInsets.all(spacerSize15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(spacerSize12),
          border: Border.all(
            color: plan.isSelect! ? AppColors.burntGold : AppColors.offWhite10,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                spacing: spacerSize4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    textAlign: TextAlign.center,
                    textColor: AppColors.offWhite70,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize12,
                    text: plan.planName ?? "",
                  ),
                  Row(
                    spacing: spacerSize4,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      BaseText(
                        textAlign: TextAlign.center,
                        textColor: AppColors.offWhite,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppKeys.inter,
                        fontSize: fontSize14,
                        text: controller.isTabMonthly.value
                            ? "R\$\t${plan.priceMonthly}/${AppLocalizations.of(context)!.mu}"
                            : "R\$\t${plan.priceAnnual}/${AppLocalizations.of(context)!.an}",
                      ).marginOnly(right: spacerSize4),

                      CircleAvatar(
                        radius: spacerSize1,
                        backgroundColor: AppColors.offWhite70,
                      ),

                      BaseText(
                        textAlign: TextAlign.center,
                        textColor: AppColors.offWhite70,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppKeys.inter,
                        fontSize: fontSize12,
                        text: plan.citiesCoverage.toString(),
                      ),

                      BaseText(
                        textAlign: TextAlign.center,
                        textColor: AppColors.offWhite,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppKeys.inter,
                        fontSize: fontSize12,
                        text: AppLocalizations.of(context)!.city,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(spacerSize2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(spacerSize12),
                border: Border.all(
                  color: plan.isSelect!
                      ? AppColors.burntGold
                      : AppColors.offWhite10,
                ),
              ),
              child: CircleAvatar(
                radius: spacerSize6,
                backgroundColor: plan.isSelect!
                    ? AppColors.burntGold
                    : AppColors.appBarColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
