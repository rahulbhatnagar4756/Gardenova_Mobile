import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class BaseBorderedContainer extends StatelessWidget {
  const BaseBorderedContainer({
    super.key,
    this.height = spacerSize0,
    this.width = double.infinity,
    this.backgroundColor = AppColors.darkGreen,
    this.borderColor = AppColors.offWhite10,
    this.childWidget,
    this.borderRadius = spacerSize15,
    this.alignment = Alignment.topLeft,
    this.padding,
  });

  final double height;
  final Color backgroundColor;
  final Color borderColor;
  final Widget? childWidget;
  final double borderRadius;
  final EdgeInsets? padding;
  final Alignment? alignment;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      alignment: alignment ?? Alignment.topLeft,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: childWidget,
    );
  }
}
