import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';
import 'package:kasagardem/plants/myPlants/myPlantsList/components/my_plants_header_delegate.dart';
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
        preferredSize: Size.fromHeight(spacerSize80),
        child: Obx(() {
          return controller.isUserLoggedIn.value
              ? Builder(
                  builder: (context) {
                    return CircularBottomAppBar(
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

        /// 🚀 IMPORTANT: NO Obx here
        child: CustomScrollView(
          controller: controller.scrollController,
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

            /// 🔹 LIST / EMPTY / LOADING (Obx here only)
            Obx(() {
              if (controller.myPlantList.isEmpty &&
                  controller.isLoading.value) {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: spacerSize50),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              if (controller.myPlantList.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _emptyState(context),
                );
              }

              return SliverPadding(
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
                        );
                      },
                    );
                  }, childCount: controller.myPlantList.length),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .85,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.w,
                  ),
                ),
              );
            }),

            /// 🔹 LOAD MORE LOADER (Obx only here)
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isLoadMoreRunning.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: spacerSize20),
                    child: const Center(
                      child: SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }),
            ),

            /// 🔹 SPACE
            SliverToBoxAdapter(child: SizedBox(height: spacerSize20)),
          ],
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

                BaseText(
                  text:
                      "${controller.myPlantList.length} ${controller.myPlantList.length == 1 ? AppLocalizations.of(context)!.plant : controller.plantPlural} ${AppLocalizations.of(context)!.andCounting}!",
                  fontFamily: AppKeys.inter,
                  textColor: AppColors.liteGreyColor,
                ),
                SizedBox(height: spacerSize10),

                BaseButton(
                  buttonWidth: double.infinity,
                  buttonLabel: AppLocalizations.of(context)!.addPlant,
                  onPressed: () {
                    Get.toNamed(Routes.allPlantsScreen);
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
          Get.toNamed(Routes.allPlantsScreen)!.then((_) {
            controller.callGetMyPlantListApi();
          });
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: fontSize14,
              fontWeight: FontWeight.w500,
              color: AppColors.offWhite,
              fontFamily: AppKeys.poppins,
            ),
            children: [
              TextSpan(text: "${AppLocalizations.of(context)!.tap} "),
              WidgetSpan(
                child: Image.asset(
                  Assets.imagesAdd,
                  height: spacerSize12,
                  width: spacerSize12,
                ),
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
}
