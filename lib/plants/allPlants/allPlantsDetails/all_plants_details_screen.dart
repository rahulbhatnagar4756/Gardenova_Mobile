import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../../base/widgets/base_shimmer.dart';
import 'all_plants_details_controller.dart';
import 'components/main_content_card.dart';

class AllPlantsDetailsScreen extends GetWidget<AllPlantsDetailsController> {
  const AllPlantsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            controller.plantDetailData.value.data == null
                ? Container()
                : imageCard(),
            MainContentCard(controller: controller),
            backButton(),
          ],
        ),
      ),
    );
  }

  Widget imageCard() {
    return Container(
      color: AppColors.charcoalGrey,
      child: CachedNetworkImage(
        height: spacerSize350,
        width: double.infinity,
        fit: BoxFit.cover,
        imageUrl: controller.plantDetailData.value.data?.plant?.imageUrl ?? "",
        placeholder: (context, url) =>
            BaseShimmer(height: spacerSize350, width: double.infinity),
        errorWidget: (context, url, error) => Icon(
          Icons.broken_image,
          color: AppColors.offWhite,
          size: spacerSize40,
        ),
      ),
    );
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
