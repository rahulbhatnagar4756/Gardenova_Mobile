import 'dart:io';

import 'package:get/get.dart';
import 'package:kasagardem/professional/professionalDashBoard/components/plant_expire_dialog.dart';
import 'package:kasagardem/professional/upgradePlans/upgrade_plan_repository.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
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
    _refreshSubscriptionStatusThenLoadPlans();
    super.onInit();
  }

  /// Refresh status from GET api/v1/plans/subscriptions/me, then load plans.
  Future<void> _refreshSubscriptionStatusThenLoadPlans() async {
    try {
      if (Get.isRegistered<SettingsViewModel>()) {
        await Get.find<SettingsViewModel>().getSubscriptionDetail();
        currentModel =
            Get.find<SettingsViewModel>().currentSubscriptionStatusModel.value ??
            currentModel;
        _applyBillingCycleFromSubscription();
        if (currentModel?.updatedAt != null) {
          try {
            final expirationDate = DateTime.parse(currentModel!.updatedAt!).toLocal();
            final now = DateTime.now();
            final today = DateTime(now.year, now.month, now.day);
            final exp = DateTime(
              expirationDate.year,
              expirationDate.month,
              expirationDate.day,
            );
            remainingDays.value =
                exp.difference(today).inDays.clamp(0, 365).toString();
          } catch (_) {}
        }
      }
    } catch (_) {}

    callGetAllPlanListApi();
    if (remainingDays.value == "0") {
      PlanExpireDialog();
    }
  }

  void changeTab(bool value) {
    if (isTabMonthly.value == value) return;

    isTabMonthly.value = value;
    isTabAdditionalCoverage.value = false;
    isSelectOneTime.value = true;

    // Paid subscribers: only keep the subscribed plan on their billing period.
    if (_hasPaidSubscription) {
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

    // No paid subscription — Free is monthly-only.
    for (final plan in planList) {
      plan.setSelect = false;
    }
    if (isTabMonthly.value) {
      final freePlan = planList.firstWhereOrNull(
        (plan) => (plan.tier ?? '').toLowerCase() == 'free',
      );
      if (freePlan != null) {
        freePlan.setSelect = true;
        selectedPlanData = freePlan;
        _updateSelectedPrice(freePlan);
      } else {
        selectedPlanData = null;
        selectedPrice.value = "";
      }
    } else {
      selectedPlanData = null;
      selectedPrice.value = "";
    }
    planList.refresh();
  }

  void selectPlanType(bool value) {
    isSelectOneTime.value = value;
  }

  void changeTabAdditionalCoverage(bool value) {
    isTabAdditionalCoverage.value = value;
  }

  void selectPlan(PlanModel plan) {
    // Keep current selection until the user taps a different plan.
    if (plan.isSelect == true) {
      selectedPlanData = plan;
      _updateSelectedPrice(plan);
      return;
    }

    for (int i = 0; i < planList.length; i++) {
      planList[i].setSelect = planList[i] == plan;
    }
    selectedPlanData = plan;
    _updateSelectedPrice(plan);
    planList.refresh();
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
      final tier = (selectedPlan.tier ?? selectedPlan.planName ?? '').toLowerCase();
      if (tier == 'free') {
        BaseSnackBar.show(
          title: 'Free Plan',
          message: 'You are already on the Free plan. Choose a paid plan to upgrade.',
        );
        return;
      }
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

    // Commented getplans API — plans come from Google Play Billing / App Store.
    // var response = await upgradePlanRepository.getPlanList();
    // if (response != null) {
    //   PlansResponseModel planResponse = PlansResponseModel.fromJson(response);
    //   planList
    //     ..clear()
    //     ..addAll(
    //       PlanModel.consolidateByTier(
    //         planResponse.data ?? [],
    //         includeProfessionalFields: true,
    //       ),
    //     );
    // }

    await SubscriptionService.instance.setupInAppPurchase();
    final plans = SubscriptionService.instance.buildPlansFromStore(
      includeProfessionalFields: true,
    );
    // Free is only for users without a paid subscription.
    if (_hasPaidSubscription) {
      plans.removeWhere((plan) => (plan.tier ?? '').toLowerCase() == 'free');
    }
    planList
      ..clear()
      ..addAll(plans);

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
    if (_hasPaidSubscription) {
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
      return;
    }

    final freePlan = planList.firstWhereOrNull(
      (plan) => (plan.tier ?? '').toLowerCase() == 'free',
    );
    if (freePlan == null) return;

    for (final plan in planList) {
      plan.setSelect = false;
    }
    freePlan.setSelect = true;
    selectedPlanData = freePlan;
    _updateSelectedPrice(freePlan);
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

  bool get _hasPaidSubscription {
    if (!_hasActiveSubscription) return false;
    final name = (currentModel?.name ?? '').trim().toLowerCase();
    if (name.isEmpty || name == 'free' || name == 'trial') return false;
    return true;
  }

  bool get _isSubscribedToMonthly {
    final cycle = (currentModel?.billingCycle ?? '').trim().toLowerCase();
    if (cycle.isEmpty) return true;
    return cycle == 'monthly' || cycle == 'month' || cycle == 'mo';
  }

  bool isCurrentSubscribedPlan(PlanModel plan) {
    if (!_hasPaidSubscription) {
      // Free is monthly-only.
      return isTabMonthly.value && (plan.tier ?? '').toLowerCase() == 'free';
    }
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
        final tier = plan.tier ?? plan.planName ?? '';
        final monthlyOffer = SubscriptionService.instance.findOfferForTier(
          tier,
          isMonthly: true,
        );
        final annualOffer = SubscriptionService.instance.findOfferForTier(
          tier,
          isMonthly: false,
        );

        if (monthlyOffer != null) {
          plan.priceMonthly = monthlyOffer.rawPrice.toInt().toString();
          plan.monthlyProductId = monthlyOffer.id;
        }
        if (annualOffer != null) {
          plan.priceAnnual = annualOffer.rawPrice.toInt().toString();
          plan.yearlyProductId = annualOffer.id;
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

    final tier = (plan.tier ?? plan.planName ?? '').toLowerCase();
    if (tier == 'free') {
      BaseSnackBar.show(
        title: 'Free Plan',
        message: 'You are already on the Free plan. Choose a paid plan to upgrade.',
      );
      return;
    }

    if (!Platform.isAndroid) {
      BaseSnackBar.show(
        title: 'Google Play',
        message: 'Subscriptions are available on Android via Google Play only.',
      );
      return;
    }

    if (!SubscriptionService.instance.isAvailable) {
      BaseSnackBar.show(
        title: 'Google Play',
        message:
            'Play Store billing is not available on this device. Please try again on a device with Google Play.',
      );
      return;
    }

    if (Get.isRegistered<SettingsViewModel>()) {
      currentModel =
          Get.find<SettingsViewModel>().currentSubscriptionStatusModel.value ??
          currentModel;
    }

    if (isLoading.value) return;

    isLoading.value = true;
    try {
      await SubscriptionService.instance.buyPlan(
        plan,
        isTabMonthly.value,
        currentModel,
      );
    } catch (e) {
      BaseSnackBar.show(
        title: 'Payment',
        message: 'Unable to start Google Play subscription.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
