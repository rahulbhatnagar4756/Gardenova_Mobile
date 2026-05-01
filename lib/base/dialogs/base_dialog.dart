import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/success_icon_layout.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class BaseDialog {
  static void showFullScreenDialog(
    BuildContext context, {
    String? dialogTitle,
    String? dialogDescription,
    String? buttonLabel,
    bool? barrieDismissible = true,
    VoidCallback? onButtonPressed,
  }) {
    showDialog(
      barrierColor: AppColors.appColor,
      context: context,
      barrierDismissible: barrieDismissible!,
      fullscreenDialog: true,
      useSafeArea: true,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: spacerSize20),
            decoration: BoxDecoration(
              color: AppColors.darkGreen,
              boxShadow: [
                BoxShadow(
                  color: AppColors.offWhite10,
                  blurRadius: 2,
                  spreadRadius: 5,
                ),
              ],
              border: Border.all(color: AppColors.offWhite10),
              borderRadius: BorderRadius.circular(spacerSize45),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: spacerSize60,
                left: spacerSize30,
                right: spacerSize30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SuccessIconLayout(),
                  BaseText(
                    text: dialogTitle ?? "",
                    textColor: AppColors.offWhite,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppKeys.merriweather,
                    fontSize: fontSize26,
                  ),
                  SizedBox(height: spacerSize5),
                  BaseText(
                    text: dialogDescription ?? "",
                    textColor: AppColors.offWhite,
                    fontWeight: FontWeight.w400,
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize16,
                    textAlign: TextAlign.center,
                  ).marginOnly(bottom: spacerSize30),
                  BaseButton(
                    onPressed: onButtonPressed,
                    backgroundColor: AppColors.burntGold,
                    buttonLabel: buttonLabel ?? "",
                    fontSize: fontSize16,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void showAlertDialog({
    required BuildContext context,
    required VoidCallback onButtonPressed,
    required String title,
    required String description,
    required String buttonLabel,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkGreen,
        title: BaseText(
          text: title,
          fontFamily: AppKeys.merriweather,
          fontSize: fontSize22,
          textColor: AppColors.offWhite,
          fontWeight: FontWeight.w700,
        ),
        content: BaseText(
          text: description,
          fontSize: fontSize16,
          textAlign: TextAlign.start,
          textColor: AppColors.offWhite50,
          fontWeight: FontWeight.w400,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: BaseText(
              text: AppLocalizations.of(context)!.cancel,
              fontSize: fontSize14,
              textColor: AppColors.offWhite50,
              fontWeight: FontWeight.w600,
            ),
          ),

          TextButton(
            isSemanticButton: true,
            onPressed: onButtonPressed,
            child: BaseText(
              text: buttonLabel,
              fontSize: fontSize14,
              textColor: AppColors.burntGold,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
