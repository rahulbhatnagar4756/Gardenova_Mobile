import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/base_text_field.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plants_catalog/plants_catalog_view_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';

class PlantsCatalogScreen extends GetView<PlantsCatalogViewModel> {
  const PlantsCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.appColor,
        appBar: CircularBottomAppBar(
          onSettingPressed: () {
            Get.toNamed(Routes.settings);
          },
        ),
        body: Column(
          children: [
            BaseTextField(
              textColor: AppColors.antiqueWhite,
              hintText: AppLocalizations.of(
                context,
              )!.searchPlantsByNameAndDescription,
              hintColor: AppColors.offWhite50,
              prefixIcon: const Icon(Icons.search, color: AppColors.offWhite),
              onChanged: (value) {
                if (value.isEmpty) {
                  controller.pageNumber.value = 1;
                }
                controller.isSearching.value = true;
                controller.debouncer.call(
                  () => controller.getPlantsListing(searchName: value),
                );
                controller.isSearching.value = false;
              },
            ).paddingAll(spacerSize10),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (!controller.isLoadMoreRunning.value &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      controller.isLoadMoreVisible.value) {
                    controller.loadMorePlants();
                  }
                  return false;
                },
                child: controller.isLoading.value
                    ? GridView.builder(
                        itemCount: 8,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                        itemBuilder: (context, index) => const BaseShimmer(),
                      )
                    : controller.plantsList.isEmpty
                    ? Center(
                        child: BaseText(
                          text: AppLocalizations.of(
                            context,
                          )!.noPlantRecommendationsFound,
                          textColor: AppColors.antiqueWhite,
                          fontFamily: AppKeys.merriweather,
                          fontWeight: FontWeight.bold,
                          textAlign: TextAlign.center,
                          fontSize: fontSize18,
                        ),
                      )
                    : GridView.builder(
                        itemCount: controller.plantsList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                Routes.plantDetail,
                                arguments: controller.plantsList[index],
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(spacerSize15),
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: spacerSize150,
                                    width: Get.width,
                                    imageUrl: controller
                                        .plantsList[index]
                                        .imageSearchUrl!,
                                    placeholder: (context, url) =>
                                        const BaseShimmer(),
                                    errorWidget: (context, url, error) {
                                      return BaseBorderedContainer(
                                        height: Get.height * .23,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(
                                          spacerSize10,
                                        ),
                                        childWidget: Icon(
                                          Icons.broken_image_rounded,
                                          size: spacerSize40,
                                          color: AppColors.offWhite10,
                                        ),
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child:
                                        Container(
                                          alignment: Alignment.center,
                                          color: AppColors.darkGunMetal,
                                          width: Get.width,

                                          child: BaseText(
                                            text:
                                                controller
                                                    .plantsList[index]
                                                    .commonName ??
                                                "",
                                            textColor: AppColors.antiqueWhite,
                                            fontWeight: FontWeight.bold,
                                            textAlign: TextAlign.center,
                                          ),
                                        ).paddingOnly(
                                          top: spacerSize2,
                                          bottom: spacerSize2,
                                        ),
                                  ),
                                ],
                              ).marginAll(spacerSize2),
                            ),
                          );
                        },
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                      ),
              ).marginOnly(left: spacerSize5, right: spacerSize5),
            ),
          ],
        ).marginOnly(bottom: spacerSize5),
      ),
    );
  }
}
