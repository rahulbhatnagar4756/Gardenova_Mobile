import 'package:flutter/foundation.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_request_model.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

class PlantDiagnosisRepository {
  final String _plantDiagnosisEndPoint = "api/v1/admin/plants/identify";

  diagnosePlant({PlantDiagnosisRequestModel? plantDiagnosisRequest}) async {
    // if (kDebugMode) {
    //   await Future.delayed(const Duration(milliseconds: 5000));
    //   return {"success": false, "message": 'Not able to load data'};
    // }
    var plantDiagnosisResponse = await ApiRepository.instance.post(
      _plantDiagnosisEndPoint,
      body: plantDiagnosisRequest,
      showDefaultLoader: false,
      showRunTimeError: false,
      rethrowExceptions: true,
    );

    return plantDiagnosisResponse;
  }
}
