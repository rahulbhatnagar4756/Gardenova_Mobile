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
import '../../../allPlants/allPlantsDetails/components/care_guide_section.dart';
import '../../../allPlants/allPlantsDetails/components/care_overview_section.dart';
import '../../../allPlants/allPlantsDetails/components/plant_classification_section.dart';
import '../../../allPlants/allPlantsDetails/components/plant_health_section.dart';
import '../../../allPlants/allPlantsDetails/components/plant_propagation_section.dart';
import '../../../allPlants/allPlantsDetails/components/quick_info_section.dart';
import '../../../allPlants/allPlantsDetails/components/special_traits_section.dart';
import '../../../model/plant_details_model.dart' show PlantModelDetails, Care;

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
              controller.plantDetailData.value.data?.plant?.imageOriginalUrl ??
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
                  // spacing: spacerSize16,
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
                    SizedBox(height: spacerSize16),
                    BaseText(
                      text: "",
                      fontFamily: AppKeys.inter,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.liteGreyColor,
                    ),
                    SizedBox(height: spacerSize16),
                    const Divider(color: AppColors.backgroundGrey, height: 1),
                    SizedBox(height: spacerSize16),
                    _progressCard(context),
                    _statsRow(controller: controller),
                    _upcomingEvents(controller: controller),
                    SizedBox(height: spacerSize16),
                    const Divider(color: AppColors.backgroundGrey, height: 1),
                    SizedBox(height: spacerSize16),
                    _buildPlantHistory(context),

                    // const Divider(color: AppColors.backgroundGrey, height: 1),
                    _buildCareSections(context),
                    SizedBox(height: 25.h),
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
        reminder?.nextFertilizedAt != null ||
        reminder?.nextPrunedAt != null ||
        reminder?.nextGenericCareAt != null;
  }

  Widget _upcomingEvents({required MyPlantDetailsController controller}) {
    final reminder = controller.plantDetailData.value.data?.reminder;
    if (reminder == null || !_shouldShowUpcomingEvents(controller)) {
      return const SizedBox();
    }

    final context = Get.context!;
    final loc = AppLocalizations.of(context)!;
    List<Widget> eventTiles = [];

    if (reminder.nextWateredAt != null) {
      eventTiles.add(
        _eventTile(
          Assets.imagesWatering,
          loc.watering,
          "${loc.scheduledFor} ${_getDayName(context, reminder.nextWateredAt)}",
        ),
      );
    }

    if (reminder.nextFertilizedAt != null) {
      eventTiles.add(
        _eventTile(
          Assets.imagesFertilizing,
          loc.fertilizing,
          "${loc.scheduledFor} ${_getDayName(context, reminder.nextFertilizedAt)}",
        ),
      );
    }

    if (reminder.nextPrunedAt != null) {
      eventTiles.add(
        _eventTile(
          Assets.imagesPruning,
          loc.pruning,
          "${loc.scheduledFor} ${_getDayName(context, reminder.nextPrunedAt)}",
        ),
      );
    }

    if (reminder.nextGenericCareAt != null) {
      eventTiles.add(
        _eventTile(
          Assets.imagesGeneralNoti,
          loc.general,
          "${loc.scheduledFor} ${_getDayName(context, reminder.nextGenericCareAt)}",
        ),
      );
    }

    if (eventTiles.isEmpty) return const SizedBox();

    return Column(
      spacing: spacerSize16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: AppColors.backgroundGrey, height: 1),
        _sectionHeader(loc.upcomingEvents),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: eventTiles
                .map((tile) => tile.marginOnly(right: spacerSize12))
                .toList(),
          ),
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
    final plant = controller.plantDetailData.value.data?.plant;
    if (plant == null) return const SizedBox();

    // Calculate completion percentage based ONLY on reminder settings
    int totalFields = 4; // Watering, Fertilizing, Pruning, General Care
    int filledFields = 0;

    // Include reminder settings in progress
    final reminder = controller.plantDetailData.value.data?.reminder;
    if (reminder?.wateringNotificationEnabled == true) filledFields++;
    if (reminder?.fertilizerNotificationEnabled == true) filledFields++;
    if (reminder?.puringNotificationEnabled == true) filledFields++;
    if (reminder?.genericNotificationEnabled == true) filledFields++;

    double percentage = filledFields / totalFields;
    if (percentage > 1.0) percentage = 1.0;
    int displayPercentage = (percentage * 100).toInt();

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
                    text: '$displayPercentage%',
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
                  value: percentage,
                  backgroundColor: AppColors.blackColor.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation(
                    AppColors.greenColor,
                  ),
                ),
              ),
              if (displayPercentage < 100)
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
              const SizedBox(height: spacerSize16),
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
              const SizedBox(height: spacerSize16),
            ],
          )
        : const SizedBox(height: spacerSize16);
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
              ).marginOnly(right: spacerSize20),
            if ((reminder.fertilizerReminderFrequency ?? 0) > 0)
              PlantStateItem(
                icon: Assets.imagesFertilizing,
                label: loc!.fertilizing,
                value:
                    "${loc.every} ${reminder.fertilizerReminderFrequency} ${loc.week}",
              ).marginOnly(right: spacerSize20),
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

  Widget _buildPlantHistory(BuildContext context) {
    final reminder = controller.plantDetailData.value.data?.reminder;
    if (reminder == null) return const SizedBox();

    final loc = AppLocalizations.of(context)!;
    List<Widget> historyTiles = [];

    if (reminder.lastWateredAt != null) {
      historyTiles.add(
        _eventTile(
          Assets.imagesWatering,
          loc.watering,
          _getTimeAgo(reminder.lastWateredAt!),
        ),
      );
    }

    if (reminder.lastFertilizedAt != null) {
      historyTiles.add(
        _eventTile(
          Assets.imagesFertilizing,
          loc.fertilizing,
          _getTimeAgo(reminder.lastFertilizedAt!),
        ),
      );
    }

    if (reminder.lastPrunedAt != null) {
      historyTiles.add(
        _eventTile(
          Assets.imagesPruning,
          loc.pruning,
          _getTimeAgo(reminder.lastPrunedAt!),
        ),
      );
    }

    if (reminder.lastGenericCareAt != null) {
      historyTiles.add(
        _eventTile(
          Assets.imagesGeneralNoti,
          loc.general,
          _getTimeAgo(reminder.lastGenericCareAt!),
        ),
      );
    }

    if (historyTiles.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(loc.plantHistory),
        SizedBox(height: spacerSize12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: historyTiles
                .map((tile) => tile.marginOnly(right: spacerSize12))
                .toList(),
          ),
        ),
        SizedBox(height: spacerSize16),
      ],
    );
  }

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) {
      return "${diff.inDays} days ago";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} hours ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} minutes ago";
    } else {
      return "Just now";
    }
  }

  Widget _buildCareSections(BuildContext context) {
    final plant = controller.plantDetailData.value.data?.plant;
    if (plant == null) return const SizedBox();

    // Map the MyPlantDetails.PlantDetails to PlantModelDetails
    // Since the classes have similar fields but are different types
    final plantModel = _convertToPlantModelDetails(plant);

    return Column(
      spacing: spacerSize16,
      children: [
        QuickInfoSection(plant: plantModel),
        CareOverviewSection(plant: plantModel),
        if (controller.plantDetailData.value.data?.care != null)
          CareGuideSection(care: controller.plantDetailData.value.data!.care!),
        PlantClassificationSection(plant: plantModel),
        PlantPropagationSection(plant: plantModel),
        SpecialTraitsSection(plant: plantModel),
      ],
    );
  }

  PlantModelDetails _convertToPlantModelDetails(PlantDetails plant) {
    // This is a mapping helper to reuse existing components
    return PlantModelDetails(
      id: plant.plantId,
      commonName: plant.commonName,
      scientificName: plant.scientificName,
      otherName: plant.otherName,
      family: plant.family,
      genus: plant.genus,
      speciesEpithet: plant.speciesEpithet,
      origin: plant.origin,
      type: plant.type,
      cycle: plant.cycle,
      watering: plant.watering,
      wateringBenchmarkValue: plant.wateringBenchmarkValue,
      wateringBenchmarkUnit: plant.wateringBenchmarkUnit,
      sunlight: plant.sunlight,
      soil: plant.soil,
      hardinessMin: plant.hardinessMin,
      hardinessMax: plant.hardinessMax,
      dimensionType: plant.dimensionType,
      dimensionMinValue: plant.dimensionMinValue?.toString(),
      dimensionMaxValue: plant.dimensionMaxValue?.toString(),
      dimensionUnit: plant.dimensionUnit,
      growthRate: plant.growthRate,
      maintenance: plant.maintenance,
      careLevel: plant.careLevel,
      careGuidesUrl: plant.careGuidesUrl,
      pruningMonth: plant.pruningMonth,
      propagation: plant.propagation,
      attracts: plant.attracts,
      pestSusceptibility: plant.pestSusceptibility,
      plantAnatomy: plant.plantAnatomy,
      droughtTolerant: plant.droughtTolerant,
      saltTolerant: plant.saltTolerant,
      thorny: plant.thorny,
      invasive: plant.invasive,
      tropical: plant.tropical,
      indoor: plant.indoor,
      flowers: plant.flowers,
      cones: plant.cones,
      fruits: plant.fruits,
      edibleFruit: plant.edibleFruit,
      leaf: plant.leaf,
      edibleLeaf: plant.edibleLeaf,
      seeds: plant.seeds,
      cuisine: plant.cuisine,
      medicinal: plant.medicinal,
      poisonousToHumans: plant.poisonousToHumans,
      poisonousToPets: plant.poisonousToPets,
      floweringSeason: plant.floweringSeason,
      harvestSeason: plant.harvestSeason,
      description: plant.description,
      imageOriginalUrl: plant.imageOriginalUrl,
      imageRegularUrl: plant.imageRegularUrl,
      imageMediumUrl: plant.imageMediumUrl,
      imageSmallUrl: plant.imageSmallUrl,
      imageThumbnail: plant.imageThumbnail,
      imageLicense: plant.imageLicense,
    );
  }

  // Widget _editPlantButton(BuildContext context) {
  //   return const SizedBox();
  // }
}
