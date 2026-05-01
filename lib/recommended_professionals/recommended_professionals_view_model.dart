import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/recommended_professionals/recommended_professionals_repository.dart';

import '../base/dialogs/base_dialog.dart';
import '../l10n/app_localizations.dart';
import '../professional/professionalDashBoard/model/professional_dashboard_model.dart';
import '../utils/constants/app_keys.dart';
import '../utils/routes.dart';
import '../utils/shared_prefs_service.dart';

class RecommendedProfessionalsViewModel extends GetxController {
  RxBool isUserLoggedIn = false.obs;
  RxBool isLoadMoreRunning = false.obs;
  RxBool isLoadMoreVisible = false.obs;
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  RxInt pageNumber = 1.obs;
  int pageSize = 20;
  double lat = 0.0;
  double long = 0.0;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final RecommendedProfessionalRepository _recommendedProfessionalRepository =
      RecommendedProfessionalRepository();
  RxList<ProfessionalCompany> professionalsList = <ProfessionalCompany>[].obs;
  RxList<ProfessionalCompany> selectedProfessionalsList =
      <ProfessionalCompany>[].obs;

  // RxList<ProfessionalRecommendations> professionalsList = <ProfessionalRecommendations>[].obs;
  //RxList<ProfessionalRecommendations> selectedProfessionalsList = <ProfessionalRecommendations>[].obs;
  final RxString selectedService = ''.obs;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();

  final loc = AppLocalizations.of(Get.context!);

  final Map<String, Map<String, String>> categories = {
    "landscaping_gardening": {
      "en": "Landscaping & Gardening",
      "pt": "Jardinagem e Paisagismo",
    },
    "flower_shops": {"en": "Flower Shops", "pt": "Floriculturas"},
    "swimming_pools": {"en": "Swimming Pools", "pt": "Piscinas"},
    "outdoor_flooring": {
      "en": "Outdoor Flooring",
      "pt": "Pisos e Revestimentos",
    },
    "irrigation": {"en": "Irrigation", "pt": "Irrigação"},
    "outdoor_lighting": {"en": "Outdoor Lighting", "pt": "Iluminação Externa"},
    "lawn_turf": {"en": "Lawn & Turf", "pt": "Grama e Gramados"},
    "bbq_outdoor_kitchen": {
      "en": "BBQ & Outdoor Kitchen",
      "pt": "Churrasqueiras",
    },
    "decks_pergolas": {"en": "Decks & Pergolas", "pt": "Decks e Pergolados"},
    "nurseries_seedlings": {
      "en": "Nurseries & Seedlings",
      "pt": "Viveiros e Mudas",
    },
    "pest_control": {"en": "Pest Control", "pt": "Controle de Pragas"},
  };

  @override
  void onInit() {
    if (Get.arguments != null) {
      debugPrint("Get.arguments::${Get.arguments['lat']}");
      lat = double.tryParse(Get.arguments['lat']?.toString() ?? "0.0") ?? 0.0;
      long = double.tryParse(Get.arguments['lng']?.toString() ?? "0.0") ?? 0.0;
    }
    super.onInit();
    callGetProfessionalListApi();
  }

  void loadMoreProfessional() {
    isLoadMoreRunning.value = true;
    if (isSearching.value == false) {
      pageNumber.value++;
    }
    getAllProfessionalList().then((value) => isLoadMoreRunning.value = false);
  }

  Future<void> callGetProfessionalListApi() async {
    professionalsList.clear();
    isLoading.value = true;
    await getAllProfessionalList();
    isLoading.value = false;
  }

  Future getAllProfessionalList() async {
    final response = await _recommendedProfessionalRepository
        .fetchProfessionalList(
        latitude: lat,
        longitude:long,
        pageNumber: pageNumber.toString(),
        pageSize: pageSize.toString(),
        category: selectedService.value

    );
    if (response != null) {
      final apiResponse = ApiResponse.fromJson(response);
      final professionalResponse = apiResponse.data;
      professionalsList.addAll(professionalResponse?.data ?? []);
      isLoadMoreVisible.value =true;

    }
  }


  void navigateToNext(int index) {
    debugPrint("index:::$index");
    switch (index) {
      case 0:
        Get.back();
        Get.back();
        break;
      case 2:
        break;

      case 3:
        break;

      case 4:
        break;

      case 5:
        Get.back();
        Get.toNamed(Routes.settings)!.then((value) {
          if (value == true) {
            callGetProfessionalListApi();
          }
        });
        break;

      case 6:
        Get.back();
        Get.toNamed(Routes.myPlantsScreen);
        break;

      default:
        Get.back();
        break;
    }
  }

  onTapToSelect(int index) {
    professionalsList[index].isSelected = !professionalsList[index].isSelected;
    professionalsList.refresh();
    selectedProfessional(index);
  }

  void selectedProfessional(int index) {
    selectedProfessionalsList.clear();
    selectedProfessionalsList.addAll(
      professionalsList
          .where((professional) => professional.isSelected == true)
          .toList(),
    );
  }

  /*  Future<void> createLead() async {
    var response = await _recommendedProfessionalRepository.createLead(
      leadDataReq: {
        ApiKeys.partnerIds: selectedProfessionalsList
            .map((ProfessionalRecommendations professional) => professional.partnerId)
            .toList(),
      },
    );*/

  Future<void> createLeadForProfessional() async {
    var response = await _recommendedProfessionalRepository.createLead(
      leadDataReq: {
        "professionalIds": selectedProfessionalsList
            .map((ProfessionalCompany professional) => professional.userId)
            .toList(),
        "description": descriptionController.text,
        "size": sizeController.text,
        "category": serviceController.text,
      },
    );

    if (response != null) {
      descriptionController.clear();
      serviceController.clear();
      sizeController.clear();
      selectedProfessionalsList.clear();
      Get.toNamed(
        Routes.requestQuoteSuccess,
        arguments: selectedProfessionalsList,
      );
    }
  }

  /* getProfessionalRecommendations(String responseId) async {
    isLoading.value = true;
    var response = await _recommendedProfessionalRepository
        .fetchProfessionalRecommendations(responseId);

    if (response != null) {
      RecommendedProfessionalsResponseModel professionalResponse =
          RecommendedProfessionalsResponseModel.fromJson(response);
      professionalsList.clear();
      professionalsList.addAll(
        professionalResponse.data!.partnerRecommendations ?? [],
      );
    }
    isLoading.value = false;
  }*/

  checkLogin() {
    if (SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false) {
      //  createLead();
      createLeadForProfessional();
    } else {
      showLoginDialog();
    }
  }

  showLoginDialog() {
    BaseDialog.showAlertDialog(
      context: Get.context!,
      onButtonPressed: () {
        Get.back();
        Get.toNamed(Routes.login, arguments: {"question_state_passed": true});
      },
      title: AppLocalizations.of(Get.context!)!.login.toUpperCase(),
      description: AppLocalizations.of(
        Get.context!,
      )!.pleaseLoginToSeeRecommendedProfessionals,
      buttonLabel: AppLocalizations.of(Get.context!)!.login.toUpperCase(),
    );
  }
}
