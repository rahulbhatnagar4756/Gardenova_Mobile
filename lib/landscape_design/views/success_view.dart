import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/clickable_image.dart';
import 'package:kasagardem/base/widgets/full_screen_image_preview.dart';
import 'package:kasagardem/base/widgets/status_bar_overlap_scroll_view.dart';
import 'package:kasagardem/landscape_design/landscape_design_view_model.dart';
import 'package:kasagardem/landscape_design/model/landscape_design_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import '../../dashboard/components/landscape_style_bottom_sheet.dart';

class LandscapeDesignSuccessView extends StatelessWidget {
  final LandscapeDesignViewModel controller;

  const LandscapeDesignSuccessView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final data = controller.landscapeResponse.value.data;
    if (data == null) return const SizedBox();

    return Stack(
      children: [
        /// 🔹 GENERATED IMAGE (MAIN BACKGROUND)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClickableImage(
            imageUrl: data.gardenUrl ?? "",
            height: spacerSize350,
            width: double.infinity,
            fit: BoxFit.cover,
            heroTag: "landscape_result_image",
          ),
        ),

        /// 🔹 SCROLLABLE CONTENT
        StatusBarOverlapScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (data.gardenUrl != null && data.gardenUrl!.isNotEmpty) {
                    FullScreenImageView.open(
                      imageUrl: data.gardenUrl!,
                      heroTag: "landscape_result_image",
                    );
                  }
                },
                child: Container(
                  height: spacerSize300,
                  color: Colors.transparent,
                ),
              ),

              // Content Card
              Container(
                width: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BaseText(
                          text: "Landscape Transformation",
                          fontSize: fontSize22,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppKeys.poppins,
                        ),
                      ],
                    ),
                    const SizedBox(height: spacerSize16),

                    /// 🔹 STYLE SELECTION SELECTOR (BOTTOM SHEET)
                    GestureDetector(
                      onTap: () async {
                        final selected = await LandscapeStyleBottomSheet.show();
                        if (selected != null) {
                          controller.updateStyle(selected);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacerSize16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.greenColor.withValues(alpha: 0.15),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => BaseText(
                                text: controller.selectedStyle.value
                                    .replaceAll('_', ' ')
                                    .toUpperCase(),
                                fontSize: fontSize14,
                                textColor: AppColors.blackColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.greenColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: spacerSize16),

                    /// 🔹 REGENERATE BUTTON
                    GestureDetector(
                      onTap: () => controller.generateLandscapeDesign(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: AppColors.linearGradientForBtn,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            const SizedBox(width: 8),
                            const BaseText(
                              text: "Regenerate Design",
                              textColor: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: spacerSize16),

                    /// 🔹 DESCRIPTION BOX
                    Container(
                      padding: const EdgeInsets.all(spacerSize16),
                      decoration: BoxDecoration(
                        color: AppColors.greenColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.greenColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: AppColors.greenColor,
                                size: 20.sp,
                              ),
                              const SizedBox(width: 8),
                              const BaseText(
                                text: "AI Analysis & Suggestions",
                                fontWeight: FontWeight.w600,
                                textColor: AppColors.greenColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          BaseText(
                            text:
                                data.description ?? "No description available",
                            textColor: AppColors.liteGreyColor,
                          ),
                        ],
                      ),
                    ),

                    if (data.recommendedPlants?.hasPlants == true) ...[
                      const SizedBox(height: spacerSize24),
                      _RecommendedPlantsSection(
                        recommendedPlants: data.recommendedPlants!,
                      ),
                    ],

                    const SizedBox(height: spacerSize24),

                    /// 🔹 COMPARISON SECTION
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BaseText(
                          text: "Original Vision",
                          fontSize: fontSize18,
                          fontWeight: FontWeight.w600,
                          fontFamily: AppKeys.poppins,
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.download,
                                color: AppColors.greenColor,
                                size: 20,
                              ),
                              onPressed: () =>
                                  controller.downloadAndSaveToGallery(
                                    data.originalUrl ?? "",
                                  ),
                            ),
                            // IconButton(
                            //   icon: const Icon(
                            //     Icons.share,
                            //     color: AppColors.greenColor,
                            //     size: 20,
                            //   ),
                            //   onPressed: () => controller.downloadAndShareImage(
                            //     data.originalUrl ?? "",
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ClickableImage(
                        imageUrl: data.originalUrl ?? "",
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(height: spacerSize28),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// 🔹 BACK BUTTON
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
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),

        /// 🔹 TOP ACTION BUTTONS (DOWNLOAD & SHARE)
        Positioned(
          top: spacerSize16.h + spacerSize30.h,
          right: spacerSize16.w,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: const Icon(Icons.download, color: Colors.white),
                  onPressed: () => controller.downloadAndSaveToGallery(
                    controller.landscapeResponse.value.data?.gardenUrl ?? "",
                  ),
                ),
              ),
              // const SizedBox(width: 8),
              // CircleAvatar(
              //   backgroundColor: Colors.black45,
              //   child: IconButton(
              //     icon: const Icon(Icons.share, color: Colors.white),
              //     onPressed: () => controller.downloadAndShareImage(
              //       controller.landscapeResponse.value.data?.gardenUrl ?? "",
              //     ),
              //   ),
              // ),
            ],
          ),
        ),

        /// 🔹 DOWNLOAD LOADING OVERLAY
        Obx(
          () => controller.isDownloading.value
              ? Container(
                  color: Colors.black26,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.greenColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _RecommendedPlantsSection extends StatelessWidget {
  const _RecommendedPlantsSection({required this.recommendedPlants});

  final RecommendedPlants recommendedPlants;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final plants = recommendedPlants.plants;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText(
          text: l10n.plantRecommendations,
          fontSize: fontSize18,
          fontWeight: FontWeight.w600,
          fontFamily: AppKeys.poppins,
        ),
        if (_hasMeta) ...[
          const SizedBox(height: spacerSize12),
          Wrap(
            spacing: spacerSize8,
            runSpacing: spacerSize8,
            children: [
              if (recommendedPlants.region?.trim().isNotEmpty == true)
                _MetaChip(
                  icon: Icons.location_on_outlined,
                  label:
                      '${l10n.region}: ${_prettyLabel(recommendedPlants.region)}',
                ),
              if (recommendedPlants.climate?.trim().isNotEmpty == true)
                _MetaChip(
                  icon: Icons.thermostat_outlined,
                  label: _prettyLabel(recommendedPlants.climate),
                ),
            ],
          ),
        ],
        const SizedBox(height: spacerSize12),
        ...plants.map(
          (plant) => Padding(
            padding: const EdgeInsets.only(bottom: spacerSize12),
            child: _RecommendedPlantCard(plant: plant),
          ),
        ),
      ],
    );
  }

  bool get _hasMeta =>
      recommendedPlants.region?.trim().isNotEmpty == true ||
      recommendedPlants.climate?.trim().isNotEmpty == true;
}

class _RecommendedPlantCard extends StatelessWidget {
  const _RecommendedPlantCard({required this.plant});

  final RecommendedPlant plant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(spacerSize16),
      decoration: BoxDecoration(
        color: AppColors.greenColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: AppColors.lightGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_florist_rounded,
                  color: AppColors.greenColor,
                  size: 22.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      text: plant.commonName ?? '',
                      fontSize: fontSize16,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppKeys.poppins,
                    ),
                    if (plant.latinName?.trim().isNotEmpty == true) ...[
                      const SizedBox(height: 2),
                      BaseText(
                        text: plant.latinName!,
                        fontSize: fontSize12,
                        fontFamily: AppKeys.inter,
                        fontWeight: FontWeight.w400,
                        textColor: AppColors.liteGreyColor,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (_hasTags) ...[
            const SizedBox(height: spacerSize12),
            Wrap(
              spacing: spacerSize8,
              runSpacing: spacerSize8,
              children: [
                if (plant.type?.trim().isNotEmpty == true)
                  _MetaChip(
                    icon: Icons.eco_outlined,
                    label: _prettyLabel(plant.type),
                  ),
                if (plant.sunlight?.trim().isNotEmpty == true)
                  _MetaChip(
                    icon: Icons.wb_sunny_outlined,
                    label: _prettyLabel(plant.sunlight),
                  ),
                if (plant.waterNeeds?.trim().isNotEmpty == true)
                  _MetaChip(
                    icon: Icons.water_drop_outlined,
                    label: _prettyLabel(plant.waterNeeds),
                  ),
              ],
            ),
          ],
          if (plant.notes?.trim().isNotEmpty == true) ...[
            const SizedBox(height: spacerSize12),
            BaseText(
              text: plant.notes!,
              fontSize: fontSize13,
              fontFamily: AppKeys.inter,
              fontWeight: FontWeight.w400,
              textColor: AppColors.liteGreyColor,
            ),
          ],
        ],
      ),
    );
  }

  bool get _hasTags =>
      plant.type?.trim().isNotEmpty == true ||
      plant.sunlight?.trim().isNotEmpty == true ||
      plant.waterNeeds?.trim().isNotEmpty == true;
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.w, color: AppColors.greenColor),
          SizedBox(width: 6.w),
          BaseText(
            text: label,
            fontSize: fontSize11,
            fontFamily: AppKeys.inter,
            fontWeight: FontWeight.w500,
            textColor: AppColors.darkGreenColor,
          ),
        ],
      ),
    );
  }
}

String _prettyLabel(String? value) {
  if (value == null || value.trim().isEmpty) return '';
  return value
      .replaceAll('_', ' ')
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
