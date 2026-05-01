import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasagardem/plants/myPlants/myPlantDetails/my_plant_details_controller.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

import '../../../base/widgets/base_button.dart';
import '../../../base/widgets/base_shimmer.dart';
import '../../../base/widgets/base_text.dart';
import '../../../generated/assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_keys.dart';
import 'components/plant_state_item.dart';

class MyPlantDetailsScreen extends GetWidget<MyPlantDetailsController> {
  const MyPlantDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            CachedNetworkImage(
              height: spacerSize350,
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl:
                  controller.plantDetailData.value.data?.plant?.imageUrl ?? "",
              placeholder: (context, url) =>
                  BaseShimmer(height: spacerSize350, width: double.infinity),
              errorWidget: (context, url, error) =>
                  Icon(Icons.broken_image, color: AppColors.offWhite10),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: spacerSize300),
                  Container(
                    padding: const EdgeInsets.all(spacerSize20),
                    decoration: const BoxDecoration(
                      color: AppColors.appColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(spacerSize30),
                      ),
                      border: Border(
                        top: BorderSide(color: AppColors.borderGold, width: 1),
                      ),
                    ),
                    child: Column(
                      spacing: spacerSize16,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                spacing: spacerSize2,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  BaseText(
                                    text:
                                        controller
                                            .plantDetailData
                                            .value
                                            .data
                                            ?.plant
                                            ?.commonName ??
                                        "",
                                    fontFamily: AppKeys.merriweather,
                                    fontSize: fontSize20,
                                    fontWeight: FontWeight.w700,
                                    textColor: AppColors.offWhite,
                                  ),
                                  BaseText(
                                    text:
                                        controller
                                            .plantDetailData
                                            .value
                                            .data
                                            ?.plant
                                            ?.scientificName ??
                                        "",
                                    fontFamily: AppKeys.inter,
                                    fontSize: fontSize14,
                                    fontWeight: FontWeight.w400,
                                    textColor: AppColors.offWhite.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(spacerSize14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.lightGold,
                                    AppColors.burntGold,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(
                                  spacerSize12,
                                ),
                              ),
                              child: Image.asset(
                                Assets.imagesNotification,
                                height: spacerSize20,
                                width: spacerSize20,
                              ),
                            ),
                          ],
                        ),

                        BaseText(
                          text:
                              controller
                                  .plantDetailData
                                  .value
                                  .data
                                  ?.plant
                                  ?.description ??
                              "",
                          fontFamily: AppKeys.inter,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.offWhite.withValues(alpha: 0.5),
                        ),
                        Divider(color: AppColors.backgroundGrey),
                        progressCard(context),
                        Divider(color: AppColors.backgroundGrey),
                        statsRow(controller: controller),
                        Divider(color: AppColors.backgroundGrey),

                        sectionHeader(
                          AppLocalizations.of(Get.context!)!.upcomingEvents,
                        ),

                        eventTile(
                          Assets.imagesWatering,
                          AppLocalizations.of(context)!.watering,
                          controller
                                      .plantDetailData
                                      .value
                                      .data
                                      ?.reminder
                                      ?.nextWateredAt ==
                                  null
                              ? ""
                              : "${AppLocalizations.of(context)!.scheduledFor} "
                                    "${getDayName(context, controller.plantDetailData.value.data?.reminder?.nextWateredAt)}",
                        ),
                        eventTile(
                          Assets.imagesFertilizing,
                          AppLocalizations.of(Get.context!)!.fertilizing,
                          "${AppLocalizations.of(context)!.scheduledFor}\t${AppLocalizations.of(context)!.next}\t${AppLocalizations.of(context)!.week}",
                        ),

                        Divider(color: AppColors.backgroundGrey),
                        sectionHeader(
                          AppLocalizations.of(Get.context!)!.plantHistory,
                        ),
                        eventTile(
                          Assets.imagesWatering,
                          "${AppLocalizations.of(context)!.watered}\t2\t${AppLocalizations.of(context)!.days}\t${AppLocalizations.of(context)!.ago}",
                          AppLocalizations.of(context)!.consistent,
                        ),
                        editPlantButton(context).marginOnly(top: spacerSize15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: spacerSize10,
                  top: spacerSize16,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.black38,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getDayName(BuildContext context, DateTime? date) {
    if (date == null) return "";
    return DateFormat(
      'EEEE',
      SharedPrefsService.instance.getString(AppKeys.selectedLang) ?? "pt",
    ).format(date);
  }

  static Widget sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BaseText(
          text: title,
          fontFamily: AppKeys.merriweather,
          fontSize: fontSize14,
          fontWeight: FontWeight.w700,
          textColor: AppColors.darkGold,
        ),
        /*    Text(
          AppLocalizations.of(Get.context!)!.viewAll,
          style: TextStyle(
            fontFamily: AppKeys.inter,
            fontSize: fontSize12,
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.darkGold,
            color: AppColors.darkGold,
          ),
        ),*/
      ],
    );
  }

  static Widget progressCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText(
          text: AppLocalizations.of(Get.context!)!.personalizedCare,
          fontFamily: AppKeys.merriweather,
          fontSize: fontSize14,
          fontWeight: FontWeight.w700,
          textColor: AppColors.darkGold,
        ).marginOnly(bottom: spacerSize20),
        Container(
          padding: const EdgeInsets.all(spacerSize12),
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(spacerSize16),
            border: Border.all(color: AppColors.backgroundGrey),
          ),
          child: Column(
            spacing: spacerSize8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BaseText(
                    text: AppLocalizations.of(
                      Get.context!,
                    )!.careProfileCompletion,
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.offWhite,
                  ),
                  BaseText(
                    text: '65%',
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.darkGold,
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(spacerSize10),
                child: const LinearProgressIndicator(
                  value: 0.65,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(AppColors.darkGold),
                ),
              ),
              BaseText(
                text: AppLocalizations.of(context)!.addMissingInfo,
                fontFamily: AppKeys.inter,
                fontSize: fontSize12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.offWhite70,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget statsRow({required MyPlantDetailsController controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText(
          text: AppLocalizations.of(Get.context!)!.plantStats,
          fontFamily: AppKeys.merriweather,
          fontSize: fontSize14,
          fontWeight: FontWeight.w700,
          textColor: AppColors.darkGold,
        ).marginOnly(bottom: spacerSize20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: spacerSize40,
          children: [
            if (controller
                    .plantDetailData
                    .value
                    .data
                    ?.reminder
                    ?.wateringReminderFrequency !=
                0)
              PlantStateItem(
                icon: Assets.imagesWatering,
                label: AppLocalizations.of(Get.context!)!.water,
                value:
                    '${AppLocalizations.of(Get.context!)!.inText.capitalizeFirst}\t${controller.plantDetailData.value.data?.reminder?.wateringReminderFrequency ?? ""}\t${AppLocalizations.of(Get.context!)!.week}',
              ),
            if (controller
                    .plantDetailData
                    .value
                    .data
                    ?.reminder
                    ?.fertilizerReminderFrequency !=
                0)
              PlantStateItem(
                icon: Assets.imagesFertilizing,
                label: AppLocalizations.of(Get.context!)!.fertilizing,
                value:
                    '${AppLocalizations.of(Get.context!)!.every}\t${controller.plantDetailData.value.data?.reminder?.fertilizerReminderFrequency ?? ""}\t${AppLocalizations.of(Get.context!)!.week}',
              ),
            if (controller
                    .plantDetailData
                    .value
                    .data
                    ?.reminder
                    ?.pruningReminderFrequency !=
                0)
              PlantStateItem(
                icon: Assets.imagesPruning,
                label: AppLocalizations.of(Get.context!)!.pruning,
                value:
                    '${AppLocalizations.of(Get.context!)!.inText.capitalizeFirst}\t${controller.plantDetailData.value.data?.reminder?.pruningReminderFrequency ?? ""}\t${AppLocalizations.of(Get.context!)!.week}',
              ),
          ],
        ),
      ],
    );
  }

  static Widget eventTile(String icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(spacerSize14),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(spacerSize14),
        border: Border.all(color: AppColors.backgroundGrey),
      ),
      child: Row(
        spacing: spacerSize10,
        children: [
          Image.asset(icon, height: spacerSize20, width: spacerSize20),
          Expanded(
            child: BaseText(
              text: title,
              fontFamily: AppKeys.inter,
              fontSize: fontSize12,
              fontWeight: FontWeight.w400,
              textColor: AppColors.offWhite,
            ),
          ),
          BaseText(
            text: subtitle,
            fontFamily: AppKeys.inter,
            fontSize: fontSize14,
            fontWeight: FontWeight.w400,
            textColor: AppColors.offWhite.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }

  Widget editPlantButton(BuildContext context) {
    return BaseButton(
      onPressed: () {
        Get.toNamed(
          Routes.allPlantsDetails,
          arguments: {
            "plant_id": controller.plantId.value,
            "screen_type": "edit",
          },
        )!.then((value) {
          if (value == true) {
            controller.callGetMyPlantDetailsApi();
          }
        });
      },
      backgroundColor: AppColors.burntGold,
      buttonLabel: AppLocalizations.of(context)!.editPlant,
      fontSize: fontSize16,
      textColor: Colors.white,
      buttonWidth: double.infinity,
    );
  }

}
