import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/widgets/base_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';
import '../../../utils/constants/app_strings.dart';
import '../model/plan_model.dart';
import '../upgrade_plan_controller.dart';

class PlanCard extends StatelessWidget {
  final UpgradePlanController controller;

  const PlanCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredPlans = controller.planList.where((plan) {
        if (controller.isTabMonthly.value) {
          return plan.monthlyId != null || plan.tier == 'free';
        } else {
          return plan.yearlyId != null;
        }
      }).toList();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacerSize20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseText(
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
              fontFamily: AppKeys.poppins,
              fontSize: fontSize15,
              text: AppLocalizations.of(context)!.selectYourPlan,
            ).marginOnly(top: spacerSize25, bottom: spacerSize15),

            Column(
              children: List.generate(filteredPlans.length, (index) {
                return planCardItem(context, filteredPlans[index]);
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget planCardItem(BuildContext context, PlanModel plan) {
    final isSelected = plan.isSelect == true;
    final isSubscribed = controller.isCurrentSubscribedPlan(plan);
    final headerActive = isSelected;
    final borderColor = isSelected
        ? AppColors.greenColor
        : isSubscribed
            ? AppColors.greenColor.withValues(alpha: 0.45)
            : AppColors.borderLiteGreyColor;

    return GestureDetector(
      onTap: () {
        controller.selectPlan(plan);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: spacerSize12),
        padding: const EdgeInsets.only(bottom: spacerSize15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(spacerSize12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: spacerSize6 - 1,
                horizontal: spacerSize12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(spacerSize12),
                  topRight: Radius.circular(spacerSize12),
                ),
                color: headerActive
                    ? AppColors.greenColor
                    : AppColors.borderLiteGreyColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: BaseText(
                      textColor: headerActive
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppKeys.inter,
                      fontSize: fontSize12,
                      text: plan.planName ?? "",
                    ),
                  ),
                  if (isSubscribed) ...[
                    SizedBox(width: spacerSize8),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacerSize8,
                        vertical: spacerSize2,
                      ),
                      decoration: BoxDecoration(
                        color: headerActive
                            ? Colors.white.withValues(alpha: 0.2)
                            : AppColors.greenColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(spacerSize12),
                        border: Border.all(
                          color: headerActive
                              ? Colors.white
                              : AppColors.greenColor,
                          width: 0.8,
                        ),
                      ),
                      child: BaseText(
                        text: AppStrings.subscribed,
                        textColor: headerActive
                            ? Colors.white
                            : AppColors.greenColor,
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize10,
                        fontFamily: AppKeys.inter,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: spacerSize15),

            Row(
              children: [
                Expanded(
                  child: Column(
                    spacing: spacerSize4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: spacerSize4,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          BaseText(
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppKeys.inter,
                            fontSize: fontSize14,
                            text: controller.isTabMonthly.value
                                ? "R\$\t${plan.priceMonthly}/${AppLocalizations.of(context)!.mu}"
                                : "R\$\t${plan.priceAnnual}/${AppLocalizations.of(context)!.an}",
                          ).marginOnly(right: spacerSize4),

                          CircleAvatar(
                            radius: spacerSize1,
                            backgroundColor: AppColors.greenColor,
                          ),

                          BaseText(
                            textAlign: TextAlign.center,
                            textColor: AppColors.liteGreyColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: AppKeys.inter,
                            fontSize: fontSize12,
                            text: plan.features?.firstWhereOrNull(
                                  (f) =>
                                      f.key == 'saved_plants' ||
                                      f.key == 'max_plants',
                                )?.label ??
                                (plan.maxPlants == -1
                                    ? "Unlimited Plants"
                                    : "${plan.maxPlants ?? 0} Plants"),
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
                      color: isSelected
                          ? AppColors.greenColor
                          : AppColors.blackColor,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: spacerSize6,
                    backgroundColor: isSelected
                        ? AppColors.greenColor
                        : AppColors.appColor,
                  ),
                ),
              ],
            ).paddingSymmetric(horizontal: spacerSize15),
          ],
        ),
      ),
    );
  }
}
