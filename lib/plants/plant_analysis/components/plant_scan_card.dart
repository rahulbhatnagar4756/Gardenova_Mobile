import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_date_format.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/plants/plant_analysis/model/plant_scan_model.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class PlantScanCard extends StatelessWidget {
  final PlantScan scan;
  final VoidCallback? onTap;

  const PlantScanCard({super.key, required this.scan, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final plantName = scan.plantName.trim().isEmpty
        ? l10n.noDataNa
        : scan.plantName.trim();
    final family = scan.family.trim();
    final disease = scan.predictedDisease.trim();
    final statusColor = scan.isHealthy
        ? AppColors.greenColor
        : AppColors.orangeColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spacerSize8),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(spacerSize16),
          border: Border.all(color: AppColors.borderLiteGreyColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _ScanImage(scan: scan),
            SizedBox(width: spacerSize8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: BaseText(
                          text: plantName,
                          fontFamily: AppKeys.poppins,
                          fontSize: fontSize15,
                          fontWeight: FontWeight.w600,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: spacerSize6),
                      _HealthChip(
                        label: scan.isHealthy
                            ? l10n.healthy
                            : l10n.needsAttention,
                        color: statusColor,
                      ),
                    ],
                  ),
                  if (family.isNotEmpty) ...[
                    SizedBox(height: spacerSize2),
                    BaseText(
                      text: family,
                      fontFamily: AppKeys.inter,
                      fontSize: fontSize12,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.liteGreyColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (disease.isNotEmpty) ...[
                    SizedBox(height: spacerSize4),
                    BaseText(
                      text: disease,
                      fontFamily: AppKeys.inter,
                      fontSize: fontSize13,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.darkGrey,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (scan.createdAt.isNotEmpty) ...[
                    SizedBox(height: spacerSize4),
                    BaseText(
                      text: timeAgo(scan.createdAt),
                      fontFamily: AppKeys.inter,
                      fontSize: fontSize11,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.liteGreyColor,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScanImage extends StatelessWidget {
  final PlantScan scan;

  const _ScanImage({required this.scan});

  static const double _size = 72;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(12.r);

    if (!scan.hasImage) {
      return _defaultImage(radius);
    }

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: scan.imageUrl,
        height: _size.w,
        width: _size.w,
        fit: BoxFit.cover,
        placeholder: (_, _) =>
            BaseShimmer(height: _size.w, width: _size.w, borderRadious: 12),
        errorWidget: (_, _, _) => _defaultImage(radius),
      ),
    );
  }

  Widget _defaultImage(BorderRadius radius) {
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        height: _size.w,
        width: _size.w,
        color: AppColors.greenColor.withValues(alpha: 0.08),
        alignment: Alignment.center,
        child: Image.asset(
          AppAssets.appLogo,
          height: 42.w,
          width: 42.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _HealthChip extends StatelessWidget {
  final String label;
  final Color color;

  const _HealthChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacerSize8,
        vertical: spacerSize4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(spacerSize20),
      ),
      child: BaseText(
        text: label,
        fontFamily: AppKeys.inter,
        fontSize: fontSize10,
        fontWeight: FontWeight.w600,
        textColor: color,
      ),
    );
  }
}

class PlantScanCardShimmer extends StatelessWidget {
  const PlantScanCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(spacerSize8),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(spacerSize16),
        border: Border.all(color: AppColors.borderLiteGreyColor),
      ),
      child: Row(
        children: [
          BaseShimmer(height: 72.w, width: 72.w, borderRadious: 12),
          SizedBox(width: spacerSize8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BaseShimmer(height: 16, width: 140, borderRadious: 4),
                SizedBox(height: spacerSize4),
                const BaseShimmer(height: 12, width: 90, borderRadious: 4),
                SizedBox(height: spacerSize4),
                const BaseShimmer(height: 12, width: 180, borderRadious: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
