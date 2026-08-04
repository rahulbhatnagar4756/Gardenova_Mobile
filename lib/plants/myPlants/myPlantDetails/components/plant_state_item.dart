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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: spacerSize15,horizontal:spacerSize35 ),
      margin: const EdgeInsets.only(bottom: spacerSize8),
      decoration: BoxDecoration(
        color: AppColors.toToLiteGreenColor,
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(
          color: AppColors.liteGreenColor,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(spacerSize15),
            margin: const EdgeInsets.only(bottom: spacerSize8),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: AppColors.whiteColor,
              ),
            ),
            child: Image.asset(icon, height: spacerSize35, width: spacerSize35,color:  AppColors.greenColor,),
          ),
          Column(
            children: [
              BaseText(
                text: label,
                fontFamily: AppKeys.inter,
                fontSize: fontSize13,
                fontWeight: FontWeight.w500,
              ),
              BaseText(
                text: value,
                fontFamily: AppKeys.inter,
                fontSize: fontSize12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.liteGreyColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
