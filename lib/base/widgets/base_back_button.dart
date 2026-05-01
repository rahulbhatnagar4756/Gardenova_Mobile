import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class BaseBackButton extends StatelessWidget {
  const BaseBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
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
    );
  }
}
