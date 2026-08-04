import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/constants/app_color.dart';

class SegmentedProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep;
  final double? height;
  final double? spacing;
  final BorderRadius radius;

  const SegmentedProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.height,
    this.spacing ,
    this.radius = const BorderRadius.all(Radius.circular(10)),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        final isCompleted = index < currentStep;

        return Expanded(
          child: Container(
            margin: EdgeInsets.only(
              right: (index == totalSteps - 1 )? 0 : spacing??6.w,
            ),
            height: height??7.h,
            decoration: BoxDecoration(
              borderRadius: radius,
              color: isCompleted
                  ? null
                  : AppColors.blackColor.withAlpha(20),
              gradient: isCompleted
                  ? AppColors.linearGradientForBtn
                  : null,
            ),
          ),
        );
      }),
    );
  }
}