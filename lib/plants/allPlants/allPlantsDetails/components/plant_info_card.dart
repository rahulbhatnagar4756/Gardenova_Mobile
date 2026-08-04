import 'package:flutter/material.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';

class PlantInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const PlantInfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(spacerSize14),
      decoration: BoxDecoration(
        color: AppColors.toToLiteGreenColor,
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.liteGreenColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(spacerSize10),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Icon(icon, color: AppColors.greenColor, size: spacerSize20),
          ),

          SizedBox(height: spacerSize14),

          BaseText(
            text: title,
            fontFamily: AppKeys.inter,
            fontSize: fontSize12,
            fontWeight: FontWeight.w500,
            textColor: AppColors.liteGreyColor,
          ),

          SizedBox(height: spacerSize4),

          BaseText(
            text: value,
            fontFamily: AppKeys.poppins,
            fontSize: fontSize14,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
