import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:lottie/lottie.dart';

class SuccessIconLayout extends StatefulWidget {
  const SuccessIconLayout({super.key});

  @override
  State<SuccessIconLayout> createState() => _SuccessIconLayoutState();
}

class _SuccessIconLayoutState extends State<SuccessIconLayout>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..addStatusListener(_handleAnimationStatus);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isAnimating) {
      _controller.forward();
    }
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildLottieAnimation(),
        Image.asset(AppAssets.success, width: 87.w,
        height: 87.w,),
      ],
    );
  }

  Widget _buildLottieAnimation() {
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(
        AppColors.greenColor,
        BlendMode.srcATop,
      ),
      child: Lottie.asset(
        AppAssets.heartAnimation,
        controller: _controller,
        filterQuality: FilterQuality.high,
        height: spacerSize150,
        width: spacerSize150,
        onLoaded: (composition) {
          _controller.duration = composition.duration;
        },
      ),
    );
  }
}
