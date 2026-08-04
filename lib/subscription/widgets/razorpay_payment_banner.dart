import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class RazorpayPaymentBanner extends StatelessWidget {
  const RazorpayPaymentBanner({super.key});

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
          Container(
            padding: EdgeInsets.all(spacerSize8),
            decoration: BoxDecoration(
              color: AppColors.greenColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.payments_outlined, color: AppColors.greenColor, size: 20.w),
          ),
          SizedBox(width: spacerSize12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  text: 'Pay with Razorpay',
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize13,
                  textColor: AppColors.blackColor,
                ),
                SizedBox(height: spacerSize2),
                BaseText(
                  text: 'UPI, cards, net banking and wallets supported.',
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
