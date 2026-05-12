import 'package:flutter/material.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../../../model/plant_details_model.dart';
import 'plant_section_title.dart';

class SpecialTraitsSection extends StatelessWidget {
  final PlantModelDetails? plant;

  const SpecialTraitsSection({super.key, required this.plant});

  Widget chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: spacerSize14,
        vertical: spacerSize10,
      ),
      decoration: BoxDecoration(
        color: AppColors.greenColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.3)),
      ),
      child: BaseText(
        text: text,
        fontFamily: AppKeys.inter,
        fontSize: fontSize12,
        fontWeight: FontWeight.w500,
        textColor: AppColors.greenColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> traits = [];

    if ((plant?.indoor ?? false) == true) {
      traits.add("Indoor Plant");
    }

    if ((plant?.droughtTolerant ?? false) == true) {
      traits.add("Drought Tolerant");
    }

    if ((plant?.poisonousToPets ?? false) == false) {
      traits.add("Pet Friendly");
    }

    if ((plant?.poisonousToHumans ?? false) == false) {
      traits.add("Human Friendly");
    }

    if ((plant?.edibleFruit ?? false) == true) {
      traits.add("Edible Fruit");
    }

    if ((plant?.edibleLeaf ?? false) == true) {
      traits.add("Edible Leaf");
    }

    if ((plant?.medicinal ?? false) == true) {
      traits.add("Medicinal");
    }

    if ((plant?.cuisine ?? false) == true) {
      traits.add("Cuisine");
    }

    if ((plant?.flowers ?? false) == true) {
      traits.add("Flowers");
    }

    if ((plant?.fruits ?? false) == true) {
      traits.add("Fruits");
    }

    if ((plant?.cones ?? false) == true) {
      traits.add("Cones");
    }

    if ((plant?.leaf ?? false) == true) {
      traits.add("Leaf");
    }

    if ((plant?.seeds ?? false) == true) {
      traits.add("Seeds");
    }

    if ((plant?.thorny ?? false) == true) {
      traits.add("Thorny");
    }

    if ((plant?.invasive ?? false) == true) {
      traits.add("Invasive");
    }

    if ((plant?.tropical ?? false) == true) {
      traits.add("Tropical");
    }

    if ((plant?.saltTolerant ?? false) == true) {
      traits.add("Salt Tolerant");
    }

    if (traits.isEmpty) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlantSectionTitle(title: "Special Traits", icon: Icons.star),

        SizedBox(height: spacerSize16),

        Wrap(
          spacing: spacerSize10,
          runSpacing: spacerSize10,
          children: traits.map((e) => chip(e)).toList(),
        ),
      ],
    );
  }
}
