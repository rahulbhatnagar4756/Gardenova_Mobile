import 'package:flutter/cupertino.dart';

import '../../../../base/widgets/base_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';

class PlantStateItem extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const PlantStateItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(spacerSize15),
          margin: const EdgeInsets.only(bottom: spacerSize8),
          decoration: BoxDecoration(
            color: AppColors.darkGold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(spacerSize12),
            border: Border.all(
              color: AppColors.darkGold.withValues(alpha: 0.1),
            ),
          ),
          child: Image.asset(icon, height: spacerSize35, width: spacerSize35),
        ),
        Column(
          children: [
            BaseText(
              text: label,
              fontFamily: AppKeys.inter,
              fontSize: fontSize13,
              fontWeight: FontWeight.w500,
              textColor: AppColors.offWhite,
            ),
            BaseText(
              text: value,
              fontFamily: AppKeys.inter,
              fontSize: fontSize12,
              fontWeight: FontWeight.w400,
              textColor: AppColors.offWhite.withValues(alpha: 0.6),
            ),
          ],
        ),
      ],
    );
  }
}
