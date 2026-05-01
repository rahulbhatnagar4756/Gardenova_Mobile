import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class TitleAndDescriptionLayout extends StatelessWidget {
  const TitleAndDescriptionLayout({
    super.key,
    this.title,
    this.description,
    this.spacing = spacerSize10,
    this.fontSize = fontSize18,
  });

  final String? title;
  final String? description;
  final double? spacing;

  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: spacing!,
      children: [
        BaseText(
          text: title ?? "",
          fontFamily: AppKeys.merriweather,
          fontWeight: FontWeight.bold,
          textColor: AppColors.burntGoldLight,
          textAlign: TextAlign.left,
          fontSize: fontSize,
        ),
        BaseText(
          text: description ?? "",
          textColor: AppColors.offWhite50,
          textAlign: TextAlign.left,
          fontSize: fontSize16,
        ),
      ],
    );
  }
}
