import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:kasagardem/plants/allPlants/allPlantsDetails/components/plant_toggle_card.dart';

import '../../../../base/widgets/base_date_format.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../base/widgets/common_click_widget.dart';
import '../../../../base/widgets/full_screen_image_preview.dart';
import '../../../../generated/assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../all_plants_details_controller.dart';
import 'care_overview_section.dart';
import 'frequency_bottom_sheet.dart';
import 'plant_health_section.dart';
import 'quick_info_section.dart';
import 'special_traits_section.dart';

class MainContentCard extends StatelessWidget {
  final AllPlantsDetailsController controller;

  const MainContentCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // const SizedBox(height: spacerSize300),
          GestureDetector(
            onTap: () {
              final imageUrl =
                  controller.plantDetailData.value.data?.plant?.imageUrl ?? "";

              if (imageUrl.isNotEmpty) {
                FullScreenImageView.open(
                  imageUrl: imageUrl,
                  heroTag: "plant_detail_image",
                );
              }
            },
            child: Container(height: spacerSize300, color: Colors.transparent),
          ),
          Container(
            padding: EdgeInsets.all(spacerSize20),
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
                controller.plantDetailData.value.data == null
                    ? SizedBox.shrink()
                    : plantTitle(),
                // need to change here
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
                        textColor: AppColors.liteGreyColor,
                      ),

                Obx(
                  () => controller.screenType.value == 'add'
                      ? Column(
                          spacing: 15.h,
                          children: [
                            Divider(color: AppColors.backgroundGrey),
                            QuickInfoSection(
                              plant:
                                  controller.plantDetailData.value.data?.plant,
                            ),

                            CareOverviewSection(
                              plant:
                                  controller.plantDetailData.value.data?.plant,
                            ),

                            SpecialTraitsSection(
                              plant:
                                  controller.plantDetailData.value.data?.plant,
                            ),

                            PlantHealthSection(
                              plant:
                                  controller.plantDetailData.value.data?.plant,
                            ),

                            // Divider(color: AppColors.backgroundGrey),
                            SizedBox(height: 25.h),
                          ],
                        )
                      : Column(
                          children: [
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
                                            title: AppLocalizations.of(
                                              context,
                                            )!.watering,
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
                                              text: AppLocalizations.of(
                                                context,
                                              )!.frequency,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppColors.blackColor,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text:
                                                  controller
                                                          .wateringFrequency
                                                          .value !=
                                                      0
                                                  ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.wateringFrequency.value}\t${controller.wateringFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                                  : AppLocalizations.of(
                                                      context,
                                                    )!.selectFrequency,

                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppColors.greenColor,
                                            ),
                                            Icon(
                                              Icons.navigate_next_outlined,
                                              size: spacerSize20,
                                              color: AppColors.greenColor,
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
                                          CareType.watering,
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
                                              text: AppLocalizations.of(
                                                context,
                                              )!.preferred,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text:
                                                  controller
                                                      .wateringTime
                                                      .value
                                                      .isNotEmpty
                                                  ? BaseDateTimeFormat.format(
                                                      dateTime: controller
                                                          .wateringTime
                                                          .value,
                                                      format: "hh:mm a",
                                                    )
                                                  : AppLocalizations.of(
                                                      context,
                                                    )!.selectTime,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppColors.greenColor,
                                            ),
                                            Icon(
                                              Icons.navigate_next_outlined,
                                              color: AppColors.greenColor,
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
                                title: AppLocalizations.of(
                                  context,
                                )!.fertilizing,
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
                                              text: AppLocalizations.of(
                                                context,
                                              )!.frequency,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text:
                                                  controller
                                                          .fertilizingFrequency
                                                          .value !=
                                                      0
                                                  ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.fertilizingFrequency.value}\t${controller.fertilizingFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                                  : AppLocalizations.of(
                                                      context,
                                                    )!.selectFrequency,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppColors.greenColor,
                                            ),
                                            Icon(
                                              Icons.navigate_next_outlined,
                                              size: spacerSize20,
                                              color: AppColors.greenColor,
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
                                              text: AppLocalizations.of(
                                                context,
                                              )!.preferred,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text:
                                                  controller
                                                      .fertilizingTime
                                                      .value
                                                      .isNotEmpty
                                                  ? BaseDateTimeFormat.format(
                                                      dateTime: controller
                                                          .fertilizingTime
                                                          .value,
                                                      format: "hh:mm a",
                                                    )
                                                  : AppLocalizations.of(
                                                      context,
                                                    )!.selectTime,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppColors.greenColor,
                                            ),
                                            Icon(
                                              Icons.navigate_next_outlined,
                                              color: AppColors.greenColor,
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
                                            title: AppLocalizations.of(
                                              context,
                                            )!.pruning,
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
                                              text: AppLocalizations.of(
                                                context,
                                              )!.frequency,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text:
                                                  controller
                                                          .pruningFrequency
                                                          .value !=
                                                      0
                                                  ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.pruningFrequency.value}\t${controller.pruningFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                                  : AppLocalizations.of(
                                                      context,
                                                    )!.selectFrequency,

                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppColors.greenColor,
                                            ),
                                            Icon(
                                              Icons.navigate_next_outlined,
                                              size: spacerSize20,
                                              color: AppColors.greenColor,
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
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text:
                                                  controller
                                                          .criticalCareFrequency
                                                          .value !=
                                                      0
                                                  ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.criticalCareFrequency.value}\t${controller.criticalCareFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                                  : AppLocalizations.of(
                                                      context,
                                                    )!.selectFrequency,

                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppColors.greenColor,
                                            ),
                                            Icon(
                                              Icons.navigate_next_outlined,
                                              size: spacerSize20,
                                              color: AppColors.greenColor,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ).marginOnly(bottom: spacerSize10),
                            ),
                          ],
                        ),
                ),
                SizedBox(height: 25.h),
                // Obx(
                //   () => addPlantButton(
                //     context,
                //     controller.screenType.value == 'add',
                //   ),
                // ),
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
                    AppLocalizations.of(Get.context!)!.noDataNa,
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
        Obx(
          () => CommonClickWidget(
            onTap: () {
              controller.validateAndSubmit(Get.context!);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
              decoration: BoxDecoration(
                gradient: AppColors.linearGradientForBtn,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greenColor.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.screenType.value == 'add'
                          ? Icons.add_rounded
                          : Icons.save_rounded,
                      color: Colors.white,
                      size: 15.w,
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Text(
                    controller.screenType.value == 'add'
                        ? AppLocalizations.of(Get.context!)!.addPlant
                        : 'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Obx(
        //   () => CommonClickWidget(
        //     onTap: () {
        //       controller.validateAndSubmit(Get.context!);
        //     },
        //     child: Container(
        //       padding: const EdgeInsets.all(spacerSize14),
        //       decoration: BoxDecoration(
        //         color: AppColors.greenColor,
        //
        //         borderRadius: BorderRadius.circular(spacerSize12),
        //       ),
        //       // child: Image.asset(
        //       //   Assets.imagesNotification,
        //       //   height: spacerSize20,
        //       //   width: spacerSize20,
        //       // ),
        //       child: Row(
        //         children: [
        //           Icon(
        //             controller.screenType.value == 'add'
        //                 ? Icons.add
        //                 : Icons.save,
        //             color: Colors.white,
        //             size: spacerSize20,
        //           ),
        //           SizedBox(width: 10.w),
        //           Text(
        //             controller.screenType.value == 'add'
        //                 ? AppLocalizations.of(Get.context!)!.addPlant
        //                 : 'Save Changes',
        //             style: TextStyle(
        //               color: Colors.white,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // Widget addPlantButton(BuildContext context, bool addPlant) {
  //   return BaseButton(
  //     onPressed: () {
  //       controller.validateAndSubmit(context);
  //     },
  //     backgroundColor: AppColors.burntGold,
  //     buttonLabel: addPlant
  //         ? AppLocalizations.of(context)!.addPlant
  //         : 'Save Changes',
  //     fontSize: fontSize16,
  //     textColor: Colors.white,
  //     buttonWidth: double.infinity,
  //   );
  // }
}
