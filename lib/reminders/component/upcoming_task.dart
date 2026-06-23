import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class UpcomingTask extends StatelessWidget {
  final bool isVisible;
  final String taskCount;

  const UpcomingTask({super.key, required this.isVisible, required this.taskCount});

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: spacerSize10),
      padding: const EdgeInsets.all(spacerSize10),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        border: Border.all(color: AppColors.greenColor.withValues(alpha: .2)),
        borderRadius: BorderRadius.circular(spacerSize24),
      ),
      child: Row(
        children: [
          Container(
            width: spacerSize40,
            height: spacerSize40,
            decoration: const BoxDecoration(
              color: AppColors.darkGreenColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_none, color: Colors.white, size: spacerSize20),
          ),
          const SizedBox(width: spacerSize16),
          Expanded(
            child: Column(
              spacing: spacerSize2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  text: "$taskCount upcoming ${taskCount == "1" ? "task" : "tasks"}",
                  fontSize: fontSize18,
                  fontWeight: FontWeight.w700,
                ),
                const BaseText(
                  text: "Next: In 5 hours",
                  fontSize: fontSize14,
                  textColor: Colors.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
