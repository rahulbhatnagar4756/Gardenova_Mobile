import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../base/widgets/base_app_bar.dart';
import '../../../base/widgets/base_shimmer.dart';
import '../../../base/widgets/base_text.dart';
import '../../../base/widgets/base_text_field.dart';
import '../../../base/widgets/circular_bottom_app_bar.dart';
import '../../../dashboard/components/full_drawer.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../model/plant_model.dart';
import '../../myPlants/myPlantsList/components/my_plants_header_delegate.dart';
import 'add_plants_controller.dart';

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
              // preferredSize: Size.fromHeight(spacerSize80),
              preferredSize: Size.fromHeight(110.h + 30.h),
              child: Builder(
                builder: (context) {
                  return CircularBottomAppBar(
                    isBackButtonVisible: true,
                    showMenuIcon: true,
                    onSettingPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                },
              ),
            )
          : BaseAppBar(isBackButtonVisible: false),

      body: RefreshIndicator(
        onRefresh: () async {
          // controller.pageNumber.value = 1;
          // await controller.callGetAllPlantListApi();
          controller.isRefreshing.value = true;

          controller.pageNumber.value = 1;

          await controller.callGetAllPlantListApi();

          controller.isRefreshing.value = false;
        },
        child: Obx(
          () => CustomScrollView(
            controller: controller.scrollController,
            // physics: const BouncingScrollPhysics(
            //   parent: AlwaysScrollableScrollPhysics(),
            // ),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              /// 🔹 HEADER (TITLE + SEARCH)
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(
              //       horizontal: spacerSize20,
              //       vertical: spacerSize20,
              //     ),
              //     child: titleWithSearch(context),
              //   ),
              // ),
              SliverPersistentHeader(
                floating: true,
                pinned: false,
                delegate: MyPlantsHeaderDelegate(
                  minHeight: 200.h,
                  maxHeight: 200.h,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: spacerSize20,
                      right: spacerSize20,
                      // top: spacerSize20,
                      // vertical: spacerSize20,
                    ),
                    child: titleWithSearch(context),
                  ),
                ),
              ),

              /// 🔹 LIST DATA
              controller.allPlantList.isEmpty && controller.isLoading.value
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: spacerSize50),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  : controller.allPlantList.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: BaseText(
                          text: AppLocalizations.of(context)!.noPlantsFound,
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: spacerSize20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, rowIndex) {
                            int firstIndex = rowIndex * 2;
                            int secondIndex = firstIndex + 1;

                            PlantModel firstPlant =
                                controller.allPlantList[firstIndex];

                            PlantModel? secondPlant =
                                secondIndex < controller.allPlantList.length
                                ? controller.allPlantList[secondIndex]
                                : null;

                            return Padding(
                              padding: EdgeInsets.only(bottom: spacerSize15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: plantCard(firstPlant, firstIndex),
                                  ),
                                  SizedBox(width: spacerSize15),
                                  Expanded(
                                    child: secondPlant != null
                                        ? plantCard(secondPlant, secondIndex)
                                        : SizedBox(),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: (controller.allPlantList.length / 2)
                              .ceil(),
                        ),
                      ),
                    ),

              /// 🔹 BOTTOM LOAD MORE LOADER (IMPORTANT)
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.isLoadMoreRunning.value) {
                    return SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: spacerSize20),
                        child: Center(
                          child: SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox();
                  }
                }),
              ),

              /// 🔹 EXTRA SPACE (better UX)
              SliverToBoxAdapter(child: SizedBox(height: spacerSize20)),
            ],
          ),
        ),
      ),
    );
  }

  //   /// 🔹 HEADER UI
  Widget titleWithSearch(BuildContext context) {
    return Container(
      color: AppColors.appColor,
      child: LayoutBuilder(
        builder: (context, constrantBox) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: spacerSize20),
              BaseText(
                text: AppLocalizations.of(context)!.addYourFirstPlant,
                fontSize: fontSize20,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: spacerSize10),

              BaseText(
                text: AppLocalizations.of(
                  context,
                )!.addYourFirstPlantDescription,
                textColor: AppColors.liteGreyColor,
              ),
              SizedBox(height: spacerSize10),

              BaseTextField(
                textEditingController: controller.searchController,
                hintText: AppLocalizations.of(context)!.searchYourPlant,
                suffixIcon: Icon(Icons.search, color: AppColors.liteGreyColor),
                onChanged: (value) {
                  controller.pageNumber.value = 1;
                  controller.isSearching.value = true;

                  controller.debouncer.call(() {
                    FocusScope.of(Get.context!).unfocus();
                    controller.callGetAllPlantListApi(searchName: value);
                  });

                  controller.isSearching.value = false;
                },
              ),
              SizedBox(height: spacerSize16),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacerSize10,
                  vertical: spacerSize6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.greenColor,
                  borderRadius: BorderRadius.circular(spacerSize20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image.asset(
                    //   Assets.imagesPruning,
                    //   height: spacerSize12,
                    //   width: spacerSize12,
                    //   color: Colors.white,
                    // ),
                    Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: spacerSize12,
                    ),

                    SizedBox(width: spacerSize4),
                    BaseText(
                      text: AppLocalizations.of(context)!.trendingPlants,
                      fontSize: fontSize12,
                      textColor: AppColors.offWhite,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔹 CARD
  Widget plantCard(PlantModel plant, int index) {
    return GestureDetector(
      onTap: () {
        controller.selectPlant(index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greenColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(spacerSize16),
          border: Border.all(
            color: AppColors.greenColor.withValues(alpha: 0.2),
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
                height: spacerSize120,
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: plant.imageUrl ?? "",
                placeholder: (_, __) =>
                    BaseShimmer(borderRadious: spacerSize15),
                errorWidget: (_, __, ___) => Icon(Icons.broken_image),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacerSize12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: spacerSize6),
                  BaseText(
                    text:
                        plant.commonName ??
                        AppLocalizations.of(Get.context!)!.noDataNa,
                    fontWeight: FontWeight.w600,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: spacerSize4),
                  BaseText(
                    text: plant.scientificName ?? "",
                    fontSize: fontSize12,
                    textColor: AppColors.liteGreyColor,
                    maxLines: 2,
                  ),
                  SizedBox(height: spacerSize10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
