import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_keys.dart';

class PlantRecommendations extends StatelessWidget {
  final DashboardController controller;

  const PlantRecommendations({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseBorderedContainer(
        height: Get.height * .23,
        padding: EdgeInsets.all(spacerSize5),
        childWidget:
            controller.plantRecommendationList.isEmpty &&
                !controller.isLoading.value
            ? Center(
                child: BaseText(
                  text: AppLocalizations.of(
                    context,
                  )!.noPlantRecommendationsFound,
                  textAlign: TextAlign.center,
                  fontFamily: AppKeys.merriweather,
                  textColor: Colors.white,
                  fontSize: fontSize15,
                  fontWeight: FontWeight.w500,
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .82,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: controller.isLoading.value
                    ? 5
                    : controller.plantRecommendationList.length,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(spacerSize20),
                    child: controller.isLoading.value
                        ? const BaseShimmer()
                        : CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                controller
                                    .plantRecommendationList[index]
                                    .image ??
                                "",
                            placeholder: (context, url) => const BaseShimmer(),
                            errorWidget: (context, url, error) {
                              return BaseBorderedContainer(
                                height: Get.height * .23,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(spacerSize10),
                                childWidget: Icon(
                                  Icons.broken_image_rounded,
                                  size: spacerSize40,
                                  color: AppColors.offWhite10,
                                ),
                              );
                            },
                          ).marginAll(spacerSize2),
                  );
                },
              ),
      ),
    );
  }

}
