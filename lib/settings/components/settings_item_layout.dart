import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class SettingsItemLayout extends StatelessWidget {
  const SettingsItemLayout({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.onTap,
    this.iconColor,
    this.iconBgColor,
    this.titleColor,
    this.trailingIconColor,
  });

  final IconData? icon;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? iconBgColor;
  final Color? titleColor;
  final Color? trailingIconColor;

  @override
  Widget build(BuildContext context) {
    final effectiveIconBgColor =
        iconBgColor ?? AppColors.greenColor.withValues(alpha: 0.1);
    final effectiveIconColor = iconColor ?? AppColors.greenColor;
    final effectiveTitleColor = titleColor ?? AppColors.blackColor;
    final effectiveTrailingColor = trailingIconColor ?? Colors.black87;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(spacerSize16),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              // Icon Container on the Left
              if (icon != null) ...[
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: effectiveIconBgColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Icon(icon, color: effectiveIconColor, size: 20.w),
                  ),
                ),
                SizedBox(width: 14.w),
              ],

              // Title and Subtitle Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BaseText(
                      text: title ?? "",
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize14.sp,
                      textColor: effectiveTitleColor,
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      BaseText(
                        text: subtitle!,
                        fontWeight: FontWeight.w400,
                        fontSize: 11.sp,
                        textColor: AppColors.liteGreyColor,
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),

              // Trailing Arrow
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios_outlined,
                color: effectiveTrailingColor,
                size: 13.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
