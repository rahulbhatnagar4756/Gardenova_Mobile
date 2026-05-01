import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/professional/professionalDashBoard/components/professional_heading_item.dart';
import 'package:kasagardem/professional/professionalDashBoard/components/professional_item.dart';

import '../../../base/widgets/base_app_bar.dart';
import '../../../base/widgets/base_bordered_container.dart';
import '../../../base/widgets/base_text.dart';
import '../../../base/widgets/success_icon_layout.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';
import '../professional_dashboard_controller.dart';

class ProfessionalDashboardSuccessQuote
    extends GetWidget<ProfessionalDashboardController> {
  const ProfessionalDashboardSuccessQuote({super.key});

  @override
  Widget build(BuildContext context) {
    var scrollerController = ScrollController();
    return Scaffold(
      appBar: BaseAppBar(
        onBackPressed: () {
          Get.back();
          Get.back();
        },
      ),
      backgroundColor: AppColors.appColor,
      body: SingleChildScrollView(
        controller: scrollerController,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SuccessIconLayout(),
            BaseText(
              text: AppLocalizations.of(context)!.requestSentSuccessfully,
              fontFamily: AppKeys.poppins,
              textColor: AppColors.offWhite,
              textAlign: TextAlign.center,
              fontSize: fontSize22,
              fontWeight: FontWeight.w400,
            ).marginOnly(bottom: spacerSize10),
            BaseText(
              text: AppLocalizations.of(context)!.requestSentSuccessMessage,
              textColor: AppColors.offWhite70,
              fontSize: fontSize14,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
            ).marginOnly(bottom: spacerSize40),

            ProfessionalHeadingItem(
              controller: controller,
              spacing: spacerSize20,
              sectionTitle: AppLocalizations.of(context)!.professionalNotified,
              child: Column(
                children: List.generate(
                  controller.selectedTabIndex.value == 0
                      ? controller.selectedProfessionalsList.length
                      : controller.selectedWholesaleList.length,
                  (index) => BaseBorderedContainer(
                    backgroundColor: AppColors.darkGreen,
                    height: spacerSize310,
                    borderColor: AppColors.offWhite10,
                    width: Get.width,
                    childWidget: ProfessionalItem(
                      isSelected: false,
                      isSuccess: true,
                      professional: controller.selectedTabIndex.value == 0
                          ? controller.selectedProfessionalsList[index]
                          : controller.selectedWholesaleList[index],
                    ),
                  ).marginOnly(bottom: spacerSize10),
                ),
              ),
            ),
          ],
        ).marginSymmetric(horizontal: spacerSize20, vertical: spacerSize10),
      ),
    );
  }
}
