import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

import '../../base/widgets/base_text.dart';
import '../model/bottom_navigation_local_model.dart';

enum BottomNavType { home, plant, scan, reminders, /*report*/ profile }

List<BottomNavigationLocalModel> bottomNavigationList() {
  return [
    BottomNavigationLocalModel(
      type: BottomNavType.home,
      label: AppStrings.home,
      icon: AppAssets.homeIc,
    ),
    BottomNavigationLocalModel(
      type: BottomNavType.plant,
      label: AppStrings.myPlants,
      icon: AppAssets.plantIc,
    ),
    BottomNavigationLocalModel(
      type: BottomNavType.scan,
      label: AppStrings.scan,
      icon: AppAssets.scanIc,
      isCenterIcon: true,
    ),

    /*  BottomNavigationLocalModel(
      type: BottomNavType.report,
      label: AppStrings.reports,
      icon: AppAssets.reportIc,
    ),*/
    BottomNavigationLocalModel(
      type: BottomNavType.reminders,
      label: AppStrings.reminders,
      icon: AppAssets.reminderIc,
    ),
    BottomNavigationLocalModel(
      type: BottomNavType.profile,
      label: AppStrings.profile,
      icon: AppAssets.profileIc,
    ),
  ];
}

class BottomNavigationWidget extends StatelessWidget {
  final bool needToShow;
  final BottomNavType? selectNavType;
  final Function(BottomNavType)? onAddPlantClick;
  const BottomNavigationWidget({
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
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.zero,
        padding: EdgeInsets.symmetric(vertical: 8.h),

        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: Colors.black.withValues(alpha: 0.1), width: 1.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: SafeArea(
          bottom: true,
          child: Row(
            children: bottomNavigationList().asMap().entries.map((entry) {
              BottomNavigationLocalModel item = entry.value;

              Color? selectedColor = item.type == selectNavType
                  ? AppColors.greenColor
                  : AppColors.grey;
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
                                    color: AppColors.blackColor.withValues(alpha: 0.15),
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
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
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

                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 250),

                                  style: TextStyle(
                                    fontSize: item.type == selectNavType ? 11.sp : 10.sp,

                                    fontWeight: item.type == selectNavType
                                        ? FontWeight.w600
                                        : FontWeight.w400,

                                    color: selectedColor ?? AppColors.liteGreyColor,
                                  ),

                                  child: BaseText(text: item.label, textColor: selectedColor),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
    // return Container(
    //   width: double.infinity,
    //   height: 69.h,
    //   // margin: EdgeInsets.only(bottom: 16.w, left: 16.w, right: 16.w),
    //   margin: EdgeInsets.only(bottom: 0, left: 0, right: 0),
    //   decoration: BoxDecoration(
    //     color: AppColors.whiteColor,
    //     borderRadius: BorderRadius.circular(18.r),
    //     border: Border.all(
    //       color: Colors.black.withValues(alpha: 0.1),
    //       width: 1.w,
    //     ),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withValues(alpha: 0.1),
    //         blurRadius: 10,
    //         spreadRadius: 1,
    //         offset: const Offset(0, 2),
    //       ),
    //     ],
    //   ),
    //   child: SafeArea(
    //     bottom: true,
    //     child: Row(
    //       children: bottomNavigationList().asMap().entries.map((entry) {
    //         BottomNavigationLocalModel item = entry.value;
    //         Color? selectedColor = item.type == selectNavType
    //             ? AppColors.greenColor
    //             : null;

    //         return Expanded(
    //           child: GestureDetector(
    //             behavior: HitTestBehavior.opaque,
    //             onTap: () {
    //               onAddPlantClick?.call(item.type);
    //             },

    //             child: Center(
    //               child: item.isCenterIcon
    //                   ? AnimatedScale(
    //                       duration: const Duration(milliseconds: 250),

    //                       scale: item.type == selectNavType ? 1.08 : 1,

    //                       child: Container(
    //                         height: 58.w,
    //                         width: 58.w,

    //                         decoration: BoxDecoration(
    //                           shape: BoxShape.circle,

    //                           boxShadow: [
    //                             BoxShadow(
    //                               color: AppColors.blackColor.withValues(
    //                                 alpha: 0.15,
    //                               ),
    //                               blurRadius: 14,
    //                               spreadRadius: 2,
    //                               offset: const Offset(0, 6),
    //                             ),
    //                           ],
    //                         ),

    //                         child: Image.asset(item.icon, fit: BoxFit.cover),
    //                       ),
    //                     )
    //                   : AnimatedContainer(
    //                       duration: const Duration(milliseconds: 250),
    //                       curve: Curves.easeInOut,

    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         mainAxisSize: MainAxisSize.min,

    //                         children: [
    //                           /// ICON ANIMATION
    //                           AnimatedScale(
    //                             duration: const Duration(milliseconds: 250),
    //                             scale: item.type == selectNavType ? 1.12 : 1,

    //                             child: Image.asset(
    //                               item.icon,
    //                               height: 24.w,
    //                               width: 24.w,
    //                               color: selectedColor,
    //                             ),
    //                           ),

    //                           SizedBox(height: 4.h),

    //                           /// TEXT ANIMATION
    //                           AnimatedDefaultTextStyle(
    //                             duration: const Duration(milliseconds: 250),

    //                             style: TextStyle(
    //                               fontSize: item.type == selectNavType
    //                                   ? 11.sp
    //                                   : 10.sp,

    //                               fontWeight: item.type == selectNavType
    //                                   ? FontWeight.w600
    //                                   : FontWeight.w400,

    //                               color:
    //                                   selectedColor ?? AppColors.liteGreyColor,
    //                             ),

    //                             child: BaseText(
    //                               text: item.label,
    //                               textColor: selectedColor,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //             ),
    //           ),
    //         );
    //       }).toList(),
    //     ),
    //   ),

    // );
  }
}
