import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/professional/payment/razorpay_payment_controller.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../l10n/app_localizations.dart';

class RazorpayPaymentScreen extends GetWidget<RazorpayPaymentController> {
  const RazorpayPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: BaseAppBar(
        isAppIconVisible: false,
        isBackButtonVisible: true,
        title: l10n.completePayment,
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
                    SizedBox(height: spacerSize16),
                    _AmountHeader(controller: controller),
                    SizedBox(height: spacerSize20),
                    _PlanSummaryCard(controller: controller),
                    SizedBox(height: spacerSize20),
                    _PaymentMethodsSection(controller: controller),
                    SizedBox(height: spacerSize20),
                    _SecurePaymentBanner(),
                    SizedBox(height: spacerSize24),
                  ],
                ),
              ),
            ),
            _BottomPayBar(controller: controller, l10n: l10n),
          ],
        ),
      ),
    );
  }
}

class _AmountHeader extends StatelessWidget {
  const _AmountHeader({required this.controller});

  final RazorpayPaymentController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacerSize20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.greenColor, AppColors.greenColor.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(spacerSize20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: 'Amount to Pay',
            textColor: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w500,
            fontSize: fontSize13,
          ),
          SizedBox(height: spacerSize8),
          BaseText(
            text: controller.formattedAmount,
            textColor: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: fontSize30,
          ),

          SizedBox(height: spacerSize4),

          BaseText(
            text: controller.billingLabel,
            textColor: Colors.white.withValues(alpha: 0.75),
            fontWeight: FontWeight.w400,
            fontSize: fontSize12,
          ),
        ],
      ),
    );
  }
}

class _PlanSummaryCard extends StatelessWidget {
  const _PlanSummaryCard({required this.controller});

  final RazorpayPaymentController controller;

  @override
  Widget build(BuildContext context) {
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
                text: 'Order Summary',
                fontWeight: FontWeight.w700,
                fontSize: fontSize14,
                textColor: AppColors.blackColor,
              ),
            ],
          ),
          SizedBox(height: spacerSize16),
          _SummaryRow(label: 'Plan', value: '${controller.plan.planName ?? 'Premium'} Plan'),
          _SummaryRow(label: 'Billing', value: controller.billingLabel),
          if (controller.hasAdditionalCoverage)
            _SummaryRow(
              label: 'National Coverage',
              value: controller.isOneTimeCoverage ? 'One-time add-on' : 'Annual add-on',
            ),
          Divider(color: AppColors.borderGreyColor, height: spacerSize24),
          _SummaryRow(
            label: 'Total',
            value: controller.formattedAmount,
            valueColor: AppColors.greenColor,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacerSize6),
      child: Row(
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
            fontSize: isBold ? fontSize14 : fontSize13,
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodsSection extends StatelessWidget {
  const _PaymentMethodsSection({required this.controller});

  final RazorpayPaymentController controller;

  @override
  Widget build(BuildContext context) {
    final methods = [
      _PaymentMethod(
        id: 'upi',
        title: 'UPI',
        subtitle: 'Google Pay, PhonePe, Paytm',
        icon: Icons.qr_code_scanner_rounded,
      ),
      _PaymentMethod(
        id: 'card',
        title: 'Cards',
        subtitle: 'Credit / Debit cards',
        icon: Icons.credit_card_rounded,
      ),
      _PaymentMethod(
        id: 'netbanking',
        title: 'Net Banking',
        subtitle: 'All major banks',
        icon: Icons.account_balance_rounded,
      ),
      _PaymentMethod(
        id: 'wallet',
        title: 'Wallets',
        subtitle: 'Paytm, Mobikwik & more',
        icon: Icons.account_balance_wallet_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BaseText(
          text: 'Payment Method',
          fontWeight: FontWeight.w700,
          fontSize: fontSize14,
          textColor: AppColors.blackColor,
        ),
        SizedBox(height: spacerSize12),
        Obx(
          () => Column(
            children: methods.map((method) {
              final isSelected = controller.selectedMethod.value == method.id;
              return Padding(
                padding: EdgeInsets.only(bottom: spacerSize10),
                child: InkWell(
                  onTap: () => controller.selectPaymentMethod(method.id),
                  borderRadius: BorderRadius.circular(spacerSize14),
                  child: Container(
                    padding: EdgeInsets.all(spacerSize14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.greenColor.withValues(alpha: 0.08)
                          : const Color(0xFFF9FBF9),
                      borderRadius: BorderRadius.circular(spacerSize14),
                      border: Border.all(
                        color: isSelected ? AppColors.greenColor : AppColors.borderGreyColor,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42.w,
                          height: 42.w,
                          decoration: BoxDecoration(
                            color: AppColors.greenColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(method.icon, color: AppColors.greenColor, size: 20.w),
                        ),
                        SizedBox(width: spacerSize12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BaseText(
                                text: method.title,
                                fontWeight: FontWeight.w600,
                                fontSize: fontSize14,
                                textColor: AppColors.blackColor,
                              ),
                              SizedBox(height: spacerSize2),
                              BaseText(
                                text: method.subtitle,
                                fontWeight: FontWeight.w400,
                                fontSize: fontSize11,
                                textColor: AppColors.liteGreyColor,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: isSelected ? AppColors.greenColor : AppColors.liteGreyColor,
                          size: 20.w,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _PaymentMethod {
  const _PaymentMethod({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}

class _SecurePaymentBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacerSize14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBF9),
        borderRadius: BorderRadius.circular(spacerSize12),
        border: Border.all(color: AppColors.borderGreyColor),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_user_outlined, color: AppColors.greenColor, size: 20.w),
          SizedBox(width: spacerSize10),
          Expanded(
            child: BaseText(
              text: 'Payments are secured by Razorpay with 256-bit encryption.',
              fontWeight: FontWeight.w500,
              fontSize: fontSize11,
              textColor: AppColors.liteGreyColor,
              fontFamily: AppKeys.inter,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomPayBar extends StatelessWidget {
  const _BottomPayBar({required this.controller, required this.l10n});

  final RazorpayPaymentController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, spacerSize12, 20.w, spacerSize16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Obx(() {
        final isBusy = controller.isLoading.value || controller.isProcessingPayment.value;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: BaseButton(
                onPressed: isBusy ? null : controller.startPayment,
                backgroundColor: isBusy ? AppColors.liteGreyColor : AppColors.greenColor,
                buttonLabel: isBusy ? 'Processing...' : l10n.fullPayment,
                fontSize: fontSize15,
                textColor: Colors.white,
              ),
            ),
            SizedBox(height: spacerSize8),
            BaseText(
              text: 'You will be redirected to Razorpay to complete payment.',
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
              fontSize: fontSize10,
              textColor: AppColors.liteGreyColor,
              fontFamily: AppKeys.inter,
            ),
          ],
        );
      }),
    );
  }
}
