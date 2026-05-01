import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/recommended_professionals/components/service_bottom_sheet.dart';
import 'package:kasagardem/recommended_professionals/recommended_professionals_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../base/widgets/base_button.dart';
import '../../base/widgets/base_text_field.dart';
import '../../l10n/app_localizations.dart';

class CreateRequestScreen extends GetWidget<RecommendedProfessionalsViewModel> {
  const CreateRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: BaseAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            spacing: spacerSize6,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BaseText(
                text: AppLocalizations.of(context)!.selectService,
                textColor: AppColors.offWhite,
                fontSize: fontSize16,
              ),
              InkWell(
                onTap: (){
                  ServiceBottomSheet.show(
                    categories: controller.categories,
                    selectedKey: controller.selectedService.value,
                    onSelect: (key, value) {
                      controller.selectedService.value = value;
                      controller.serviceController.text = value;
                    },
                  );
                },
                child: BaseTextField(
                  hintText:  AppLocalizations.of(context)!.selectService,
                  hintColor: AppColors.mediumGrey,
                  isTextFieldEnabled: false,
                  textEditingController: controller.serviceController,
                  errorText: AppLocalizations.of(context)!.selectService,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.selectService;
                    }
                    return null;
                  },
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.offWhite,
                  ),
                ),
              ).marginOnly(
                  bottom: spacerSize10
              ),
              BaseText(
                text:  AppLocalizations.of(context)!.shortDescription,
                textColor: AppColors.offWhite,
                fontSize: fontSize16,
              ),
              BaseTextField(
                hintText:AppLocalizations.of(context)!.shortDescription,
                hintColor: AppColors.mediumGrey,
                textEditingController: controller.descriptionController,
                errorText:AppLocalizations.of(context)!.enterShortDescription,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterShortDescription;
                  }
                  return null;
                },
              ).marginOnly(
                  bottom: spacerSize10
              ),
              BaseText(
                text:  AppLocalizations.of(context)!.sizeOfTheArea,
                textColor: AppColors.offWhite,
                fontSize: fontSize16,
              ),
              BaseTextField(
                hintText: AppLocalizations.of(context)!.sizeOfTheArea,
                hintColor: AppColors.mediumGrey,
                textEditingController: controller.sizeController,
                errorText: AppLocalizations.of(context)!.enterSizeOfTheArea,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.enterSizeOfTheArea;
                  }
                  return null;
                },
              ),
        
              BaseButton(
                buttonLabel: AppLocalizations.of(
                  context,
                )!.requestAQuote,
                buttonWidth: Get.width,
                onPressed: () {
                  if (controller.formKey.currentState!.validate()) {
                    if (controller.professionalsList.any((professional) => professional.isSelected == true)) {
                      controller.checkLogin();
                    }
                  }
                },
              ).marginOnly(
                  top: spacerSize40
              ),
            ],
          ).marginSymmetric(horizontal: spacerSize20, vertical: spacerSize10),
        ),
      ),
    );
  }
}