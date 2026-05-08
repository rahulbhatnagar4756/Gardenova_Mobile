import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/introduction/question/components/segmented_progressbar.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class QuestionProgressIndicator extends StatelessWidget {
  const QuestionProgressIndicator({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
  });

  final int currentQuestion;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    // final progressPercentage = (currentQuestion * 100) ~/ totalQuestions;
    final progressPercentage = totalQuestions > 0
        ? ((currentQuestion / totalQuestions) * 100).toInt()
        : 0;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: BaseText(
            fontWeight: FontWeight.w400,
            text:
                "$progressPercentage% ${AppLocalizations.of(context)!.completed}",
            textAlign: TextAlign.start,
            textColor: AppColors.blackColor,
            fontSize: 11.sp,
          ),
        ).marginOnly(bottom: spacerSize5),
        if (totalQuestions > 0)
          LayoutBuilder(
            builder: (context, constraints) {
              final progressWidth =
                  (currentQuestion / totalQuestions) * constraints.maxWidth;
              return Stack(
                children: [
                  SegmentedProgressBar(
                    totalSteps: totalQuestions,
                    currentStep: currentQuestion,
                  ),
                ],
              );
            },
          )
        else
          SizedBox(),
      ],
    );
  }
}
