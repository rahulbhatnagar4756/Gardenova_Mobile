import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:kasagardem/professional/myLead/model/my_lead_model.dart';
import '../../utils/constants/app_keys.dart';
import '../../utils/routes.dart';
import 'my_lead_repository.dart';

class MyLeadController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isSearching = false.obs;
  RxBool isTabSearch = false.obs;
  RxBool isLoadMoreRunning = false.obs;
  RxBool isLoadMoreVisible = true.obs;
  String noDataText = '';
  int pageSize = 20;
  RxInt newLeads = 0.obs;
  RxInt pageNumber = 1.obs;
  RxInt totalLeads = 0.obs;
  RxInt closedLeads = 0.obs;
  RxInt contactedLeads = 0.obs;

  final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));

  MyLeadRepository myLeadRepository = MyLeadRepository();

  RxList<LeadModel> myLeadsList = <LeadModel>[].obs;

  Map<String, String> get leadStatus => {
    "new": AppLocalizations.of(Get.context!)!.newLead,
    "closed": AppLocalizations.of(Get.context!)!.closedLead,
    "contacted": AppLocalizations.of(Get.context!)!.contactedLead,
  };

  @override
  void onInit() {
    callGetMyLeadListApi();
    super.onInit();
  }

  void navigateToNext(int index) {
    debugPrint("index:::$index");
    switch (index) {
      case 0:
        Get.back();
        break;
      case 1:
        Get.back(result: 0);
        Get.back(result: 0);
        break;
      case 2:
        Get.back(result: 1);
        Get.back(result: 1);
        break;
      case 3:
        Get.back();
        Get.toNamed(Routes.settings, arguments: AppKeys.professional);
        break;

      default:
        Get.back();
        break;
    }
  }

  void onTabSearch() {
    isTabSearch.value = !isTabSearch.value;
  }

  void onSelectItem(int index) {
    for (var element in myLeadsList) {
      element.isSelected = false;
    }
    myLeadsList[index].isSelected = true;
    myLeadsList.refresh();
  }

  void loadMoreLeads() {
    isLoadMoreRunning.value = true;
    if (isSearching.value == false) {
      pageNumber.value++;
    }
    getMyLeadList().then((value) => isLoadMoreRunning.value = false);
  }

  Future getMyLeadList({String searchName = ''}) async {
    var response = await myLeadRepository.fetchAllLead(
      pageNumber: pageNumber.value.toString(),
      pageSize: pageSize.toString(),
      searchName: searchName,
    );
    if (response != null) {
      debugPrint("response:::$response");
      LeadsResponseModel allLeadsResponse = LeadsResponseModel.fromJson(
        response,
      );
      myLeadsList.clear();
      myLeadsList.addAll(allLeadsResponse.data!);
      isLoadMoreVisible.value = true;
      noDataText = AppLocalizations.of(Get.context!)!.noLeadsFound;

      callAllLeadMetricApi();

      /*  allLeadsResponse.data!.totalCount! > myLeadsList.length
          ? true
          : false;*/
    }
  }

  callGetMyLeadListApi({String searchName = ''}) {
    isLoading.value = true;
    getMyLeadList(
      searchName: searchName,
    ).then((value) => isLoading.value = false);
  }

  callUpdateLeadStatusApi(String leadId) {
    isLoading.value = true;
    myLeadRepository.updateLeadStatus(leadId).then((value) {
      if (value != null) {
        Get.back();
        callGetMyLeadListApi();
      }
    });
  }

  Future callAllLeadMetricApi() async {
    var response = await myLeadRepository.fetchAllMetricLeadData();
    if (response != null) {
      debugPrint("response:::$response");
      totalLeads.value = response['data']['totalLeads'] ?? 0;
      newLeads.value = response['data']['newLeads'] ?? 0;
      contactedLeads.value = response['data']['contactedLeads'] ?? 0;
      closedLeads.value = response['data']['closedLeads'] ?? 0;
    }
  }

}
