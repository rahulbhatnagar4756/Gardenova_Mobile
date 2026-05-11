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
    return Shimmer(
      color: Colors.white,
      colorOpacity: 0.4,
      interval: const Duration(milliseconds: 100),
      duration: const Duration(milliseconds: 1500),
      child: Container(
        height: height ?? Get.height * .27,
        width: width ?? Get.width,
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(borderRadious ?? spacerSize14),
        ),
      ),
    );
  }
}
