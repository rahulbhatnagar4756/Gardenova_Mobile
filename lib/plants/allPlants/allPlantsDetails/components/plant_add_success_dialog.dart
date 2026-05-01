import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_back_button.dart';
import 'package:kasagardem/l10n/app_localizations.dart';

import '../../../../base/widgets/base_button.dart';
import '../../../../base/widgets/base_shimmer.dart';
import '../../../../base/widgets/base_text.dart';
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
                color: AppColors.darkGreen,
                borderRadius: BorderRadius.circular(spacerSize20),
                border: Border.all(color: AppColors.backgroundGrey),
              ),
              child: Column(
                spacing: spacerSize20,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: spacerSize12,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(spacerSize45),
                        child: CachedNetworkImage(
                          height: 70,
                          width: 70,
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
                              fontFamily: AppKeys.merriweather,
                              fontSize: fontSize22,
                              fontWeight: FontWeight.w400,
                              textColor: AppColors.offWhite,
                            ),
                            BaseText(
                              text: AppLocalizations.of(
                                context,
                              )!.successfullyAdded,
                              fontFamily: AppKeys.inter,
                              fontSize: fontSize14,
                              fontWeight: FontWeight.w400,
                              textColor: AppColors.darkGold,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  BaseText(
                    text: description,
                    fontFamily: AppKeys.inter,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.offWhite.withValues(alpha: 0.5),
                  ),

                  const SizedBox(height: spacerSize2),

                  BaseButton(
                    onPressed: () {
                      Get.back(result: true);
                      Get.back(result: true);
                      Get.back(result: true);
                    },
                    backgroundColor: AppColors.burntGold,
                    buttonLabel: buttonLabel,
                    fontSize: fontSize16,
                    buttonWidth: double.infinity,
                    textColor: Colors.white,
                  ),

                  BaseBackButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
