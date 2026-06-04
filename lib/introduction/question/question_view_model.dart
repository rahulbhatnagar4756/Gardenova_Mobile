import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
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

import '../../base/dialogs/base_dialog.dart';
import '../../utils/constants/app_strings.dart';

class QuestionViewModel extends GetxController {
  late QuestionRepository questionRepository;
  final formKey = GlobalKey<FormState>();
  RxInt currentQuestion = 0.obs;
  // var totalQuestions = 5.obs;
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
  TextEditingController stateSearchController = TextEditingController();
  TextEditingController citySearchController = TextEditingController();
  bool cameFromSetting = false;
  bool showExtraPreference = false;

  List<Questions> get multipleChoiceQuestions => questionList
      .where((q) => q.options != null && q.options!.isNotEmpty)
      .toList();

  @override
  onInit() {
    cameFromSetting = Get.arguments as bool? ?? false;
    questionRepository = QuestionRepository();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getQuestionList();
    });

    super.onInit();
  }

  void getQuestionList() async {
    var response = await questionRepository.fetchQuestions();
    if (response != null) {
      QuestionResponseModel questionResponse = QuestionResponseModel.fromJson(
        response,
      );
      if (questionResponse.data != null) {
        questionList.value = questionResponse.data!.questions!;
        if (multipleChoiceQuestions.isNotEmpty && currentQuestion.value == 0) {
          currentQuestion.value = 1;
        }
      }
    }
  }

  void getStateList() async {
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
      filteredStateList.assignAll(
        stateList
            .where(
              (state) =>
                  state.name?.toLowerCase().contains(query.toLowerCase()) ??
                  false,
            )
            .toList(),
      );
    }
  }

  void getCityList({required String? stateCode}) async {
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
    cityController.text = '';
    selectedCity.value = Cities();
  }

  void filterCity(String query) {
    if (query.isEmpty) {
      filteredCityList.assignAll(cityList);
    } else {
      filteredCityList.assignAll(
        cityList
            .where(
              (city) =>
                  city.name?.toLowerCase().contains(query.toLowerCase()) ??
                  false,
            )
            .toList(),
      );
    }
  }

  void saveAnswer({required SaveAnswerRequestModel? saveAnswer}) async {
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

        // Get.toNamed(
        //   Routes.reportSuccess,
        //   arguments: {plantResponse.data!.responseId ?? ""},
        // );
        BaseDialog.showFullScreenDialog(
          barrieDismissible: false,
          Get.context!,
          buttonLabel: AppLocalizations.of(Get.context!)!.viewReport,
          dialogTitle: AppLocalizations.of(
            Get.context!,
          )!.yourIntelligentDiagnosisReportIsReady,
          dialogDescription: '',
          onButtonPressed: () {
            Get.back();
            print('cameFromSetting  $cameFromSetting');
            if (cameFromSetting) {
              // Get.back();
              // Get.back();
              if (Get.isRegistered<DashboardController>()) {
                Get.find<DashboardController>().getPlantsRecommendations(
                  plantResponse.data!.responseId ?? "",
                );
              }
              Get.until((route) => route.settings.name == Routes.profile);
            } else {
              SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, true);
              Get.offAllNamed(
                Routes.dashboard,
                arguments: {plantResponse.data!.responseId ?? ""},
              );
            }
          },
        );
      }
    }
  }

  void submitAnswers() {
    answerList.clear();
    for (var question in questionList) {
      if (question.options != null && question.options!.isNotEmpty) {
        if (question.selectedAnswer != null &&
            question.selectedAnswer!.isNotEmpty) {
          answerList.add(
            Answers(
              type: AppKeys.multipleChoiceType,
              questionId: question.questionId,
              selectedOption: question.selectedAnswer,
            ),
          );
        }
      } else if (showExtraPreference) {
        answerList.add(
          Answers(
            type: AppKeys.dropDownType,
            questionId: question.questionId,
            selectedAddress: SelectedAddress(
              city: cityController.text,
              state: stateController.text,
            ),
          ),
        );
      }
    }
    saveAnswer(saveAnswer: SaveAnswerRequestModel(answers: answerList));
  }

  void onContinuePressed() {
    if (currentQuestion.value <= multipleChoiceQuestions.length) {
      if (multipleChoiceQuestions[currentQuestion.value - 1].selectedAnswer ==
          null) {
        BaseSnackBar.show(
          title: AppStrings.selectionRequired.tr,
          message: AppStrings.pleaseSelectAnAnswerToContinue.tr,
        );
        return;
      } else {
        if (currentQuestion.value == multipleChoiceQuestions.length) {
          if (showExtraPreference) {
            getStateList();
            currentQuestion++;
          } else {
            submitAnswers();
          }
        } else {
          currentQuestion++;
        }
      }
    } else {
      if (formKey.currentState?.validate() == true) {
        submitAnswers();
      }
    }
  }

  void backPressed() {
    if (currentQuestion.value <= 1) {
      Get.back();
    } else {
      if (showExtraPreference &&
          currentQuestion.value == multipleChoiceQuestions.length + 1) {
        stateController.clear();
        cityController.clear();
        stateSearchController.clear();
        citySearchController.clear();
      }
      currentQuestion--;
    }
  }
}
