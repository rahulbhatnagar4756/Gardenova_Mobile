import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:kasagardem/plants/allPlants/allPlantsDetails/components/plant_toggle_card.dart';
import '../../../../base/widgets/base_button.dart';
import '../../../../base/widgets/base_date_format.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../generated/assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../all_plants_details_controller.dart';
import 'frequency_bottom_sheet.dart';

class MainContentCard extends StatelessWidget {
  final AllPlantsDetailsController controller;

  const MainContentCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: spacerSize300),
          Container(
            padding: EdgeInsets.all(spacerSize20),
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
                controller.plantDetailData.value.data == null
                    ? SizedBox.shrink()
                    : plantTitle(),

                controller.plantDetailData.value.data == null
                    ? SizedBox.shrink()
                    : BaseText(
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

                Obx(
                  () => PlantToggleCard(
                    icon: Assets.imagesWatering,
                    title:
                        "${AppLocalizations.of(context)!.watering}\t${AppLocalizations.of(context)!.reminders}",
                    value: controller.isWateringOn.value,
                    onChanged: (value) {
                      controller.toggleWatering(value);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (controller.isWateringOn.value) {
                              FrequencyBottomSheet.show(
                                controller,
                                CareType.watering,
                              );
                            } else {
                              BaseSnackBar.show(
                                title: AppLocalizations.of(context)!.watering,
                                message: AppLocalizations.of(
                                  context,
                                )!.enableWatering,
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: spacerSize12,
                              top: spacerSize8,
                              right: spacerSize5,
                            ),
                            child: Row(
                              children: [
                                BaseText(
                                  text: AppLocalizations.of(context)!.frequency,
                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.offWhite,
                                ),
                                Spacer(),
                                BaseText(
                                  text: controller.wateringFrequency.value != 0
                                      ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.wateringFrequency.value}\t${controller.wateringFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                      : AppLocalizations.of(
                                          context,
                                        )!.selectFrequency,

                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.darkGold,
                                ),
                                Icon(
                                  Icons.navigate_next_outlined,
                                  size: spacerSize20,
                                  color: AppColors.darkGold,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: AppColors.backgroundGrey,
                          indent: 0,
                          endIndent: 0,
                        ),
                        InkWell(
                          onTap: () {
                            controller.pickerTime(context, CareType.watering);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: spacerSize12,
                              bottom: spacerSize12,
                              right: spacerSize5,
                            ),
                            child: Row(
                              children: [
                                BaseText(
                                  text:
                                      AppLocalizations.of(context)!.preferred,
                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.offWhite,
                                ),
                                Spacer(),
                                BaseText(
                                  text: controller.wateringTime.value.isNotEmpty
                                      ? BaseDateTimeFormat.format(
                                          dateTime:
                                              controller.wateringTime.value,
                                          format: "hh:mm a",
                                        )
                                      : AppLocalizations.of(
                                          context,
                                        )!.selectTime,
                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.darkGold,
                                ),
                                Icon(
                                  Icons.navigate_next_outlined,
                                  color: AppColors.darkGold,
                                  size: spacerSize20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).marginOnly(bottom: spacerSize10),
                ),

                Obx(
                  () => PlantToggleCard(
                    icon: Assets.imagesFertilizing,
                    title:
                        AppLocalizations.of(context)!.fertilizing,
                    value: controller.isFertilizingOn.value,
                    onChanged: (value) {
                      controller.toggleFertilizing(value);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (controller.isFertilizingOn.value) {
                              FrequencyBottomSheet.show(
                                controller,
                                CareType.fertilizing,
                              );
                            } else {
                              BaseSnackBar.show(
                                title: AppLocalizations.of(
                                  context,
                                )!.fertilizing,
                                message: AppLocalizations.of(
                                  context,
                                )!.enableFertilizing,
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: spacerSize12,
                              top: spacerSize12,
                              right: spacerSize5,
                            ),
                            child: Row(
                              children: [
                                BaseText(
                                  text: AppLocalizations.of(context)!.frequency,
                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.offWhite,
                                ),
                                Spacer(),
                                BaseText(
                                  text:
                                      controller.fertilizingFrequency.value != 0
                                      ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.fertilizingFrequency.value}\t${controller.fertilizingFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                      : AppLocalizations.of(
                                          context,
                                        )!.selectFrequency,
                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.darkGold,
                                ),
                                Icon(
                                  Icons.navigate_next_outlined,
                                  size: spacerSize20,
                                  color: AppColors.darkGold,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: AppColors.backgroundGrey,
                          indent: 0,
                          endIndent: 0,
                        ),
                        InkWell(
                          onTap: () {
                            controller.pickerTime(
                              context,
                              CareType.fertilizing,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: spacerSize12,
                              bottom: spacerSize12,
                              right: spacerSize5,
                            ),
                            child: Row(
                              children: [
                                BaseText(
                                  text:    AppLocalizations.of(context)!.preferred,
                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.offWhite,
                                ),
                                Spacer(),
                                BaseText(
                                  text:
                                      controller
                                          .fertilizingTime
                                          .value
                                          .isNotEmpty
                                      ? BaseDateTimeFormat.format(
                                          dateTime:
                                              controller.fertilizingTime.value,
                                          format: "hh:mm a",
                                        )
                                      : AppLocalizations.of(
                                          context,
                                        )!.selectTime,
                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.darkGold,
                                ),
                                Icon(
                                  Icons.navigate_next_outlined,
                                  color: AppColors.darkGold,
                                  size: spacerSize20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).marginOnly(bottom: spacerSize10),

                Obx(
                  () => PlantToggleCard(
                    icon: Assets.imagesPruning,
                    title:
                        "${AppLocalizations.of(context)!.pruning}\t${AppLocalizations.of(context)!.alerts}",
                    value: controller.isPruningOn.value,
                    onChanged: (value) {
                      controller.togglePruning(value);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (controller.isPruningOn.value) {
                              FrequencyBottomSheet.show(
                                controller,
                                CareType.pruning,
                              );
                            } else {
                              BaseSnackBar.show(
                                title: AppLocalizations.of(context)!.pruning,
                                message: AppLocalizations.of(
                                  context,
                                )!.enablePruning,
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: spacerSize12,
                              top: spacerSize12,
                              bottom: spacerSize12,
                              right: spacerSize5,
                            ),
                            child: Row(
                              children: [
                                BaseText(
                                  text: AppLocalizations.of(context)!.frequency,
                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.offWhite,
                                ),
                                Spacer(),
                                BaseText(
                                  text: controller.pruningFrequency.value != 0
                                      ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.pruningFrequency.value}\t${controller.pruningFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                      : AppLocalizations.of(
                                          context,
                                        )!.selectFrequency,

                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.darkGold,
                                ),
                                Icon(
                                  Icons.navigate_next_outlined,
                                  size: spacerSize20,
                                  color: AppColors.darkGold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).marginOnly(bottom: spacerSize10),
                ),

                Obx(
                  () => PlantToggleCard(
                    icon: Assets.imagesGeneralNoti,
                    title:
                        "${AppLocalizations.of(context)!.general}\t${AppLocalizations.of(context)!.options}",
                    value: controller.isCriticalOn.value,
                    onChanged: (value) {
                      controller.toggleCritical(value);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            if (controller.isCriticalOn.value) {
                              FrequencyBottomSheet.show(
                                controller,
                                CareType.critical,
                              );
                            } else {
                              BaseSnackBar.show(
                                title: AppLocalizations.of(
                                  context,
                                )!.criticalCare,
                                message: AppLocalizations.of(
                                  context,
                                )!.enableCriticalCare,
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: spacerSize12,
                              top: spacerSize12,
                              bottom: spacerSize12,
                              right: spacerSize5,
                            ),
                            child: Row(
                              children: [
                                BaseText(
                                  text:
                                      "${AppLocalizations.of(context)!.criticalCare}\t${AppLocalizations.of(context)!.alerts}",
                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.offWhite,
                                ),
                                Spacer(),
                                BaseText(
                                  text:
                                      controller.criticalCareFrequency.value !=
                                          0
                                      ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.criticalCareFrequency.value}\t${controller.criticalCareFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                      : AppLocalizations.of(
                                          context,
                                        )!.selectFrequency,

                                  fontFamily: AppKeys.inter,
                                  fontSize: fontSize12,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.darkGold,
                                ),
                                Icon(
                                  Icons.navigate_next_outlined,
                                  size: spacerSize20,
                                  color: AppColors.darkGold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).marginOnly(bottom: spacerSize10),
                ),

                addPlantButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget plantTitle() {
    return Row(
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
                    controller.plantDetailData.value.data?.plant?.commonName ??
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
                textColor: AppColors.offWhite.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(spacerSize14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.lightGold, AppColors.burntGold],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(spacerSize12),
          ),
          child: Image.asset(
            Assets.imagesNotification,
            height: spacerSize20,
            width: spacerSize20,
          ),
        ),
      ],
    );
  }

  Widget addPlantButton(BuildContext context) {
    return BaseButton(
      onPressed: () {
        controller.validateAndSubmit(context);
      },
      backgroundColor: AppColors.burntGold,
      buttonLabel: AppLocalizations.of(context)!.addPlant,
      fontSize: fontSize16,
      textColor: Colors.white,
      buttonWidth: double.infinity,
    );
  }

}
