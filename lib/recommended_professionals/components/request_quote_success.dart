import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/success_icon_layout.dart';
import 'package:kasagardem/dashboard/components/heading_ui_layout.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/recommended_professionals/components/professional_card_layout.dart';
import 'package:kasagardem/recommended_professionals/recommended_professionals_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class RequestQuoteSuccess extends GetWidget<RecommendedProfessionalsViewModel> {
  const RequestQuoteSuccess({super.key});

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
              fontFamily: AppKeys.merriweather,
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

            HeadingUiLayout(
              spacing: spacerSize20,
              sectionTitle: AppLocalizations.of(context)!.professionalNotified,
              child: Column(
                children: List.generate(
                  controller.selectedProfessionalsList.length,
                  (index) => BaseBorderedContainer(
                    backgroundColor: AppColors.darkGreen,
                    height: spacerSize310,
                    borderColor: AppColors.offWhite10,
                    width: Get.width,
                    childWidget: ProfessionalCardLayout(
                      isSelected: false,
                      isSuccess: true,
                      professional: controller.selectedProfessionalsList[index],
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
