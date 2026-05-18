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
        height: 175.h,
        // padding: EdgeInsets.all(spacerSize5),
        backgroundColor: AppColors.appColor,
        borderColor: AppColors.appColor,
        childWidget:
            controller.plantRecommendationList.isEmpty &&
                !controller.isLoading.value
            ? Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.local_florist_outlined,
                      size: 60.w,
                      color: AppColors.greenColor,
                    ),

                    SizedBox(height: 12.h),
                    BaseText(
                      text: AppLocalizations.of(
                        context,
                      )!.noPlantRecommendationsFound,
                      textAlign: TextAlign.center,
                      fontFamily: AppKeys.poppins,
                      textColor: AppColors.liteGreyColor,
                      fontSize: fontSize15,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ).paddingOnly(top: 30.h),
              )
            : ListView.separated(
                padding: EdgeInsets.only(
                  left: spacerSize20,
                  right: spacerSize20,
                ),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 10.w),
                itemCount: controller.isLoading.value
                    ? 7
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
                    child: SizedBox(
                      width: 140.w,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: controller.isLoading.value
                                ? BaseShimmer(borderRadious: 16.r)
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      /// 🔹 Image Section
                                      Expanded(
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16.r),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: item?.image ?? "",
                                                placeholder: (context, url) =>
                                                    const BaseShimmer(),
                                                errorWidget: (context, url, error) {
                                                  return BaseBorderedContainer(
                                                    alignment: Alignment.center,
                                                    padding: EdgeInsets.all(
                                                      spacerSize10,
                                                    ),
                                                    childWidget: Icon(
                                                      Icons
                                                          .broken_image_rounded,
                                                      size: spacerSize40,
                                                      color: AppColors
                                                          .liteGreyColor,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),

                                            /// 🔹 Heart Icon
                                            Positioned(
                                              top: 8.h,
                                              right: 8.w,
                                              child: Container(
                                                padding: EdgeInsets.all(5.w),
                                                decoration: const BoxDecoration(
                                                  color: AppColors.whiteColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  Icons.favorite_border,
                                                  size: 16.w,
                                                  color:
                                                      AppColors.liteGreyColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),

                          /// 🔹 Text Section
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              shadowColor: Colors.black.withValues(alpha: 0.5),
                              color: AppColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13.r),
                                side: BorderSide(
                                  color: Colors.black.withValues(alpha: 0.06),
                                ),
                              ),
                              child: Container(
                                height: 52.h,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Spacer(),
                                    BaseText(
                                      text:
                                          item?.commonName ??
                                          item?.speciesName ??
                                          "",
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppKeys.poppins,
                                      fontSize: 12.sp,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 1.h),
                                    if ((item?.whyRecommended != null &&
                                            item!.whyRecommended!.isNotEmpty) ||
                                        (item?.plantType != null &&
                                            item!.plantType!.isNotEmpty))
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.greenColor
                                              .withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                        ),
                                        child: BaseText(
                                          text:
                                              item.whyRecommended?.isNotEmpty ==
                                                  true
                                              ? item.whyRecommended!.first
                                              : (item.plantType ?? ""),
                                          textColor: AppColors.greenColor,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.w400,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    SizedBox(height: 8.h),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
