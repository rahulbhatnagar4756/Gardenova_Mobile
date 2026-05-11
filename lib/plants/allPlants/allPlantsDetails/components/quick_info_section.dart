import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../model/plant_details_model.dart';
import 'plant_info_card.dart';
import 'plant_section_title.dart';

class QuickInfoSection extends StatelessWidget {
  final PlantModel? plant;

  const QuickInfoSection({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    bool isIndoor = plant?.indoor ?? false;
    String careLevel = plant?.careLevel ?? "";
    String growthRate = plant?.growthRate ?? "";
    String blooming = plant?.blooming ?? "";
    if (isIndoor == false) {
      isIndoor = false;
    }
    if (careLevel.isEmpty) {
      careLevel = AppLocalizations.of(context)!.noDataNa;
    }
    if (growthRate.isEmpty) {
      growthRate = AppLocalizations.of(context)!.noDataNa;
    }
    if (blooming.isEmpty) {
      blooming = AppLocalizations.of(context)!.noDataNa;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        PlantSectionTitle(title: "Quick Information", icon: Icons.eco),

        SizedBox(height: 16),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              PlantInfoCard(
                icon: Icons.home,
                title: "Indoor",
                value: isIndoor ? "Yes" : "No",
              ),

              SizedBox(width: 12),

              PlantInfoCard(
                icon: Icons.spa,
                title: "Care Level",
                value: careLevel,
              ),

              SizedBox(width: 12),

              PlantInfoCard(
                icon: Icons.trending_up,
                title: "Growth",
                value: growthRate,
              ),

              SizedBox(width: 12),

              PlantInfoCard(
                icon: Icons.category,
                title: "Plant Type",
                value:
                    plant?.plantType ?? AppLocalizations.of(context)!.noDataNa,
              ),

              SizedBox(width: 12),

              PlantInfoCard(
                icon: Icons.nature,
                title: "Growth Habit",
                value:
                    plant?.growthHabit ??
                    AppLocalizations.of(context)!.noDataNa,
              ),

              SizedBox(width: 12),

              PlantInfoCard(
                icon: Icons.local_florist,
                title: "Blooming",
                value: blooming,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
