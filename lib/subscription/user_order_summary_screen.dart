import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/subscription/user_subscription_controller.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class UserOrderSummaryScreen extends GetWidget<UserSubscriptionController> {
  const UserOrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final plan = controller.selectedPlanData;
    final isMonthly = controller.isTabMonthly.value;
    final total = controller.getOrderTotalAmount();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: BaseAppBar(
        isAppIconVisible: false,
        isBackButtonVisible: true,
        title: l10n.orderSummary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: spacerSize10),
                    _PlanHeaderCard(
                      planName: plan?.planName ?? 'Premium',
                      billingLabel: isMonthly ? 'Monthly' : 'Annually',
                      amount: total,
                    ),
                    SizedBox(height: spacerSize20),
                    _IncludedFeaturesCard(plan: plan),
                    // Razorpay banner disabled — Google Play Billing only.
                    // if (Platform.isAndroid) ...[
                    //   SizedBox(height: spacerSize20),
                    //   _RazorpayBanner(),
                    // ],
                    if (Platform.isAndroid) ...[
                      SizedBox(height: spacerSize20),
                      _GooglePlayBanner(),
                    ],
                    SizedBox(height: spacerSize20),
                    _PaymentBreakdownCard(total: total),
                    SizedBox(height: spacerSize30),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: spacerSize16),
              child: Obx(() {
                final isBusy = controller.isLoading.value || controller.isProcessingPayment.value;
                return SizedBox(
                  width: double.infinity,
                  child: BaseButton(
                    onPressed: isBusy ? null : controller.startPurchaseFlow,
                    // Razorpay path disabled:
                    // onPressed: isBusy
                    //     ? null
                    //     : () {
                    //         if (Platform.isAndroid) {
                    //           controller.startRazorpayPayment();
                    //         } else {
                    //           controller.startPurchaseFlow();
                    //         }
                    //       },
                    backgroundColor: isBusy ? AppColors.liteGreyColor : AppColors.greenColor,
                    buttonLabel: isBusy
                        ? 'Processing...'
                        : Platform.isAndroid
                            ? 'Pay with Google Play'
                            : l10n.fullPayment,
                    fontSize: fontSize15,
                    textColor: Colors.white,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanHeaderCard extends StatelessWidget {
  const _PlanHeaderCard({required this.planName, required this.billingLabel, required this.amount});

  final String planName;
  final String billingLabel;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacerSize20),
      decoration: BoxDecoration(
        color: AppColors.greenColor,
        borderRadius: BorderRadius.circular(spacerSize20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(AppAssets.crownIc, width: 14.w, height: 14.w, color: Colors.white),
              SizedBox(width: spacerSize6),
              BaseText(
                text: 'PREMIUM PLAN',
                textColor: Colors.white.withValues(alpha: 0.8),
                fontWeight: FontWeight.w700,
                fontSize: fontSize10,
              ),
            ],
          ),
          SizedBox(height: spacerSize12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseText(
                    text: '$planName Plan',
                    textColor: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize18,
                  ),
                  SizedBox(height: spacerSize2),
                  BaseText(
                    text: billingLabel,
                    textColor: Colors.white.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize12,
                  ),
                ],
              ),
              BaseText(
                text: '₹ ${amount.toInt()}',
                textColor: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: fontSize20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IncludedFeaturesCard extends StatelessWidget {
  const _IncludedFeaturesCard({required this.plan});

  final dynamic plan;

  @override
  Widget build(BuildContext context) {
    final features = plan?.features as List?;
    final enabledFeatures =
        features
            ?.where((feature) => feature.enabled == true)
            .map((feature) => feature.label?.toString() ?? '')
            .where((label) => label.isNotEmpty)
            .toList() ??
        <String>[];

    if (enabledFeatures.isEmpty) {
      enabledFeatures.addAll([
        if (plan?.diagnosisScans != null) '${plan.diagnosisScans} diagnosis scans',
        if (plan?.maxPlants != null)
          plan.maxPlants == -1 ? 'Unlimited plants' : '${plan.maxPlants} plants',
        if (plan?.aiAssistant == true) 'AI assistant',
        if (plan?.hdRenders == true) 'HD renders',
      ]);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacerSize20),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAF6),
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: "What's Included",
            fontWeight: FontWeight.w700,
            fontSize: fontSize14,
            textColor: AppColors.blackColor,
          ),
          SizedBox(height: spacerSize16),
          ...enabledFeatures.map(
            (label) => Padding(
              padding: EdgeInsets.symmetric(vertical: spacerSize6),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: AppColors.greenColor, size: 16.w),
                  SizedBox(width: spacerSize10),
                  Expanded(
                    child: BaseText(
                      text: label,
                      fontWeight: FontWeight.w500,
                      fontSize: fontSize13,
                      textColor: AppColors.blackColor,
                      fontFamily: AppKeys.inter,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GooglePlayBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacerSize16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAF6),
        borderRadius: BorderRadius.circular(spacerSize14),
        border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.shop_outlined, color: AppColors.greenColor, size: 20.w),
          SizedBox(width: spacerSize12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  text: 'Pay with Google Play',
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize13,
                  textColor: AppColors.blackColor,
                ),
                SizedBox(height: spacerSize2),
                BaseText(
                  text:
                      'Subscriptions are billed and managed securely through Google Play.',
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize11,
                  textColor: AppColors.liteGreyColor,
                  fontFamily: AppKeys.inter,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Razorpay banner disabled — Google Play Billing only.
// class _RazorpayBanner extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(spacerSize16),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF4FAF6),
//         borderRadius: BorderRadius.circular(spacerSize14),
//         border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.2)),
//       ),
//       child: Row(
//         children: [
//           Icon(Icons.payments_outlined, color: AppColors.greenColor, size: 20.w),
//           SizedBox(width: spacerSize12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 BaseText(
//                   text: 'Pay with Razorpay',
//                   fontWeight: FontWeight.w600,
//                   fontSize: fontSize13,
//                   textColor: AppColors.blackColor,
//                 ),
//                 SizedBox(height: spacerSize2),
//                 BaseText(
//                   text:
//                       'Payments are processed securely via Razorpay. This purchase is not managed by Google Play.',
//                   fontWeight: FontWeight.w400,
//                   fontSize: fontSize11,
//                   textColor: AppColors.liteGreyColor,
//                   fontFamily: AppKeys.inter,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _PaymentBreakdownCard extends StatelessWidget {
  const _PaymentBreakdownCard({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacerSize20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBF9),
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.borderGreyColor),
      ),
      child: Column(
        children: [
          _BreakdownRow(label: 'Subtotal', value: '₹ ${total.toInt()}'),
          SizedBox(height: spacerSize12),
          _BreakdownRow(label: 'Tax', value: '₹ 0'),
          SizedBox(height: spacerSize12),
          Divider(color: AppColors.borderGreyColor),
          SizedBox(height: spacerSize12),
          _BreakdownRow(
            label: 'Total',
            value: '₹ ${total.toInt()}',
            valueColor: AppColors.greenColor,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  const _BreakdownRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isBold = false,
  });

  final String label;
  final String value;
  final Color? valueColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BaseText(
          text: label,
          textColor: AppColors.liteGreyColor,
          fontWeight: FontWeight.w500,
          fontSize: fontSize13,
        ),
        BaseText(
          text: value,
          textColor: valueColor ?? AppColors.blackColor,
          fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
          fontSize: isBold ? fontSize16 : fontSize13,
        ),
      ],
    );
  }
}
