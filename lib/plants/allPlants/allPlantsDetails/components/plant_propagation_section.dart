import 'package:flutter/material.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../../../model/plant_details_model.dart';
import 'plant_section_title.dart';

class PlantPropagationSection extends StatelessWidget {
  final PlantModelDetails? plant;

  const PlantPropagationSection({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    if (plant?.propagation == null || plant!.propagation!.isEmpty) {
      return SizedBox();
    }

    final List<String> methods = plant!.propagation!.split('|');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlantSectionTitle(title: "Propagation", icon: Icons.settings_input_antenna),

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
              BaseText(
                text: "Common methods to propagate this plant:",
                fontFamily: AppKeys.inter,
                fontSize: fontSize13,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: spacerSize12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: methods.map((method) => _methodChip(method.trim())).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _methodChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.liteGreenColor),
      ),
      child: BaseText(
        text: text,
        fontFamily: AppKeys.inter,
        fontSize: fontSize11,
        fontWeight: FontWeight.w500,
        textColor: AppColors.greenColor,
      ),
    );
  }
}
