import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/plants/allPlants/allPlantsDetails/components/circular_image_card.dart';
import 'package:kasagardem/plants/allPlants/allPlantsDetails/components/plant_care_tip.dart';
import 'package:kasagardem/plants/allPlants/allPlantsDetails/components/plant_property_card.dart';
import 'package:kasagardem/plants/allPlants/allPlantsDetails/components/plant_toggle_card.dart';
import 'package:kasagardem/reminders/component/add_note.dart';
import 'package:kasagardem/reminders/component/add_note_dialog.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';
import 'package:kasagardem/utils/routes.dart';

import '../../../../base/widgets/base_date_format.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../base/widgets/expandable_text.dart';
import '../../../../base/widgets/full_screen_image_preview.dart';
import '../../../../generated/assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../all_plants_details_controller.dart';
import 'care_guide_section.dart';
import 'care_overview_section.dart';
import 'frequency_bottom_sheet.dart';
import 'plant_basic_requirements_section.dart';
import 'plant_classification_section.dart';
import 'plant_disease_section.dart';
import 'plant_health_section.dart';
import 'plant_propagation_section.dart';
import 'quick_info_section.dart';
import 'special_traits_section.dart';

class MainContentCard extends StatelessWidget {
  final AllPlantsDetailsController controller;

  const MainContentCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    print("value of argument ${controller.plantDetailData.value.data!.alreadyAdded}");
    print("value of argument ${controller.plantDetailData.value.data!.toJson()}");
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              final imageUrl = controller.plantDetailData.value.data?.plant?.imageUrl ?? "";

              if (imageUrl.isNotEmpty) {
                FullScreenImageView.open(imageUrl: imageUrl, heroTag: "plant_detail_image");
              }
            },
            child: Container(height: spacerSize300, color: Colors.transparent),
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.appColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(spacerSize30)),
              border: Border(top: BorderSide(color: AppColors.greenColor, width: 1)),
            ),
            child: Column(
              spacing: spacerSize16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spacerSize35)),
                  color: AppColors.whiteColor,
                  child: Column(
                    children: [
                      controller.plantDetailData.value.data == null
                          ? SizedBox.shrink()
                          : plantTitle(),
                      ExpandableText(
                        text: controller.plantDetailData.value.data?.plant?.description ?? "",
                        trimLines: 3,
                        textColor: AppColors.liteGreyColor,
                        lineHeight: 1.5,
                      ),
                      if (Get.currentRoute != Routes.allPlantsDetails) Divider(thickness: 1),
                      PlantPropertyCard(allPlantsDetailsController: controller),
                    ],
                  ).paddingAll(spacerSize10),
                ).marginOnly(left: spacerSize10, right: spacerSize10),

                Obx(
                  () => controller.screenType.value == 'add'
                      ? Column(
                          // spacing: 15.h,
                          children: [
                            Divider(color: AppColors.backgroundGrey),
                            SizedBox(height: 15.h),
                            PlantBasicRequirementsSection(
                              plant: controller.plantDetailData.value.data?.plant,
                            ),
                            SizedBox(height: 15.h),
                            QuickInfoSection(plant: controller.plantDetailData.value.data?.plant),
                            if (controller.plantDetailData.value.data?.disease != null) ...[
                              SizedBox(height: 15.h),
                              PlantDiseaseSection(
                                disease: controller.plantDetailData.value.data!.disease,
                                showImage: true,
                              ),
                            ],
                            SizedBox(height: 15.h),
                            CareOverviewSection(
                              plant: controller.plantDetailData.value.data?.plant,
                            ),
                            SizedBox(height: 15.h),
                            if (controller.plantDetailData.value.data?.care != null)
                              CareGuideSection(care: controller.plantDetailData.value.data!.care!),

                            PlantClassificationSection(
                              plant: controller.plantDetailData.value.data?.plant,
                            ),
                            SizedBox(height: 15.h),
                            PlantPropagationSection(
                              plant: controller.plantDetailData.value.data?.plant,
                            ),
                            SizedBox(height: 15.h),
                            SpecialTraitsSection(
                              plant: controller.plantDetailData.value.data?.plant,
                            ),
                            SizedBox(height: 15.h),
                            PlantHealthSection(plant: controller.plantDetailData.value.data?.plant),
                            SizedBox(height: 15.h),
                          ],
                        )
                      : Column(
                          children: [
                            Divider(color: AppColors.backgroundGrey),

                            Obx(
                              () => PlantToggleCard(
                                iconColor: AppColors.dodgerBlue,
                                backgroundColor: AppColors.dodgerBlue.withValues(alpha: 0.2),
                                icon: Icons.water_drop_rounded,
                                title:
                                    "${AppLocalizations.of(context)!.watering}\t${AppLocalizations.of(context)!.reminders}",
                                subTitle: "Get reminded when it's time to water",
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
                                          FrequencyBottomSheet.show(controller, CareType.watering);
                                        } else {
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.watering,
                                            message: AppLocalizations.of(context)!.enableWatering,
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
                                            Icon(
                                              Icons.calendar_month,
                                              size: spacerSize20,
                                              color: AppColors.grey,
                                            ),
                                            SizedBox(width: spacerSize4),
                                            BaseText(
                                              text: AppLocalizations.of(context)!.frequency,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                              textColor: AppColors.blackColor,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text: controller.wateringFrequency.value != 0
                                                  ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.wateringFrequency.value}\t${controller.wateringFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                                  : AppLocalizations.of(context)!.selectFrequency,

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
                                        if (controller.isWateringOn.value) {
                                          controller.pickerTime(
                                            context,
                                            CareType.watering,
                                            controller.wateringTime.value,
                                          );
                                        } else {
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.watering,
                                            message: AppLocalizations.of(context)!.enableWatering,
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: spacerSize12,
                                          //   bottom: spacerSize12,
                                          right: spacerSize5,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: spacerSize20,
                                              color: AppColors.grey,
                                            ),
                                            SizedBox(width: spacerSize4),
                                            BaseText(
                                              text: AppLocalizations.of(context)!.preferred,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text: controller.wateringTime.value.isNotEmpty
                                                  ? BaseDateTimeFormat.format(
                                                      dateTime: controller.wateringTime.value,
                                                      format: "hh:mm a",
                                                    )
                                                  : AppLocalizations.of(context)!.selectTime,
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
                                    AddNote(
                                      title: controller.wateringNote.value.isEmpty
                                          ? AppStrings.addNote
                                          : AppStrings.viewNote,
                                      onTap: () {
                                        if (controller.isWateringOn.value) {
                                          controller.wateringController.text =
                                              controller.wateringNote.value;
                                          addNoteDialog(
                                            context,
                                            controller.wateringController,
                                            controller.wateringController.text.isNotEmpty
                                                ? AppStrings.editNote
                                                : AppStrings.addANote,
                                            controller.wateringNote,
                                            "${controller.getType(CareType.watering).toLowerCase()} alert.",
                                          );
                                        } else {
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.watering,
                                            message: AppLocalizations.of(context)!.enableWatering,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ).marginOnly(bottom: spacerSize10),
                            ),

                            Obx(
                              () => PlantToggleCard(
                                iconColor: AppColors.greenColor,
                                backgroundColor: AppColors.greenColor.withValues(alpha: 0.2),
                                icon: Assets.imagesFertilizing,
                                title: AppLocalizations.of(context)!.fertilizing,
                                value: controller.isFertilizingOn.value,
                                subTitle: "Nourish your plant with timely reminders",
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
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.fertilizing,
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
                                            Icon(
                                              Icons.calendar_month,
                                              size: spacerSize20,
                                              color: AppColors.grey,
                                            ),
                                            SizedBox(width: spacerSize4),
                                            BaseText(
                                              text: AppLocalizations.of(context)!.frequency,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text: controller.fertilizingFrequency.value != 0
                                                  ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.fertilizingFrequency.value}\t${controller.fertilizingFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                                  : AppLocalizations.of(context)!.selectFrequency,
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
                                        if (controller.isFertilizingOn.value) {
                                          controller.pickerTime(
                                            context,
                                            CareType.fertilizing,
                                            controller.fertilizingTime.value,
                                          );
                                        } else {
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.fertilizing,
                                            message: AppLocalizations.of(
                                              context,
                                            )!.enableFertilizing,
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: spacerSize12,
                                          //  bottom: spacerSize12,
                                          right: spacerSize5,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: spacerSize20,
                                              color: AppColors.grey,
                                            ),
                                            SizedBox(width: spacerSize4),
                                            BaseText(
                                              text: AppLocalizations.of(context)!.preferred,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text: controller.fertilizingTime.value.isNotEmpty
                                                  ? BaseDateTimeFormat.format(
                                                      dateTime: controller.fertilizingTime.value,
                                                      format: "hh:mm a",
                                                    )
                                                  : AppLocalizations.of(context)!.selectTime,
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
                                    AddNote(
                                      title: controller.fertilizingNote.value.isEmpty
                                          ? AppStrings.addNote
                                          : AppStrings.viewNote,
                                      onTap: () {
                                        if (controller.isFertilizingOn.value) {
                                          controller.fertilizeController.text =
                                              controller.fertilizingNote.value;
                                          addNoteDialog(
                                            context,
                                            controller.fertilizeController,
                                            controller.fertilizeController.text.isNotEmpty
                                                ? AppStrings.editNote
                                                : AppStrings.addANote,
                                            controller.fertilizingNote,
                                            "${controller.getType(CareType.fertilizing).toLowerCase()} alert.",
                                          );
                                        } else {
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.fertilizing,
                                            message: AppLocalizations.of(
                                              context,
                                            )!.enableFertilizing,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ).marginOnly(bottom: spacerSize10),

                            Obx(
                              () => PlantToggleCard(
                                iconColor: AppColors.orangeColor,
                                backgroundColor: AppColors.orangeColor.withValues(alpha: 0.2),
                                icon: Assets.imagesPruning,
                                title:
                                    "${AppLocalizations.of(context)!.pruning}\t${AppLocalizations.of(context)!.alerts}",
                                subTitle: "Manage general alerts and notifications",
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
                                          FrequencyBottomSheet.show(controller, CareType.pruning);
                                        } else {
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.pruning,
                                            message: AppLocalizations.of(context)!.enablePruning,
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: spacerSize12,
                                          top: spacerSize12,
                                          //      bottom: spacerSize12,
                                          right: spacerSize5,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              size: spacerSize20,
                                              color: AppColors.grey,
                                            ),
                                            SizedBox(width: spacerSize4),
                                            BaseText(
                                              text: AppLocalizations.of(context)!.frequency,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text: controller.pruningFrequency.value != 0
                                                  ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.pruningFrequency.value}\t${controller.pruningFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                                  : AppLocalizations.of(context)!.selectFrequency,

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
                                        if (controller.isPruningOn.value) {
                                          controller.pickerTime(
                                            context,
                                            CareType.pruning,
                                            controller.pruningTime.value,
                                          );
                                        } else {
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.pruning,
                                            message: AppLocalizations.of(context)!.enablePruning,
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: spacerSize12,
                                          //    bottom: spacerSize12,
                                          right: spacerSize5,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: spacerSize20,
                                              color: AppColors.grey,
                                            ),
                                            SizedBox(width: spacerSize4),
                                            BaseText(
                                              text: AppLocalizations.of(context)!.preferred,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text: controller.pruningTime.value.isNotEmpty
                                                  ? BaseDateTimeFormat.format(
                                                      dateTime: controller.pruningTime.value,
                                                      format: "hh:mm a",
                                                    )
                                                  : AppLocalizations.of(context)!.selectTime,
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
                                    AddNote(
                                      title: controller.pruningNote.value.isEmpty
                                          ? AppStrings.addNote
                                          : AppStrings.viewNote,
                                      onTap: () {
                                        if (controller.isPruningOn.value) {
                                          controller.pruningController.text =
                                              controller.pruningNote.value;
                                          addNoteDialog(
                                            context,
                                            controller.pruningController,
                                            controller.pruningController.text.isNotEmpty
                                                ? AppStrings.editNote
                                                : AppStrings.addANote,
                                            controller.pruningNote,
                                            "${controller.getType(CareType.pruning).toLowerCase()} alert.",
                                          );
                                        } else {
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.pruning,
                                            message: AppLocalizations.of(context)!.enablePruning,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ).marginOnly(bottom: spacerSize10),
                            ),

                            Obx(
                              () => PlantToggleCard(
                                iconColor: AppColors.organicColor,
                                backgroundColor: AppColors.organicColor.withValues(alpha: 0.2),
                                icon: Assets.imagesGeneralNoti,
                                title:
                                    "${AppLocalizations.of(context)!.general}\t${AppLocalizations.of(context)!.options}",
                                subTitle: "Manage general alerts and notifications",
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
                                          FrequencyBottomSheet.show(controller, CareType.critical);
                                        } else {
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.criticalCare,
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
                                          //   bottom: spacerSize12,
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
                                              text: controller.criticalCareFrequency.value != 0
                                                  ? '${AppLocalizations.of(Get.context!)!.every}\t${controller.criticalCareFrequency.value}\t${controller.criticalCareFrequency.value == 1 ? AppLocalizations.of(Get.context!)!.day : AppLocalizations.of(Get.context!)!.days}'
                                                  : AppLocalizations.of(context)!.selectFrequency,

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
                                    Divider(thickness: 1),
                                    InkWell(
                                      onTap: () {
                                        if (controller.isCriticalOn.value) {
                                          controller.pickerTime(
                                            context,
                                            CareType.critical,
                                            controller.criticalTime.value,
                                          );
                                        } else {
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.criticalCare,
                                            message: AppLocalizations.of(
                                              context,
                                            )!.enableCriticalCare,
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: spacerSize12,
                                          //  bottom: spacerSize12,
                                          right: spacerSize5,
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: spacerSize20,
                                              color: AppColors.grey,
                                            ),
                                            SizedBox(width: spacerSize4),
                                            BaseText(
                                              text: AppLocalizations.of(context)!.preferred,
                                              fontFamily: AppKeys.inter,
                                              fontSize: fontSize12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            Spacer(),
                                            BaseText(
                                              text: controller.criticalTime.value.isNotEmpty
                                                  ? BaseDateTimeFormat.format(
                                                      dateTime: controller.criticalTime.value,
                                                      format: "hh:mm a",
                                                    )
                                                  : AppLocalizations.of(context)!.selectTime,
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
                                    AddNote(
                                      title: controller.criticalNote.value.isEmpty
                                          ? AppStrings.addNote
                                          : AppStrings.viewNote,
                                      onTap: () {
                                        if (controller.isCriticalOn.value) {
                                          controller.criticalController.text =
                                              controller.criticalNote.value;
                                          addNoteDialog(
                                            context,
                                            controller.criticalController,
                                            controller.criticalController.text.isNotEmpty
                                                ? AppStrings.editNote
                                                : AppStrings.addANote,
                                            controller.criticalNote,
                                            "${controller.getType(CareType.critical).toLowerCase()} alert.",
                                          );
                                        } else {
                                          controller.showSnackBar(
                                            title: AppLocalizations.of(context)!.criticalCare,
                                            message: AppLocalizations.of(
                                              context,
                                            )!.enableCriticalCare,
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ).marginOnly(bottom: spacerSize10),
                            ),
                            PlantCareTipCard(
                              green: AppColors.greenColor,
                              lightGreen: AppColors.lightGreen,
                            ),
                          ],
                        ),
                ).paddingOnly(right: spacerSize10, left: spacerSize10),

                SizedBox(height: 25.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget plantTitle() {
    controller.plantDetailData.value.data?.alreadyAdded ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacerSize10,
      children: [
        CircularImageCard(
          imageUrl: controller.plantDetailData.value.data?.plant?.imageUrl ?? "",
          size: spacerSize70,
        ),

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
                    controller.plantDetailData.value.data?.plant?.scientificName ??
                    AppLocalizations.of(Get.context!)!.noDataNa,
                fontFamily: AppKeys.inter,
                fontSize: fontSize14,
                fontWeight: FontWeight.w400,
                textColor: AppColors.liteGreyColor,
              ),
              if (controller.plantDetailData.value.data?.plant?.otherName != null &&
                  controller.plantDetailData.value.data!.plant!.otherName!.isNotEmpty)
                BaseText(
                  text:
                      "Also known as: ${controller.plantDetailData.value.data?.plant?.otherName ?? AppLocalizations.of(Get.context!)!.noDataNa}",
                  fontFamily: AppKeys.inter,
                  fontSize: fontSize12,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.liteGreyColor,
                ),
            ],
          ),
        ),
        Obx(() {
          final isAdded = controller.screenType.value == "edit";
          return isAdded
              ? Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.greenColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.greenColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, color: AppColors.greenColor, size: spacerSize16.w),
                      SizedBox(width: 6.w),
                      Text(
                        'Added',
                        style: TextStyle(
                          color: AppColors.greenColor,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppKeys.inter,
                        ),
                      ),
                    ],
                  ),
                )
              : CommonClickWidget(
                  onTap: () {
                    controller.validateAndSubmit(Get.context!);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColors.greenColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greenColor.withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Text(
                      AppLocalizations.of(Get.context!)!.addPlant,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                );
        }),
      ],
    );
  }
}
