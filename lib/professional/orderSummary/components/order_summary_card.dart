import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/professional/orderSummary/components/feature_item_card.dart';
import 'package:kasagardem/professional/upgradePlans/upgrade_plan_controller.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_keys.dart';

class OrderSummaryCard extends StatelessWidget {
  final UpgradePlanController controller;

  const OrderSummaryCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: spacerSize18,
        vertical: spacerSize30,
      ),
      padding: const EdgeInsets.all(spacerSize24),
      decoration: BoxDecoration(
        color: AppColors.appBarColor,
        borderRadius: BorderRadius.circular(spacerSize24),
        border: Border.all(color: AppColors.offWhite10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: BaseText(
              fontWeight: FontWeight.w700,
              fontFamily: AppKeys.poppins,
              fontSize: fontSize16,
              textColor: AppColors.offWhite,
              text: AppLocalizations.of(context)!.orderSummary.toUpperCase(),
            ),
          ).marginOnly(bottom: spacerSize20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                spacing: spacerSize4,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    fontWeight: FontWeight.w600,
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize15,
                    textColor: AppColors.darkGold,
                    text: controller.selectedPlanData!.planName!,
                  ),

                  BaseText(
                    fontWeight: FontWeight.w400,
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize12,
                    textColor: AppColors.offWhite50,
                    text: controller.isTabMonthly.value
                        ? "(${AppLocalizations.of(context)!.monthly})"
                        : "(${AppLocalizations.of(context)!.annually})",
                  ),
                ],
              ),
              BaseText(
                fontWeight: FontWeight.w500,
                fontFamily: AppKeys.inter,
                fontSize: fontSize14,
                textColor: AppColors.offWhite,
                text: controller.isTabMonthly.value
                    ? "R\$\t${controller.selectedPlanData?.priceMonthly}/${AppLocalizations.of(context)!.mu}"
                    : "R\$\t${controller.selectedPlanData?.priceAnnual}/${AppLocalizations.of(context)!.an}",
              ),
            ],
          ).marginOnly(bottom: spacerSize10),

          Divider(
            color: Colors.white12,
          ).marginZero.marginOnly(bottom: spacerSize10),
          FeatureItemCard(
            title:
                "${controller.selectedPlanData!.citiesCoverage}\t${AppLocalizations.of(context)!.citiesCoverage}",
          ),
          Visibility(
            visible: controller.selectedPlanData!.appearInSearch!,
            child: FeatureItemCard(
              title: AppLocalizations.of(context)!.appearInSearchResults,
            ),
          ),
          FeatureItemCard(
            title:
                (controller.selectedPlanData!.leadsLimit == null ||
                    controller.selectedPlanData!.leadsLimit == 0)
                ? AppLocalizations.of(context)!.unlimitedLeads
                : "${controller.selectedPlanData!.leadsLimit.toString()}\t Leads",
          ),
          Visibility(
            visible: controller.selectedPlanData!.premiumProfileBadge!,
            child: FeatureItemCard(
              title: AppLocalizations.of(context)!.premiumProfileBadge,
            ),
          ),
          Visibility(
            visible: controller.selectedPlanData!.priorityCustomerSupport!,
            child: FeatureItemCard(
              title: AppLocalizations.of(context)!.priorityCustomerSupport,
            ),
          ),

          Divider(
            color: Colors.white12,
          ).marginZero.marginOnly(top: spacerSize10, bottom: spacerSize10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaseText(
                fontWeight: FontWeight.w500,
                fontFamily: AppKeys.inter,
                fontSize: fontSize14,
                textColor: AppColors.offWhite50,
                text: AppLocalizations.of(context)!.total,
              ),
              BaseText(
                fontWeight: FontWeight.w600,
                fontFamily: AppKeys.inter,
                fontSize: fontSize15,
                textColor: AppColors.darkGold,
                text: controller.isTabMonthly.value
                    ? "R\$\t${controller.selectedPlanData?.priceMonthly}/${AppLocalizations.of(context)!.mu}"
                    : "R\$\t${controller.selectedPlanData?.priceAnnual}/${AppLocalizations.of(context)!.an}",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
