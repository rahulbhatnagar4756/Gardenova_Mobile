/// =========================================================
/// FILE: base/widgets/expandable_text.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_keys.dart';
import 'base_text.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;

  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? lineHeight;

  final String? expandText;
  final String? collapseText;

  const ExpandableText({
    super.key,
    required this.text,
    this.trimLines = 4,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.lineHeight,
    this.expandText,
    this.collapseText,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final bool showButton = widget.text.trim().length > 180;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: widget.text,
            textColor: widget.textColor ?? AppColors.liteGreyColor,
            fontSize: widget.fontSize ?? fontSize14,
            fontWeight: widget.fontWeight ?? FontWeight.w400,
            fontFamily: widget.fontFamily ?? AppKeys.inter,
            // lineHeight: widget.lineHeight ?? 1.5,
            maxLines: isExpanded ? null : widget.trimLines,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),

          if (showButton) ...[
            SizedBox(height: 8.h),

            InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 2.w),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BaseText(
                      text: isExpanded
                          ? (widget.collapseText ?? "Show Less")
                          : (widget.expandText ?? "Show More"),
                      textColor: AppColors.greenColor,
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize13,
                      fontFamily: AppKeys.inter,
                    ),

                    SizedBox(width: 4.w),

                    AnimatedRotation(
                      duration: const Duration(milliseconds: 300),
                      turns: isExpanded ? 0.5 : 0,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.greenColor,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
