import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class BaseTextButton extends StatelessWidget {
  const BaseTextButton({
    super.key,
    this.onPressed,
    this.textLabel,
    this.fontSize = fontSize16,
    this.textColor,
    this.backgroundColor,
  });

  final VoidCallback? onPressed;
  final String? textLabel;
  final double? fontSize;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: backgroundColor,
        textStyle: TextStyle(fontSize: fontSize),
      ),
      child: Text(textLabel ?? "", style: TextStyle(color: textColor)),
    );
  }
}
