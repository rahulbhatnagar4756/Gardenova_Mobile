import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';

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
    final progressPercentage = (currentQuestion * 100) ~/ totalQuestions;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: BaseText(
            fontWeight: FontWeight.w400,
            text:
                "$progressPercentage% ${AppLocalizations.of(context)!.completed}",
            textAlign: TextAlign.start,
            textColor: AppColors.offWhite70,
            fontSize: fontSize12,
          ),
        ).marginOnly(bottom: spacerSize5),
        if (totalQuestions > 0)
          LayoutBuilder(
            builder: (context, constraints) {
              final progressWidth =
                  (currentQuestion / totalQuestions) * constraints.maxWidth;
              return Stack(
                children: [
                  LinearProgressBar(
                    minHeight: spacerSize5,
                    currentStep: currentQuestion,
                    borderRadius: BorderRadius.circular(spacerSize10),
                    progressColor: AppColors.burntGold,
                    maxSteps: totalQuestions,
                    backgroundColor: AppColors.offWhite.withAlpha(25),
                  ),
                  if (currentQuestion > 0)
                    Positioned(
                      left: (progressWidth - 20).clamp(
                        0.0,
                        constraints.maxWidth - 20,
                      ),
                      child: Container(
                        width: spacerSize20,
                        height: spacerSize5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(spacerSize10),
                            bottomLeft: Radius.circular(spacerSize10),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.burntGold.withAlpha(90),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
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
