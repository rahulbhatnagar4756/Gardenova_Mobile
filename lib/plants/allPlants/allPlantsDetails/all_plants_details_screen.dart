import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kasagardem/services/admob_service.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

import '../../../base/widgets/base_button.dart';
import '../../../base/widgets/base_shimmer.dart';
import '../../../base/widgets/clickable_image.dart';
import '../../../l10n/app_localizations.dart';
import 'all_plants_details_controller.dart';
import 'components/main_content_card.dart';

class AllPlantsDetailsScreen extends GetWidget<AllPlantsDetailsController> {
  const AllPlantsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _loadingView();
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return _errorView(controller.errorMessage.value);
      }

      if (controller.plantDetailData.value.data == null) {
        return _noDataView();
      }

      return Scaffold(
        backgroundColor: AppColors.appColor,
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned(top: 0, left: 0, right: 0, child: imageCard()),
                  MainContentCard(controller: controller),
                  backButton(),
                ],
              ),
            ),
            if (controller.screenType.value == "edit")
              BaseButton(
                buttonLabel: AppStrings.saveChanges,
                buttonWidth: double.infinity,
                onPressed: () {
                  //Get.toNamed(Routes.plantRemindersListing);
                  controller.validateAndSubmit(context);
                },
              ).marginAll(spacerSize10),
            Obx(() {
              if (AdMobService.instance.shouldShowBanners &&
                  controller.isAdLoaded.value &&
                  controller.bannerAd != null) {
                return Container(
                  alignment: Alignment.center,
                  width: controller.bannerAd!.size.width.toDouble().w,
                  height: controller.bannerAd!.size.height.toDouble().h,
                  child: AdWidget(ad: controller.bannerAd!),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      );
    });
  }

  Widget _loadingView() {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Stack(
        children: [
          // 1. Image Shimmer
          const BaseShimmer(height: spacerSize350),

          // 2. Content Card Shimmer
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: spacerSize300),
                Container(
                  padding: const EdgeInsets.all(spacerSize20),
                  decoration: const BoxDecoration(
                    color: AppColors.appColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(spacerSize30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title Shimmer
                      const BaseShimmer(height: 30, width: 200, borderRadious: 8),
                      const SizedBox(height: 12),
                      // Subtitle Shimmer
                      const BaseShimmer(height: 20, width: 150, borderRadious: 6),
                      const SizedBox(height: 24),
                      // Description Shimmer
                      const BaseShimmer(height: 16, borderRadious: 4),
                      const SizedBox(height: 8),
                      const BaseShimmer(height: 16, borderRadious: 4),
                      const SizedBox(height: 8),
                      const BaseShimmer(height: 16, width: 200, borderRadious: 4),
                      const SizedBox(height: 32),

                      // Quick Info Shimmer (Horizontal List)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                            4,
                            (index) => const Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: BaseShimmer(height: 110, width: 140, borderRadious: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Care Overview Shimmer Section
                      const BaseShimmer(height: 25, width: 150, borderRadious: 6),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(spacerSize16),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundGrey.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(spacerSize18),
                          border: Border.all(color: AppColors.backgroundGrey),
                        ),
                        child: Column(
                          children: List.generate(
                            4,
                            (index) => Column(
                              children: [
                                Row(
                                  children: [
                                    const BaseShimmer(height: 24, width: 24, borderRadious: 12),
                                    const SizedBox(width: 12),
                                    const BaseShimmer(height: 14, width: 100, borderRadious: 4),
                                    const Spacer(),
                                    const BaseShimmer(height: 12, width: 60, borderRadious: 4),
                                  ],
                                ),
                                if (index < 3) const Divider(color: AppColors.backgroundGrey),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Special Traits Shimmer Section
                      const BaseShimmer(height: 25, width: 150, borderRadious: 6),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(
                          5,
                          (index) => const BaseShimmer(height: 35, width: 110, borderRadious: 100),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Plant Health Shimmer
                      const BaseShimmer(height: 25, width: 150, borderRadious: 6),
                      const SizedBox(height: 16),
                      const BaseShimmer(height: 120, borderRadious: 18),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Back Button
          backButton(),
        ],
      ),
    );
  }

  Widget _errorView(String message) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Stack(
        children: [
          backButton(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 60, color: Colors.red),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    if (controller.screenType.value == "add") {
                      controller.callGetPlantDetailsApi();
                    } else {
                      controller.callGetMyPlantDetailsApi();
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenColor),
                  child: Text("Retry", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _noDataView() {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Stack(
        children: [
          backButton(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.eco_outlined, size: 60, color: AppColors.greenColor),
                SizedBox(height: 16),
                Text(
                  AppStrings.noDetailsFoundForThisPlant,
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addPlantButton(BuildContext context, bool addPlant) {
    return SizedBox(
      width: 80.w,
      child: BaseButton(
        onPressed: () {
          controller.validateAndSubmit(context);
        },
        backgroundColor: AppColors.burntGold,
        buttonLabel: addPlant ? AppLocalizations.of(context)!.addPlant : 'Save Changes',
        fontSize: fontSize16,
        textColor: Colors.white,
        buttonWidth: double.infinity,
      ),
    );
  }

  Widget imageCard() {
    final imageUrl = controller.plantDetailData.value.data?.plant?.imageUrl ?? "";

    return Container(
      color: AppColors.charcoalGrey,
      child: ClickableImage(
        imageUrl: imageUrl,
        height: spacerSize350,
        width: double.infinity,
        fit: BoxFit.cover,
        heroTag: "plant_detail_image",
        errorWidget: Icon(Icons.broken_image, color: AppColors.offWhite, size: spacerSize40),
      ),
    );
  }

  Widget backButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: spacerSize10, top: spacerSize16),
        child: CircleAvatar(
          backgroundColor: Colors.black38,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
        ),
      ),
    );
  }
}
