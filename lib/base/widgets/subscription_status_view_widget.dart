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

  void _openUpgrade({Object? arguments}) {
    Get.toNamed(
      SubscriptionNavigation.upgradeRoute,
      arguments: arguments ?? currentModel,
    )!.then((val) {
      if (val == true) {
        onUpgradeRefresh?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Free has no paid entitlement — always present as expired + upgrade CTA.
    final isExpired = _isFreePlan || _isExpired;
    final isExpiringToday =
        !_isFreePlan && (_isExpiringToday || _remainingDays == 0);
    final showUpgradeCta =
        _isFreePlan || isExpired || currentModel.name?.toLowerCase() == 'trial';
    final planName =
        '${currentModel.name == null ? "Free" : (currentModel.name!.capitalizeFirst ?? "")} Plan';

    return Container(
      padding: EdgeInsets.all(spacerSize16),
      margin: EdgeInsets.only(bottom: spacerSize18),
      decoration: BoxDecoration(
        gradient: AppColors.linearGradientForBtn,
        borderRadius: BorderRadius.circular(spacerSize20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      text: AppLocalizations.of(Get.context!)!.status.toUpperCase(),
                      fontFamily: AppKeys.inter,
                      textColor: AppColors.offWhite70,
                      fontSize: fontSize10,
                      fontWeight: FontWeight.w400,
                    ),
                    SizedBox(height: spacerSize4),
                    Row(
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: AppColors.whiteColor),
                        SizedBox(width: spacerSize6),
                        Flexible(
                          child: BaseText(
                            text: Utils.capitalize(currentModel.status ?? "Active"),
                            fontFamily: AppKeys.inter,
                            textColor: AppColors.whiteColor,
                            fontSize: fontSize16,
                            fontWeight: FontWeight.w600,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _openUpgrade,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacerSize10,
                    vertical: spacerSize6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(spacerSize20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (currentModel.name != null)
                        Image.asset(AppAssets.crownIc, width: 11.w, height: 11.w),
                      if (currentModel.name != null) SizedBox(width: spacerSize6),
                      BaseText(
                        text: planName,
                        fontSize: fontSize12,
                        fontFamily: AppKeys.inter,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.greenColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (!isExpired) ...[
            SizedBox(height: spacerSize14),
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
          ],
          if (isExpired) ...[
            SizedBox(height: spacerSize12),
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
          if (showUpgradeCta) ...[
            SizedBox(height: spacerSize14),
            CommonClickWidget(
              onTap: () {
                _openUpgrade(arguments: {AppKeys.screenType: AppKeys.dashboard});
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: spacerSize14,
                  vertical: spacerSize12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(spacerSize16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BaseText(
                      text: l10n.upgradeNow,
                      fontFamily: AppKeys.inter,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.greenColor,
                    ),
                    SizedBox(width: spacerSize8),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 18.w,
                      color: AppColors.greenColor,
                    ),
                  ],
                ),
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
                           // decoration: TextDecoration.underline,
                          ),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
