import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BaseShimmer extends StatelessWidget {
  const BaseShimmer({
    super.key,
    this.height,
    this.width,
    this.backgroundColor = AppColors.darkGreen,
  });

  final double? height;
  final double? width;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return shimmerPlaceHolder();
  }

  Widget shimmerPlaceHolder() {
    return BaseBorderedContainer(
      backgroundColor: AppColors.darkGreen,
      height: spacerSize310,
      width: Get.width,
      childWidget: Shimmer(
        color: AppColors.offWhite10,
        colorOpacity: 0.25,
        interval: Duration(milliseconds: 5),
        duration: Duration(milliseconds: 3500),
        child: Container(
          height: height ?? Get.height * .27,
          width: width ?? Get.width,
          decoration: BoxDecoration(
            color: AppColors.appColor,
            borderRadius: BorderRadius.circular(spacerSize14),
          ),
        ),
      ),
    );
  }
}
