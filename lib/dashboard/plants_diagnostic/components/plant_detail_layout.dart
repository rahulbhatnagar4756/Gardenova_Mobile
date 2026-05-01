import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/title_and_description_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_view_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class PlantDetailLayout extends StatelessWidget {
  const PlantDetailLayout({super.key, this.plantDiagnosisViewModel});

  final PlantDiagnosisViewModel? plantDiagnosisViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: spacerSize10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText(
          text:
              plantDiagnosisViewModel!.plantDiagnosisResponse.value.data != null
              ? plantDiagnosisViewModel!
                    .plantDiagnosisResponse
                    .value
                    .data!
                    .plantInfo!
                    .commonNames!
                    .join(', ')
                    .toTitleCase()
              : "",
          fontFamily: AppKeys.merriweather,
          fontWeight: FontWeight.bold,
          textColor: AppColors.burntGold,
          textAlign: TextAlign.left,
          fontSize: fontSize20,
        ),

        TitleAndDescriptionLayout(
          title: AppLocalizations.of(context)!.scientificName,
          description:
              plantDiagnosisViewModel!.plantDiagnosisResponse.value.data != null
              ? plantDiagnosisViewModel!
                    .plantDiagnosisResponse
                    .value
                    .data!
                    .plantInfo!
                    .scientificName
              : "",
          spacing: spacerSize6,
        ),
        TitleAndDescriptionLayout(
          title: AppLocalizations.of(context)!.description,
          description:
              plantDiagnosisViewModel!.plantDiagnosisResponse.value.data != null
              ? plantDiagnosisViewModel!
                    .plantDiagnosisResponse
                    .value
                    .data!
                    .plantInfo!
                    .description
              : "",
          spacing: spacerSize6,
        ),

        BaseText(
          text: AppLocalizations.of(context)!.careNotes,
          fontFamily: AppKeys.merriweather,
          fontWeight: FontWeight.bold,
          textColor: AppColors.burntGoldLight,
          textAlign: TextAlign.left,
          fontSize: fontSize20,
        ).marginOnly(bottom: spacerSize10),

        TitleAndDescriptionLayout(
          title: "${AppLocalizations.of(context)!.watering}:",
          description:
              plantDiagnosisViewModel!.plantDiagnosisResponse.value.data != null
              ? plantDiagnosisViewModel!
                    .plantDiagnosisResponse
                    .value
                    .data!
                    .plantInfo!
                    .careGuide!
                    .watering
              : "",
          spacing: spacerSize6,
        ),
        TitleAndDescriptionLayout(
          title: "${AppLocalizations.of(context)!.lightCondition}:",
          description:
              plantDiagnosisViewModel!.plantDiagnosisResponse.value.data != null
              ? plantDiagnosisViewModel!
                    .plantDiagnosisResponse
                    .value
                    .data!
                    .plantInfo!
                    .careGuide!
                    .lightCondition
              : "",
          spacing: spacerSize6,
        ),
        TitleAndDescriptionLayout(
          title: "${AppLocalizations.of(context)!.soilType}:",
          description:
              plantDiagnosisViewModel!.plantDiagnosisResponse.value.data != null
              ? plantDiagnosisViewModel!
                    .plantDiagnosisResponse
                    .value
                    .data!
                    .plantInfo!
                    .careGuide!
                    .soilType
              : "",
          spacing: spacerSize6,
        ),
      ],
    );
  }
}
