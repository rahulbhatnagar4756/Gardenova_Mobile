import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../base/widgets/base_app_bar.dart';
import '../../../base/widgets/base_back_button.dart';
import '../../../base/widgets/base_shimmer.dart';
import '../../../base/widgets/base_text.dart';
import '../../../base/widgets/base_text_field.dart';
import '../../../base/widgets/circular_bottom_app_bar.dart';
import '../../../dashboard/components/full_drawer.dart';
import '../../../generated/assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';
import 'all_plants_controller.dart';

class AllPlantsListScreen extends GetWidget<AllPlantsController> {
  const AllPlantsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      drawer: FullScreenDrawer(
        onTap: (index) {
          controller.navigateToNext(index);
        },
      ),
      appBar: controller.isUserLoggedIn.value
          ? PreferredSize(
              preferredSize: Size.fromHeight(spacerSize80),
              child: Builder(
                builder: (context) {
                  return CircularBottomAppBar(
                    showMenuIcon: true,
                    onSettingPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            )
          : BaseAppBar(isBackButtonVisible: false),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseBackButton(),
        ],
      ).marginOnly(
        bottom: spacerSize15,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.callGetAllPlantListApi();
        },
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: spacerSize20,
            vertical: spacerSize20,
          ),
          child: Column(
            spacing: spacerSize12,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWithSearch(context),
              Expanded(child: allPlantItem(context)),
              //BaseBackButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget titleWithSearch(BuildContext context) {
    return Column(
      spacing: spacerSize10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText(
          text: AppLocalizations.of(context)!.addYourFirstPlant,
          textAlign: TextAlign.center,
          fontFamily: AppKeys.poppins,
          textColor: AppColors.offWhite,
          fontSize: fontSize20,
          fontWeight: FontWeight.w500,
        ).marginOnly(top: spacerSize10),

        BaseText(
          text: AppLocalizations.of(context)!.addYourFirstPlantDescription,
          fontFamily: AppKeys.inter,
          textColor: AppColors.offWhite70,
          fontSize: fontSize14,
          fontWeight: FontWeight.w400,
        ).marginOnly(bottom: spacerSize10),

        BaseTextField(
          textEditingController: controller.searchController,
          hintText: AppLocalizations.of(context)!.searchYourPlant,
          hintColor: AppColors.offWhite70,
          prefixIcon: Icon(Icons.search, color: AppColors.amberGold),
          onChanged: (value) {
            if (value.isEmpty) {
              controller.pageNumber.value = 1;
            }
            controller.isSearching.value = true;
            controller.debouncer.call(() {
              FocusScope.of(Get.context!).unfocus();
              controller.callGetAllPlantListApi(searchName: value);
            });
            controller.isSearching.value = false;
          },
        ).marginOnly(bottom: spacerSize16),

        Container(
          margin: EdgeInsets.only(bottom: spacerSize12),
          padding: EdgeInsets.symmetric(
            horizontal: spacerSize10,
            vertical: spacerSize6,
          ),
          decoration: BoxDecoration(
            color: AppColors.harvestGold,
            borderRadius: BorderRadius.circular(spacerSize20),
          ),
          child: Row(
            spacing: spacerSize4,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Assets.imagesPruning,
                height: spacerSize12,
                width: spacerSize12,
                color: Colors.white,
              ),

              BaseText(
                text: AppLocalizations.of(context)!.trendingPlants,
                fontSize: fontSize12,
                fontFamily: AppKeys.inter,
                fontWeight: FontWeight.w500,
                textColor: AppColors.offWhite,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget allPlantItem(BuildContext context) {
    return Obx(
      () => NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!controller.isLoadMoreRunning.value &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              controller.isLoadMoreVisible.value) {
            controller.loadMorePlants();
          }
          return false;
        },
        child: controller.allPlantList.isNotEmpty
                  ? ListView.builder(
                      itemCount: (controller.allPlantList.length / 2).ceil(),
                      itemBuilder: (context, rowIndex) {
                        int firstIndex = rowIndex * 2;
                        int secondIndex = firstIndex + 1;

                        var firstPlant = controller.allPlantList[firstIndex];
                        var secondPlant =
                            secondIndex < controller.allPlantList.length
                            ? controller.allPlantList[secondIndex]
                            : null;

                        return Padding(
                          padding: EdgeInsets.only(bottom: spacerSize15),
                          child: IntrinsicHeight(
                            child: Row(
                              spacing: spacerSize15,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: plantCard(firstPlant, firstIndex),
                                ),
                                Expanded(
                                  child: secondPlant != null
                                      ? plantCard(secondPlant, secondIndex)
                                      : SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: BaseText(
                        text: AppLocalizations.of(context)!.noPlantsFound,
                        textColor: AppColors.offWhite,
                        fontWeight: FontWeight.w700,
                        fontFamily: AppKeys.poppins,
                        fontSize: fontSize14,
                      ),
                    )
      ),
    );
  }

  Widget plantCard(var plant, int index) {
    return GestureDetector(
      onTap: () {
        controller.selectPlant(index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkGreen,
          borderRadius: BorderRadius.circular(spacerSize15),
          border: Border.all(
            color: plant.isSelected
                ? AppColors.borderGold
                : AppColors.offWhite10,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(spacerSize15),
                topRight: Radius.circular(spacerSize15),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                height: spacerSize120,
                width: double.infinity,
                imageUrl: plant.imageUrl ?? "",
                placeholder: (context, url) => BaseShimmer(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.broken_image, color: AppColors.offWhite10),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacerSize12),
              child: Column(
                spacing: spacerSize8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    text: plant.commonName ?? "",
                    fontFamily: AppKeys.poppins,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.offWhite,
                  ).marginOnly(top: spacerSize6),

                  BaseText(
                    text: plant.scientificName ?? "",
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.offWhite70,
                  ).marginOnly(bottom: spacerSize10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
