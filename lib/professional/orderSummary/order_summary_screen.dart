import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_back_button.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/professional/upgradePlans/upgrade_plan_controller.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/routes.dart';
import 'components/order_summary_card.dart';

class OrderSummaryScreen extends GetWidget<UpgradePlanController> {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(AppAssets.appLogo, scale: 2.2),
          ).marginOnly(top: spacerSize50),

          Container(
            margin: EdgeInsets.symmetric(vertical: spacerSize50),
            decoration: BoxDecoration(
              color: AppColors.darkGreen,
              border: Border(
                top: BorderSide(
                  color: AppColors.offWhite10,
                  width: spacerSize2,
                  style: BorderStyle.solid,
                ),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(spacerSize28),
                topRight: Radius.circular(spacerSize28),
              ),
            ),
            child: OrderSummaryCard(controller: controller),
          ),

          Spacer(),

          Padding(
            padding: EdgeInsets.all(spacerSize20),
            child: Column(
              spacing: spacerSize8,
              children: [
                BaseButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.professionalDashboard);
                  },
                  backgroundColor: AppColors.burntGold,
                  buttonLabel: AppLocalizations.of(context)!.fullPayment,
                  fontSize: fontSize16,
                  textColor: Colors.white,
                  buttonWidth: double.infinity,
                ),
                BaseBackButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
