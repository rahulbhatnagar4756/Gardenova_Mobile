import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kasagardem/professional/professionalDashBoard/model/professional_dashboard_model.dart';
import 'package:kasagardem/professional/professionalDashBoard/professinal_dashboard_repository.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../base/widgets/base_text.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/routes.dart';
import '../../utils/shared_prefs_service.dart';

class ProfessionalDashboardController extends GetxController {
  RxBool isUserLoggedIn = false.obs;
  RxBool isLoading = false.obs;
  RxBool hidePopUp = false.obs;
  RxInt selectedTabIndex = 0.obs;
  RxInt pageNumber = 1.obs;
  int pageSize = 20;
  RxBool isLoadMoreVisible = false.obs;
  RxBool isSearching = false.obs;
  RxBool isLoadMoreRunning = false.obs;
  double lat = 0.0;
  double long = 0.0;
  Position? position;

  RxList<ProfessionalCompany> professionalsList = <ProfessionalCompany>[].obs;
  RxList<ProfessionalCompany> selectedProfessionalsList =
      <ProfessionalCompany>[].obs;
  RxList<ProfessionalCompany> selectedWholesaleList =
      <ProfessionalCompany>[].obs;
  final ProfessionalDashboardRepository professionalDashboardRepository = ProfessionalDashboardRepository();

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

  final RxString selectedService = ''.obs;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController serviceController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments < 2) {
      debugPrint("selected index:::::${Get.arguments}");
      selectedTabIndex.value = Get.arguments;
    }

    if (SharedPrefsService.instance.getString(AppKeys.remainingDays) == "0") {
      hidePopUp.value = true;
    } else {
      hidePopUp.value = false;
    }
    loadData();
  }

  Future<void> loadData() async {
    await getCurrentLocation();
    callGetProfessionalListApi();
  }

  void onTabChanged(int index) {
    selectedTabIndex.value = index;
    professionalsList.clear();
    isLoading.value = true;
    if (index == 0) {
      callGetProfessionalListApi();
    } else {
      callGetWholesaleSupplierListApi();
    }
  }

  void navigateToNext(int index) async {
    switch (index) {
      case 0:
        Get.back();
        var newIndex = await Get.toNamed(Routes.myLeadScreen);
        if (newIndex != null && newIndex is int) {
          selectedTabIndex.value = newIndex;
        }
        break;
      case 1:
        Get.back();
        selectedTabIndex.value = 0;
        callGetProfessionalListApi();
        break;
      case 2:
        Get.back();
        selectedTabIndex.value = 1;
        callGetWholesaleSupplierListApi();
        break;
      case 3:
        Get.back();
        Get.toNamed(Routes.settings, arguments: AppKeys.professional)!.then((
          value,
        ) {
          if (value == true) {
            professionalsList.clear();
            categories.clear();
            loadData();
          }
        });
        break;

      default:
        Get.back();
        break;
    }
  }

  void onTapToSelect(int index) {
    professionalsList[index].isSelected = !professionalsList[index].isSelected;
    professionalsList.refresh();
    if (selectedTabIndex.value == 0) {
      selectedProfessional(index);
    } else {
      selectedWholesale(index);
    }
  }

  void selectedProfessional(int index) {
    selectedProfessionalsList.clear();
    selectedWholesaleList.clear();
    selectedProfessionalsList.addAll(
      professionalsList
          .where((professional) => professional.isSelected == true)
          .toList(),
    );
    Get.toNamed(Routes.createProfessionalLeadRequestScreen);
  }

  void selectedWholesale(int index) {
    selectedProfessionalsList.clear();
    selectedWholesaleList.clear();
    selectedWholesaleList.addAll(
      professionalsList
          .where((professional) => professional.isSelected == true)
          .toList(),
    );
  }

  void onTabHidePopup() {
    hidePopUp.value = true;
  }

  Future getCurrentLocation() async {
    position = await _determinePosition();
    lat = position!.latitude;
    long = position!.longitude;

    return position;
  }

  Future<Position> _determinePosition() async {
    isLoading.value = true;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (Platform.isIOS) {
        await Get.dialog(
          AlertDialog(
            title: BaseText(
              text: AppLocalizations.of(
                Get.context!,
              )!.locationPermissionRequired,
            ),
            content: BaseText(
              text: AppLocalizations.of(
                Get.context!,
              )!.locationPermissionsAreDenied,
            ),
            actions: [
              TextButton(
                child: BaseText(
                  text: AppLocalizations.of(Get.context!)!.cancel,
                ),
                onPressed: () => Get.back(),
              ),
              TextButton(
                child: BaseText(
                  text: AppLocalizations.of(Get.context!)!.openSettings,
                ),
                onPressed: () {
                  Geolocator.openAppSettings();
                  Get.back();
                },
              ),
            ],
          ),
        );
        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.',
        );
      }

      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
    return await Geolocator.getCurrentPosition();
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
    final response = await professionalDashboardRepository
        .fetchProfessionalDashboardList(
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




  Future<void> callGetWholesaleSupplierListApi() async {
    try {
      isLoading.value = true;
      final response = await professionalDashboardRepository
          .fetchAllWholesaleSupplierList(lat, long, "");
      if (response != null) {
        final apiResponse = ApiResponse.fromJson(response);
        final wholesaleResponse = apiResponse.data;
        professionalsList.clear();
        professionalsList.addAll(wholesaleResponse?.data ?? []);
      }
    } catch (e, stackTrace) {
      debugPrint("error::: $e");
      debugPrint("stackTrace::: $stackTrace");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createLeadForProfessional() async {
    var response = await professionalDashboardRepository.createProfessionalLead(
      leadDataReq: {
        "professionalIds": selectedProfessionalsList
            .map((ProfessionalCompany professional) => professional.userId)
            .toList(),
        "description":descriptionController.text,
        "size":sizeController.text,
        "category":serviceController.text,
      },
    );
    if (response != null) {
      descriptionController.clear();
      serviceController.clear();
      sizeController.clear();
      selectedProfessionalsList.clear();
      Get.toNamed(
        Routes.professionalDashboardSuccessQuote,
        arguments: selectedProfessionalsList,
      );
    }
  }

  Future<void> createLeadForWholesale() async {
    var response = await professionalDashboardRepository.createWholesaleLead(
      leadDataReq: {
        "wholesalerIds": selectedWholesaleList
            .map((ProfessionalCompany professional) => professional.id)
            .toList(),
      },
    );
    if (response != null) {
      Get.toNamed(
        Routes.professionalDashboardSuccessQuote,
        arguments: selectedWholesaleList,
      );
    }
  }
}
