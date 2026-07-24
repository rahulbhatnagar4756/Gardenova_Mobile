import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/professional/upgradePlans/upgrade_plan_controller.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';

import '../../l10n/app_localizations.dart';

class OrderSummaryScreen extends GetWidget<UpgradePlanController> {
  const OrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plan = controller.selectedPlanData;
    final isMonthly = controller.isTabMonthly.value;
    
    // Parse prices
    final basePriceStr = (isMonthly ? plan?.priceMonthly : plan?.priceAnnual) ?? "0";
    final double basePrice = double.tryParse(basePriceStr.replaceAll(',', '').replaceAll(' ', '')) ?? 0.0;
    
    double additionalPrice = 0.0;
    if (controller.isTabAdditionalCoverage.value) {
      if (isMonthly) {
        additionalPrice = 100.0;
      } else {
        additionalPrice = controller.isSelectOneTime.value ? 100.0 : 1200.0;
      }
    }
    
    final double subtotal = basePrice + additionalPrice;
    final double total = subtotal;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: BaseAppBar(
        isAppIconVisible: false,
        isBackButtonVisible: true,
        title: AppLocalizations.of(context)!.orderSummary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: spacerSize10),
                      
                      // 1. Top Green Card (Premium Plan Info)
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.greenColor,
                          borderRadius: BorderRadius.circular(spacerSize20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(spacerSize20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Crown Icon + PREMIUM PLAN
                                  Row(
                                    children: [
                                      Image.asset(
                                        AppAssets.crownIc,
                                        width: 14.w,
                                        height: 14.w,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: spacerSize6),
                                      BaseText(
                                        text: "PREMIUM PLAN",
                                        textColor: Colors.white.withValues(alpha: 0.8),
                                        fontWeight: FontWeight.w700,
                                        fontSize: fontSize10,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: spacerSize12),
                                  
                                  // Plan Name & Price Row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          BaseText(
                                            text: "${plan?.planName ?? "Gold"} Plan",
                                            textColor: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: fontSize18,
                                          ),
                                          SizedBox(height: spacerSize2),
                                          BaseText(
                                            text: isMonthly ? "Monthly" : "Annually",
                                            textColor: Colors.white.withValues(alpha: 0.7),
                                            fontWeight: FontWeight.w400,
                                            fontSize: fontSize12,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          BaseText(
                                            text: "R\$ ${basePrice.toInt()}",
                                            textColor: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: fontSize20,
                                          ),
                                          SizedBox(height: spacerSize2),
                                          BaseText(
                                            text: isMonthly ? "/month" : "/year",
                                            textColor: Colors.white.withValues(alpha: 0.7),
                                            fontWeight: FontWeight.w400,
                                            fontSize: fontSize10,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Horizontal Line and National Coverage Row (if selected)
                            if (controller.isTabAdditionalCoverage.value) ...[
                              Container(
                                height: 0.8,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              Padding(
                                padding: EdgeInsets.all(spacerSize20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          BaseText(
                                            text: "National Coverage",
                                            textColor: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: fontSize14,
                                          ),
                                          SizedBox(height: spacerSize2),
                                          BaseText(
                                            text: isMonthly
                                                ? "Valid for current month only"
                                                : (controller.isSelectOneTime.value
                                                    ? "Valid for current month only"
                                                    : "Valid for 1 year"),
                                            textColor: Colors.white.withValues(alpha: 0.7),
                                            fontWeight: FontWeight.w400,
                                            fontSize: fontSize11,
                                          ),
                                        ],
                                      ),
                                    ),
                                    BaseText(
                                      text: "R\$ ${additionalPrice.toInt()}",
                                      textColor: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: fontSize16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      SizedBox(height: spacerSize20),
                      
                      // 2. What's Included Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(spacerSize20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4FAF6),
                          borderRadius: BorderRadius.circular(spacerSize16),
                          border: Border.all(
                            color: AppColors.greenColor.withValues(alpha: 0.15),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title with green vertical bar
                            Row(
                              children: [
                                Container(
                                  width: 3.w,
                                  height: 16.h,
                                  decoration: BoxDecoration(
                                    color: AppColors.greenColor,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                SizedBox(width: spacerSize8),
                                BaseText(
                                  text: "What's Included",
                                  fontWeight: FontWeight.w700,
                                  fontSize: fontSize14,
                                  textColor: AppColors.blackColor,
                                ),
                              ],
                            ),
                            SizedBox(height: spacerSize16),
                            
                            // Feature Items List
                            Column(
                              children: plan?.features != null && plan!.features!.isNotEmpty
                                  ? plan.features!.map((feature) {
                                      if (feature.enabled != true) {
                                        return const SizedBox.shrink();
                                      }
                                      IconData icon = Icons.check_circle_outline;
                                      switch (feature.key) {
                                        case 'diagnosis_scans':
                                          icon = Icons.qr_code_scanner;
                                          break;
                                        case 'landscape_gen':
                                        case 'landscape_gens':
                                          icon = Icons.landscape_outlined;
                                          break;
                                        case 'max_plants':
                                        case 'saved_plants':
                                          icon = Icons.eco_outlined;
                                          break;
                                        case 'ai_assistant':
                                        case 'ai_care_assistant':
                                          icon = Icons.assistant_outlined;
                                          break;
                                        case 'hd_renders':
                                          icon = Icons.hd_outlined;
                                          break;
                                        case 'pdf_export':
                                          icon = Icons.picture_as_pdf_outlined;
                                          break;
                                        case 'premium_styles':
                                        case 'premium_themes':
                                          icon = Icons.style_outlined;
                                          break;
                                        case 'before_after_download':
                                          icon = Icons.compare_arrows_outlined;
                                          break;
                                        case 'basic_reminders':
                                          icon = Icons.notifications_active_outlined;
                                          break;
                                        case 'priority_generation':
                                          icon = Icons.bolt_outlined;
                                          break;
                                        case 'priority_support':
                                          icon = Icons.headset_mic_outlined;
                                          break;
                                        case 'ad_free':
                                          icon = Icons.block_outlined;
                                          break;
                                      }
                                      return _buildFeatureRow(
                                        icon: icon,
                                        title: feature.displayLabel(
                                          isMonthly: controller.isTabMonthly.value,
                                        ),
                                      );
                                    }).toList()
                                  : [
                                      _buildFeatureRow(
                                        icon: Icons.location_on_outlined,
                                        title: "${plan?.citiesCoverage ?? 3} Cities Coverage",
                                      ),
                                      if (plan?.appearInSearch ?? false)
                                        _buildFeatureRow(
                                          icon: Icons.search,
                                          title: "Appear In Search Results",
                                        ),
                                      _buildFeatureRow(
                                        icon: Icons.trending_up,
                                        title: (plan?.leadsLimit == null || plan?.leadsLimit == 0)
                                            ? "Unlimited Leads"
                                            : "${plan?.leadsLimit} Leads",
                                        ),
                                      if (plan?.premiumProfileBadge ?? false)
                                        _buildFeatureRow(
                                          icon: Icons.workspace_premium_outlined,
                                          title: "Premium Profile Badge",
                                        ),
                                      if (plan?.priorityCustomerSupport ?? false)
                                        _buildFeatureRow(
                                          icon: Icons.headset_mic_outlined,
                                          title: "Priority Customer Support",
                                        ),
                                    ],
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: spacerSize20),
                      
                      // 3. Payment details Card
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(spacerSize20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FBF9),
                          borderRadius: BorderRadius.circular(spacerSize16),
                          border: Border.all(
                            color: AppColors.borderGreyColor,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BaseText(
                                  text: "Subtotal",
                                  textColor: AppColors.liteGreyColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: fontSize13,
                                ),
                                BaseText(
                                  text: "R\$ ${subtotal.toInt()}",
                                  textColor: AppColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: fontSize13,
                                ),
                              ],
                            ),
                            SizedBox(height: spacerSize12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BaseText(
                                  text: "Tax",
                                  textColor: AppColors.liteGreyColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: fontSize13,
                                ),
                                BaseText(
                                  text: "R\$ 0",
                                  textColor: AppColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: fontSize13,
                                ),
                              ],
                            ),
                            SizedBox(height: spacerSize12),
                            Divider(
                              color: AppColors.borderGreyColor,
                              thickness: 1,
                            ),
                            SizedBox(height: spacerSize12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                BaseText(
                                  text: "Total",
                                  textColor: AppColors.blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: fontSize14,
                                ),
                                BaseText(
                                  text: "R\$ ${total.toInt()}",
                                  textColor: AppColors.greenColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: fontSize16,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(height: spacerSize30),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: spacerSize16),
              child: Obx(
                () => SizedBox(
                  width: double.infinity,
                  child: BaseButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            controller.startPurchaseFlow();
                          },
                    backgroundColor: controller.isLoading.value
                        ? AppColors.liteGreyColor
                        : AppColors.greenColor,
                    buttonLabel: controller.isLoading.value ? "Processing..." : "Full Payment",
                    fontSize: fontSize15,
                    textColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow({required IconData icon, required String title}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacerSize8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(spacerSize6),
            decoration: BoxDecoration(
              color: AppColors.greenColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16.w,
              color: AppColors.greenColor,
            ),
          ),
          SizedBox(width: spacerSize12),
          Expanded(
            child: BaseText(
              text: title,
              textColor: AppColors.blackColor,
              fontWeight: FontWeight.w500,
              fontFamily: AppKeys.inter,
              fontSize: fontSize13,
            ),
          ),
          Icon(
            Icons.check,
            size: 16.w,
            color: AppColors.greenColor,
          ),
        ],
      ),
    );
  }
}
