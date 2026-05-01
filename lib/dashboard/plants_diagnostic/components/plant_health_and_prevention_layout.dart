import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/expansion_tile_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/components/title_and_description_layout.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/plant_diagnosis_view_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class PlantHealthAndPreventionLayout extends StatelessWidget {
  const PlantHealthAndPreventionLayout({
    super.key,
    this.plantDiagnosisViewModel,
  });

  final PlantDiagnosisViewModel? plantDiagnosisViewModel;

  @override
  Widget build(BuildContext context) {
    return ExpansionTileLayout(
      childWidget: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: spacerSize10,
          children: [
            TitleAndDescriptionLayout(
              title: AppLocalizations.of(context)!.issue,
              fontSize: fontSize16,
              spacing: spacerSize5,
              description:
                  plantDiagnosisViewModel!.plantDiagnosisResponse.value.data !=
                      null
                  ? plantDiagnosisViewModel!
                        .plantDiagnosisResponse
                        .value
                        .data!
                        .healthStatus!
                        .issues![0]
                        .name
                  : "",
            ),
            TitleAndDescriptionLayout(
              title: AppLocalizations.of(context)!.issueType,
              spacing: spacerSize5,
              fontSize: fontSize16,
              description:
                  plantDiagnosisViewModel!.plantDiagnosisResponse.value.data !=
                      null
                  ? plantDiagnosisViewModel!
                        .plantDiagnosisResponse
                        .value
                        .data!
                        .healthStatus!
                        .issues![0]
                        .type!
                        .toTitleCase()
                  : "",
            ),
            TitleAndDescriptionLayout(
              title: AppLocalizations.of(context)!.severity,
              spacing: spacerSize5,
              fontSize: fontSize16,
              description:
                  plantDiagnosisViewModel!.plantDiagnosisResponse.value.data !=
                      null
                  ? plantDiagnosisViewModel!
                        .plantDiagnosisResponse
                        .value
                        .data!
                        .healthStatus!
                        .issues![0]
                        .severity!
                        .toTitleCase()
                  : "",
            ),
            TitleAndDescriptionLayout(
              title: AppLocalizations.of(context)!.symptoms,
              spacing: spacerSize5,
              fontSize: fontSize16,
              description:
                  plantDiagnosisViewModel!.plantDiagnosisResponse.value.data !=
                      null
                  ? plantDiagnosisViewModel!
                        .plantDiagnosisResponse
                        .value
                        .data!
                        .healthStatus!
                        .issues![0]
                        .symptoms!
                        .join('\n')
                        .toTitleCase()
                  : "",
            ),
            TitleAndDescriptionLayout(
              title: AppLocalizations.of(context)!.causes,
              spacing: spacerSize5,
              fontSize: fontSize16,
              description:
                  plantDiagnosisViewModel!.plantDiagnosisResponse.value.data !=
                      null
                  ? plantDiagnosisViewModel!
                        .plantDiagnosisResponse
                        .value
                        .data!
                        .healthStatus!
                        .issues![0]
                        .causes!
                        .join('\n')
                        .toTitleCase()
                  : "",
            ),
            BaseText(
              text: AppLocalizations.of(context)!.suggestedTreatment,
              fontFamily: AppKeys.merriweather,
              fontWeight: FontWeight.bold,
              textColor: AppColors.burntGoldLight,
              textAlign: TextAlign.left,
              fontSize: fontSize18,
            ).marginOnly(top: spacerSize10, bottom: spacerSize5),
            TitleAndDescriptionLayout(
              title: AppLocalizations.of(context)!.immediate,
              fontSize: fontSize16,
              spacing: spacerSize5,
              description:
                  plantDiagnosisViewModel!.plantDiagnosisResponse.value.data !=
                      null
                  ? plantDiagnosisViewModel!
                        .plantDiagnosisResponse
                        .value
                        .data!
                        .healthStatus!
                        .issues![0]
                        .treatment!
                        .immediate!
                        .join('\n')
                  : "",
            ),
            TitleAndDescriptionLayout(
              title: AppLocalizations.of(context)!.longTerm,
              fontSize: fontSize16,
              spacing: spacerSize5,
              description:
                  plantDiagnosisViewModel!.plantDiagnosisResponse.value.data !=
                      null
                  ? plantDiagnosisViewModel!
                        .plantDiagnosisResponse
                        .value
                        .data!
                        .healthStatus!
                        .issues![0]
                        .treatment!
                        .longTerm!
                        .join('\n')
                  : "",
            ),
            TitleAndDescriptionLayout(
              title: AppLocalizations.of(context)!.prevention,
              fontSize: fontSize16,
              spacing: spacerSize5,
              description:
                  plantDiagnosisViewModel!.plantDiagnosisResponse.value.data !=
                      null
                  ? plantDiagnosisViewModel!
                        .plantDiagnosisResponse
                        .value
                        .data!
                        .healthStatus!
                        .issues![0]
                        .treatment!
                        .prevention!
                        .join('\n')
                  : "",
            ),
          ],
        ),
      ),
      title: AppLocalizations.of(context)!.healthStatus,
    );
  }
}
