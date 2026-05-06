import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import '../../model/plant_details_model.dart';
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
                        top: BorderSide(color: AppColors.greenColor, width: 1),
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
                                        AppLocalizations.of(context)!.noDataNa,
                                    fontFamily: AppKeys.poppins,
                                    fontSize: fontSize20,
                                    fontWeight: FontWeight.w700,
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
                                    textColor: AppColors.liteGreyColor,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(spacerSize14),
                              decoration: BoxDecoration(
                                // gradient: LinearGradient(
                                //   colors: [
                                //     AppColors.lightGold,
                                //     AppColors.burntGold,
                                //   ],
                                //   begin: Alignment.topCenter,
                                //   end: Alignment.bottomCenter,
                                // ),
                                color: AppColors.greenColor,
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
                          textColor: AppColors.liteGreyColor,
                        ),
                        Divider(color: AppColors.backgroundGrey, height: 1),
                        progressCard(context),

                        statsRow(controller: controller),
                        upcomingEvents(controller: controller),

                        Divider(color: AppColors.backgroundGrey, height: 1),
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

  bool shouldShowUpcomingEvents(MyPlantDetailsController controller) {
    final reminder = controller.plantDetailData.value.data?.reminder;

    return reminder?.nextWateredAt != null ||
        reminder?.fertilizerReminderFrequency != null ||
        reminder?.pruningReminderFrequency != null && false;
  }

  Widget upcomingEvents({required MyPlantDetailsController controller}) {
    if (!shouldShowUpcomingEvents(controller)) {
      return const SizedBox();
    }

    final context = Get.context!;

    return Column(
      spacing: spacerSize16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: AppColors.backgroundGrey, height: 1),
        sectionHeader(AppLocalizations.of(context)!.upcomingEvents),
        Row(
          children: [
            Flexible(
              child: eventTile(
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
            ),
            SizedBox(width: 15.w),
            Flexible(
              child: eventTile(
                Assets.imagesFertilizing,
                AppLocalizations.of(context)!.fertilizing,
                "${AppLocalizations.of(context)!.scheduledFor} "
                "${AppLocalizations.of(context)!.next} "
                "${AppLocalizations.of(context)!.week}",
              ),
            ),
          ],
        ),
      ],
    );
  }

  String getDayName(BuildContext context, DateTime? date) {
    if (date == null) return "";

    String lang =
        SharedPrefsService.instance.getString(AppKeys.selectedLang) ?? "en";

    if (lang.isEmpty) {
      lang = "en"; // fallback
    }

    return DateFormat('EEEE', lang).format(date);
  }

  // String getDayName(BuildContext context, DateTime? date) {
  //   if (date == null) return "";
  //   return DateFormat(
  //     'EEEE',
  //     SharedPrefsService.instance.getString(AppKeys.selectedLang) ?? "pt",
  //   ).format(date);
  // }

  static Widget sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BaseText(
          text: title,
          fontFamily: AppKeys.poppins,
          fontSize: fontSize14,
          fontWeight: FontWeight.w700,
          textColor: AppColors.greenColor,
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
          fontFamily: AppKeys.poppins,
          fontSize: fontSize14,
          fontWeight: FontWeight.w700,
          textColor: AppColors.greenColor,
        ).marginOnly(bottom: spacerSize20),
        Container(
          padding: const EdgeInsets.all(spacerSize12),
          decoration: BoxDecoration(
            color: AppColors.toToLiteGreenColor,
            borderRadius: BorderRadius.circular(spacerSize16),
            border: Border.all(color: AppColors.greenColor),
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
                  ),
                  BaseText(
                    text: '65%',
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.greenColor,
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(spacerSize10),
                child: LinearProgressIndicator(
                  value: 0.65,
                  backgroundColor: AppColors.blackColor.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation(AppColors.greenColor),
                ),
              ),
              BaseText(
                text: AppLocalizations.of(context)!.addMissingInfo,
                fontFamily: AppKeys.inter,
                fontSize: fontSize12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.liteGreyColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget statsRow({required MyPlantDetailsController controller}) {
    ReminderModel? reminder = controller.plantDetailData.value.data?.reminder;
    bool reindePruningrReq = ((reminder?.pruningReminderFrequency ?? 0) > 0);
    bool reinderFertilizerReq =
        ((reminder?.fertilizerReminderFrequency ?? 0) > 0);
    bool reinderWateringReq = ((reminder?.wateringReminderFrequency ?? 0) > 0);

    bool needToShow =
        reindePruningrReq || reinderFertilizerReq || reinderWateringReq;
    return needToShow
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: spacerSize8),
              Divider(color: AppColors.backgroundGrey, height: 1),
              SizedBox(height: spacerSize16),
              BaseText(
                text: AppLocalizations.of(Get.context!)!.plantStats,
                fontFamily: AppKeys.poppins,
                fontSize: fontSize14,
                fontWeight: FontWeight.w700,
                textColor: AppColors.greenColor,
              ).marginOnly(bottom: spacerSize20),
              buildReminderList(controller),
            ],
          )
        : const SizedBox();
  }

  static Widget buildReminderList(MyPlantDetailsController controller) {
    final reminder = controller.plantDetailData.value.data?.reminder;
    final loc = AppLocalizations.of(Get.context!);

    if (reminder == null) return const SizedBox();
    return Container(
      height: 145.h,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if ((reminder.wateringReminderFrequency ?? 0) > 0)
              PlantStateItem(
                icon: Assets.imagesWatering,
                label: loc?.water ?? '',
                value:
                    "${loc!.inText.capitalizeFirst} ${reminder.wateringReminderFrequency} ${loc.week}",
              ),

            if ((reminder.fertilizerReminderFrequency ?? 0) > 0)
              PlantStateItem(
                icon: Assets.imagesFertilizing,
                label: loc!.fertilizing,
                value:
                    "${loc.every} ${reminder.fertilizerReminderFrequency} ${loc.week}",
              ),

            if ((reminder.pruningReminderFrequency ?? 0) > 0)
              PlantStateItem(
                icon: Assets.imagesPruning,
                label: loc!.pruning,
                value:
                    "${loc.inText.capitalizeFirst} ${reminder.pruningReminderFrequency} ${loc.week}",
              ),
          ],
        ),
      ),
    );
    // return Container(
    //   color: Colors.red,
    //   height: 130.h,
    //   child: ListView(
    //     padding: EdgeInsets.zero,
    //     children: [
    //       if ((reminder.wateringReminderFrequency ?? 0) > 0)
    //         PlantStateItem(
    //           icon: Assets.imagesWatering,
    //           label: loc!.water,
    //           value:
    //           "${loc.inText.capitalizeFirst} ${reminder.wateringReminderFrequency} ${loc.week}",
    //         ),
    //
    //       if ((reminder.fertilizerReminderFrequency ?? 0) > 0)
    //         PlantStateItem(
    //           icon: Assets.imagesFertilizing,
    //           label: loc!.fertilizing,
    //           value:
    //           "${loc.every} ${reminder.fertilizerReminderFrequency} ${loc.week}",
    //         ),
    //
    //       if ((reminder.pruningReminderFrequency ?? 0) > 0)
    //         PlantStateItem(
    //           icon: Assets.imagesPruning,
    //           label: loc!.pruning,
    //           value:
    //           "${loc.inText.capitalizeFirst} ${reminder.pruningReminderFrequency} ${loc.week}",
    //         ),
    //     ],
    //   ),
    // );
  }

  static Widget eventTile(String icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(spacerSize15),
      margin: const EdgeInsets.only(bottom: spacerSize8),
      decoration: BoxDecoration(
        color: AppColors.toToLiteGreenColor,
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.liteGreenColor),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(spacerSize15),
            margin: const EdgeInsets.only(bottom: spacerSize8),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: AppColors.whiteColor),
            ),
            child: Image.asset(
              icon,
              height: spacerSize35,
              width: spacerSize35,
              color: AppColors.greenColor,
            ),
          ),
          Column(
            children: [
              BaseText(
                text: title,
                fontFamily: AppKeys.inter,
                fontSize: fontSize13,
                fontWeight: FontWeight.w500,
              ),
              BaseText(
                text: subtitle,
                fontFamily: AppKeys.inter,
                fontSize: fontSize12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.liteGreyColor,
              ),
            ],
          ),
        ],
      ),
    );

    // return Container(
    //     padding: const EdgeInsets.all(spacerSize15),
    //     margin: const EdgeInsets.only(bottom: spacerSize8),
    //     decoration: BoxDecoration(
    //       color: AppColors.toToLiteGreenColor,
    //       borderRadius: BorderRadius.circular(spacerSize12),
    //       border: Border.all(
    //         color: AppColors.liteGreenColor,
    //       ),
    //     ),
    //   child: Column(
    //     children: [
    //             Container(
    //               padding: const EdgeInsets.all(spacerSize15),
    //               margin: const EdgeInsets.only(bottom: spacerSize8),
    //               decoration: BoxDecoration(
    //                 color: AppColors.whiteColor,
    //                 borderRadius: BorderRadius.circular(100),
    //                 border: Border.all(
    //                   color: AppColors.whiteColor,
    //                 ),
    //               ),
    //               child: Image.asset(icon, height: spacerSize35, width: spacerSize35,color:  AppColors.greenColor,),
    //             ),
    //       // Image.asset(icon, height: spacerSize20, width: spacerSize20,color: AppColors.greenColor,),
    //       Expanded(
    //         child: BaseText(
    //           text: title,
    //           fontFamily: AppKeys.inter,
    //           fontSize: fontSize12,
    //           fontWeight: FontWeight.w400,
    //         ),
    //       ),
    //       BaseText(
    //         text: subtitle,
    //         fontFamily: AppKeys.inter,
    //         fontSize: fontSize14,
    //         fontWeight: FontWeight.w400,
    //         textColor: AppColors.liteGreyColor,
    //       ),
    //     ],
    //   ),
    // );
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
      bottomPadding: true,
      buttonWidth: double.infinity,
    );
  }
}
