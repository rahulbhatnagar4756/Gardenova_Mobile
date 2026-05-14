import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../model/plant_details_model.dart';
import 'plant_info_card.dart';
import 'plant_section_title.dart';

class QuickInfoSection extends StatelessWidget {
  final PlantModelDetails? plant;

  const QuickInfoSection({super.key, required this.plant});

  String _cap(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    bool isIndoor = plant?.indoor ?? false;
    String careLevel = _cap(plant?.careLevel ?? "");
    String growthRate = _cap(plant?.growthRate ?? "");
    String floweringSeason = _cap(plant?.floweringSeason ?? "");
    String cycle = _cap(plant?.cycle ?? "");
    String plantType = _cap(plant?.type ?? AppLocalizations.of(context)!.noDataNa);

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

        Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PlantInfoCard(
                      icon: Icons.home,
                      title: "Indoor",
                      value: isIndoor ? "Yes" : "No",
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: PlantInfoCard(
                      icon: Icons.spa,
                      title: "Care Level",
                      value: careLevel,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PlantInfoCard(
                      icon: Icons.trending_up,
                      title: "Growth",
                      value: growthRate,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: PlantInfoCard(
                      icon: Icons.category,
                      title: "Plant Type",
                      value: plantType,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PlantInfoCard(
                      icon: Icons.thermostat,
                      title: "Hardiness",
                      value:
                          (plant?.hardinessMin != null && plant?.hardinessMax != null)
                          ? "Zone ${plant?.hardinessMin}-${plant?.hardinessMax}"
                          : AppLocalizations.of(context)!.noDataNa,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: PlantInfoCard(
                      icon: Icons.straighten,
                      title: "Dimensions",
                      value:
                          (plant?.dimensionMinValue != null &&
                              plant?.dimensionMaxValue != null)
                          ? "${plant?.dimensionMinValue}-${plant?.dimensionMaxValue} ${plant?.dimensionUnit ?? ""}"
                          : AppLocalizations.of(context)!.noDataNa,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PlantInfoCard(
                      icon: Icons.nature,
                      title: "Cycle",
                      value: cycle,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: PlantInfoCard(
                      icon: Icons.local_florist,
                      title: "Flowering",
                      value: floweringSeason,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
