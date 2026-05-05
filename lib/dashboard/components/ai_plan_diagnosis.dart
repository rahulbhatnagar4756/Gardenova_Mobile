import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class AiPlantDiagnosisCard extends StatelessWidget {
  final VoidCallback? onTap;

  const AiPlantDiagnosisCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BaseBorderedContainer(
        height: spacerSize125,
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: spacerSize15,
          vertical: spacerSize15,
        ),
        childWidget: Row(
          children: [
            /// 🔹 Icon Container (same pattern as your suggestionItem)
            BaseBorderedContainer(
              height: spacerSize60,
              width: spacerSize60,
              borderRadius: spacerSize100,
              backgroundColor: AppColors.whiteColor,
              borderColor: Colors.transparent,
              alignment: Alignment.center,
              padding: EdgeInsets.all(spacerSize0),
              childWidget:
              Icon(Icons.camera_alt_outlined,size: 50.w,color: AppColors.greenColor,)
              // Image.asset(
              //
              //
              //   AppAssets.camera, // 👈 add camera/scan icon
              //   color: AppColors.greenColor,
              //   scale: 2,
              // ),
            ),

            SizedBox(width: spacerSize15),

            /// 🔹 Text Section
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    text: AppLocalizations.of(context)!.ai,
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize16,
                  ),
                  SizedBox(height: spacerSize5),
                  BaseText(
                    text: AppLocalizations.of(context)!
                        .scanYourPlantForHealthAndDetails,
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),

            /// 🔹 Arrow Icon (optional UX improvement)
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.greyColor,
            )
          ],
        ),
      ),
    );
  }
}