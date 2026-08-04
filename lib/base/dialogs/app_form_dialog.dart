import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class AppFormDialog {
  AppFormDialog._();

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? description,
    required Widget content,
    required String primaryButtonLabel,
    required VoidCallback onPrimaryPressed,
    String? secondaryButtonLabel,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: AppColors.appBarColor.withValues(alpha: 0.9),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: spacerSize20),
          child: Container(
            padding: EdgeInsets.all(spacerSize15),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(spacerSize20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CommonClickWidget(
                      onTap: () => Navigator.pop(dialogContext),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.h, left: 15.w, top: 2.h),
                        child: Image.asset(
                          AppAssets.closeIc,
                          height: 33.w,
                          width: 33.w,
                          color: AppColors.greenColor,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: spacerSize8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BaseText(
                        text: title,
                        fontFamily: AppKeys.poppins,
                        fontSize: fontSize22,
                        fontWeight: FontWeight.w600,
                      ),
                      if (description != null && description.isNotEmpty) ...[
                        SizedBox(height: spacerSize8),
                        BaseText(
                          text: description,
                          fontFamily: AppKeys.inter,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.liteGreyColor,
                        ),
                      ],
                      SizedBox(height: spacerSize20),
                      content,
                      SizedBox(height: spacerSize24),
                      SizedBox(
                        width: double.infinity,
                        child: BaseButton(
                          onPressed: onPrimaryPressed,
                          backgroundColor: AppColors.greenColor,
                          buttonLabel: primaryButtonLabel,
                          fontSize: fontSize16,
                          buttonWidth: double.infinity,
                          textColor: Colors.white,
                        ),
                      ),
                      if (secondaryButtonLabel != null) ...[
                        SizedBox(height: spacerSize10),
                        Center(
                          child: CommonClickWidget(
                            onTap: onSecondaryPressed ?? () => Navigator.pop(dialogContext),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: spacerSize6),
                              child: BaseText(
                                text: secondaryButtonLabel,
                                fontFamily: AppKeys.inter,
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w600,
                                textColor: AppColors.liteGreyColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: spacerSize10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
