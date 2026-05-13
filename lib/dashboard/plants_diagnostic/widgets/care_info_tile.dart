/// =========================================================
/// FILE: plants_diagnostic/widgets/care_info_tile.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../../base/widgets/expandable_text.dart';

class CareInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const CareInfoTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.toToLiteGreenColor,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.white,
            child: Icon(icon, color: AppColors.greenColor),
          ),

          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  text: title,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppKeys.poppins,
                ),

                SizedBox(height: 4.h),

                // BaseText(
                //   text: value,
                //   textColor: AppColors.liteGreyColor,
                // ),
                ExpandableText(
                  text: value,
                  trimLines: 3,
                  textColor: AppColors.liteGreyColor,
                  lineHeight: 1.5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
