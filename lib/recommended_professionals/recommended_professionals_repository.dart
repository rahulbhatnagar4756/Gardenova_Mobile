import 'package:kasagardem/utils/network_services/api_repository.dart';

class RecommendedProfessionalRepository {
  // final String _createLeadEndPoint = 'api/v1/admin/leads';
  final String _createLeadEndPoint = 'api/v1/professional/createLeads';
  // final String _recommendedProfessionalsEndPoint = 'api/v1/answers/partners';
  final String _recommendedProfessionalsEndPoint =
      'api/v1/professional/getSortedProfessionals';

  createLead({Map? leadDataReq}) async {
    var leadResponse = await ApiRepository.instance.post(
      _createLeadEndPoint,
      body: leadDataReq,
    );
    return leadResponse;
  }

  fetchProfessionalRecommendations(String responseId) async {
    var plantsResponse = await ApiRepository.instance.get(
      '$_recommendedProfessionalsEndPoint/$responseId',
    );
    return plantsResponse;
  }

  fetchProfessionalList({
    double? latitude,
    double? longitude,
    String? pageNumber,
    String? pageSize,
    String? category,
  }) async {
    String endUrl = "$_recommendedProfessionalsEndPoint?page=$pageNumber&limit=$pageSize&lat=$latitude&lng=$longitude";

    if (category!= null && category.isNotEmpty) {
      endUrl = "$endUrl&category=$category";
    }
    var response = await ApiRepository.instance.get(endUrl);
    return response;
  }





}
