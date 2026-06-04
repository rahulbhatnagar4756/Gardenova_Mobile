import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_date_format.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../l10n/app_localizations.dart';
import '../../settings/model/subscription_local_status_ui_model.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/routes.dart';
import '../../utils/utils.dart';

class SubscriptionStatusViewWidget extends StatelessWidget {
  final SubscriptionStatusUiModel currentModel;
  final VoidCallback? onUpgradeRefresh;

  const SubscriptionStatusViewWidget(
    this.currentModel, {
    this.onUpgradeRefresh,
    super.key,
  });

  int get _remainingDays {
    if (currentModel.updatedAt == null) return 0;
    try {
      final expirationDate = DateTime.parse(currentModel.updatedAt!).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final exp = DateTime(
        expirationDate.year,
        expirationDate.month,
        expirationDate.day,
      );
      final difference = exp.difference(today).inDays;
      return difference.clamp(0, 365);
    } catch (_) {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(spacerSize16),
          margin: EdgeInsets.only(bottom: spacerSize18),
          decoration: BoxDecoration(
            color: AppColors.greenColor,
            borderRadius: BorderRadius.circular(spacerSize20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 4,
                        backgroundColor: AppColors.whiteColor,
                      ),
                      SizedBox(width: spacerSize6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaseText(
                            text: AppLocalizations.of(
                              Get.context!,
                            )!.status.toUpperCase(),
                            fontFamily: AppKeys.inter,
                            textColor: AppColors.offWhite70,
                            fontSize: fontSize10,
                            fontWeight: FontWeight.w400,
                          ),
                          Row(
                            children: [
                              BaseText(
                                text: Utils.capitalize(
                                  currentModel.status ?? "",
                                ),
                                fontFamily: AppKeys.inter,
                                textColor: AppColors.whiteColor,
                                fontSize: fontSize16,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            Routes.upgradePlan,
                            // arguments: {AppKeys.screenType: AppKeys.dashboard},
                            arguments: currentModel,
                          )!.then((val) {
                            if (val == true) {
                              onUpgradeRefresh?.call();
                            }
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacerSize8,
                            vertical: spacerSize6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(spacerSize20),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                AppAssets.crownIc,
                                width: 11.w,
                                height: 11.w,
                              ),
                              SizedBox(width: spacerSize6),
                              BaseText(
                                text: '${(currentModel.name ?? "")} Plan',
                                fontSize: fontSize12,
                                fontFamily: AppKeys.inter,
                                fontWeight: FontWeight.w600,
                                textColor: AppColors.greenColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: spacerSize8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CommonClickWidget(
                          onTap: () {
                            Get.toNamed(
                              Routes.upgradePlan,
                              arguments: {
                                AppKeys.screenType: AppKeys.dashboard,
                              },
                            )!.then((val) {
                              if (val == true) {
                                onUpgradeRefresh?.call();
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.sync,
                                size: 11.w,
                                color: AppColors.whiteColor,
                              ),
                              SizedBox(width: spacerSize4),
                              BaseText(
                                text:
                                    currentModel.name?.toLowerCase() == "trial"
                                    ? AppLocalizations.of(
                                        Get.context!,
                                      )!.upgradeNow
                                    : AppLocalizations.of(
                                        Get.context!,
                                      )!.renewPlan,
                                fontFamily: AppKeys.inter,
                                fontSize: fontSize10,
                                fontWeight: FontWeight.w600,
                                textColor: AppColors.whiteColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: spacerSize8),
              Divider(
                color: AppColors.whiteColor.withValues(alpha: 0.6),
                thickness: 0.8,
              ),
              SizedBox(height: spacerSize8),
              Container(
                padding: EdgeInsets.all(spacerSize14),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(spacerSize16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: AppColors.whiteColor,
                        ),
                        SizedBox(width: spacerSize6),
                        BaseText(
                          text: AppLocalizations.of(
                            Get.context!,
                          )!.subscriptionRemaining.toUpperCase(),
                          fontFamily: AppKeys.inter,
                          textColor: AppColors.whiteColor,
                          fontSize: fontSize10,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                    SizedBox(height: spacerSize6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: _remainingDays.toString(),
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.whiteColor,
                                  fontFamily: AppKeys.inter,
                                ),
                              ),
                              TextSpan(
                                text:
                                    " ${AppLocalizations.of(Get.context!)!.days} ${AppLocalizations.of(Get.context!)!.left}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.offWhite70,
                                  fontFamily: AppKeys.inter,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            BaseText(
                              text: AppLocalizations.of(Get.context!)!.expDate,
                              fontFamily: AppKeys.inter,
                              textColor: AppColors.whiteColor,
                              fontSize: fontSize10,
                              fontWeight: FontWeight.w400,
                            ),
                            SizedBox(height: spacerSize2),
                            BaseText(
                              text: BaseDateTimeFormat.format(
                                dateTime: currentModel.updatedAt ?? "",
                                format: "MMM dd, yyyy",
                              ),
                              fontFamily: AppKeys.inter,
                              textColor: AppColors.offWhite70,
                              fontSize: fontSize12,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 4,
          margin: EdgeInsets.only(top: 0.3, left: 10.w, right: 10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(spacerSize24),
            gradient: AppColors.linearGradientForBtn,
          ),
        ),
      ],
    );
  }
}
