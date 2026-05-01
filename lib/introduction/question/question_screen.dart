import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_form.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
import 'package:kasagardem/introduction/question/components/question_progress_indicator.dart';
import 'package:kasagardem/introduction/question/models/question_response_model.dart';
import 'package:kasagardem/introduction/question/question_view_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

class QuestionScreen extends GetWidget<QuestionViewModel> {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isUserLoggedIn.value =
          SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false;
    });
    return Obx(
      () => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          controller.backPressed();
        },
        child: Scaffold(
          appBar: controller.isUserLoggedIn.value
              ? CircularBottomAppBar(
                  onSettingPressed: () {
                    Get.toNamed(Routes.settings, arguments: 'question');
                  },
                )
              : BaseAppBar(onBackPressed: controller.backPressed),
          backgroundColor: AppColors.appColor,
          body: Obx(
            () =>
                Stack(
                  children: [
                    Column(
                      children: [
                        QuestionProgressIndicator(
                          currentQuestion: controller.currentQuestion.value,
                          totalQuestions: controller.totalQuestions,
                        ).marginOnly(top: spacerSize45),

                        questionLayout(),

                        if (controller.questionList.isNotEmpty)
                          controller.totalQuestions ==
                                  controller
                                      .questionList[controller
                                              .currentQuestion
                                              .value -
                                          1]
                                      .order
                              ? answer5Layout(context)
                              : Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.center,
                                  spacing: spacerSize10,
                                  runSpacing: spacerSize10,
                                  children: List.generate(
                                    controller
                                        .questionList[controller
                                                .currentQuestion
                                                .value -
                                            1]
                                        .options!
                                        .length,
                                    (index) {
                                      return answersLayout(
                                        question:
                                            controller.questionList[controller
                                                    .currentQuestion
                                                    .value -
                                                1],
                                        index: index,
                                        context: context,
                                      );
                                    },
                                  ),
                                ).marginOnly(top: spacerSize15),
                      ],
                    ),
                    continueAndBackLayout(context),
                  ],
                ).marginOnly(
                  top: spacerSize20,
                  bottom: spacerSize15,
                  right: spacerSize20,
                  left: spacerSize20,
                ),
          ),
        ),
      ),
    );
  }

  answersLayout({
    int index = 0,
    required Questions question,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        question.selectedAnswer = question.options![index].optionText;
        controller.questionList.refresh();
      },
      child: Container(
        height: spacerSize60,
        width: spacerSize150,
        alignment: Alignment.topLeft,
        decoration: BoxDecoration(
          color: AppColors.darkGreen,
          border: Border.all(
            color:
                (question.options![index].optionText == question.selectedAnswer)
                ? AppColors.burntGold
                : AppColors.backgroundGrey,
          ),
          borderRadius: BorderRadius.circular(spacerSize10),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: spacerSize17,
          vertical: spacerSize10,
        ),
        child: Center(
          child: BaseText(
            textAlign: TextAlign.center,
            fontFamily: AppKeys.poppins,
            fontWeight: FontWeight.w400,
            fontSize: fontSize14,
            textColor: AppColors.offWhite,
            text: question.options![index].optionText ?? "",
          ),
        ),
      ),
    );
  }

  continueAndBackLayout(BuildContext context) {
    return Positioned(
      bottom: spacerSize0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          BaseButton(
            backgroundColor: AppColors.burntGold,
            textColor: AppColors.offWhite,
            fontSize: fontSize17,
            buttonLabel: AppLocalizations.of(
              context,
            )!.continueText.toUpperCase(),
            onPressed: controller.onContinuePressed,
          ),
          GestureDetector(
            onTap: controller.backPressed,
            child: Row(
              spacing: spacerSize4,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Icon(
                    Icons.arrow_back,
                    size: spacerSize20,
                    color: AppColors.offWhite,
                    applyTextScaling: true,
                  ),
                ),
                BaseText(
                  text: AppLocalizations.of(context)!.back,
                  fontSize: fontSize16,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.offWhite,
                ),
              ],
            ),
          ).marginOnly(top: spacerSize5),
        ],
      ),
    );
  }

  questionLayout() {
    return BaseText(
      text: controller.questionList.isNotEmpty
          ? controller
                .questionList[controller.currentQuestion.value - 1]
                .questionText!
                .toTitleCase()
          : "",
      textColor: AppColors.offWhite,
      fontWeight: FontWeight.w400,
      textAlign: TextAlign.center,
      fontFamily: AppKeys.poppins,
      fontSize: fontSize22,
    ).marginOnly(top: spacerSize25).paddingAll(spacerSize5);
  }

  answer5Layout(BuildContext context) {
    return BaseForm(
      formKey: controller.formKey,
      child: Column(
          spacing:spacerSize15,
          children: [state(context), city(context)]).marginOnly(top: spacerSize30),
    );
  }


  state(BuildContext context) {
    return InkWell(
          onTap: () => _showStateBottomSheet(context),
          child: BaseTextField(
            textEditingController: controller.stateController,
            hintText: AppLocalizations.of(context)!.selectState,
            hintColor: Colors.white,
            isTextFieldEnabled:false,
            validator: (value) {
              if (value!.isEmpty) {
                return AppLocalizations.of(context)!.selectState;
              }
              return null;
            },
            suffixIcon: const Icon(
              Icons.keyboard_arrow_down_outlined,
              color: AppColors.offWhite,
            ),
          ),
        );
  }

  city(BuildContext context) {
    return InkWell(
      onTap: () {
        if (controller.selectedState.value.name != null) {
          _showCityBottomSheet(context);
        }else{
          BaseSnackBar.show(
            title: AppLocalizations.of(context)!.error,
            message: AppLocalizations.of(context)!.selectState,
          );
        }
      },
      child: BaseTextField(
        textEditingController: controller.cityController,
        hintText: AppLocalizations.of(context)!.selectCity,
        hintColor: Colors.white,
        isTextFieldEnabled:false,
        validator: (value) {
          if (value!.isEmpty) {
            return AppLocalizations.of(context)!.selectCity;
          }
          return null;
        },
        suffixIcon: const Icon(
          Icons.keyboard_arrow_down_outlined,
          color: AppColors.offWhite,
        ),
      ),
    );
  }

  void _showStateBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(
          color: AppColors.darkGreen,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(spacerSize28),
            topRight: Radius.circular(spacerSize28),
          ),
        ),
        padding: EdgeInsets.all(spacerSize20),
        child: Column(
          children: [
            BaseText(
              text: AppLocalizations.of(context)!.selectState,
              fontSize: fontSize18,
              fontWeight: FontWeight.w600,
              textColor: AppColors.offWhite,
            ).marginOnly(bottom: spacerSize15),
            BaseTextField(
              textEditingController: controller.stateController,
              hintText: AppLocalizations.of(context)!.search,
              hintColor: Colors.white,
              onChanged: (value) => controller.filterState(value),
            ),
            SizedBox(height: spacerSize15),
            Expanded(
              child: Obx(
                    () => ListView.separated(
                  itemCount: controller.filteredStateList.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppColors.offWhite.withOpacity(0.1),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final state = controller.filteredStateList[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: BaseText(
                        text: state.name ?? "",
                        textColor: AppColors.offWhite,
                        fontSize: fontSize14,
                        fontWeight: FontWeight.w500,
                      ),
                      onTap: () {
                        controller.selectedState.value = state;
                        controller.stateController.text = state.name??"";
                        controller.getCityList(stateCode: state.iso2);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showCityBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.7,
        decoration: BoxDecoration(
          color: AppColors.darkGreen,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(spacerSize28),
            topRight: Radius.circular(spacerSize28),
          ),
        ),
        padding: EdgeInsets.all(spacerSize20),
        child: Column(
          children: [
            BaseText(
              text: AppLocalizations.of(context)!.selectCity,
              fontSize: fontSize18,
              fontWeight: FontWeight.w600,
              textColor: AppColors.offWhite,
            ).marginOnly(bottom: spacerSize15),
            BaseTextField(
              textEditingController: controller.cityController,
              hintText: AppLocalizations.of(context)!.search,
              hintColor: Colors.white,
              onChanged: (value) => controller.filterCity(value),
            ),
            SizedBox(height: spacerSize15),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.filteredCityList.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppColors.offWhite.withOpacity(0.1),
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final city = controller.filteredCityList[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: BaseText(
                        text: city.name ?? "",
                        textColor: AppColors.offWhite,
                        fontSize: fontSize14,
                        fontWeight: FontWeight.w500,
                      ),
                      onTap: () {
                        controller.cityController.text = city.name??"";
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

}
