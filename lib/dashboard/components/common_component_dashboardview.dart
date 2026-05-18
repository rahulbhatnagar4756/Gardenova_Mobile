import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

import '../../base/widgets/base_text.dart';
import '../../utils/constants/app_constants.dart';

class CommonComponentDashboardView extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  const CommonComponentDashboardView({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,

      shadowColor: Colors.black.withValues(alpha: 0.5),

      color: AppColors.whiteColor,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.r),

        side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
      ),

      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          top: 15.h,
          bottom: 15.h,
          right: 4.w,
        ),

        child: Row(
          children: [
            /// LEFT IMAGE
            Image.asset(
              image,
              width: 40.w,
              height: 40.w,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),

            SizedBox(width: spacerSize15),

            /// TEXT SECTION
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  BaseText(
                    text: title,
                    fontWeight: FontWeight.w600,
                    fontSize: 15.sp,
                  ),

                  SizedBox(height: 3.h),

                  BaseText(
                    text: description,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ),

            SizedBox(width: spacerSize15),

            /// RIGHT ARROW
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

    // return Container(
    //   decoration: BoxDecoration(
    //     color: AppColors.whiteColor,
    //     borderRadius: BorderRadius.circular(13.r),
    //     border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withValues(alpha: 0.06),
    //         blurRadius: 18,
    //         spreadRadius: 1,
    //         offset: const Offset(0, 5),
    //       ),
    //     ],
    //   ),
    //   // height: spacerSize125,
    //   width: double.infinity,
    //   padding: EdgeInsets.only(left: 16.w, top: 15.h, bottom: 15.h, right: 4.w),
    //   child: Row(
    //     children: [
    //       Image.asset(
    //         image,
    //         width: 40.w,
    //         height: 40.w,
    //         fit: BoxFit.cover,
    //         filterQuality: FilterQuality.high,
    //       ),
    //       SizedBox(width: spacerSize15),

    //       /// 🔹 Text Section
    //       Expanded(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             BaseText(
    //               text: title,
    //               fontWeight: FontWeight.w600,
    //               fontSize: 15.sp,
    //             ),
    //             SizedBox(height: 3.h),
    //             BaseText(
    //               text: description,
    //               fontSize: (10.5).sp,
    //               fontWeight: FontWeight.w400,
    //             ),
    //           ],
    //         ),
    //       ),
    //       SizedBox(width: spacerSize15),

    //       /// 🔹 Arrow Icon (optional UX improvement)
    //       // Icon(
    //       //   Icons.arrow_forward_ios,
    //       //   size: 16,
    //       //   color: AppColors.liteGreyColor,
    //       // ),
    //       Image.asset(
    //         AppAssets.rightArrowIc,
    //         width: 55.w,
    //         height: 55.w,
    //         fit: BoxFit.cover,
    //         filterQuality: FilterQuality.high,
    //       ),
    //     ],
    //   ),
    // );
  }
}
