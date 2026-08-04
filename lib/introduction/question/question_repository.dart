import 'package:kasagardem/introduction/question/models/save_answer_request_model.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';

class QuestionRepository {
  final String _questionApiEndPoint = 'api/v1/admin/question';
  final String _answerApiEndPoint = 'api/v1/answers/';
  final String _statesApiEndPoint = 'api/v1/stateCityData/countries/states';
  final String _cityApiEndPoint = 'api/v1/stateCityData/countries';
  final String _saveAnswersEndPoint = 'api/v1/answers';

  String getCityEndPoint({String? stateCode}) {
    var language = 'IN';
    // String language ='BR'
    return '$_cityApiEndPoint/$language/states/$stateCode/cities';
  }

  Future<dynamic> fetchQuestions() async {
    var questionResponse = await ApiRepository.instance.get(_questionApiEndPoint);
    return questionResponse;
  }

  Future<dynamic> fetchAnswers({required String? userId}) async {
    var questionResponse = await ApiRepository.instance.get(_answerApiEndPoint + userId!);
    return questionResponse;
  }

  Future<dynamic> fetchStates() async {
    var statesResponse = await ApiRepository.instance.get(_statesApiEndPoint);
    return statesResponse;
  }

  Future<dynamic> fetchCities({required String? stateCode}) async {
    var loginResponse = await ApiRepository.instance.get(getCityEndPoint(stateCode: stateCode));
    return loginResponse;
  }

  Future<dynamic> saveAnswers({required SaveAnswerRequestModel? saveAnswerRequest}) async {
    var saveAnswerResponse = await ApiRepository.instance.post(
      _saveAnswersEndPoint,
      body: saveAnswerRequest,
    );
    return saveAnswerResponse;
  }
}
