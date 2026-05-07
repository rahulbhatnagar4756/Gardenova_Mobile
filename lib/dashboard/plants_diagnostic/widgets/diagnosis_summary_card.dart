/// =========================================================
/// FILE: widgets/diagnosis_summary_card.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class DiagnosisSummaryCard extends StatelessWidget {
  final String plantName;
  final bool isHealthy;
  final String issueName;
  final num confidence;

  const DiagnosisSummaryCard({
    super.key,
    required this.plantName,
    required this.isHealthy,
    required this.issueName,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isHealthy
            ? AppColors.greenColor.withValues(alpha: .08)
            : Colors.orange.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isHealthy
              ? AppColors.greenColor.withValues(alpha: .25)
              : Colors.orange.withValues(alpha: .25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isHealthy
                    ? Icons.check_circle_rounded
                    : Icons.warning_amber_rounded,
                color: isHealthy ? AppColors.greenColor : Colors.orange,
                size: 26.sp,
              ),

              SizedBox(width: 10.w),

              Expanded(
                child: BaseText(
                  text: isHealthy
                      ? "Plant Looks Healthy"
                      : "Plant Needs Attention",
                  fontFamily: AppKeys.poppins,
                  fontWeight: FontWeight.w700,
                  fontSize: fontSize18,
                ),
              ),
            ],
          ),

          SizedBox(height: 18.h),

          _item("Plant", plantName),

          SizedBox(height: 10.h),

          _item("Main Issue", isHealthy ? "No Disease Detected" : issueName),

          // SizedBox(height: 10.h),

          // _item("AI Confidence", "${confidence.toStringAsFixed(0)}%"),
        ],
      ),
    );
  }

  Widget _item(String title, String value) {
    return Row(
      children: [
        SizedBox(
          width: 100.w,
          child: BaseText(
            text: title,
            fontWeight: FontWeight.w600,
            fontSize: fontSize14,
          ),
        ),

        Expanded(
          child: BaseText(
            text: value,
            textColor: AppColors.liteGreyColor,
            fontSize: fontSize14,
          ),
        ),
      ],
    );
  }
}
