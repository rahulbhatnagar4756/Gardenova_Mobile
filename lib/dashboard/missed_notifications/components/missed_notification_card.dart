import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/missed_notifications/model/missed_notification_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';

class MissedNotificationCard extends StatelessWidget {
  final MissedNotificationItem item;
  final VoidCallback? onTap;

  const MissedNotificationCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final commonName = item.commonName.trim();
    final scientificName = item.scientificName.trim();
    final feature = _featureLabel(l10n, item.notificationFeature);
    final featureColor = _featureColor(item.notificationFeature);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: featureColor.withValues(alpha: 0.18), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: featureColor.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          onTap: onTap ?? () => Get.toNamed(Routes.plantRemindersListing),
          borderRadius: BorderRadius.circular(18.r),
          child: Stack(
            children: [
              Positioned(
                top: -10,
                right: -10,
                child: Container(
                  width: 50.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: featureColor.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            featureColor.withValues(alpha: 0.18),
                            featureColor.withValues(alpha: 0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: featureColor.withValues(alpha: 0.25), width: 1),
                      ),
                      child: Icon(
                        _featureIcon(item.notificationFeature),
                        color: featureColor,
                        size: 24.w,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BaseText(
                            text: commonName.isEmpty ? l10n.noDataNa : commonName,
                            fontFamily: AppKeys.poppins,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.blackColor,
                            maxLines: 1,
                            overflow: TextOverflow.visible,
                          ),
                          if (scientificName.isNotEmpty) ...[
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Icon(
                                  Icons.spa_outlined,
                                  size: 11.w,
                                  color: AppColors.greenColor.withValues(alpha: 0.7),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    scientificName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontFamily: AppKeys.inter,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.liteGreyColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          SizedBox(height: 10.h),
                          Wrap(
                            spacing: 6.w,
                            runSpacing: 6.h,
                            children: [
                              if (feature.isNotEmpty)
                                _FeatureChip(label: feature, color: featureColor),

                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      margin: EdgeInsets.only(top: 4.h),
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: featureColor.withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.chevron_right_rounded, size: 18.w, color: featureColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _featureLabel(AppLocalizations l10n, String feature) {
    switch (feature.trim().toLowerCase()) {
      case 'watering':
      case 'water':
        return l10n.watering;
      case 'fertilizing':
      case 'fertilize':
      case 'fertilizer':
        return l10n.fertilizing;
      case 'pruning':
      case 'prune':
        return l10n.pruning;
      default:
        final cleaned = feature.trim().replaceAll('_', ' ');
        if (cleaned.isEmpty) return '';
        return cleaned
            .split(' ')
            .where((word) => word.isNotEmpty)
            .map((word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
            .join(' ');
    }
  }

  IconData _featureIcon(String feature) {
    switch (feature.trim().toLowerCase()) {
      case 'watering':
      case 'water':
        return Icons.water_drop_rounded;
      case 'fertilizing':
      case 'fertilize':
      case 'fertilizer':
        return Icons.science_outlined;
      case 'pruning':
      case 'prune':
        return Icons.content_cut_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }

  Color _featureColor(String feature) {
    switch (feature.trim().toLowerCase()) {
      case 'watering':
      case 'water':
        return AppColors.dodgerBlue;
      case 'fertilizing':
      case 'fertilize':
      case 'fertilizer':
        return AppColors.violet;
      case 'pruning':
      case 'prune':
        return AppColors.sandColor;
      default:
        return AppColors.greenColor;
    }
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;
  final Color color;

  const _FeatureChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.25), width: 0.8),
      ),
      child: BaseText(
        text: label,
        fontFamily: AppKeys.poppins,
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        textColor: color,
      ),
    );
  }
}

class _MissedCountChip extends StatelessWidget {
  final int count;
  final String label;

  const _MissedCountChip({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    const alertColor = AppColors.orangeColor;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [alertColor.withValues(alpha: 0.16), alertColor.withValues(alpha: 0.08)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: alertColor.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, size: 12.w, color: alertColor),
          SizedBox(width: 4.w),
          BaseText(
            text: '$label $count',
            fontFamily: AppKeys.poppins,
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            textColor: alertColor,
          ),
        ],
      ),
    );
  }
}

class MissedNotificationCardShimmer extends StatelessWidget {
  const MissedNotificationCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.borderLiteGreyColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseShimmer(height: 48.w, width: 48.w, borderRadious: 14),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BaseShimmer(height: 16, width: 140, borderRadious: 4),
                SizedBox(height: 6.h),
                const BaseShimmer(height: 12, width: 180, borderRadious: 4),
                SizedBox(height: 12.h),
                Row(
                  children: const [
                    BaseShimmer(height: 22, width: 80, borderRadious: 12),
                    SizedBox(width: 6),
                    BaseShimmer(height: 22, width: 70, borderRadious: 12),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
