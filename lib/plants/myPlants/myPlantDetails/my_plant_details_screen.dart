import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import '../../../services/admob_service.dart';
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
              if (AdMobService.instance.shouldShowBanners &&
                  controller.isAdLoaded.value &&
                  controller.bannerAd != null) {
                return Container(
                  alignment: Alignment.center,
                  width: controller.bannerAd!.size.width.toDouble().w,
                  height: controller.bannerAd!.size.height.toDouble().h,
                  child: AdWidget(ad: controller.bannerAd!),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      );
    });
  }
}
