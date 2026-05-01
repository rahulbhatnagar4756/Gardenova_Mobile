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
      () => ListView.separated(
        itemCount: controller.myPlantList.length,
        itemBuilder: (context, index) {
          var item = controller.myPlantList[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routes.myPlantsDetails, arguments: item.plantId);
            },
            child: Container(
              padding: EdgeInsets.all(spacerSize10),
              decoration: BoxDecoration(
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(spacerSize15),
                border: Border.all(color: AppColors.offWhite10),
              ),

              child: Row(
                spacing: spacerSize14,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(spacerSize14),
                    child: CachedNetworkImage(
                      height: spacerSize90,
                      width: spacerSize90,
                      fit: BoxFit.cover,
                      imageUrl: item.imageUrl ?? "",
                      placeholder: (context, url) => BaseShimmer(),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.broken_image, color: AppColors.offWhite10),
                    ),
                  ),

                  Expanded(
                    child: Column(
                      spacing: spacerSize2,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseText(
                          text: item.commonName ?? "",
                          fontFamily: AppKeys.poppins,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w700,
                          textColor: AppColors.offWhite,
                        ),

                        BaseText(
                          text: item.scientificName ?? "",

                          fontFamily: AppKeys.inter,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.offWhite70,
                        ),

                        Row(
                          spacing: spacerSize4,
                          children: [
                            statusChip(
                              icon: Icons.info,
                              text:
                                  "85%\t${AppLocalizations.of(context)!.health}",
                            ),
                            statusChip(
                              icon: Icons.water_drop_outlined,
                              text:
                                  "${AppLocalizations.of(context)!.inText}\t${item.wateringReminderFrequency}\t${AppLocalizations.of(context)!.day}s",
                            ),
                          ],
                        ).marginOnly(top: spacerSize25),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.chevron_right,
                    size: spacerSize25,
                    color: AppColors.mossGold,
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(height: spacerSize12);
        },
      ),
    );
  }

  Widget statusChip({required IconData icon, required String text}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: spacerSize8, vertical: spacerSize4),
      decoration: BoxDecoration(
        color: AppColors.harvestGold,
        borderRadius: BorderRadius.circular(spacerSize20),
      ),
      child: Row(
        spacing: spacerSize4,
        children: [
          Icon(icon, size: spacerSize14, color: AppColors.offWhite),
          BaseText(
            text: text,
            fontSize: fontSize11,
            fontFamily: AppKeys.inter,
            fontWeight: FontWeight.w500,
            textColor: AppColors.offWhite,
          ),
        ],
      ),
    );
  }
}
