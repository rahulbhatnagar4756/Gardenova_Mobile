import 'package:kasagardem/utils/network_services/api_repository.dart';

class DashboardRepository {
  final String _plantRecommendationEndPoint = "api/v1/answers/plants";
  final String _externalLinksUrl = "api/v1/externalLinks";

  String getPlantRecommendationEndPoint(String responseId) {
    return "$_plantRecommendationEndPoint/$responseId";
  }

  fetchPlantRecommendation(String responseId) async {
    var plantsResponse = await ApiRepository.instance.get(
      getPlantRecommendationEndPoint(responseId),
    );
    return plantsResponse;
  }

  fetchExternalLink() async {
    var linkResponse = await ApiRepository.instance.get(_externalLinksUrl);
    return linkResponse;
  }
}
