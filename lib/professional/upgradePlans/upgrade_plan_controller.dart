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
        _applyBillingCycleFromSubscription();

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
    if (isTabMonthly.value == value) return;

    isTabMonthly.value = value;
    isTabAdditionalCoverage.value = false;
    isSelectOneTime.value = true;

    if (_hasActiveSubscription) {
      for (final plan in planList) {
        plan.setSelect = false;
      }
      selectedPlanData = null;
      selectedPrice.value = "";

      if (isTabMonthly.value == _isSubscribedToMonthly) {
        setSelectedPlan(applyBillingCycle: false);
      }
      planList.refresh();
      return;
    }

    for (final plan in planList) {
      plan.setSelect = false;
    }
    selectedPlanData = null;
    selectedPrice.value = "";
    planList.refresh();
  }

  void selectPlanType(bool value) {
    isSelectOneTime.value = value;
  }

  void changeTabAdditionalCoverage(bool value) {
    isTabAdditionalCoverage.value = value;
  }

  void selectPlan(PlanModel plan) {
    if (plan.isSelect == true) {
      _updateSelectedPrice(plan);
      return;
    }

    for (int i = 0; i < planList.length; i++) {
      planList[i].setSelect = planList[i] == plan;
    }
    _updateSelectedPrice(plan);
    planList.refresh();
    selectedPlanData = null;
  }

  void _updateSelectedPrice(PlanModel plan) {
    if (isTabMonthly.value) {
      selectedPrice.value = "${plan.priceMonthly ?? '0'}/mo";
    } else {
      selectedPrice.value = "${plan.priceAnnual ?? '0'}/an";
    }
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

  double getOrderTotalAmount() {
    final plan = selectedPlanData;
    if (plan == null) return 0;

    final basePriceStr =
        (isTabMonthly.value ? plan.priceMonthly : plan.priceAnnual) ?? "0";
    final double basePrice =
        double.tryParse(basePriceStr.replaceAll(',', '').replaceAll(' ', '')) ??
            0.0;

    double additionalPrice = 0.0;
    if (isTabAdditionalCoverage.value) {
      if (isTabMonthly.value) {
        additionalPrice = 100.0;
      } else {
        additionalPrice = isSelectOneTime.value ? 100.0 : 1200.0;
      }
    }

    return basePrice + additionalPrice;
  }

  void callGetAllPlanListApi() async {
    isLoading.value = true;
    var response = await upgradePlanRepository.getPlanList();

    if (response != null) {
      PlansResponseModel planResponse = PlansResponseModel.fromJson(response);
      planList
        ..clear()
        ..addAll(
          PlanModel.consolidateByTier(
            planResponse.data ?? [],
            includeProfessionalFields: true,
          ),
        );
    }
    setSelectedPlan();
    updateStorePrices();
    isLoading.value = false;
  }

  void _applyBillingCycleFromSubscription() {
    final cycle = (currentModel?.billingCycle ?? '').trim().toLowerCase();
    if (cycle.isEmpty) return;
    isTabMonthly.value =
        cycle == 'monthly' || cycle == 'month' || cycle == 'mo';
  }

  void setSelectedPlan({bool applyBillingCycle = true}) {
    if (!_hasActiveSubscription) return;
    if (applyBillingCycle) {
      _applyBillingCycleFromSubscription();
    }

    final planName = (currentModel?.name ?? '').trim().toLowerCase();
    final planId = currentModel?.id?.trim();

    PlanModel? subscribedPlan;
    if (planId != null && planId.isNotEmpty) {
      subscribedPlan = planList.firstWhereOrNull(
        (plan) =>
            plan.id == planId ||
            plan.monthlyId == planId ||
            plan.yearlyId == planId,
      );
    }
    if (subscribedPlan == null &&
        planName.isNotEmpty &&
        planName != 'free' &&
        planName != 'trial') {
      subscribedPlan = planList.firstWhereOrNull((plan) {
        final tier = (plan.tier ?? '').trim().toLowerCase();
        final name = (plan.planName ?? '').trim().toLowerCase();
        return tier == planName || name == planName;
      });
    }
    if (subscribedPlan == null) return;

    for (final plan in planList) {
      plan.setSelect = false;
    }
    subscribedPlan.setSelect = true;
    selectedPlanData = subscribedPlan;
    _updateSelectedPrice(subscribedPlan);
    planList.refresh();
  }

  bool get _hasActiveSubscription {
    final model = currentModel;
    if (model == null) return false;
    if (model.isActive == true) return true;
    final status = (model.status ?? '').trim().toLowerCase();
    return status == 'active' ||
        status == 'renewed' ||
        status == 'cancelled' ||
        status == 'canceled';
  }

  bool get _isSubscribedToMonthly {
    final cycle = (currentModel?.billingCycle ?? '').trim().toLowerCase();
    if (cycle.isEmpty) return true;
    return cycle == 'monthly' || cycle == 'month' || cycle == 'mo';
  }

  bool isCurrentSubscribedPlan(PlanModel plan) {
    if (!_hasActiveSubscription) return false;
    if (isTabMonthly.value != _isSubscribedToMonthly) return false;

    final planName = (currentModel?.name ?? '').trim().toLowerCase();
    final planId = currentModel?.id?.trim();

    if (planId != null && planId.isNotEmpty) {
      if (plan.id == planId ||
          plan.monthlyId == planId ||
          plan.yearlyId == planId) {
        return true;
      }
    }

    if (planName.isEmpty || planName == 'free' || planName == 'trial') {
      return false;
    }

    final tier = (plan.tier ?? '').trim().toLowerCase();
    final name = (plan.planName ?? '').trim().toLowerCase();
    return tier == planName || name == planName;
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
}
