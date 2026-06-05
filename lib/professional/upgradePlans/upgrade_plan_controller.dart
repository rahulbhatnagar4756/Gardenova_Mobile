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

  void selectPlan(PlanModel plan) {
    for (int i = 0; i < planList.length; i++) {
      planList[i].setSelect = planList[i] == plan;
    }
    if (isTabMonthly.value) {
      selectedPrice.value = "${plan.priceMonthly!}/mo";
    } else {
      selectedPrice.value = "${plan.priceAnnual!}/an";
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

      final apiPlans = planResponse.data ?? [];
      final tiers = ['free', 'starter', 'plus', 'pro'];

      for (var t in tiers) {
        final tierPlans = apiPlans.where((p) => p.tier == t).toList();
        if (tierPlans.isEmpty) continue;

        final monthlyPlan = tierPlans.firstWhereOrNull(
          (p) => p.billingPeriod == 'monthly',
        );
        final yearlyPlan = tierPlans.firstWhereOrNull(
          (p) => p.billingPeriod == 'yearly',
        );
        final template = monthlyPlan ?? yearlyPlan ?? tierPlans.first;

        final cities = t == 'free'
            ? 5
            : t == 'starter'
            ? 25
            : t == 'plus'
            ? 100
            : 500;
        final name = t == 'free'
            ? 'Free'
            : t == 'starter'
            ? 'Starter'
            : t == 'plus'
            ? 'Plus'
            : 'Pro';

        String cleanPrice(String? priceStr) {
          if (priceStr == null) return "0";
          final d = double.tryParse(priceStr);
          if (d == null) return priceStr;
          return d.toStringAsFixed(0);
        }

        final consolidatedPlan = PlanModel(
          id: template.id,
          planName: name,
          tier: t,
          citiesCoverage: cities,
          priceMonthly: cleanPrice(monthlyPlan?.price ?? "0"),
          priceAnnual: cleanPrice(
            yearlyPlan?.price ?? cleanPrice(monthlyPlan?.price ?? "0"),
          ),
          appearInSearch: t != 'free',
          leadsLimit: t == 'free'
              ? 0
              : t == 'starter'
              ? 15
              : 0,
          premiumProfileBadge: t == 'plus' || t == 'pro',
          priorityCustomerSupport: t == 'pro',
          status: 'active',
          isSelect: false,

          diagnosisScans: template.diagnosisScans,
          landscapeGen: template.landscapeGen,
          maxPlants: template.maxPlants,
          aiAssistant: template.aiAssistant,
          hdRenders: template.hdRenders,
          pdfExport: template.pdfExport,
          premiumStyles: template.premiumStyles,
          beforeAfterDownload: template.beforeAfterDownload,
          basicReminders: template.basicReminders,

          monthlyProductId: monthlyPlan?.productId,
          yearlyProductId: yearlyPlan?.productId,
          monthlyId: monthlyPlan?.id,
          yearlyId: yearlyPlan?.id,
        );

        planList.add(consolidatedPlan);
      }
    }
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
}
