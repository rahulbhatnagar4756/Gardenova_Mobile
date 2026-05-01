import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_request_model.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

class PlantDiagnosisRepository {
  final String _plantDiagnosisEndPoint = "api/v1/admin/plants/identify";

  diagnosePlant({PlantDiagnosisRequestModel? plantDiagnosisRequest}) async {
    var plantDiagnosisResponse = await ApiRepository.instance.post(
      _plantDiagnosisEndPoint,
      body: plantDiagnosisRequest,
    );
    return plantDiagnosisResponse;
  }
}
