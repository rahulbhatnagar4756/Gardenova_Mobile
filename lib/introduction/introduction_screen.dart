import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/introduction/introduction_screen_view_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';

class IntroductionScreen extends GetWidget<IntroductionScreenViewModel> {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (result, didPop) {
        if (didPop != null) return;
        BaseDialog.showAlertDialog(
          context: context,
          title: appName,
          description: AppLocalizations.of(context)!.exitAppContent,
          buttonLabel: AppLocalizations.of(context)!.exit,
          onButtonPressed: () {
            SystemNavigator.pop();
          },
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        appBar: const BaseAppBar(
          isAppIconVisible: false,
          isBackButtonVisible: false,
          topMargin: spacerSize0,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    AppAssets.appLogo,
                    width: 60.w,
                    height: 60.w,
                  ),
                ),

                BaseText(
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppKeys.poppins,
                  fontSize: 25.sp,
                  text: AppLocalizations.of(context)!.startIntelligentDiagnosis,
                ).marginOnly(
                  top: spacerSize30,
                  bottom: spacerSize15,
                  left: 15.w,
                  right: 15.w,
                ),

                BaseText(
                  textAlign: TextAlign.center,
                  textColor: AppColors.liteGreyColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppKeys.inter,
                  fontSize: 14.sp,
                  text: AppLocalizations.of(
                    context,
                  )!.startIntelligentDiagnosisDesc,
                ).marginOnly(bottom: spacerSize30, left: 10.w, right: 10.w),

                ListView(
                  shrinkWrap: true,
                  physics: RangeMaintainingScrollPhysics(),
                  children: List.generate(
                    controller.introductionList.length,
                    (itemIndex) => itemsLayout(itemIndex),
                  ),
                ),
                SizedBox(height: 36.h),
                SizedBox(
                  width: double.infinity,
                  child: BaseButton(
                    textColor: AppColors.offWhite,
                    fontSize: fontSize17,
                    buttonLabel: AppLocalizations.of(context)!.startDiagnosis,
                    onPressed: () {
                      Get.toNamed(Routes.question);
                    },
                  ),
                ),
                Obx(
                  () => !controller.isUserLoggedIn.value
                      ? Column(
                          children: [
                            SizedBox(height: 11.h),
                            SizedBox(
                              width: double.infinity,
                              child: BaseButton(
                                textColor: AppColors.offWhite,
                                fontSize: fontSize17,
                                buttonLabel: AppLocalizations.of(
                                  context,
                                )!.login,
                                onPressed: () {
                                  // Get.offAllNamed(Routes.login);
                                  Get.offAllNamed(Routes.chooseAccountType);
                                },
                              ),
                            ),
                            SizedBox(height: 25.h),
                          ],
                        )
                      : const SizedBox(),
                ),

                // Obx(
                //   () => !controller.isUserLoggedIn.value
                //       ? GestureDetector(
                //           onTap: () {
                //             Get.offAllNamed(Routes.login);
                //           },
                //           child: BaseText(
                //             text: AppLocalizations.of(context)!.login,
                //             fontSize: fontSize16,
                //             fontWeight: FontWeight.w400,
                //             textColor: AppColors.offWhite,
                //           ),
                //         ).marginOnly(top: spacerSize5, bottom: spacerSize15)
                //       : SizedBox(height: spacerSize35),
                // ),
              ],
            ).marginSymmetric(horizontal: spacerSize20),

            // Positioned(
            //   bottom: spacerSize0,
            //   left: spacerSize0,
            //   right: spacerSize0,
            //   child: Column(
            //     mainAxisSize: MainAxisSize.max,
            //     children: [
            //       BaseButton(
            //         backgroundColor: AppColors.burntGold,
            //         textColor: AppColors.offWhite,
            //         fontSize: fontSize17,
            //         buttonLabel: AppLocalizations.of(context)!.startDiagnosis,
            //         onPressed: () {
            //           Get.toNamed(Routes.question);
            //         },
            //       ),
            //       Obx(
            //         () => !controller.isUserLoggedIn.value
            //             ? GestureDetector(
            //                 onTap: () {
            //                   // Get.offAllNamed(Routes.login);
            //                   Get.offAllNamed(Routes.chooseAccountType);
            //                 },
            //                 child: BaseText(
            //                   text: AppLocalizations.of(context)!.login,
            //                   fontSize: fontSize16,
            //                   fontWeight: FontWeight.w400,
            //                   textColor: AppColors.offWhite,
            //                 ),
            //               ).marginOnly(top: spacerSize5, bottom: spacerSize15)
            //             : SizedBox(height: spacerSize35),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  itemsLayout(int itemIndex) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greenColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: spacerSize10,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.greenColor,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              color: AppColors.whiteColor,
              width: 25.w,
              height: 25.w,
              controller.introductionList[itemIndex].imagePath ?? "",
            ).marginAll(spacerSize10),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  textAlign: TextAlign.start,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppKeys.poppins,
                  fontSize: 15.sp,
                  text: controller.introductionList[itemIndex].title ?? "",
                ),
                BaseText(
                  textAlign: TextAlign.start,
                  textColor: AppColors.liteGreyColor,
                  fontWeight: FontWeight.w400,
                  fontFamily: AppKeys.poppins,
                  fontSize: 12.sp,
                  text:
                      controller.introductionList[itemIndex].description ?? "",
                ),
              ],
            ),
          ),
        ],
      ).marginAll(spacerSize10),
    ).marginOnly(bottom: spacerSize10);
  }
}
