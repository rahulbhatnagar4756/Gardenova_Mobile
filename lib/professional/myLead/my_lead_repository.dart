import 'package:kasagardem/utils/network_services/api_repository.dart';

class MyLeadRepository {
  final String getAllLeadUrl = 'api/v1/professional/getLeads';
  final String updateLeadStatusUrl = 'api/v1/professional/updateStatus/';
  final String getAllMetricDataUrl = 'api/v1/admin/getLeadsForMonth';

  fetchAllLead({
    String? pageNumber,
    String? pageSize,
    String? searchName,
  }) async {
    var endUrl = "$getAllLeadUrl?page=$pageNumber&limit=$pageSize";
    if (searchName != null && searchName.isNotEmpty) {
      endUrl = "$endUrl&search=$searchName";
    }
    var leadResponse = await ApiRepository.instance.get(endUrl);
    return leadResponse;
  }

  updateLeadStatus(String leadId) async {
    var leadResponse = await ApiRepository.instance.patch(
      "$updateLeadStatusUrl$leadId",
      {},
    );
    return leadResponse;
  }

  fetchAllMetricLeadData() async {
    var leadResponse = await ApiRepository.instance.get(getAllMetricDataUrl);
    return leadResponse;
  }
}
