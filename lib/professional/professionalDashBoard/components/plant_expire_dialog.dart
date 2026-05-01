import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:kasagardem/l10n/app_localizations.dart';

import '../../../base/widgets/base_button.dart';
import '../../../base/widgets/base_text.dart';
import '../../../generated/assets.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';
import '../../../utils/routes.dart';

class PlanExpireDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.appBarColor.withValues(alpha: 0.9),
      builder: (_) {
        return PopScope(
          canPop: false,
          child: Dialog(
            alignment: Alignment.center,
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: spacerSize18),
            child: Container(
              padding: EdgeInsets.all(spacerSize25),
              decoration: BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(spacerSize20),
                border: Border.all(color: AppColors.dimGold, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.dimGold,
                    radius: spacerSize42,
                    child: Container(
                      padding: EdgeInsets.all(spacerSize15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.lightGold, AppColors.burntGold],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(spacerSize40),
                      ),
                      child: Image.asset(
                        Assets.imagesITextIcon,
                        height: spacerSize30,
                        width: spacerSize30,
                      ),
                    ),
                  ).marginOnly(bottom: spacerSize15),

                  BaseText(
                    text: AppLocalizations.of(
                      context,
                    )!.youAreOnA30DayTrialEnded,
                    fontFamily: AppKeys.poppins,
                    textAlign: TextAlign.center,
                    fontSize: fontSize22,
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.offWhite,
                  ).marginOnly(bottom: spacerSize10),

                  Row(
                    spacing: spacerSize3,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BaseText(
                        text: AppLocalizations.of(
                          context,
                        )!.yourProfileIsCurrently,
                        fontFamily: AppKeys.inter,
                        textAlign: TextAlign.center,
                        fontSize: fontSize14,
                        fontWeight: FontWeight.w400,
                        textColor: AppColors.darkGold,
                      ),

                      BaseText(
                        text: AppLocalizations.of(
                          context,
                        )!.inactive.toUpperCase(),
                        fontFamily: AppKeys.inter,
                        textAlign: TextAlign.center,
                        fontSize: fontSize14,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.darkGold,
                      ),
                    ],
                  ).marginOnly(bottom: spacerSize6),

                  BaseText(
                    text: AppLocalizations.of(context)!.customerPlanDesc,
                    fontFamily: AppKeys.inter,
                    textAlign: TextAlign.center,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.offWhite70,
                  ).marginOnly(bottom: spacerSize10),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: spacerSize90,
                    ),
                    child: Divider(color: AppColors.dimGold, thickness: 2),
                  ),

                  BaseText(
                    text: AppLocalizations.of(context)!.customerPlanDesc2,
                    fontFamily: AppKeys.inter,
                    textAlign: TextAlign.center,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.offWhite,
                  ).marginOnly(top: spacerSize8, bottom: spacerSize30),

                  BaseButton(
                    onPressed: () {
                      Get.toNamed(
                        Routes.upgradePlan,
                        arguments: {AppKeys.screenType: AppKeys.dashboard},
                      );
                    },
                    backgroundColor: AppColors.burntGold,
                    buttonLabel: AppLocalizations.of(context)!.seePlans,
                    fontSize: fontSize16,
                    buttonWidth: double.infinity,
                    textColor: Colors.white,
                  ).marginOnly(bottom: spacerSize10),

                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: BaseText(
                      text: AppLocalizations.of(context)!.notNow,
                      fontFamily: AppKeys.inter,
                      textAlign: TextAlign.center,
                      fontSize: fontSize16,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.offWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
