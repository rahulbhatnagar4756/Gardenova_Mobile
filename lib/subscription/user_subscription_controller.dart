import 'dart:io';

import 'package:get/get.dart';
import 'package:kasagardem/professional/upgradePlans/model/plan_model.dart';
import 'package:kasagardem/professional/upgradePlans/upgrade_plan_repository.dart';
import 'package:kasagardem/services/subscription_service.dart';
import 'package:kasagardem/settings/model/subscription_local_status_ui_model.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

class UserSubscriptionController extends GetxController {
  RxBool isTabMonthly = true.obs;
  RxString selectedPrice = ''.obs;
  RxString remainingDays = ''.obs;
  final UpgradePlanRepository _repository = UpgradePlanRepository();
  RxList<PlanModel> planList = <PlanModel>[].obs;
  PlanModel? selectedPlanData;
  RxBool isLoading = false.obs;
  SubscriptionStatusUiModel? currentModel;

  @override
  void onInit() {
    initIAP();
    _readArguments();
    callGetAllPlanListApi();
    super.onInit();
  }

  void _readArguments() {
    if (Get.arguments is SubscriptionStatusUiModel) {
      currentModel = Get.arguments as SubscriptionStatusUiModel;
      _setRemainingDaysFromModel(currentModel);
      return;
    }

    if (Get.arguments is Map) {
      _setRemainingDaysFromPrefs();
      return;
    }

    _setRemainingDaysFromPrefs();
  }

  void _setRemainingDaysFromModel(SubscriptionStatusUiModel? model) {
    if (model?.updatedAt == null) {
      remainingDays.value = '0';
      return;
    }

    try {
      final expirationDate = DateTime.parse(model!.updatedAt!).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final exp = DateTime(
        expirationDate.year,
        expirationDate.month,
        expirationDate.day,
      );
      remainingDays.value = exp.difference(today).inDays.clamp(0, 365).toString();
    } catch (_) {
      remainingDays.value = '0';
    }
  }

  void _setRemainingDaysFromPrefs() {
    remainingDays.value =
        SharedPrefsService.instance.getString(AppKeys.remainingDays) ?? '0';
  }

  void changeTab(bool value) {
    isTabMonthly.value = value;
    selectedPrice.value = '';
    for (final plan in planList) {
      plan.setSelect = false;
    }
    planList.refresh();
  }

  void selectPlan(PlanModel plan) {
    for (final item in planList) {
      item.setSelect = item == plan;
    }
    selectedPrice.value = isTabMonthly.value
        ? '${plan.priceMonthly!}/mo'
        : '${plan.priceAnnual!}/an';
    planList.refresh();
    selectedPlanData = null;
  }

  void goToOrderSummary() {
    final selectedPlan = planList.firstWhereOrNull((plan) => plan.isSelect == true);
    if (selectedPlan == null) {
      BaseSnackBar.show(title: 'Plan', message: 'Please select a plan');
      return;
    }

    selectedPlanData = selectedPlan;
    Get.toNamed(Routes.userOrderSummary);
  }

  double getOrderTotalAmount() {
    final plan = selectedPlanData;
    if (plan == null) return 0;

    final basePriceStr =
        (isTabMonthly.value ? plan.priceMonthly : plan.priceAnnual) ?? '0';
    return double.tryParse(
          basePriceStr.replaceAll(',', '').replaceAll(' ', ''),
        ) ??
        0.0;
  }

  void goToRazorpayPayment() {
    final plan = selectedPlanData;
    if (plan == null) {
      BaseSnackBar.show(title: 'Plan', message: 'Please select a plan');
      return;
    }

    Get.toNamed(
      Routes.razorpayPayment,
      arguments: {
        'plan': plan,
        'isMonthly': isTabMonthly.value,
        'hasAdditionalCoverage': false,
        'isOneTimeCoverage': false,
        'totalAmount': getOrderTotalAmount(),
        'currentSubscription': currentModel,
        'isUser': true,
      },
    );
  }

  Future<void> callGetAllPlanListApi() async {
    isLoading.value = true;
    final response = await _repository.getPlanList();

    if (response != null) {
      final planResponse = PlansResponseModel.fromJson(response);
      planList.clear();

      final apiPlans = planResponse.data ?? [];
      final tiers = ['free', 'starter', 'plus', 'pro'];

      for (final tier in tiers) {
        final tierPlans = apiPlans.where((p) => p.tier == tier).toList();
        if (tierPlans.isEmpty) continue;

        final monthlyPlan =
            tierPlans.firstWhereOrNull((p) => p.billingPeriod == 'monthly');
        final yearlyPlan =
            tierPlans.firstWhereOrNull((p) => p.billingPeriod == 'yearly');
        final template = monthlyPlan ?? yearlyPlan ?? tierPlans.first;

        final name = switch (tier) {
          'free' => 'Free',
          'starter' => 'Starter',
          'plus' => 'Plus',
          _ => 'Pro',
        };

        planList.add(
          PlanModel(
            id: template.id,
            planName: name,
            tier: tier,
            priceMonthly: _cleanPrice(monthlyPlan?.price ?? '0'),
            priceAnnual: _cleanPrice(
              yearlyPlan?.price ?? _cleanPrice(monthlyPlan?.price ?? '0'),
            ),
            currency: template.currency,
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
            features: template.features,
          ),
        );
      }
    }

    updateStorePrices();
    isLoading.value = false;
  }

  String _cleanPrice(String? priceStr) {
    if (priceStr == null) return '0';
    final value = double.tryParse(priceStr);
    if (value == null) return priceStr;
    return value.toStringAsFixed(0);
  }

  Future<void> initIAP() async {
    await SubscriptionService.instance.setupInAppPurchase();
    updateStorePrices();
  }

  void updateStorePrices() {
    if (!SubscriptionService.instance.isAvailable ||
        SubscriptionService.instance.products.isEmpty) {
      return;
    }

    for (final plan in planList) {
      final monthlyProdId = SubscriptionService.instance.getProductId(
        plan.planName ?? '',
        true,
      );
      final annualProdId = SubscriptionService.instance.getProductId(
        plan.planName ?? '',
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

  Future<void> startPurchaseFlow() async {
    final plan = selectedPlanData;
    if (plan == null) {
      BaseSnackBar.show(title: 'Plan', message: 'Please select a plan');
      return;
    }

    if (Platform.isAndroid) {
      goToRazorpayPayment();
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
