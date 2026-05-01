import 'package:kasagardem/utils/network_services/api_repository.dart';

class ProfessionalDashboardRepository {
  final String professionalsDashboardListUrl =
      'api/v1/professional/getSortedProfessionals';
  final String _createProfessionalLeadUrl = 'api/v1/professional/createLeads';
  final String _createWholesaleLeadUrl =
      'api/v1/professional/createLeadsForWholesaler';
  final String _getAllWholesaleListUrl = 'api/v1/suppliers/getSortedsuppliers';

  createProfessionalLead({Map? leadDataReq}) async {
    var leadResponse = await ApiRepository.instance.post(
      _createProfessionalLeadUrl,
      body: leadDataReq,
    );
    return leadResponse;
  }

  createWholesaleLead({Map? leadDataReq}) async {
    var leadResponse = await ApiRepository.instance.post(
      _createWholesaleLeadUrl,
      body: leadDataReq,
    );
    return leadResponse;
  }



  fetchProfessionalDashboardList({
    double? latitude,
    double? longitude,
    String? pageNumber,
    String? pageSize,
    String? category,
  }) async {
    String endUrl = "$professionalsDashboardListUrl?page=$pageNumber&limit=$pageSize&lat=$latitude&lng=$longitude";

    if (category!= null && category.isNotEmpty) {
      endUrl = "$endUrl&category=$category";
    }
    var response = await ApiRepository.instance.get(endUrl);
    return response;
  }





  fetchAllWholesaleSupplierList(
    double latitude,
    double longitude,
    String category,
  ) async {
    var response = await ApiRepository.instance.get(
      "$_getAllWholesaleListUrl?lat=$latitude&lng=$longitude&category=${category.toLowerCase()}",
    );
    return response;
  }
}
