import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_calculate_remaining_days.dart';
import 'package:kasagardem/base/widgets/base_date_format.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../l10n/app_localizations.dart';
import '../../settings/model/subscription_local_status_ui_model.dart';
import '../../subscription/subscription_navigation.dart';
import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/utils.dart';

class SubscriptionStatusViewWidget extends StatelessWidget {
  final SubscriptionStatusUiModel currentModel;
  final VoidCallback? onUpgradeRefresh;
  final VoidCallback? onCancelSubscription;
  final bool isCancellingSubscription;
  final bool showCancelAction;

  const SubscriptionStatusViewWidget(
    this.currentModel, {
    this.onUpgradeRefresh,
    this.onCancelSubscription,
    this.isCancellingSubscription = false,
    this.showCancelAction = false,
    super.key,
  });

  int get _remainingDays =>
      BaseCalculateRemainingDays.daysUntilEndDate(currentModel.updatedAt);

  bool get _isExpired =>
      BaseCalculateRemainingDays.isExpired(currentModel.updatedAt);

  bool get _isExpiringToday =>
      BaseCalculateRemainingDays.isExpiringToday(currentModel.updatedAt);

  bool get _isFreePlan => currentModel.isFreePlan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Free has no paid entitlement — always present as expired + upgrade CTA.
    final isExpired = _isFreePlan || _isExpired;
    final isExpiringToday =
        !_isFreePlan && (_isExpiringToday || _remainingDays == 0);

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
                      CircleAvatar(radius: 4, backgroundColor: AppColors.whiteColor),
                      SizedBox(width: spacerSize6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaseText(
                            text: AppLocalizations.of(Get.context!)!.status.toUpperCase(),
                            fontFamily: AppKeys.inter,
                            textColor: AppColors.offWhite70,
                            fontSize: fontSize10,
                            fontWeight: FontWeight.w400,
                          ),
                          Row(
                            children: [
                              BaseText(
                                text: Utils.capitalize(currentModel.status ?? "Active"),
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
                            SubscriptionNavigation.upgradeRoute,
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
                              if (currentModel.name != null)
                                Image.asset(AppAssets.crownIc, width: 11.w, height: 11.w),
                              SizedBox(width: spacerSize6),
                              BaseText(
                                text:
                                    '${currentModel.name == null ? "Free" : (currentModel.name!.capitalizeFirst ?? "")} Plan',
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
                      if (_isFreePlan ||
                          isExpired ||
                          currentModel.name?.toLowerCase() == 'trial')
                        Align(
                          alignment: Alignment.centerRight,
                          child: CommonClickWidget(
                            onTap: () {
                              Get.toNamed(
                                SubscriptionNavigation.upgradeRoute,
                                arguments: {AppKeys.screenType: AppKeys.dashboard},
                              )!.then((val) {
                                if (val == true) {
                                  onUpgradeRefresh?.call();
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(Icons.sync, size: 11.w, color: AppColors.whiteColor),
                                SizedBox(width: spacerSize4),
                                BaseText(
                                  text: AppLocalizations.of(Get.context!)!.upgradeNow,
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
              Divider(color: AppColors.whiteColor.withValues(alpha: 0.6), thickness: 0.8),
              if (!isExpired) SizedBox(height: spacerSize8),
              if (!isExpired)
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
                          Icon(Icons.access_time, size: 14, color: AppColors.whiteColor),
                          SizedBox(width: spacerSize6),
                          BaseText(
                            text: isExpiringToday
                                ? l10n.planExpiringToday.toUpperCase()
                                : l10n.subscriptionRemaining.toUpperCase(),
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
                          isExpiringToday
                              ? BaseText(
                                  text: l10n.planExpiringToday,
                                  fontSize: fontSize22,
                                  fontWeight: FontWeight.w700,
                                  textColor: AppColors.whiteColor,
                                  fontFamily: AppKeys.inter,
                                )
                              : RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: _remainingDays.clamp(0, 365).toString(),
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.whiteColor,
                                          fontFamily: AppKeys.inter,
                                        ),
                                      ),
                                      TextSpan(
                                        text: " ${l10n.days} ${l10n.left}",
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
              if (isExpired) ...[
                SizedBox(height: spacerSize8),
                BaseText(
                  text: l10n.planExpired,
                  fontSize: fontSize18,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.whiteColor,
                  fontFamily: AppKeys.inter,
                ),
              ],
              if (currentModel.hasPendingPlan) ...[
                SizedBox(height: spacerSize10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(spacerSize12),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(spacerSize14),
                    border: Border.all(color: AppColors.whiteColor.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.schedule, size: 16, color: AppColors.whiteColor),
                      SizedBox(width: spacerSize8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BaseText(
                              text: 'UPCOMING PLAN',
                              fontFamily: AppKeys.inter,
                              textColor: AppColors.offWhite70,
                              fontSize: fontSize10,
                              fontWeight: FontWeight.w500,
                            ),
                            SizedBox(height: spacerSize4),
                            BaseText(
                              text:
                                  '${currentModel.pendingPlanDisplayLabel} starts on ${BaseDateTimeFormat.format(dateTime: currentModel.pendingEffectiveAt ?? currentModel.updatedAt ?? "", format: "MMM dd, yyyy")}',
                              fontFamily: AppKeys.inter,
                              textColor: AppColors.whiteColor,
                              fontSize: fontSize12,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (showCancelAction && !isExpired)
                Padding(
                  padding: EdgeInsets.only(top: spacerSize10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CommonClickWidget(
                      onTap: isCancellingSubscription ? null : onCancelSubscription,
                      child: isCancellingSubscription
                          ? SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.whiteColor,
                              ),
                            )
                          : Text(
                              AppStrings.cancelSubscription,
                              style: TextStyle(
                                fontFamily: AppKeys.inter,
                                fontSize: fontSize10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.whiteColor.withValues(alpha: 0.9),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                    ),
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
