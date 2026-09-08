import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/safe_banner_ad.dart';
import 'package:kasagardem/services/admob_service.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

import 'my_plant_details_controller.dart';
import 'views/error_view.dart';
import 'views/loading_view.dart';
import 'views/success_view.dart';

class MyPlantDetailsScreen extends GetWidget<MyPlantDetailsController> {
  const MyPlantDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const MyPlantDetailsLoadingView();
      }

      if (controller.errorMessage.isNotEmpty) {
        return MyPlantDetailsErrorView(
          errorMessage: controller.errorMessage.value,
          onRetry: () => controller.callGetMyPlantDetailsApi(),
        );
      }

      if (controller.plantDetailData.value.data == null) {
        return MyPlantDetailsErrorView(
          errorMessage: "No data available for this plant",
          onRetry: () => controller.callGetMyPlantDetailsApi(),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.appColor,
        body: Column(
          children: [
            Expanded(child: MyPlantDetailsSuccessView(controller: controller)),
            Obx(() {
              final banner = controller.bannerAd;
              if (AdMobService.instance.shouldShowBanners &&
                  controller.isAdLoaded.value &&
                  banner != null) {
                return SafeBannerAd(key: ObjectKey(banner), ad: banner);
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      );
    });
  }
}
