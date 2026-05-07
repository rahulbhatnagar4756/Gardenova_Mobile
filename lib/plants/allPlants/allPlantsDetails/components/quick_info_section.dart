import 'package:flutter/material.dart';
import '../../../model/plant_details_model.dart';
import 'plant_info_card.dart';
import 'plant_section_title.dart';

class QuickInfoSection extends StatelessWidget {
  final PlantModel? plant;

  const QuickInfoSection({
    super.key,
    required this.plant,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PlantSectionTitle(
          title: "Quick Information",
          icon: Icons.eco,
        ),

        SizedBox(height: 16),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              PlantInfoCard(
                icon: Icons.home,
                title: "Indoor",
                value: plant?.indoor == true ? "Yes" : "No",
              ),

              SizedBox(width: 12),

              PlantInfoCard(
                icon: Icons.spa,
                title: "Care Level",
                value: plant?.careLevel ?? "N/A",
              ),

              SizedBox(width: 12),

              PlantInfoCard(
                icon: Icons.trending_up,
                title: "Growth",
                value: plant?.growthRate ?? "N/A",
              ),

              SizedBox(width: 12),

              PlantInfoCard(
                icon: Icons.local_florist,
                title: "Blooming",
                value: plant?.blooming ?? "N/A",
              ),
            ],
          ),
        ),
      ],
    );
  }
}