import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class BaseBorderedContainer extends StatelessWidget {
  const BaseBorderedContainer({
    super.key,
    this.height = spacerSize0,
    this.width = double.infinity,
    this.backgroundColor,
    this.borderColor ,
    this.childWidget,
    this.borderRadius = spacerSize20,
    this.alignment = Alignment.topLeft,
    this.padding,
  });

  final double height;
  final Color? backgroundColor;
  final Color? borderColor;
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
        color: backgroundColor??AppColors.greenColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor??AppColors.greenColor.withValues(alpha: 0.2), width: 1),
      ),
      child: childWidget,
    );
  }
}
// color: AppColors.greenColor.withValues(alpha: 0.1),
// borderRadius: BorderRadius.circular(spacerSize16),
// border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.2)),