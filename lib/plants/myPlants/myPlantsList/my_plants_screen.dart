import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_back_button.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';

import '../../../base/widgets/base_app_bar.dart';
import '../../../base/widgets/base_text.dart';
import '../../../base/widgets/circular_bottom_app_bar.dart';
import '../../../dashboard/components/full_drawer.dart';
import '../../../generated/assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';
import '../../../utils/routes.dart';
import 'components/my_plants_list.dart';
import 'my_plants_controller.dart';

class MyPlantsScreen extends GetWidget<MyPlantsController> {
  const MyPlantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
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
            ))
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
            await controller.callGetMyPlantListApi();
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
                controller.myPlantList.isNotEmpty
                    ? Expanded(child: MyPlantsList(controller: controller))
                    : Expanded(child: _emptyState(context)),
              ],
            ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BaseText(
              text: AppLocalizations.of(context)!.myPlants,
              textAlign: TextAlign.center,
              fontFamily: AppKeys.poppins,
              textColor: AppColors.offWhite,
              fontSize: fontSize20,
              fontWeight: FontWeight.w500,
            ),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.allPlantsScreen)!.then((value) {
                  controller.callGetMyPlantListApi();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(spacerSize10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.lightGold, AppColors.burntGold],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(spacerSize12),
                ),
                child: Image.asset(
                  Assets.imagesAdd,
                  height: spacerSize16,
                  width: spacerSize16,
                ),
              ),
            ),
          ],
        ).marginOnly(top: spacerSize10),
        BaseText(
          text: "${controller.myPlantList.length} "
              "${controller.myPlantList.length == 1
              ? AppLocalizations.of(context)!.plant
              : controller.plantPlural} "
              "${AppLocalizations.of(context)!.andCounting}!",

          textAlign: TextAlign.center,

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
            controller.debouncer.call(
              () => controller.callGetMyPlantListApi(searchName: value),
            );
            controller.isSearching.value = false;
          },
        ).marginOnly(bottom: spacerSize16),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.allPlantsScreen)!.then((value) {
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
              TextSpan(text: "${AppLocalizations.of(context)!.tap}\t"),

              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.allPlantsScreen)!.then((value) {
                      controller.callGetMyPlantListApi();
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: spacerSize4),
                    child: Image.asset(
                      Assets.imagesAdd,
                      height: spacerSize12,
                      width: spacerSize12,
                    ),
                  ),
                ),
              ),

              TextSpan(
                text: "\t${AppLocalizations.of(context)!.toAddYourFirstPlant}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
