import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/introduction/question/models/city_response_model.dart';
import 'package:kasagardem/introduction/question/models/question_response_model.dart';
import 'package:kasagardem/introduction/question/models/save_answer_request_model.dart';
import 'package:kasagardem/introduction/question/models/save_answer_response_model.dart';
import 'package:kasagardem/introduction/question/models/state_response_model.dart';
import 'package:kasagardem/introduction/question/question_repository.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

class QuestionViewModel extends GetxController {
  late QuestionRepository questionRepository;
  final formKey = GlobalKey<FormState>();
  RxInt currentQuestion = 1.obs;
  int totalQuestions = 5;
  RxBool isUserLoggedIn = false.obs;
  RxList<Questions> questionList = <Questions>[].obs;
  RxList<States> stateList = <States>[].obs;
  RxList<States> filteredStateList = <States>[].obs;
  RxList<Cities> cityList = <Cities>[].obs;
  RxList<Cities> filteredCityList = <Cities>[].obs;
  RxList<Answers> answerList = <Answers>[].obs;
  Rx<Cities> selectedCity = Cities().obs;
  Rx<States> selectedState = States().obs;
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  onInit() {
    questionRepository = QuestionRepository();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getQuestionList();
    });

    super.onInit();
  }

  getQuestionList() async {
    var response = await questionRepository.fetchQuestions();
    if (response != null) {
      QuestionResponseModel questionResponse = QuestionResponseModel.fromJson(
        response,
      );
      if (questionResponse.data != null) {
        questionList.value = questionResponse.data!.questions!;
      }
    }
  }

  getStateList() async {
    var response = await questionRepository.fetchStates();
    if (response != null) {
      stateList.clear();
      filteredStateList.clear();
      cityList.clear();
      filteredCityList.clear();
      selectedState.value = States();
      selectedCity.value = Cities();
      StateResponseModel stateResponse = StateResponseModel.fromJson(response);
      if (stateResponse.data != null) {
        stateList.value = stateResponse.data!.states!;
        filteredStateList.assignAll(stateList);
      }
    }
  }

  void filterState(String query) {
    if (query.isEmpty) {
      filteredStateList.assignAll(stateList);
    } else {
      filteredStateList.assignAll(stateList
          .where((state) =>
              state.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList());
    }
  }

  getCityList({required String? stateCode}) async {
    selectedCity.value = Cities();
    filteredCityList.clear();
    var response = await questionRepository.fetchCities(stateCode: stateCode);
    if (response != null) {
      CityResponseModel cityResponse = CityResponseModel.fromJson(response);
      if (cityResponse.data != null) {
        cityList.value = cityResponse.data!.cities!;
        filteredCityList.assignAll(cityList);
      }
    }
  }

  void filterCity(String query) {
    if (query.isEmpty) {
      filteredCityList.value = cityList;
    } else {
      filteredCityList.value = cityList
          .where((city) =>
              city.name?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
  }

  saveAnswer({required SaveAnswerRequestModel? saveAnswer}) async {
    var response = await questionRepository.saveAnswers(
      saveAnswerRequest: saveAnswer,
    );
    if (response != null) {
      SaveAnswerResponseModel plantResponse = SaveAnswerResponseModel.fromJson(
        response,
      );
      if (plantResponse.data != null) {
        SharedPrefsService.instance.setString(
          AppKeys.submissionResponseId,
          plantResponse.data!.responseId ?? "",
        );
        Get.toNamed(
          Routes.reportSuccess,
          arguments: {plantResponse.data!.responseId ?? ""},
        );
      }
    }
  }

  onContinuePressed() {
    if (currentQuestion.value != questionList.length) {
      if (questionList[currentQuestion.value - 1].selectedAnswer == null) {
        BaseSnackBar.show(
          title: AppLocalizations.of(Get.context!)!.error,
          message: AppLocalizations.of(Get.context!)!.pleaseSelectAnswer,
        );
        return;
      } else {
        if (currentQuestion.value == questionList.length - 1) {
          getStateList();
        }
        currentQuestion++;
      }
    } else {
      if (formKey.currentState!.validate()) {
        answerList.clear();
        for (var question in questionList) {
          answerList.add(
            question.selectedAnswer != null &&
                    question.selectedAnswer!.isNotEmpty
                ? Answers(
                    type: AppKeys.multipleChoiceType,
                    questionId: question.questionId,
                    selectedOption: question.selectedAnswer,
                  )
                : Answers(
                    type: AppKeys.dropDownType,
                    questionId: question.questionId,
                    selectedAddress: SelectedAddress(
                      city: cityController.text,
                      state:stateController.text,
                    ),
                  ),
          );
        }
        saveAnswer(saveAnswer: SaveAnswerRequestModel(answers: answerList));
      }
    }
  }

  backPressed() {
    if (currentQuestion.value == 1) {
      Get.back();
    } else {
      stateController.clear();
      cityController.clear();
      currentQuestion--;
    }
  }
}
