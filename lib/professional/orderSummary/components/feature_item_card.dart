import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../../base/widgets/base_text.dart';
import '../../../utils/constants/app_keys.dart';

class FeatureItemCard extends StatelessWidget {
  final String title;

  const FeatureItemCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: spacerSize8),
      child: Row(
        spacing: spacerSize12,
        children: [
          Container(
            padding: EdgeInsets.all(spacerSize3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.borderGold.withValues(alpha: .2),
            ),
            child: Icon(
              Icons.check,
              size: spacerSize12,
              color: AppColors.darkGold,
            ),
          ),
          Expanded(
            child: BaseText(
              fontWeight: FontWeight.w500,
              fontFamily: AppKeys.inter,
              fontSize: fontSize14,
              textColor: AppColors.offWhite,
              text: title,
            ),
          ),
        ],
      ),
    );
  }
}
