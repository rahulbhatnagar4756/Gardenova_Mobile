import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:kasagardem/professional/upgradePlans/components/toggle_button.dart';

import '../../../base/widgets/base_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';
import '../upgrade_plan_controller.dart';

class AdditionalNationalCoverage extends StatelessWidget {
  final UpgradePlanController controller;
  final bool isShowPlanType;
  final bool isSelected;
  final VoidCallback onTap;

  const AdditionalNationalCoverage({
    super.key,
    required this.controller,
    required this.isShowPlanType,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(spacerSize20),
        child: DottedBorder(
          options: RoundedRectDottedBorderOptions(
            dashPattern: [5, 5],
            strokeWidth: spacerSize1,
            padding: EdgeInsets.all(spacerSize14),
            color: isSelected ? AppColors.burntGold : AppColors.offWhite10,
            radius: const Radius.circular(spacerSize12),
          ),
          child: Row(
            spacing: spacerSize8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(spacerSize2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(spacerSize12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.burntGold
                        : AppColors.offWhite10,
                  ),
                ),
                child: CircleAvatar(
                  radius: spacerSize6,
                  backgroundColor: isSelected
                      ? AppColors.burntGold
                      : AppColors.appBarColor,
                ),
              ),

              Expanded(
                child: Column(
                  spacing: spacerSize8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BaseText(
                          text: AppLocalizations.of(
                            context,
                          )!.additionalNationalCoverage,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppKeys.inter,
                          textColor: AppColors.offWhite70,
                        ),
                        Obx(
                          () => FittedBox(
                            fit: BoxFit.scaleDown,
                            child: BaseText(
                              text:
                                  isShowPlanType &&
                                      controller.isSelectOneTime.value
                                  ? "+R\$\t100.00/${AppLocalizations.of(context)!.an}"
                                  : !controller.isSelectOneTime.value
                                  ? "+R\$1200.00/${AppLocalizations.of(context)!.an}"
                                  : "+R\$\t100.00/${AppLocalizations.of(context)!.mu}",
                              fontSize: fontSize14,
                              fontWeight: FontWeight.w600,
                              fontFamily: AppKeys.inter,
                              textColor: AppColors.burntGold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isShowPlanType)
                      BaseText(
                        text: AppLocalizations.of(
                          context,
                        )!.additionalNationalCoverageDesc1,
                        fontSize: fontSize12,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppKeys.inter,
                        textColor: AppColors.offWhite50,
                      ),
                    if (isShowPlanType)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaseText(
                            text: AppLocalizations.of(
                              context,
                            )!.additionalNationalCoverageDesc2,
                            fontSize: fontSize12,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppKeys.inter,
                            textColor: AppColors.offWhite50,
                          ),
                          Text(
                            AppLocalizations.of(context)!.validFor1Year,
                            style: TextStyle(
                              fontSize: fontSize12,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppKeys.inter,
                              color: AppColors.darkGold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          Visibility(
                            visible: controller.isTabAdditionalCoverage.value,
                            child: Row(
                              spacing: spacerSize15,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BaseText(
                                  text: AppLocalizations.of(
                                    context,
                                  )!.planType.toUpperCase(),
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: AppKeys.poppins,
                                  textColor: AppColors.offWhite50,
                                ).marginOnly(top: spacerSize6),
                                Obx(
                                  () => Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: spacerSize2,
                                      horizontal: spacerSize2,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        spacerSize30,
                                      ),
                                      border: Border.all(
                                        color: AppColors.borderGold,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,

                                      children: [
                                        ToggleButton(
                                          verticalPadding: spacerSize3,
                                          horizontalPadding: spacerSize8,
                                          title: AppLocalizations.of(
                                            context,
                                          )!.oneTime.toUpperCase(),
                                          isSelected:
                                              controller.isSelectOneTime.value,
                                          onTap: () {
                                            if (controller.planList.any(
                                              (plan) => plan.isSelect == true,
                                            )) {
                                              controller.selectPlanType(true);
                                            }
                                          },
                                        ),
                                        ToggleButton(
                                          title: AppLocalizations.of(
                                            context,
                                          )!.reccuring.toUpperCase(),
                                          isSelected:
                                              !controller.isSelectOneTime.value,
                                          onTap: () {
                                            if (controller.planList.any(
                                              (plan) => plan.isSelect == true,
                                            )) {
                                              controller.selectPlanType(false);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ).marginOnly(top: spacerSize8),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
