import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/routes.dart';
import '../../../../base/widgets/base_shimmer.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../my_plants_controller.dart';

// class MyPlantsList extends StatelessWidget {
//   final MyPlantsController controller;
//
//   const MyPlantsList({super.key, required this.controller});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => ListView.separated(
//         itemCount: controller.myPlantList.length,
//         itemBuilder: (context, index) {
//           var item = controller.myPlantList[index];
//           return GestureDetector(
//             onTap: () {
//               Get.toNamed(Routes.myPlantsDetails, arguments: item.plantId);
//             },
//             child: Container(
//               padding: EdgeInsets.all(spacerSize10),
//               decoration: BoxDecoration(
//                 color: AppColors.darkGreen,
//                 borderRadius: BorderRadius.circular(spacerSize15),
//                 border: Border.all(color: AppColors.offWhite10),
//               ),
//
//               child: Row(
//                 spacing: spacerSize14,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(spacerSize14),
//                     child: CachedNetworkImage(
//                       height: spacerSize90,
//                       width: spacerSize90,
//                       fit: BoxFit.cover,
//                       imageUrl: item.imageUrl ?? "",
//                       placeholder: (context, url) => BaseShimmer(),
//                       errorWidget: (context, url, error) =>
//                           Icon(Icons.broken_image, color: AppColors.offWhite10),
//                     ),
//                   ),
//
//                   Expanded(
//                     child: Column(
//                       spacing: spacerSize2,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         BaseText(
//                           text: item.commonName ?? "",
//                           fontFamily: AppKeys.poppins,
//                           fontSize: fontSize14,
//                           fontWeight: FontWeight.w700,
//                           textColor: AppColors.offWhite,
//                         ),
//
//                         BaseText(
//                           text: item.scientificName ?? "",
//
//                           fontFamily: AppKeys.inter,
//                           fontSize: fontSize12,
//                           fontWeight: FontWeight.w400,
//                           textColor: AppColors.offWhite70,
//                         ),
//
//                         Row(
//                           spacing: spacerSize4,
//                           children: [
//                             statusChip(
//                               icon: Icons.info,
//                               text:
//                                   "85%\t${AppLocalizations.of(context)!.health}",
//                             ),
//                             statusChip(
//                               icon: Icons.water_drop_outlined,
//                               text:
//                                   "${AppLocalizations.of(context)!.inText}\t${item.wateringReminderFrequency}\t${AppLocalizations.of(context)!.day}s",
//                             ),
//                           ],
//                         ).marginOnly(top: spacerSize25),
//                       ],
//                     ),
//                   ),
//
//                   Icon(
//                     Icons.chevron_right,
//                     size: spacerSize25,
//                     color: AppColors.mossGold,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox(height: spacerSize12);
//         },
//       ),
//     );
//   }
//
//   Widget statusChip({required IconData icon, required String text}) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: spacerSize8, vertical: spacerSize4),
//       decoration: BoxDecoration(
//         color: AppColors.harvestGold,
//         borderRadius: BorderRadius.circular(spacerSize20),
//       ),
//       child: Row(
//         spacing: spacerSize4,
//         children: [
//           Icon(icon, size: spacerSize14, color: AppColors.offWhite),
//           BaseText(
//             text: text,
//             fontSize: fontSize11,
//             fontFamily: AppKeys.inter,
//             fontWeight: FontWeight.w500,
//             textColor: AppColors.offWhite,
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/routes.dart';
import '../../../../base/widgets/base_shimmer.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../my_plants_controller.dart';

class MyPlantsList extends StatelessWidget {
  final MyPlantsController controller;

  const MyPlantsList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GridView.builder(
        padding: EdgeInsets.zero,
        // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //   crossAxisCount: 2,
        //   crossAxisSpacing: .95,
        //   mainAxisSpacing: spacerSize12,
        //   childAspectRatio: 0.68, // Adjust as needed to fit the card properly on the screen
        // ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .82,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.w,
        ),
        itemCount: controller.myPlantList.length,
        itemBuilder: (context, index) {
          var item = controller.myPlantList[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routes.myPlantsDetails, arguments: item.plantId);
            },
            child: Container(
              decoration: BoxDecoration(
                // Use light background as seen in the image
                color: AppColors.greenColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(spacerSize16),
                border: Border.all(
                  width: 1,
                  color: AppColors.greenColor.withValues(alpha: 0.2),
                ), // Adjust border color as needed
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image at the top of the grid card
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(spacerSize15),
                    ),
                    child: CachedNetworkImage(
                      height: 110,
                      // Fixed height for image area
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: item.imageUrl ?? "",
                      placeholder: (context, url) => const BaseShimmer(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image, color: AppColors.offWhite10),
                    ),
                  ),

                  // Text & Status section at the bottom of the card
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(spacerSize8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Plant Names & Action Icon
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: BaseText(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      text: item.commonName ?? AppLocalizations.of(
                                        context,
                                      )!.noDataNa,
                                      fontFamily: AppKeys.poppins,
                                      fontSize: fontSize13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    size: spacerSize20,
                                    color: AppColors.darkGreen,
                                  ),
                                ],
                              ),
                              SizedBox(height: spacerSize2),
                              BaseText(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                text: item.scientificName ?? "",
                                fontFamily: AppKeys.inter,
                                fontSize: fontSize11,
                                fontWeight: FontWeight.w400,
                                textColor: AppColors.liteGreyColor,
                              ),
                            ],
                          ),

                          // Status Chips Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: statusChip(
                                  icon: Icons.info,
                                  text:
                                      "85%\t${AppLocalizations.of(context)!.health}",
                                  // Use a green/success color for health
                                  chipColor: AppColors
                                      .greenColor, // Or update to AppColors.success
                                ),
                              ),
                              Flexible(
                                child: statusChip(
                                  icon: Icons.water_drop_outlined,
                                  text:
                                      "${AppLocalizations.of(context)!.inText}\t${item.wateringReminderFrequency}\t${AppLocalizations.of(context)!.day}s",
                                  // Use the harvestGold or an alert color for watering
                                  chipColor: AppColors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Modified status chip method supporting custom chip color configuration
  Widget statusChip({
    required IconData icon,
    required String text,
    required Color chipColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacerSize6,
        vertical: spacerSize4,
      ),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(spacerSize20),
      ),
      child: Row(
        spacing: spacerSize4,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: spacerSize12, color: AppColors.offWhite),
          Flexible(
            child: BaseText(
              text: text,
              fontSize: fontSize9,
              fontFamily: AppKeys.inter,
              fontWeight: FontWeight.w500,
              textColor: AppColors.offWhite,
            ),
          ),
        ],
      ),
    );
  }
}
