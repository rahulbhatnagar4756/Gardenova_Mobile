import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../../base/widgets/base_button.dart';
import '../../../base/widgets/clickable_image.dart';
import '../../../l10n/app_localizations.dart';
import 'all_plants_details_controller.dart';
import 'components/main_content_card.dart';

class AllPlantsDetailsScreen extends GetWidget<AllPlantsDetailsController> {
  const AllPlantsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.testing(),
        child: Scaffold(
          backgroundColor: AppColors.appColor,
          body: Stack(
            children: [
              controller.plantDetailData.value.data == null
                  ? Container()
                  : Positioned(top: 0, left: 0, right: 0, child: imageCard()),
              MainContentCard(controller: controller),
              // Positioned(
              //   top: 0,
              //   left: 0,
              //   right: 0,
              //   height: spacerSize350,
              //   child: IgnorePointer(
              //     ignoring: false,
              //     child: Material(
              //       color: Colors.transparent,
              //       child: InkWell(
              //         onTap: () {
              //           final imageUrl =
              //               controller
              //                   .plantDetailData
              //                   .value
              //                   .data
              //                   ?.plant
              //                   ?.imageUrl ??
              //               "";
              //
              //           if (imageUrl.isNotEmpty) {
              //             FullScreenImageView.open(
              //               imageUrl: imageUrl,
              //               heroTag: "plant_detail_image",
              //             );
              //           }
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              backButton(),
            ],
          ),
          floatingActionButton: Obx(
            () => Container(
              decoration: BoxDecoration(
                gradient: AppColors.linearGradientForBtn,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greenColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () async {
                  controller.validateAndSubmit(context);
                },
                icon: Icon(
                  controller.screenType.value == 'add' ? Icons.add : Icons.save,
                  color: Colors.white,
                ),
                label: Text(
                  controller.screenType.value == 'add'
                      ? AppLocalizations.of(context)!.addPlant
                      : 'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
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
        buttonLabel: addPlant
            ? AppLocalizations.of(context)!.addPlant
            : 'Save Changes',
        fontSize: fontSize16,
        textColor: Colors.white,
        buttonWidth: double.infinity,
      ),
    );
  }

  Widget imageCard() {
    final imageUrl =
        controller.plantDetailData.value.data?.plant?.imageUrl ?? "";

    return Container(
      color: AppColors.charcoalGrey,
      child: ClickableImage(
        imageUrl: imageUrl,
        height: spacerSize350,
        width: double.infinity,
        fit: BoxFit.cover,
        heroTag: "plant_detail_image",
        errorWidget: Icon(
          Icons.broken_image,
          color: AppColors.offWhite,
          size: spacerSize40,
        ),
      ),
    );
    // return Container(
    //   color: AppColors.charcoalGrey,
    //   child: CachedNetworkImage(
    //     height: spacerSize350,
    //     width: double.infinity,
    //     fit: BoxFit.cover,
    //     imageUrl: controller.plantDetailData.value.data?.plant?.imageUrl ?? "",
    //     placeholder: (context, url) =>
    //         BaseShimmer(height: spacerSize350, width: double.infinity),
    //     errorWidget: (context, url, error) => Icon(
    //       Icons.broken_image,
    //       color: AppColors.offWhite,
    //       size: spacerSize40,
    //     ),
    //   ),
    // );
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
