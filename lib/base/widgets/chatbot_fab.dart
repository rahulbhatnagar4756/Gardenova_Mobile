import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:lottie/lottie.dart';

class ChatbotFab extends StatefulWidget {
  final VoidCallback onTap;

  const ChatbotFab({super.key, required this.onTap});

  @override
  State<ChatbotFab> createState() => _ChatbotFabState();
}

class _ChatbotFabState extends State<ChatbotFab>
    with SingleTickerProviderStateMixin {
  static const int _rippleCount = 3;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
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
    final iconSize = 75.w;
    final rippleSize = 80.w;
    if (!_controller.isAnimating) {
      _controller.forward();
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: rippleSize,
        height: rippleSize,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < _rippleCount; i++)
              _RippleRing(
                controller: _controller,
                size: rippleSize,
                delay: i / _rippleCount,
              ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.greenColor.withValues(alpha: 0.55),
                BlendMode.srcATop,
              ),
              child: Lottie.asset(
                AppAssets.heartAnimation,
                controller: _controller,
                filterQuality: FilterQuality.high,
                width: rippleSize,
                height: rippleSize,
                onLoaded: (composition) {
                  _controller.duration = composition.duration;
                },
              ),
            ),
            Image.asset(
              AppAssets.chatbotIconPng,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

class _RippleRing extends StatelessWidget {
  final AnimationController controller;
  final double size;
  final double delay;

  const _RippleRing({
    required this.controller,
    required this.size,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final t = ((controller.value + delay) % 1.0);
        final progress = Curves.easeOut.transform(t);
        final scale = 0.48 + (progress * 0.52);
        final opacity = (1.0 - progress) * 0.7;

        return IgnorePointer(
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: scale,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.greenColor,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.greenColor.withValues(alpha: 0.35),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}