import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    this.buttonLabel,
    this.fontSize ,
    this.onPressed,
    this.buttonWidth = spacerSize215,
    this.buttonHeight ,
    this.backgroundColor = Colors.black,
    this.textColor = Colors.white,
    this.buttonPadding = const EdgeInsets.symmetric(
      vertical: spacerSize12,
      horizontal: spacerSize10,
    ),
  });

  final String? buttonLabel;
  final VoidCallback? onPressed;
  final double? fontSize;
  final double? buttonWidth;
  final double? buttonHeight;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsets? buttonPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight??48.h,
        padding: buttonPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(spacerSize10),
          gradient: AppColors.linearGradientForBtn,
        ),
        alignment: Alignment.center,
        child: BaseText(
          text: buttonLabel??'',
          fontFamily: AppKeys.inter,
          overflow: TextOverflow.ellipsis,
          textColor: Colors.white,
          fontSize: fontSize ?? 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
