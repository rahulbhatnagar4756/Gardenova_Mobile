import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/dashboard/components/automation_suggestions.dart';
import 'package:kasagardem/dashboard/components/heading_ui_layout.dart';
import 'package:kasagardem/dashboard/components/soil_analysis.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
import 'package:kasagardem/dashboard/plant_recommendations/plant_recommendations.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class MainDashboardContent extends StatelessWidget {
  final DashboardController controller;

  const MainDashboardContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeadingUiLayout(
            sectionTitle: AppLocalizations.of(context)!.overview,
            child: SoilAnalysis(),
          ),
          const SizedBox(height: spacerSize20),
          HeadingUiLayout(
            sectionTitle: AppLocalizations.of(context)!.automationSuggestions,
            child: AutomationSuggestions(),
          ),
          const SizedBox(height: spacerSize20),
          HeadingUiLayout(
            sectionTitle: AppLocalizations.of(context)!.plantRecommendations,
            child: Column(
              children: [PlantRecommendations(controller: controller)],
            ),
          ),
        ],
      ).marginOnly(top: spacerSize25, left: spacerSize20, right: spacerSize20),
    );
  }
}
