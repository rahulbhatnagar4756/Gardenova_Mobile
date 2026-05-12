import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import 'plant_section_title.dart';
import '../../../model/plant_details_model.dart';

class CareOverviewSection extends StatelessWidget {
  final PlantModelDetails? plant;

  const CareOverviewSection({super.key, required this.plant});

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
    String watering = plant?.watering ?? "";
    String sunlight = plant?.sunlight ?? "";
    String soil = plant?.soil ?? "";
    // String fertilizer = plant?.fertilizer ?? "";
    String pruningMonth = plant?.pruningMonth ?? "";

    if (watering.isNotEmpty && plant?.wateringBenchmarkValue != null) {
      watering =
          "$watering (${plant!.wateringBenchmarkValue} ${plant!.wateringBenchmarkUnit ?? ""})";
    }

    if (watering.isEmpty) {
      watering = AppLocalizations.of(context)!.noDataNa;
    }
    if (sunlight.isEmpty) {
      sunlight = AppLocalizations.of(context)!.noDataNa;
    }
    if (soil.isEmpty) {
      soil = AppLocalizations.of(context)!.noDataNa;
    }
    // if (fertilizer.isEmpty) {
    //   fertilizer = AppLocalizations.of(context)!.noDataNa;
    // }
    if (pruningMonth.isEmpty) {
      pruningMonth = AppLocalizations.of(context)!.noDataNa;
    }

    if (watering == AppLocalizations.of(context)!.noDataNa &&
        sunlight == AppLocalizations.of(context)!.noDataNa &&
        soil == AppLocalizations.of(context)!.noDataNa
    // &&fertilizer == AppLocalizations.of(context)!.noDataNa
    ) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlantSectionTitle(title: AppStrings.careOverview, icon: Icons.favorite),

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
                title: AppStrings.watering,
                value: watering,
              ),

              Divider(),

              item(
                icon: Icons.sunny,
                title: AppStrings.sunlight,
                value: sunlight,
              ),

              Divider(),

              item(icon: Icons.grass, title: AppStrings.soil, value: soil),

              // Divider(),

              // item(
              //   icon: Icons.science,
              //   title: AppStrings.fertilizer,
              //   value: fertilizer,
              // ),
              if (pruningMonth != AppLocalizations.of(context)!.noDataNa) ...[
                Divider(),
                item(
                  icon: Icons.content_cut,
                  title: "Pruning Season",
                  value: pruningMonth,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
