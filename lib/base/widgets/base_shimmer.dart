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
    this.borderRadious,
    this.backgroundColor = AppColors.darkGreen,
  });

  final double? height;
  final double? width;
  final double? borderRadious;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return shimmerPlaceHolder();
  }

  Widget shimmerPlaceHolder() {
    return BaseBorderedContainer(
      backgroundColor: AppColors.greenColor,
      height: spacerSize310,
      width: Get.width,
      borderRadius:borderRadious??0 ,
      childWidget: ClipRRect(
        borderRadius:BorderRadius.circular( borderRadious??0 ),
        child: Shimmer(
          color: AppColors.greenColor,
          colorOpacity: 0.25,
          interval: Duration(milliseconds: 5),
          duration: Duration(milliseconds: 3500),
          child: Container(
            height: height ?? Get.height * .27,
            width: width ?? Get.width,
            decoration: BoxDecoration(
              color: AppColors.toToLiteGreenColor,
              borderRadius: BorderRadius.circular(spacerSize14),
            ),
          ),
        ),
      ),
    );
  }
}
