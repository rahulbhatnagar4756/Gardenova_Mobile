import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class LandscapeStyleBottomSheet extends StatelessWidget {
  const LandscapeStyleBottomSheet({super.key});

  static Future<String?> show() async {
    return await Get.bottomSheet<String>(
      isScrollControlled: true,
      const LandscapeStyleBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final styles = [
      "modern",
      "luxury",
      "luxury_modern",
      "tropical",
      "modern_tropical",
      "japanese",
      "minimalist",
      "mediterranean",
      "cottage",
      "contemporary",
      "eco_friendly",
      "desert",
    ];

    return Container(
      constraints: BoxConstraints(maxHeight: Get.height * 0.75),
      padding: EdgeInsets.fromLTRB(spacerSize20, spacerSize20, spacerSize20, spacerSize30),
      decoration: const BoxDecoration(
        color: AppColors.appColor,
        border: Border(
          top: BorderSide(color: AppColors.greenColor, width: spacerSize2),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(spacerSize28),
          topRight: Radius.circular(spacerSize28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const BaseText(
                      text: "Select Design Style",
                      fontFamily: AppKeys.poppins,
                      fontWeight: FontWeight.bold,
                      textColor: AppColors.greenColor,
                      fontSize: fontSize18,
                    ),
                    SizedBox(height: spacerSize4),
                    BaseText(
                      text: "Choose a theme to apply to your scan",
                      fontFamily: AppKeys.inter,
                      textColor: AppColors.liteGreyColor,
                      fontSize: fontSize12,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, color: AppColors.blackColor),
              ),
            ],
          ),
          SizedBox(height: spacerSize20),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.3,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.w,
              ),
              itemCount: styles.length,
              itemBuilder: (context, index) {
                final style = styles[index];
                final displayName = style.replaceAll('_', ' ').toUpperCase();

                return GestureDetector(
                  onTap: () {
                    Get.back(result: style);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.toToLiteGreenColor.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(spacerSize12),
                      border: Border.all(
                        color: AppColors.greenColor.withOpacity(0.3),
                      ),
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: spacerSize8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconForStyle(style),
                          color: AppColors.greenColor,
                          size: 20.sp,
                        ),
                        SizedBox(height: spacerSize4),
                        BaseText(
                          text: displayName,
                          fontFamily: AppKeys.inter,
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.blackColor,
                          fontSize: fontSize11,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForStyle(String style) {
    switch (style) {
      case "modern":
        return Icons.chair_alt_rounded;
      case "luxury":
        return Icons.diamond_rounded;
      case "luxury_modern":
        return Icons.star_border_purple500_rounded;
      case "tropical":
        return Icons.eco_rounded;
      case "modern_tropical":
        return Icons.nature_people_rounded;
      case "japanese":
        return Icons.spa_rounded;
      case "minimalist":
        return Icons.space_dashboard_rounded;
      case "mediterranean":
        return Icons.waves_rounded;
      case "cottage":
        return Icons.home_work_rounded;
      case "contemporary":
        return Icons.architecture_rounded;
      case "eco_friendly":
        return Icons.recycling_rounded;
      case "desert":
        return Icons.wb_sunny_rounded;
      default:
        return Icons.auto_awesome;
    }
  }
}
