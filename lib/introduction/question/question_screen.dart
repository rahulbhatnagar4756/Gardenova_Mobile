import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_form.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';
import 'package:kasagardem/introduction/question/components/question_progress_indicator.dart';
import 'package:kasagardem/introduction/question/models/question_response_model.dart';
import 'package:kasagardem/introduction/question/question_view_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import '../../utils/constants/app_assets.dart';

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
        canPop: controller.currentQuestion.value == 1,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          controller.backPressed();
        },
        child: Scaffold(
          // appBar: controller.isUserLoggedIn.value && false
          //     ? CircularBottomAppBar(
          //         onSettingPressed: () {
          //           Get.toNamed(Routes.settings, arguments: 'question');
          //         },
          //       )
          //     : BaseAppBar(onBackPressed: controller.backPressed),
          appBar: BaseAppBar(onBackPressed: controller.backPressed),
          backgroundColor: AppColors.appColor,
          body: Obx(
            () =>
                Stack(
                  children: [
                    Column(
                      children: [
                        QuestionProgressIndicator(
                          currentQuestion: controller.currentQuestion.value,
                          totalQuestions: controller.questionList.length + 1,
                        ).marginOnly(top: 25.h),

                        questionLayout(),

                        if (controller.questionList.isNotEmpty)
                          // State/city tab is shown when currentQuestion exceeds the question list
                          controller.currentQuestion.value >
                                  controller.questionList.length
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
                                ).marginOnly(top: 26.h),
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

  Widget answersLayout({
    int index = 0,
    required Questions question,
    required BuildContext context,
  }) {
    // Image.asset(AppAssets.selectedRadioIc, width: 24.w,height: 24.w,),
    // Image.asset(AppAssets.unSelectedRadioIc, width: 24.w,height: 24.w,),
    return GestureDetector(
      onTap: () {
        question.selectedAnswer = question.options![index].optionText;
        controller.questionList.refresh();
      },
      child: Container(
        height: spacerSize60,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: spacerSize17,
          vertical: spacerSize10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(spacerSize10),
          border: Border.all(
            color:
                (question.options![index].optionText == question.selectedAnswer)
                ? AppColors
                      .greenColor // selected border
                : AppColors.borderLiteGreyColor,
            width: 1.2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// ✅ Text (Left)
            Expanded(
              child: BaseText(
                text: (question.options![index].optionText ?? "").trim(),
                fontFamily: AppKeys.poppins,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(width: 5.w),

            /// ✅ Radio Icon (Right)
            Image.asset(
              (question.options![index].optionText == question.selectedAnswer)
                  ? AppAssets.selectedRadioIc
                  : AppAssets.unSelectedRadioIc,
              width: 24.w,
              height: 24.w,
            ),
          ],
        ),
      ),
    );
    // return GestureDetector(
    //   onTap: () {
    //     question.selectedAnswer = question.options![index].optionText;
    //     controller.questionList.refresh();
    //   },
    //   child: Container(
    //     height: spacerSize60,
    //     width: spacerSize150,
    //     alignment: Alignment.topLeft,
    //     decoration: BoxDecoration(
    //       color: AppColors.darkGreen,
    //       border: Border.all(
    //         color:
    //             (question.options![index].optionText == question.selectedAnswer)
    //             ? AppColors.burntGold
    //             : AppColors.backgroundGrey,
    //       ),
    //       borderRadius: BorderRadius.circular(spacerSize10),
    //     ),
    //     padding: EdgeInsets.symmetric(
    //       horizontal: spacerSize17,
    //       vertical: spacerSize10,
    //     ),
    //     child: Center(
    //       child: BaseText(
    //         textAlign: TextAlign.center,
    //         fontFamily: AppKeys.poppins,
    //         fontWeight: FontWeight.w400,
    //         fontSize: fontSize14,
    //         textColor: AppColors.offWhite,
    //         text: question.options![index].optionText ?? "",
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget continueAndBackLayout(BuildContext context) {
    return Positioned(
      bottom: spacerSize0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: BaseButton(
              bottomPadding: true,
              backgroundColor: AppColors.burntGold,
              textColor: AppColors.offWhite,
              fontSize: fontSize17,
              buttonLabel: AppLocalizations.of(context)!.continueText,
              onPressed: controller.onContinuePressed,
            ),
          ),
        ],
      ),
    );
  }

  Widget questionLayout() {
    // On the state/city tab, show a fixed heading instead of a question text
    final isStateCityTab =
        controller.questionList.isNotEmpty &&
        controller.currentQuestion.value > controller.questionList.length;
    return BaseText(
      text: isStateCityTab
          ? ""
          : controller.questionList.isNotEmpty
          ? controller
                .questionList[controller.currentQuestion.value - 1]
                .questionText!
                .toTitleCase()
          : "",
      textColor: AppColors.blackColor,
      fontWeight: FontWeight.w600,
      textAlign: TextAlign.left,
      fontFamily: AppKeys.poppins,
      fontSize: 22.sp,
    ).marginOnly(top: 29.h);
  }

  Widget answer5Layout(BuildContext context) {
    return BaseForm(
      formKey: controller.formKey,
      child: Column(
        spacing: spacerSize15,
        children: [state(context), city(context)],
      ).marginOnly(top: 26.h),
    );
  }

  Widget state(BuildContext context) {
    return InkWell(
      onTap: () => _showStateBottomSheet(context),
      child: BaseTextField(
        textEditingController: controller.stateController,
        hintText: AppLocalizations.of(context)!.selectState,
        isTextFieldEnabled: false,
        validator: (value) {
          if (value!.isEmpty) {
            return AppLocalizations.of(context)!.selectState;
          }
          return null;
        },
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: AppColors.liteGreyColor,
        ),
      ),
    );
  }

  Widget city(BuildContext context) {
    return InkWell(
      onTap: () {
        if (controller.selectedState.value.name != null) {
          _showCityBottomSheet(context);
        } else {
          BaseSnackBar.show(
            title: AppLocalizations.of(context)!.error,
            message: AppLocalizations.of(context)!.selectState,
          );
        }
      },
      child: BaseTextField(
        textEditingController: controller.cityController,
        hintText: AppLocalizations.of(context)!.selectCity,
        isTextFieldEnabled: false,
        validator: (value) {
          if (value!.isEmpty) {
            return AppLocalizations.of(context)!.selectCity;
          }
          return null;
        },
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: AppColors.liteGreyColor,
        ),
      ),
    );
  }

  void _showStateBottomSheet(BuildContext context) {
    // Reset search field each time the sheet opens
    controller.stateSearchController.clear();
    controller.filterState('');
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
            // Use a dedicated search controller — NOT stateController — so
            // typing in the search box doesn't overwrite the selected value.
            BaseTextField(
              textEditingController: controller.stateSearchController,
              hintText: AppLocalizations.of(context)!.search,
              hintColor: AppColors.liteGreyColor,
              onChanged: (value) => controller.filterState(value),
            ),
            SizedBox(height: spacerSize15),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.filteredStateList.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppColors.offWhite.withValues(alpha: 0.1),
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
                        controller.stateController.text = state.name ?? "";
                        controller.getCityList(stateCode: state.iso2);
                        controller.stateSearchController.clear();
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
    // Clear the search text only — filteredCityList is already populated by getCityList()
    controller.citySearchController.clear();
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
            // Use a dedicated search controller — NOT cityController — so
            // typing in the search box doesn't overwrite the selected value.
            BaseTextField(
              textEditingController: controller.citySearchController,
              hintText: AppLocalizations.of(context)!.search,
              onChanged: (value) => controller.filterCity(value),
            ),
            SizedBox(height: spacerSize15),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.filteredCityList.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppColors.offWhite.withValues(alpha: 0.1),
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
                        controller.selectedCity.value = city;
                        controller.cityController.text = city.name ?? "";
                        controller.citySearchController.clear();
                        controller.formKey.currentState!.validate();
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
