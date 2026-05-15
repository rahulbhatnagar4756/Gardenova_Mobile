import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/components/common_component_dashboardview.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../utils/constants/app_assets.dart';

class AiPlantDiagnosisCard extends StatelessWidget {
  final VoidCallback? onTap;

  const AiPlantDiagnosisCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: CommonComponentDashboardView(
        title: AppLocalizations.of(context)!.plantAnalysis,
        description: AppLocalizations.of(
          context,
        )!.scanYourPlantForHealthAndDetails,
        image: AppAssets.aiAnalysisIc,
      ),
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        // height: spacerSize125,
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 16.w,
          top: 15.h,
          bottom: 15.h,
          right: 4.w,
        ),
        child: Row(
          children: [
            Image.asset(
              AppAssets.aiAnalysisIc,
              width: 40.w,
              height: 40.w,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
            SizedBox(width: spacerSize15),

            /// 🔹 Text Section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    text: AppLocalizations.of(context)!.plantAnalysis,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),
                  SizedBox(height: 3.h),
                  BaseText(
                    text: AppLocalizations.of(
                      context,
                    )!.scanYourPlantForHealthAndDetails,
                    fontSize: (10.5).sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),
            SizedBox(width: spacerSize15),

            /// 🔹 Arrow Icon (optional UX improvement)
            // Icon(
            //   Icons.arrow_forward_ios,
            //   size: 16,
            //   color: AppColors.liteGreyColor,
            // ),
            Image.asset(
              AppAssets.rightArrowIc,
              width: 55.w,
              height: 55.w,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ],
        ),
      ),
    );
  }
}
