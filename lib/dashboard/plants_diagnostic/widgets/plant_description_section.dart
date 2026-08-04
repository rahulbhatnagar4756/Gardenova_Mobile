/// =========================================================
/// FILE: widgets/plant_description_section.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class PlantDescriptionSection extends StatelessWidget {
  final String description;

  const PlantDescriptionSection({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    if (description.trim().isEmpty) {
      return const SizedBox();
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: .15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: AppStrings.plantDescription,
            fontFamily: AppKeys.poppins,
            fontWeight: FontWeight.w700,
            fontSize: fontSize18,
            textColor: AppColors.greenColor,
          ),

          SizedBox(height: 12.h),

          BaseText(
            text: description,
            fontSize: fontSize14,
            textColor: AppColors.liteGreyColor,
          ),
        ],
      ),
    );
  }
}
