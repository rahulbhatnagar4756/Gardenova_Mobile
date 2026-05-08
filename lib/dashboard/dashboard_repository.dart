import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:kasagardem/dashboard/model/solid_analysis_model.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

class DashboardRepository {
  final String _plantRecommendationEndPoint = "api/v1/answers/plants";
  final String _externalLinksUrl = "api/v1/externalLinks";

  String getPlantRecommendationEndPoint(String responseId) {
    return "$_plantRecommendationEndPoint/$responseId";
  }

  fetchPlantRecommendation(
    String responseId, {
    bool showDefaultLoader = true,
  }) async {
    var plantsResponse = await ApiRepository.instance.get(
      getPlantRecommendationEndPoint(responseId),
      showDefaultLoader: showDefaultLoader,
    );
    return plantsResponse;
  }

  fetchExternalLink() async {
    var linkResponse = await ApiRepository.instance.get(_externalLinksUrl);
    return linkResponse;
  }

  /// NEW FUNCTION
  Future<SoilAnalysisModel?> fetchSoilAnalysis({
    required double lat,
    required double lon,
  }) async {
    try {
      final url =
          "https://rest.isric.org/soilgrids/v2.0/properties/query"
          "?lat=$lat"
          "&lon=$lon"
          "&property=clay"
          "&property=sand"
          "&property=silt"
          "&property=soc"
          "&depth=0-5cm";

      var response = await ApiRepository.instance.get(
        url,
        directUrl: true,
        showDefaultLoader: false,
        showRunTimeError: false,
      );
      log('response soild $response');

      return response != null ? SoilAnalysisModel.fromJson(response) : null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
