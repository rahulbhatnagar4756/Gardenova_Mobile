import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../model/plant_details_model.dart';
import 'plant_info_card.dart';
import 'plant_section_title.dart';

class QuickInfoSection extends StatelessWidget {
  final PlantModelDetails? plant;

  const QuickInfoSection({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    bool isIndoor = plant?.indoor ?? false;
    String careLevel = plant?.careLevel ?? "";
    String growthRate = plant?.growthRate ?? "";
    String floweringSeason = plant?.floweringSeason ?? "";
    String cycle = plant?.cycle ?? "";
    String plantType = plant?.type ?? AppLocalizations.of(context)!.noDataNa;

    if (careLevel.isEmpty) {
      careLevel = AppLocalizations.of(context)!.noDataNa;
    }
    if (growthRate.isEmpty) {
      growthRate = AppLocalizations.of(context)!.noDataNa;
    }
    if (floweringSeason.isEmpty) {
      floweringSeason = AppLocalizations.of(context)!.noDataNa;
    }
    if (cycle.isEmpty) {
      cycle = AppLocalizations.of(context)!.noDataNa;
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
                value: plantType,
              ),

              SizedBox(width: 12),
              PlantInfoCard(
                icon: Icons.thermostat,
                title: "Hardiness",
                value:
                    (plant?.hardinessMin != null && plant?.hardinessMax != null)
                    ? "Zone ${plant?.hardinessMin}-${plant?.hardinessMax}"
                    : AppLocalizations.of(context)!.noDataNa,
              ),

              SizedBox(width: 12),
              PlantInfoCard(
                icon: Icons.straighten,
                title: "Dimensions",
                value:
                    (plant?.dimensionMinValue != null &&
                        plant?.dimensionMaxValue != null)
                    ? "${plant?.dimensionMinValue}-${plant?.dimensionMaxValue} ${plant?.dimensionUnit ?? ""}"
                    : AppLocalizations.of(context)!.noDataNa,
              ),

              SizedBox(width: 12),

              PlantInfoCard(
                icon: Icons.nature,
                title: "Cycle",
                value: cycle,
              ),

              SizedBox(width: 12),

              PlantInfoCard(
                icon: Icons.local_florist,
                title: "Flowering",
                value: floweringSeason,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
