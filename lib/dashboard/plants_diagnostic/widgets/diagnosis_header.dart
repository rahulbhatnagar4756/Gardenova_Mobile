/// =========================================================
/// FILE: plants_diagnostic/widgets/diagnosis_header.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_response_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../../base/widgets/expandable_text.dart';

class DiagnosisHeader extends StatelessWidget {
  final PlantInfo plant;

  const DiagnosisHeader({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText(
          text: plant.commonNames?.join(", ").toTitleCase() ?? "",
          fontSize: fontSize24,
          fontWeight: FontWeight.bold,
          fontFamily: AppKeys.poppins,
        ),

        SizedBox(height: 6.h),

        BaseText(
          text: plant.scientificName ?? "",
          textColor: AppColors.greenColor,
        ),

        SizedBox(height: 16.h),

        // BaseText(
        //   text: plant.description ?? "",
        //   textColor: AppColors.liteGreyColor,
        // ),
        ExpandableText(
          text: plant.description ?? "",
          trimLines: 4,
          textColor: AppColors.liteGreyColor,
          lineHeight: 1.5,
        ),
      ],
    );
  }
}
