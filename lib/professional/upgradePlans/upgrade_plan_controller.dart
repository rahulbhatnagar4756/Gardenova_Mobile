import 'package:get/get.dart';
import 'package:kasagardem/professional/professionalDashBoard/components/plant_expire_dialog.dart';
import 'package:kasagardem/professional/upgradePlans/upgrade_plan_repository.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import '../../utils/routes.dart';
import '../../utils/shared_prefs_service.dart';
import 'model/plan_model.dart';

class UpgradePlanController extends GetxController {
  RxBool isTabMonthly = true.obs;
  RxBool isSelectOneTime = true.obs;
  RxBool isTabAdditionalCoverage = false.obs;
  RxString selectedPrice = "".obs;
  RxString screenType = "".obs;
  RxString remainingDays = "".obs;
  UpgradePlanRepository upgradePlanRepository = UpgradePlanRepository();
  RxList<PlanModel> planList = <PlanModel>[].obs;
  PlanModel? selectedPlanData;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      screenType.value = Get.arguments[AppKeys.screenType] ?? "";
    }
    remainingDays.value =
        SharedPrefsService.instance.getString(AppKeys.remainingDays) ?? "0";
    callGetAllPlanListApi();
    if (SharedPrefsService.instance.getString(AppKeys.remainingDays) == "0") {
      PlanExpireDialog();
    }
    super.onInit();
  }

  void changeTab(bool value) {
    isTabMonthly.value = value;
    isTabAdditionalCoverage.value = false;
    isSelectOneTime.value = true;
    selectedPrice.value = "";
    planList.where((plan) => plan.isSelect == true).forEach((plan) {
      plan.setSelect = false;
    });
  }

  void selectPlanType(bool value) {
    isSelectOneTime.value = value;
  }

  void changeTabAdditionalCoverage(bool value) {
    isTabAdditionalCoverage.value = value;
  }

  void selectPlan(int index) {
    for (int i = 0; i < planList.length; i++) {
      planList[i].setSelect = i == index;
    }
    final selectedPlan = planList[index];
    if (isTabMonthly.value) {
      selectedPrice.value = "${selectedPlan.priceMonthly!}/mo";
    } else {
      selectedPrice.value = "${selectedPlan.priceAnnual!}/an";
    }
    planList.refresh();
    selectedPlanData = null;
  }

  void goToOrderSummary() {
    final selectedPlan = planList.firstWhereOrNull(
      (plan) => plan.isSelect == true,
    );
    if (selectedPlan != null) {
      selectedPlanData = selectedPlan;
      Get.toNamed(Routes.orderSummary);
    } else {
      BaseSnackBar.show(title: "Plan", message: "Please select a plan");
    }
  }

  callGetAllPlanListApi() async {
    isLoading.value = true;
    var response = await upgradePlanRepository.getPlanList();

    if (response != null) {
      PlansResponseModel planResponse = PlansResponseModel.fromJson(response);
      planList.clear();
      planList.addAll(planResponse.data!.plans ?? []);
    }
    isLoading.value = false;
  }
}
