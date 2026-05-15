import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

import '../../base/widgets/base_text.dart';
import '../../utils/constants/app_constants.dart';
import '../model/bottom_navigation_local_model.dart';

enum BottomNavType { home, plant, scan, report, profile }

List<BottomNavigationLocalModel> bottomNavigationList() {
  return [
    BottomNavigationLocalModel(
      type: BottomNavType.home,
      label: AppStrings.home,
      icon: AppAssets.homeIc,
    ),
    BottomNavigationLocalModel(
      type: BottomNavType.plant,
      label: AppStrings.plants,
      icon: AppAssets.plantIc,
    ),
    BottomNavigationLocalModel(
      type: BottomNavType.scan,
      label: AppStrings.scan,
      icon: AppAssets.scanIc,
      isCenterIcon: true,
    ),
    BottomNavigationLocalModel(
      type: BottomNavType.report,
      label: AppStrings.reports,
      icon: AppAssets.reportIc,
    ),
    BottomNavigationLocalModel(
      type: BottomNavType.profile,
      label: AppStrings.profile,
      icon: AppAssets.profileIc,
    ),
  ];
}

class BottomNavigationWidget extends StatelessWidget {
  bool needToShow;
  BottomNavType? selectNavType;
  Function(BottomNavType)? onAddPlantClick;
  BottomNavigationWidget({
    super.key,
    required this.needToShow,
    required this.selectNavType,
    required this.onAddPlantClick,
  });

  @override
  Widget build(BuildContext context) {
    if (!needToShow) {
      return SizedBox();
    }
    return SafeArea(
      bottom: true,
      child: Container(
        width: double.infinity,
        height: 69.h,
        margin: EdgeInsets.only(bottom: 16.w, left: 16.w, right: 16.w),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: Colors.black.withValues(alpha: 0.1),
            width: 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: bottomNavigationList().asMap().entries.map((entry) {
            BottomNavigationLocalModel item = entry.value;
            Color? selectedColor = item.type == selectNavType
                ? AppColors.greenColor
                : null;

            return Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  onAddPlantClick?.call(item.type);
                },

                child: Center(
                  child: item.isCenterIcon
                      ? AnimatedScale(
                          duration: const Duration(milliseconds: 250),

                          scale: item.type == selectNavType ? 1.08 : 1,

                          child: Container(
                            height: 58.w,
                            width: 58.w,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.blackColor.withOpacity(0.15),
                                  blurRadius: 14,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),

                            child: Image.asset(item.icon, fit: BoxFit.cover),
                          ),
                        )
                      : AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              /// ICON ANIMATION
                              AnimatedScale(
                                duration: const Duration(milliseconds: 250),
                                scale: item.type == selectNavType ? 1.12 : 1,

                                child: Image.asset(
                                  item.icon,
                                  height: 24.w,
                                  width: 24.w,
                                  color: selectedColor,
                                ),
                              ),

                              SizedBox(height: 4.h),

                              /// TEXT ANIMATION
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 250),

                                style: TextStyle(
                                  fontSize: item.type == selectNavType
                                      ? 11.sp
                                      : 10.sp,

                                  fontWeight: item.type == selectNavType
                                      ? FontWeight.w600
                                      : FontWeight.w400,

                                  color:
                                      selectedColor ?? AppColors.liteGreyColor,
                                ),

                                child: BaseText(
                                  text: item.label,
                                  textColor: selectedColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
                // child: Center(
                //   child: item.isCenterIcon
                //       ? Container(
                //           height: 58.w,
                //           width: 58.w,

                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,

                //             boxShadow: [
                //               BoxShadow(
                //                 color: AppColors.blackColor.withOpacity(0.15),
                //                 blurRadius: 14,
                //                 spreadRadius: 2,
                //                 offset: const Offset(0, 6),
                //               ),
                //             ],
                //           ),
                //           child: Image.asset(
                //             fit: BoxFit.cover,
                //             item.icon,
                //             height: 60.w,
                //             width: 60.w,
                //           ),
                //         )
                //       : Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.center,
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             Image.asset(
                //               item.icon,
                //               height: 24.w,
                //               width: 24.w,
                //               color: selectedColor,
                //             ),
                //             SizedBox(height: 3.h),
                // BaseText(
                //   text: item.label,
                //   fontSize: 10.sp,
                //   fontWeight: FontWeight.w400,
                //   textColor: selectedColor,
                // ),
                //           ],
                //         ),
                // ),
              ),
            );
          }).toList(),
        ),
        // child: Center(
        //   child: ListView.separated(
        //     padding: EdgeInsets.zero,
        //     scrollDirection: Axis.horizontal,
        //     shrinkWrap: true,
        //     separatorBuilder: (context, index) => SizedBox(width: 10.w),
        //     itemBuilder: (context, index) {
        //       BottomNavigationLocalModel item = bottomNavigationList()[index];
        //       Color selectedColor = item.isSelected
        //           ? AppColors.whiteColor
        //           : AppColors.liteGreyColor;
        //       return item.isCenterIcon
        //           ? Image.asset(item.icon, height: 60.w, width: 60.w)
        //           : Column(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               crossAxisAlignment: CrossAxisAlignment.center,

        //               children: [
        //                 Image.asset(
        //                   item.icon,
        //                   height: 24.w,
        //                   width: 24.w,
        //                   color: selectedColor,
        //                 ),
        //                 SizedBox(height: 4.h),
        //                 BaseText(
        //                   text: bottomNavigationList()[index].label,
        //                   fontSize: 12.sp,
        //                   fontWeight: FontWeight.w400,
        //                   textColor: selectedColor,
        //                 ),
        //               ],
        //             );
        //     },
        //     itemCount: bottomNavigationList().length,
        //   ),
        // ),
      ),
    );
  }
}
