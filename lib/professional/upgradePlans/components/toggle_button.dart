import 'package:flutter/material.dart';

import '../../../base/widgets/base_text.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';

class ToggleButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? textSize;
  final VoidCallback onTap;

  const ToggleButton({
    super.key,
    required this.title,
    required this.isSelected,
    this.verticalPadding,
    this.horizontalPadding,
    this.textSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? spacerSize3,
          horizontal: horizontalPadding ?? spacerSize8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [AppColors.lightGold, AppColors.burntGold],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : null,
          borderRadius: BorderRadius.circular(spacerSize30),
        ),
        child: BaseText(
          text: title,
          textColor: AppColors.offWhite,
          fontWeight: FontWeight.w400,
          fontFamily: AppKeys.inter,
          fontSize: textSize ?? fontSize11,
        ),
      ),
    );
  }
}
