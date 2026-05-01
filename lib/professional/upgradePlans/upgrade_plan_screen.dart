import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_back_button.dart';
import 'package:kasagardem/professional/upgradePlans/upgrade_plan_controller.dart';

import '../../base/widgets/base_button.dart';
import '../../base/widgets/base_text.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_keys.dart';
import '../../utils/routes.dart';
import 'components/additional_coverage.dart';
import 'components/header_card.dart';
import 'components/plan_card.dart';
import 'components/toggle_button.dart';

class UpgradePlanScreen extends GetWidget<UpgradePlanController> {
  const UpgradePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.appColor,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
            left: spacerSize20,
            right: spacerSize20,
            bottom: spacerSize20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BaseButton(
                onPressed: () {
                  controller.goToOrderSummary();
                },
                backgroundColor: AppColors.burntGold,
                buttonLabel: controller.selectedPrice.value.isEmpty
                    ? AppLocalizations.of(context)!.continueText
                    : "${AppLocalizations.of(context)!.continueWith}\t\$${controller.selectedPrice.value}",
                fontSize: fontSize16,
                textColor: Colors.white,
                buttonWidth: double.infinity,
              ).marginOnly(bottom: spacerSize8),

              Visibility(
                visible: controller.screenType.value == AppKeys.login,
                replacement: BaseBackButton(),
                child: TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    minimumSize: WidgetStateProperty.all(Size.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                  ),
                  onPressed: () {
                    Get.offAllNamed(Routes.professionalDashboard);
                  },
                  child: BaseText(
                    text: AppLocalizations.of(context)!.skip.toUpperCase(),

                    fontSize: fontSize16,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.offWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderCard(controller: controller).marginOnly(top: spacerSize40),
              Obx(
                () => Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: spacerSize2,
                      horizontal: spacerSize2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(spacerSize30),
                      border: Border.all(color: AppColors.borderGold),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ToggleButton(
                          verticalPadding: spacerSize8,
                          horizontalPadding: spacerSize20,
                          textSize: fontSize13,
                          title: AppLocalizations.of(
                            context,
                          )!.monthly.toUpperCase(),
                          isSelected: controller.isTabMonthly.value,
                          onTap: () => controller.changeTab(true),
                        ),
                        ToggleButton(
                          verticalPadding: spacerSize8,
                          horizontalPadding: spacerSize30,
                          textSize: fontSize13,
                          title: AppLocalizations.of(
                            context,
                          )!.annually.toUpperCase(),
                          isSelected: !controller.isTabMonthly.value,
                          onTap: () => controller.changeTab(false),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PlanCard(controller: controller),
              Obx(() {
                return AdditionalNationalCoverage(
                  controller: controller,
                  isShowPlanType: !controller.isTabMonthly.value ? true : false,
                  isSelected: controller.isTabAdditionalCoverage.value,
                  onTap: () {
                    if (controller.planList.any(
                      (plan) => plan.isSelect == true,
                    )) {
                      controller.changeTabAdditionalCoverage(
                        !controller.isTabAdditionalCoverage.value,
                      );
                    }
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
