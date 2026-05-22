import 'package:flutter/material.dart';
import 'package:kasagardem/dashboard/components/common_component_dashboardview.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import '../../utils/constants/app_assets.dart';

class AiPlantDiagnosisCard extends StatelessWidget {
  final VoidCallback? onTap;

  const AiPlantDiagnosisCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: CommonComponentDashboardView(
        title: AppLocalizations.of(context)!.plantAnalysis,
        description: AppLocalizations.of(
          context,
        )!.scanYourPlantForHealthAndDetails,
        image: AppAssets.aiAnalysisIc,
      ),
    );
  }
}
