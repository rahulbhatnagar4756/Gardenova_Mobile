import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class BaseOutlineButton extends StatelessWidget {
  const BaseOutlineButton({
    super.key,
    this.buttonLabel,
    this.fontSize,
    this.onPressed,
    this.buttonWidth = spacerSize215,
    this.buttonHeight,
    this.borderColor = Colors.green,
    this.textColor = Colors.green,
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
  final Color? borderColor;
  final Color? textColor;
  final EdgeInsets? buttonPadding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: buttonWidth,
        height: buttonHeight ?? 48.h,
        padding: buttonPadding,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent, // or Colors.white
          borderRadius: BorderRadius.circular(spacerSize10),
          border: Border.all(
            color: borderColor ?? Colors.green,
            width: 1.5,
          ),
        ),
        child: BaseText(
          text: buttonLabel ?? '',
          fontFamily: AppKeys.inter,
          overflow: TextOverflow.ellipsis,
          textColor: textColor ?? Colors.green,
          fontSize: fontSize ?? 16.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}