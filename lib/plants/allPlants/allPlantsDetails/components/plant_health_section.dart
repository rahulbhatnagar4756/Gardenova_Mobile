import 'package:flutter/material.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../../../model/plant_details_model.dart';
import 'plant_section_title.dart';

class PlantHealthSection extends StatelessWidget {
  final PlantModelDetails? plant;

  const PlantHealthSection({super.key, required this.plant});

  Widget item({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: spacerSize16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: title,
            fontFamily: AppKeys.poppins,
            fontSize: fontSize13,
            fontWeight: FontWeight.w600,
          ),

          SizedBox(height: spacerSize6),

          BaseText(
            text: value,
            fontFamily: AppKeys.inter,
            fontSize: fontSize12,
            fontWeight: FontWeight.w400,
            textColor: AppColors.liteGreyColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String maintenance = plant?.maintenance ?? "";
    String pests = plant?.pestSusceptibility?.toString() ?? "";
    String anatomy = plant?.plantAnatomy ?? "";

    if (maintenance.isEmpty && pests.isEmpty && anatomy.isEmpty) {
      return SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlantSectionTitle(title: "Plant Details", icon: Icons.info_outline),

        SizedBox(height: spacerSize16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(spacerSize16),
          decoration: BoxDecoration(
            color: AppColors.toToLiteGreenColor,
            borderRadius: BorderRadius.circular(spacerSize18),
            border: Border.all(color: AppColors.liteGreenColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (maintenance.isNotEmpty)
                item(title: "Maintenance", value: maintenance),
              if (pests.isNotEmpty && pests != "null")
                item(title: "Pest Susceptibility", value: pests),
              if (anatomy.isNotEmpty)
                item(title: "Plant Anatomy", value: anatomy),
            ],
          ),
        ),
      ],
    );
  }
}
