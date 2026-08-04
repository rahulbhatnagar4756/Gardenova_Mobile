import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class BottomSheetLayout extends StatelessWidget {
  const BottomSheetLayout({
    super.key,
    this.buttonLabel,
    this.childLayout,
    this.onButtonTap,
    this.isButtonVisible = true,
  });

  final String? buttonLabel;
  final bool? isButtonVisible;
  final Widget? childLayout;
  final VoidCallback? onButtonTap;

  @override
  Widget build(BuildContext context) {
    return isButtonVisible!
        ? Center(
            child: Column(
              children: [
                Expanded(child: childLayout!),
                Visibility(
                  visible: true,
                  child: SizedBox(
                    width: double.infinity,
                    child: BaseButton(
                      bottomPadding: true,
                      buttonWidth: spacerSize200,
                      backgroundColor: AppColors.burntGold,
                      textColor: Colors.white,
                      buttonLabel: buttonLabel ?? "",
                      onPressed: onButtonTap,
                    ),
                  ),
                ),
              ],
            ),
          ).marginOnly(
            left: spacerSize20,
            right: spacerSize20,
            bottom: spacerSize20,
            top: spacerSize30,
          )
        : SizedBox();
  }
}
