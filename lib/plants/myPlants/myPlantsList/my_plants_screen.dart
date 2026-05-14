import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';
import 'package:kasagardem/plants/myPlants/myPlantsList/components/my_plants_header_delegate.dart';

import '../../../base/widgets/base_shimmer.dart';

import '../../../base/widgets/base_app_bar.dart';
import '../../../base/widgets/base_button.dart';
import '../../../base/widgets/base_text.dart';
import '../../../base/widgets/circular_bottom_app_bar.dart';
import '../../../dashboard/components/full_drawer.dart';
import '../../../generated/assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';
import '../../../utils/routes.dart';
import '../../../utils/utils.dart';
import 'components/my_plants_list_item.dart';
import 'my_plants_controller.dart';

class MyPlantsScreen extends GetView<MyPlantsController> {
  const MyPlantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,

      /// 🔹 Drawer
      drawer: FullScreenDrawer(
        onTap: (index) {
          controller.navigateToNext(index);
        },
      ),

      /// 🔹 AppBar (only this needs Obx)
      appBar: PreferredSize(
        // preferredSize: Size.fromHeight(spacerSize80),
        preferredSize: Size.fromHeight(110.h + 30.h),
        child: Obx(() {
          return controller.isUserLoggedIn.value
              ? Builder(
                  builder: (context) {
                    return CircularBottomAppBar(
                      isBackButtonVisible: true,
                      showMenuIcon: true,
                      onSettingPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                )
              : BaseAppBar(isBackButtonVisible: false);
        }),
      ),

      /// 🔹 BODY
      body: RefreshIndicator(
        onRefresh: () async {
          controller.pageNumber.value = 1;
          await controller.callGetMyPlantListApi();
        },

        /// 🚀 IMPORTANT: Obx wraps CustomScrollView to handle slivers correctly
        child: Obx(
          () => CustomScrollView(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              /// 🔹 HEADER
              SliverPersistentHeader(
                floating: true,
                pinned: false,
                delegate: MyPlantsHeaderDelegate(
                  minHeight: 210.h,
                  maxHeight: 210.h,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacerSize20),
                    child: titleWithSearch(context),
                  ),
                ),
              ),

              /// 🔹 LIST / EMPTY / LOADING
              if (controller.myPlantList.isEmpty && controller.isLoading.value)
                _shimmerList()
              else if (controller.myPlantList.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _emptyState(context),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.only(
                    left: spacerSize20,
                    right: spacerSize20,
                    bottom: 25.h,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      var item = controller.myPlantList[index];

                      return MyPlantsListItem(
                        item: item,
                        onTap: () {
                          Get.toNamed(
                            Routes.myPlantsDetails,
                            arguments: item.plantId,
                          )?.then((value) {
                            Utils.hideKeyboard();
                          });
                        },
                      );
                    }, childCount: controller.myPlantList.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .81,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.w,
                    ),
                  ),
                ),

              /// 🔹 LOAD MORE LOADER
              SliverToBoxAdapter(
                child: controller.isLoadMoreRunning.value
                    ? Padding(
                        padding: EdgeInsets.only(
                          left: spacerSize20,
                          right: spacerSize20,
                          bottom: spacerSize20,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: .84,
                                crossAxisSpacing: 8.w,
                                mainAxisSpacing: 8.w,
                              ),
                          itemCount: 2,
                          itemBuilder: (context, index) => _shimmerListItem(),
                        ),
                      )
                    : const SizedBox(),
              ),

              /// 🔹 SPACE
              SliverToBoxAdapter(child: SizedBox(height: spacerSize20)),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 HEADER UI
  Widget titleWithSearch(BuildContext context) {
    return Container(
      color: AppColors.appColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: spacerSize20),
                BaseText(
                  text: AppLocalizations.of(context)!.myPlants,
                  fontFamily: AppKeys.poppins,
                  fontSize: fontSize20,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: spacerSize5),

                Obx(
                  () => BaseText(
                    text:
                        "${controller.myPlantList.length} ${controller.myPlantList.length == 1 ? AppLocalizations.of(context)!.plant : controller.plantPlural} ${AppLocalizations.of(context)!.andCounting}!",
                    fontFamily: AppKeys.inter,
                    textColor: AppColors.liteGreyColor,
                  ),
                ),
                SizedBox(height: spacerSize10),

                BaseButton(
                  buttonWidth: double.infinity,
                  buttonLabel: AppLocalizations.of(context)!.addPlant,
                  onPressed: () {
                    Get.toNamed(Routes.allPlantsScreen)?.then((value) {
                      Utils.hideKeyboard();
                      // controller.callGetMyPlantListApi();
                    });
                  },
                ),

                SizedBox(height: spacerSize25),

                BaseTextField(
                  textEditingController: controller.searchController,
                  hintText: AppLocalizations.of(context)!.searchYourPlant,
                  suffixIcon: Icon(
                    Icons.search,
                    color: AppColors.liteGreyColor,
                  ),
                  onChanged: (value) {
                    controller.pageNumber.value = 1;
                    controller.debouncer.call(() {
                      controller.callGetMyPlantListApi(searchName: value);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// 🔹 EMPTY STATE
  Widget _emptyState(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Utils.hideKeyboard();
          Get.toNamed(Routes.allPlantsScreen)!.then((_) {
            Utils.hideKeyboard();
            controller.callGetMyPlantListApi();
          });
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize14,
              fontWeight: FontWeight.w500,
              color: AppColors.blackColor,
              fontFamily: AppKeys.poppins,
            ),
            children: [
              TextSpan(text: "${AppLocalizations.of(context)!.tap} "),
              WidgetSpan(
                child: Image.asset(
                  color: AppColors.blackColor,
                  Assets.imagesAdd,
                  height: spacerSize12,
                  width: spacerSize12,
                ).paddingOnly(bottom: 3.h),
              ),
              TextSpan(
                text: " ${AppLocalizations.of(context)!.toAddYourFirstPlant}",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 SHIMMER LIST
  Widget _shimmerList() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: spacerSize20),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return _shimmerListItem();
        }, childCount: 6),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .84,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.w,
        ),
      ),
    );
  }

  /// 🔹 SHIMMER ITEM
  Widget _shimmerListItem() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.backgroundGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BaseShimmer(
            height: 105,
            width: double.infinity,
            borderRadious: 16,
          ),
          Padding(
            padding: EdgeInsets.all(spacerSize8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BaseShimmer(height: 14, width: 100, borderRadious: 4),
                SizedBox(height: spacerSize4),
                const BaseShimmer(height: 10, width: 60, borderRadious: 4),
                const SizedBox(height: spacerSize12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BaseShimmer(height: 18, width: 60, borderRadious: 20),
                    const BaseShimmer(height: 18, width: 60, borderRadious: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
