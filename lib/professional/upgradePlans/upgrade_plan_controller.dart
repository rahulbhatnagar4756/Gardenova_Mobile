import 'package:get/get.dart';
import 'package:kasagardem/professional/professionalDashBoard/components/plant_expire_dialog.dart';
import 'package:kasagardem/professional/upgradePlans/upgrade_plan_repository.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import '../../utils/routes.dart';
import '../../utils/shared_prefs_service.dart';
import 'model/plan_model.dart';
import '../../settings/model/subscription_local_status_ui_model.dart';
import '../../services/subscription_service.dart';

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
  SubscriptionStatusUiModel? currentModel;

  @override
  void onInit() {
    initIAP();
    if (Get.arguments != null) {
      if (Get.arguments is SubscriptionStatusUiModel) {
        currentModel = Get.arguments as SubscriptionStatusUiModel;
        screenType.value = AppKeys.dashboard;

        if (currentModel!.updatedAt != null) {
          try {
            final expirationDate = DateTime.parse(
              currentModel!.updatedAt!,
            ).toLocal();
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final exp = DateTime(
              expirationDate.year,
              expirationDate.month,
              expirationDate.day,
            );
            final difference = exp.difference(today).inDays;
            remainingDays.value = difference.clamp(0, 365).toString();
          } catch (_) {
            remainingDays.value = "0";
          }
        } else {
          remainingDays.value = "0";
        }
      } else if (Get.arguments is Map) {
        screenType.value = Get.arguments[AppKeys.screenType] ?? "";
        remainingDays.value =
            SharedPrefsService.instance.getString(AppKeys.remainingDays) ?? "0";
      }
    } else {
      remainingDays.value =
          SharedPrefsService.instance.getString(AppKeys.remainingDays) ?? "0";
    }
    callGetAllPlanListApi();
    if (remainingDays.value == "0") {
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

  void callGetAllPlanListApi() async {
    isLoading.value = true;
    var response = await upgradePlanRepository.getPlanList();

    if (response != null) {
      PlansResponseModel planResponse = PlansResponseModel.fromJson(response);
      planList.clear();
      planList.addAll(planResponse.data!.plans ?? []);
    }
    _addMockPlants();
    updateStorePrices();
    isLoading.value = false;
  }

  Future<void> initIAP() async {
    await SubscriptionService.instance.setupInAppPurchase();
    updateStorePrices();
  }

  void updateStorePrices() {
    if (SubscriptionService.instance.isAvailable &&
        SubscriptionService.instance.products.isNotEmpty) {
      for (var plan in planList) {
        final monthlyProdId = SubscriptionService.instance.getProductId(
          plan.planName ?? "",
          true,
        );
        final annualProdId = SubscriptionService.instance.getProductId(
          plan.planName ?? "",
          false,
        );

        if (monthlyProdId.isNotEmpty) {
          final monthlyProduct = SubscriptionService.instance.products
              .firstWhereOrNull((p) => p.id == monthlyProdId);
          if (monthlyProduct != null) {
            plan.priceMonthly = monthlyProduct.rawPrice.toInt().toString();
          }
        }
        if (annualProdId.isNotEmpty) {
          final annualProduct = SubscriptionService.instance.products
              .firstWhereOrNull((p) => p.id == annualProdId);
          if (annualProduct != null) {
            plan.priceAnnual = annualProduct.rawPrice.toInt().toString();
          }
        }
      }
      planList.refresh();
    }
  }

  void startPurchaseFlow() async {
    final plan = selectedPlanData;
    if (plan == null) {
      BaseSnackBar.show(title: "Plan", message: "Please select a plan");
      return;
    }

    isLoading.value = true;
    try {
      await SubscriptionService.instance.buyPlan(
        plan,
        isTabMonthly.value,
        currentModel,
      );
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  void _addMockPlants() {
    planList.clear();

    planList.add(
      PlanModel(
        id: "1",
        planName: "Free",
        description:
            "3 diagnosis scans/month\n1 landscape generation/month\nSave 5 plants\nBasic reminders",
        priceMonthly: "0",
        priceAnnual: "0",
        citiesCoverage: 5,
        appearInSearch: false,
        leadsLimit: 0,
        premiumProfileBadge: false,
        priorityCustomerSupport: false,
        status: "active",
      ),
    );

    planList.add(
      PlanModel(
        id: "2",
        planName: "Starter",
        description: "15 diagnosis scans\n2 landscape generations\n25 plants",
        priceMonthly: "99",
        priceAnnual: "999",
        citiesCoverage: 25,
        appearInSearch: true,
        leadsLimit: 15,
        premiumProfileBadge: false,
        priorityCustomerSupport: false,
        status: "active",
      ),
    );

    planList.add(
      PlanModel(
        id: "3",
        planName: "Plus",
        description:
            "30 diagnosis scans\n5 landscape generations\nUnlimited plants\nAI Care Assistant\nHD renders",
        priceMonthly: "199",
        priceAnnual: "1,999",
        citiesCoverage: 100,
        appearInSearch: true,
        leadsLimit: 0,
        premiumProfileBadge: true,
        priorityCustomerSupport: false,
        status: "active",
      ),
    );

    planList.add(
      PlanModel(
        id: "4",
        planName: "Pro",
        description:
            "50 diagnosis scans\n10 landscape generations\nPDF export\nPremium styles\nBefore/After download",
        priceMonthly: "299",
        priceAnnual: "2,999",
        citiesCoverage: 500,
        appearInSearch: true,
        leadsLimit: 0,
        premiumProfileBadge: true,
        priorityCustomerSupport: true,
        status: "active",
      ),
    );
  }
}
