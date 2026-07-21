import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/professional/upgradePlans/components/toggle_button.dart';
import 'package:kasagardem/professional/upgradePlans/model/plan_model.dart';
import 'package:kasagardem/subscription/user_subscription_controller.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class UserSubscriptionScreen extends GetWidget<UserSubscriptionController> {
  const UserSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.appColor,
        appBar: BaseAppBar(
          isAppIconVisible: false,
          isBackButtonVisible: true,
          title: l10n.upgradePlanScreen,
        ),
        body: controller.isLoading.value && controller.planList.isEmpty
            ? SizedBox()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _HeaderSection(controller: controller, l10n: l10n),
                    _BillingToggle(controller: controller, l10n: l10n),
                    _PlanList(controller: controller, l10n: l10n),
                  ],
                ),
              ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(spacerSize20, spacerSize12, spacerSize20, spacerSize20),
          child: BaseButton(
            onPressed: controller.goToOrderSummary,
            backgroundColor: AppColors.greenColor,
            buttonLabel: controller.selectedPrice.value.isEmpty
                ? l10n.continueText
                : '${l10n.continueWith}\t₹${controller.selectedPrice.value}',
            fontSize: fontSize16,
            textColor: Colors.white,
            buttonWidth: double.infinity,
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({required this.controller, required this.l10n});

  final UserSubscriptionController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(spacerSize20),
      child: Column(
        children: [
          Image.asset(AppAssets.appLogo, width: 60.w, height: 60.w),
          SizedBox(height: spacerSize16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() {
                final isExpired = controller.remainingDays.value == '0';
                if (isExpired) {
                  return BaseText(
                    text: l10n.planExpired,
                    fontWeight: FontWeight.w700,
                    fontFamily: AppKeys.poppins,
                    fontSize: fontSize18,
                    textColor: AppColors.red,
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BaseText(
                      text: '${l10n.yourPlanEnds}\tin\t',
                      fontWeight: FontWeight.w400,
                      fontFamily: AppKeys.poppins,
                      fontSize: fontSize15,
                    ),
                    BaseText(
                      text: '${controller.remainingDays.value}\t${l10n.days}',
                      fontWeight: FontWeight.w700,
                      fontFamily: AppKeys.poppins,
                      fontSize: fontSize18,
                    ),
                  ],
                );
              }),
            ],
          ),
          SizedBox(height: spacerSize8),
          Obx(
            () => BaseText(
              text: controller.remainingDays.value == '0'
                  ? l10n.planExpiredDesc
                  : l10n.yourPlanEndsDesc,
              textAlign: TextAlign.center,
              textColor: AppColors.liteGreyColor,
              fontWeight: FontWeight.w400,
              fontFamily: AppKeys.inter,
              fontSize: fontSize14,
            ),
          ),
        ],
      ),
    );
  }
}

class _BillingToggle extends StatelessWidget {
  const _BillingToggle({required this.controller, required this.l10n});

  final UserSubscriptionController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(horizontal: spacerSize20),
        padding: EdgeInsets.all(spacerSize4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(spacerSize3),
          border: Border.all(color: AppColors.greenColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ToggleButton(
              verticalPadding: spacerSize6,
              horizontalPadding: spacerSize20,
              textSize: fontSize13,
              title: l10n.monthly.toUpperCase(),
              isSelected: controller.isTabMonthly.value,
              onTap: () => controller.changeTab(true),
            ),
            ToggleButton(
              verticalPadding: spacerSize6,
              horizontalPadding: spacerSize30,
              textSize: fontSize13,
              title: l10n.annually.toUpperCase(),
              isSelected: !controller.isTabMonthly.value,
              onTap: () => controller.changeTab(false),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanList extends StatelessWidget {
  const _PlanList({required this.controller, required this.l10n});

  final UserSubscriptionController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final filteredPlans = controller.planList.where((plan) {
        if (controller.isTabMonthly.value) {
          return plan.monthlyId != null || plan.tier == 'free';
        }
        return plan.yearlyId != null;
      }).toList();

      return Padding(
        padding: EdgeInsets.all(spacerSize20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BaseText(
              text: l10n.selectYourPlan,
              fontWeight: FontWeight.w600,
              fontFamily: AppKeys.poppins,
              fontSize: fontSize15,
            ),
            SizedBox(height: spacerSize16),
            ...filteredPlans.map(
              (plan) => _UserPlanCard(
                plan: plan,
                isMonthly: controller.isTabMonthly.value,
                isSubscribed: controller.isCurrentSubscribedPlan(plan),
                l10n: l10n,
                onTap: () => controller.selectPlan(plan),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _UserPlanCard extends StatelessWidget {
  const _UserPlanCard({
    required this.plan,
    required this.isMonthly,
    required this.isSubscribed,
    required this.l10n,
    required this.onTap,
  });

  final PlanModel plan;
  final bool isMonthly;
  final bool isSubscribed;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = plan.isSelect == true;
    final price = isMonthly ? plan.priceMonthly : plan.priceAnnual;
    final period = isMonthly ? l10n.mu : l10n.an;
    final headerActive = isSelected;
    final borderColor = isSelected
        ? AppColors.greenColor
        : isSubscribed
            ? AppColors.greenColor.withValues(alpha: 0.45)
            : AppColors.borderLiteGreyColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: spacerSize12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(spacerSize16),
          border: Border.all(
            color: borderColor,
            width: isSelected || isSubscribed ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: spacerSize16, vertical: spacerSize10),
              decoration: BoxDecoration(
                color: headerActive
                    ? AppColors.greenColor
                    : AppColors.borderLiteGreyColor.withValues(alpha: 0.35),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(spacerSize16),
                  topRight: Radius.circular(spacerSize16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: BaseText(
                            text: plan.planName ?? '',
                            textColor: headerActive
                                ? Colors.white
                                : AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                            fontSize: fontSize14,
                          ),
                        ),
                        if (isSubscribed) ...[
                          SizedBox(width: spacerSize8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: spacerSize8,
                              vertical: spacerSize2,
                            ),
                            decoration: BoxDecoration(
                              color: headerActive
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : AppColors.greenColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(spacerSize12),
                              border: Border.all(
                                color: headerActive
                                    ? Colors.white
                                    : AppColors.greenColor,
                                width: 0.8,
                              ),
                            ),
                            child: BaseText(
                              text: AppStrings.subscribed,
                              textColor: headerActive
                                  ? Colors.white
                                  : AppColors.greenColor,
                              fontWeight: FontWeight.w600,
                              fontSize: fontSize10,
                              fontFamily: AppKeys.inter,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: spacerSize8),
                  BaseText(
                    text: '₹$price/$period',
                    textColor: headerActive
                        ? Colors.white
                        : AppColors.greenColor,
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize13,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(spacerSize16),
              child: Column(children: _featureRows()),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _featureRows() {
    if (plan.features != null && plan.features!.isNotEmpty) {
      return plan.features!
          .where((feature) => feature.enabled == true)
          .map((feature) => _FeatureRow(label: feature.label ?? ''))
          .toList();
    }

    return [
      if (plan.diagnosisScans != null) _FeatureRow(label: '${plan.diagnosisScans} diagnosis scans'),
      if (plan.maxPlants != null)
        _FeatureRow(label: plan.maxPlants == -1 ? 'Unlimited plants' : '${plan.maxPlants} plants'),
      if (plan.aiAssistant == true) const _FeatureRow(label: 'AI assistant'),
      if (plan.hdRenders == true) const _FeatureRow(label: 'HD renders'),
      if (plan.pdfExport == true) const _FeatureRow(label: 'PDF export'),
    ];
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacerSize4),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: AppColors.greenColor, size: 16.w),
          SizedBox(width: spacerSize8),
          Expanded(
            child: BaseText(
              text: label,
              fontWeight: FontWeight.w500,
              fontSize: fontSize12,
              textColor: AppColors.blackColor,
              fontFamily: AppKeys.inter,
            ),
          ),
        ],
      ),
    );
  }
}
