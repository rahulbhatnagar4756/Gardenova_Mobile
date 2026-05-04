import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class SettingsItemLayout extends StatelessWidget {
  const SettingsItemLayout({super.key, this.icon, this.title, this.onTap});

  final IconData? icon;
  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greenColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(spacerSize16),
          border: Border.all(
            color: AppColors.greenColor.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            SizedBox(width: 13.w,),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.all(spacerSize10),
                  decoration: BoxDecoration(
                    color: AppColors.greenColor,
                    borderRadius: BorderRadius.circular(spacerSize10),
                  ),
                  child: Icon(icon, color: AppColors.whiteColor),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: BaseText(
                text: title ?? "",
                fontWeight: FontWeight.w500,
                fontSize: fontSize14,
              ),
            ),
         Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: AppColors.blackColor,
                  size: fontSize18,
                ),
              ),
            SizedBox(width: 13.w,)
          ],
        ).marginSymmetric(vertical: spacerSize10),
      ),
    );
  }
}
