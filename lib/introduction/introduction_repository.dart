import 'package:kasagardem/introduction/introduction_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';

class IntroductionRepository {
  fetchIntroductionList(AppLocalizations appLocalisation) {
    return [
      IntroductionModel(
        title: appLocalisation.smartAnalysis,
        description: appLocalisation.smartAnalysisDesc,
        imagePath: AppAssets.brain,
      ),
      IntroductionModel(
        title: appLocalisation.productRecommendations,
        description: appLocalisation.productRecommendationsDesc,
        imagePath: AppAssets.cart,
      ),
      IntroductionModel(
        title: appLocalisation.professionalConnections,
        description: appLocalisation.professionalConnectionsDesc,
        imagePath: AppAssets.people,
      ),
    ];
  }
}
