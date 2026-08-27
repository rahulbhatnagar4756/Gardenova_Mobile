import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../generated/assets.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    super.key,
    this.buttonLabel,
    this.fontSize ,
    this.bottomPadding ,
    this.tickPrefixIcon ,
    this.onPressed,
    this.buttonWidth = spacerSize215,
    this.buttonHeight ,
    this.backgroundColor = Colors.black,
    this.linearBackgroundColor ,
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
  final LinearGradient? linearBackgroundColor;
  final Color? textColor;
  final EdgeInsets? buttonPadding;
  final bool? bottomPadding;
  final bool? tickPrefixIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        onPressed?.call();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: bottomPadding==true?25.h:0),
        width: buttonWidth,
        height: buttonHeight??48.h,
        padding: buttonPadding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(spacerSize10),
          gradient:linearBackgroundColor?? AppColors.linearGradientForBtn,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tickPrefixIcon==true?
                Image.asset(Assets.tickIc,width: 14.w,height: 14.w,).paddingOnly(right: 5.w)
                :const SizedBox(),
            BaseText(
              text: buttonLabel??'',
              fontFamily: AppKeys.inter,
              overflow: TextOverflow.ellipsis,
              textColor: Colors.white,
              fontSize: fontSize ?? 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
