import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/l10n/app_localizations.dart';

import '../../../../base/widgets/base_button.dart';
import '../../../../base/widgets/base_shimmer.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';

class PlantAddSuccessDialog {
  static void show(
    BuildContext context, {
    required String title,
    required String image,
    required String description,
    required String buttonLabel,
    VoidCallback? onButtonPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.appBarColor.withValues(alpha: 0.9),
      builder: (_) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: spacerSize20),
            child: Container(
              padding: EdgeInsets.all(spacerSize15),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(spacerSize20),
              ),
              child: Column(
                // spacing: spacerSize20,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CommonClickWidget(
                        onTap: () => Get.back(),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: 10.h,
                            left: 15.w,
                            top: 2.h,
                          ),
                          child: Image.asset(
                            Assets.closeIc,
                            height: 33.w,
                            width: 33.w,
                            color: AppColors.greyIconColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    spacing: spacerSize12,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(spacerSize45),
                        child: CachedNetworkImage(
                          height: 86.w,
                          width: 86.w,
                          fit: BoxFit.cover,
                          imageUrl: image,
                          placeholder: (c, s) =>
                              BaseShimmer(height: 200, width: double.infinity),
                          errorWidget: (c, s, o) => const Icon(
                            Icons.broken_image,
                            color: AppColors.offWhite10,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          spacing: spacerSize4,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BaseText(
                              text: title,
                              fontFamily: AppKeys.poppins,
                              fontSize: fontSize22,
                              fontWeight: FontWeight.w600,
                            ),
                            BaseText(
                              text: AppLocalizations.of(
                                context,
                              )!.successfullyAdded,
                              fontFamily: AppKeys.inter,
                              fontSize: fontSize14,
                              fontWeight: FontWeight.w400,
                              textColor: AppColors.greenColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  BaseText(
                    text: description,
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.liteGreyColor,
                  ),

                  SizedBox(height: 35.h),

                  BaseButton(
                    onPressed: () {
                      // Get.back(result: true);
                      // Get.back(result: true);
                      // Get.back(result: true);
                      onButtonPressed?.call();
                    },
                    backgroundColor: AppColors.burntGold,
                    buttonLabel: buttonLabel,
                    fontSize: fontSize16,
                    buttonWidth: double.infinity,
                    textColor: Colors.white,
                  ),
                  SizedBox(height: 25.h),
                  // BaseBackButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
