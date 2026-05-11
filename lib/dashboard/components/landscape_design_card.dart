import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class LandscapeDesignCard extends StatelessWidget {
  final VoidCallback? onTap;

  const LandscapeDesignCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: BaseBorderedContainer(
        height: spacerSize125,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: spacerSize15,
          vertical: spacerSize15,
        ),
        childWidget: Row(
          children: [
            /// 🔹 Icon Container
            BaseBorderedContainer(
              height: spacerSize60,
              width: spacerSize60,
              borderRadius: spacerSize100,
              backgroundColor: AppColors.whiteColor,
              borderColor: Colors.transparent,
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              childWidget: Icon(
                Icons.auto_awesome_mosaic_outlined,
                size: 50.w,
                color: AppColors.greenColor,
              ),
            ),

            const SizedBox(width: spacerSize15),

            /// 🔹 Text Section
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    text: "AI Landscape Design",
                    fontWeight: FontWeight.w600,
                    fontSize: fontSize16,
                  ),
                  SizedBox(height: spacerSize5),
                  BaseText(
                    text: "Transform your empty space into a beautiful garden vision.",
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),

            /// 🔹 Arrow Icon
             Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.liteGreyColor,
            )
          ],
        ),
      ),
    );
  }
}
