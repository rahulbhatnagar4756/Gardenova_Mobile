import 'package:flutter/material.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';

class PlantSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlantSectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.greenColor,
          size: spacerSize18,
        ),
        SizedBox(width: spacerSize8),
        BaseText(
          text: title,
          fontFamily: AppKeys.poppins,
          fontSize: fontSize15,
          fontWeight: FontWeight.w700,
          textColor: AppColors.greenColor,
        ),
      ],
    );
  }
}