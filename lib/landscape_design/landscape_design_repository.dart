import 'package:kasagardem/utils/network_services/api_repository.dart';
import 'model/landscape_design_model.dart';

class LandscapeDesignRepository {
  final String _landscapeDesignEndPoint = "api/v1/landscape/";

  generateLandscapeDesign({LandscapeDesignRequestModel? request}) async {
    var response = await ApiRepository.instance.post(
      _landscapeDesignEndPoint,
      body: request,
      showDefaultLoader: false,
      showRunTimeError: false,
    );
    return response;
  }
}
