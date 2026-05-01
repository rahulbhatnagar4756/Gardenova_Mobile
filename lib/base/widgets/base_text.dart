import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class BaseText extends StatelessWidget {
  const BaseText({
    super.key,
    this.fontSize,
    this.textColor = Colors.black,
    this.text = '',
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.fontFamily = AppKeys.inter,
    this.overflow = TextOverflow.visible,
    this.maxLines,
  });

  final double? fontSize;
  final Color? textColor;
  final String text;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final String? fontFamily;
  final TextOverflow? overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      softWrap: true,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: fontFamily,
        color: textColor,
        fontWeight: fontWeight,
        overflow: overflow,
        wordSpacing: 1.2,
      ),
    );
  }
}
