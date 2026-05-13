import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plant_recommendations_response_model.dart'
    show PlantRecommendationsResponse;
import 'package:kasagardem/utils/constants/app_constants.dart';
import '../../base/dialogs/base_dialog.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_keys.dart';
import '../../utils/routes.dart';

class PlantRecommendations extends StatelessWidget {
  final DashboardController controller;

  const PlantRecommendations({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseBorderedContainer(
        height: Get.height * .23,
        // padding: EdgeInsets.all(spacerSize5),
        backgroundColor: AppColors.appColor,
        borderColor: AppColors.appColor,
        childWidget:
            controller.plantRecommendationList.isEmpty &&
                !controller.isLoading.value
            ? Center(
                child: BaseText(
                  text: AppLocalizations.of(
                    context,
                  )!.noPlantRecommendationsFound,
                  textAlign: TextAlign.center,
                  fontFamily: AppKeys.poppins,
                  textColor: Colors.white,
                  fontSize: fontSize15,
                  fontWeight: FontWeight.w500,
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .995,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.w,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: controller.isLoading.value
                    ? 5
                    : controller.plantRecommendationList.length,
                itemBuilder: (context, index) {
                  PlantRecommendationsResponse? item;
                  if (controller.plantRecommendationList.length - 1 >= index) {
                    item = controller.plantRecommendationList[index];
                  }
                  return CommonClickWidget(
                    onTap: () {
                      if (item != null) {
                        if (controller.isUserLoggedIn.value == false) {
                          BaseDialog.showAlertDialog(
                            context: Get.context!,
                            onButtonPressed: () {
                              Get.back();
                              Get.offAllNamed(
                                Routes.login,
                                arguments: {"question_state_passed": true},
                              );
                            },
                            title: AppLocalizations.of(
                              Get.context!,
                            )!.login.toUpperCase(),
                            description: AppLocalizations.of(
                              Get.context!,
                            )!.pleaseLoginToSeeRecommendedProfessionals,
                            buttonLabel: AppLocalizations.of(
                              Get.context!,
                            )!.login.toUpperCase(),
                          );
                          return;
                        }

                        Get.toNamed(
                          Routes.allPlantsDetails,
                          arguments: {
                            "plant_id": item.id,
                            "screen_type": "add",
                          },
                        );
                      }
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(spacerSize20),
                      child: controller.isLoading.value
                          ? const BaseShimmer(borderRadious: spacerSize20)
                          : CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl:
                                  controller
                                      .plantRecommendationList[index]
                                      .image ??
                                  "",
                              placeholder: (context, url) =>
                                  const BaseShimmer(),

                              errorWidget: (context, url, error) {
                                return BaseBorderedContainer(
                                  height: Get.height * .23,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(spacerSize10),
                                  childWidget: Icon(
                                    Icons.broken_image_rounded,
                                    size: spacerSize40,
                                    color: AppColors.liteGreyColor,
                                  ),
                                );
                              },
                            ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
