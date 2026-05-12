import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/base/widgets/full_screen_image_preview.dart';
import 'package:kasagardem/generated/assets.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/plants/myPlants/myPlantDetails/components/plant_state_item.dart'
    show PlantStateItem;
import 'package:kasagardem/plants/myPlants/myPlantDetails/model/my_plant_detail_model.dart';
import 'package:kasagardem/plants/myPlants/myPlantDetails/my_plant_details_controller.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

class MyPlantDetailsSuccessView extends StatelessWidget {
  final MyPlantDetailsController controller;

  const MyPlantDetailsSuccessView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          height: spacerSize350,
          width: double.infinity,
          fit: BoxFit.cover,
          imageUrl:
              controller.plantDetailData.value.data?.plant?.imageRegularUrl ??
              "",
          placeholder: (context, url) =>
              const BaseShimmer(height: spacerSize350, width: double.infinity),
          errorWidget: (context, url, error) =>
              const Icon(Icons.broken_image, color: AppColors.offWhite10),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  final imageUrl =
                      controller
                          .plantDetailData
                          .value
                          .data
                          ?.plant
                          ?.imageOriginalUrl ??
                      "";

                  if (imageUrl.isNotEmpty) {
                    FullScreenImageView.open(
                      imageUrl: imageUrl,
                      heroTag: "plant_detail_image",
                    );
                  }
                },
                child: Container(
                  height: spacerSize300,
                  color: Colors.transparent,
                ),
              ),
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
                        CommonClickWidget(
                          onTap: () {
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
                          child: Container(
                            padding: const EdgeInsets.all(spacerSize14),
                            decoration: BoxDecoration(
                              color: AppColors.greenColor,
                              borderRadius: BorderRadius.circular(spacerSize12),
                            ),
                            child: Image.asset(
                              Assets.imagesNotification,
                              height: spacerSize20,
                              width: spacerSize20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    BaseText(
                      text: "",
                      fontFamily: AppKeys.inter,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.liteGreyColor,
                    ),
                    const Divider(color: AppColors.backgroundGrey, height: 1),
                    _progressCard(context),
                    _statsRow(controller: controller),
                    _upcomingEvents(controller: controller),
                    const Divider(color: AppColors.backgroundGrey, height: 1),
                    _sectionHeader(
                      AppLocalizations.of(Get.context!)!.plantHistory,
                    ),
                    _eventTile(
                      Assets.imagesWatering,
                      "${AppLocalizations.of(context)!.watered}\t2\t${AppLocalizations.of(context)!.days}\t${AppLocalizations.of(context)!.ago}",
                      AppLocalizations.of(context)!.consistent,
                    ),
                    _editPlantButton(context).marginOnly(top: spacerSize15),
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
    );
  }

  bool _shouldShowUpcomingEvents(MyPlantDetailsController controller) {
    final reminder = controller.plantDetailData.value.data?.reminder;
    return reminder?.nextWateredAt != null ||
        reminder?.fertilizerReminderFrequency != null ||
        reminder?.pruningReminderFrequency != null && false;
  }

  Widget _upcomingEvents({required MyPlantDetailsController controller}) {
    if (!_shouldShowUpcomingEvents(controller)) {
      return const SizedBox();
    }
    final context = Get.context!;
    return Column(
      spacing: spacerSize16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AppColors.backgroundGrey, height: 1),
        _sectionHeader(AppLocalizations.of(context)!.upcomingEvents),
        Row(
          children: [
            Flexible(
              child: _eventTile(
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
                          "${_getDayName(context, controller.plantDetailData.value.data?.reminder?.nextWateredAt)}",
              ),
            ),
            SizedBox(width: 15.w),
            Flexible(
              child: _eventTile(
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

  String _getDayName(BuildContext context, DateTime? date) {
    if (date == null) return "";
    String lang =
        SharedPrefsService.instance.getString(AppKeys.selectedLang) ?? "en";
    if (lang.isEmpty) lang = "en";
    return DateFormat('EEEE', lang).format(date);
  }

  Widget _sectionHeader(String title) {
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
      ],
    );
  }

  Widget _progressCard(BuildContext context) {
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
                  const BaseText(
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
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.greenColor,
                  ),
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

  Widget _statsRow({required MyPlantDetailsController controller}) {
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
              const SizedBox(height: spacerSize8),
              const Divider(color: AppColors.backgroundGrey, height: 1),
              const SizedBox(height: spacerSize16),
              BaseText(
                text: AppLocalizations.of(Get.context!)!.plantStats,
                fontFamily: AppKeys.poppins,
                fontSize: fontSize14,
                fontWeight: FontWeight.w700,
                textColor: AppColors.greenColor,
              ).marginOnly(bottom: spacerSize20),
              _buildReminderList(controller),
            ],
          )
        : const SizedBox();
  }

  Widget _buildReminderList(MyPlantDetailsController controller) {
    final reminder = controller.plantDetailData.value.data?.reminder;
    final loc = AppLocalizations.of(Get.context!);
    if (reminder == null) return const SizedBox();
    return SizedBox(
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
  }

  Widget _eventTile(String icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(spacerSize15),
      margin: const EdgeInsets.only(bottom: spacerSize8),
      constraints: BoxConstraints(minWidth: 150.w),
      decoration: BoxDecoration(
        color: AppColors.toToLiteGreenColor,
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.liteGreenColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
                textAlign: TextAlign.center,
                maxLines: 3,
                fontWeight: FontWeight.w400,
                textColor: AppColors.liteGreyColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _editPlantButton(BuildContext context) {
    return const SizedBox();
  }
}
