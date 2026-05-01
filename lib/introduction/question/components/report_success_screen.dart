import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_back_button.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/success_icon_layout.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';

class ReportSuccessScreen extends StatelessWidget {
  const ReportSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SuccessIconLayout(),
              BaseText(
                text: AppLocalizations.of(
                  context,
                )!.yourIntelligentDiagnosisReportIsReady,
                textColor: AppColors.offWhite,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                fontFamily: AppKeys.merriweather,
                fontSize: fontSize22,
              ),
            ],
          ),
          continueAndBackLayout(context),
        ],
      ).marginAll(spacerSize20),
    );
  }

  continueAndBackLayout(BuildContext context) {
    return Positioned(
      bottom: spacerSize0,
      left: spacerSize0,
      right: spacerSize0,
      child: Column(
        children: [
          BaseButton(
            backgroundColor: AppColors.burntGold,
            textColor: AppColors.offWhite,
            fontSize: fontSize17,
            buttonLabel: AppLocalizations.of(context)!.viewReport.toUpperCase(),
            onPressed: () {
              Get.offNamed(Routes.dashboard, arguments: Get.arguments);
            },
          ),
          BaseBackButton().marginOnly(top: spacerSize5),
        ],
      ),
    );
  }
}
