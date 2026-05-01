import 'package:kasagardem/introduction/question/models/save_answer_request_model.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

class QuestionRepository {
  final String _questionApiEndPoint = 'api/v1/admin/question';
  final String _statesApiEndPoint = 'api/v1/stateCityData/countries/states';
  final String _cityApiEndPoint = 'api/v1/stateCityData/countries/BR';
  final String _saveAnswersEndPoint = 'api/v1/answers';

  getCityEndPoint({String? stateCode}) {
    return '$_cityApiEndPoint/states/$stateCode/cities';
  }

  fetchQuestions() async {
    var questionResponse = await ApiRepository.instance.get(
      _questionApiEndPoint,
    );
    return questionResponse;
  }

  fetchStates() async {
    var statesResponse = await ApiRepository.instance.get(_statesApiEndPoint);
    return statesResponse;
  }

  fetchCities({required String? stateCode}) async {
    var loginResponse = await ApiRepository.instance.get(
      getCityEndPoint(stateCode: stateCode),
    );
    return loginResponse;
  }

  saveAnswers({required SaveAnswerRequestModel? saveAnswerRequest}) async {
    var saveAnswerResponse = await ApiRepository.instance.post(
      _saveAnswersEndPoint,
      body: saveAnswerRequest,
    );
    return saveAnswerResponse;
  }
}
