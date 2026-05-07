import 'package:flutter/material.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import 'plant_section_title.dart';
import '../../../model/plant_details_model.dart';

class CareOverviewSection extends StatelessWidget {
  final PlantModel? plant;

  const CareOverviewSection({
    super.key,
    required this.plant,
  });

  Widget item({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: spacerSize10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.greenColor),

          SizedBox(width: spacerSize12),

          Expanded(
            child: BaseText(
              text: title,
              fontFamily: AppKeys.inter,
              fontSize: fontSize13,
              fontWeight: FontWeight.w500,
            ),
          ),

          Expanded(
            child: BaseText(
              text: value,
              fontFamily: AppKeys.inter,
              fontSize: fontSize12,
              fontWeight: FontWeight.w400,
              textColor: AppColors.liteGreyColor,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlantSectionTitle(
          title: "Care Overview",
          icon: Icons.favorite,
        ),

        SizedBox(height: spacerSize16),

        Container(
          padding: const EdgeInsets.all(spacerSize16),
          decoration: BoxDecoration(
            color: AppColors.toToLiteGreenColor,
            borderRadius: BorderRadius.circular(spacerSize18),
            border: Border.all(color: AppColors.liteGreenColor),
          ),
          child: Column(
            children: [
              item(
                icon: Icons.water_drop,
                title: "Watering",
                value: plant?.watering ?? "N/A",
              ),

              Divider(),

              item(
                icon: Icons.sunny,
                title: "Sunlight",
                value: plant?.sunlight ?? "N/A",
              ),

              Divider(),

              item(
                icon: Icons.grass,
                title: "Soil",
                value: plant?.soil ?? "N/A",
              ),

              Divider(),

              item(
                icon: Icons.science,
                title: "Fertilizer",
                value: plant?.fertilizer ?? "N/A",
              ),
            ],
          ),
        ),
      ],
    );
  }
}