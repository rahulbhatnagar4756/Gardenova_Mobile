import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/plants/myPlants/myPlantsList/model/my_plants_listing_model.dart';
import '../../../../base/widgets/base_shimmer.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';

class MyPlantsListItem extends StatelessWidget {
  final Plants item;
  final VoidCallback? onTap;

  const MyPlantsListItem({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    int wateringReminderFrequency = item.wateringReminderFrequency ?? 0;
    bool healthStatus = item.healthStatus?.isNotEmpty ?? false;
    bool needToShowBottomWidget = wateringReminderFrequency > 0 || healthStatus;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.greenColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(spacerSize16),
          border: Border.all(
            color: AppColors.greenColor.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 IMAGE
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(spacerSize15),
              ),
              child: CachedNetworkImage(
                height: 105.h,
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: item.imageUrl ?? (item.imageOriginalUrl ?? ""),
                placeholder: (_, __) =>
                    const BaseShimmer(borderRadious: spacerSize16),
                errorWidget: (_, __, ___) =>
                    Icon(Icons.broken_image, color: AppColors.offWhite10),
              ),
            ),

            /// 🔹 CONTENT
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(spacerSize8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 TITLE + ARROW
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: BaseText(
                                text:
                                    item.commonName ??
                                    AppLocalizations.of(context)!.noDataNa,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                fontFamily: AppKeys.poppins,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              size: spacerSize20,
                              color: AppColors.darkGreen,
                            ),
                          ],
                        ),

                        SizedBox(height: spacerSize2),

                        BaseText(
                          text: (item.otherName?.isNotEmpty ?? false)
                              ? item.otherName ??
                                    "${AppLocalizations.of(context)!.noDataNa}: ${item.otherName}"
                              : item.genus ??
                                    AppLocalizations.of(context)!.noDataNa,
                          maxLines: !needToShowBottomWidget ? 2 : 1,
                          overflow: TextOverflow.ellipsis,
                          fontFamily: AppKeys.inter,
                          fontSize: (10.1).sp,
                          fontWeight: FontWeight.w400,
                          textColor: AppColors.liteGreyColor,
                        ),
                      ],
                    ),

                    /// 🔹 STATUS CHIPS
                    /// with new data don't have data this.
                    !needToShowBottomWidget
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              healthStatus
                                  ? Flexible(
                                      child: _statusChip(
                                        icon: Icons.info,
                                        // text: "85% ${AppLocalizations.of(context)!.health}",
                                        text:
                                            item.healthStatus ??
                                            AppLocalizations.of(
                                              context,
                                            )!.noDataNa,
                                        chipColor: AppColors.greenColor,
                                      ),
                                    )
                                  : const SizedBox(),
                              SizedBox(width: healthStatus ? spacerSize4 : 0),
                              wateringReminderFrequency > 0
                                  ? Flexible(
                                      child: _statusChip(
                                        icon: Icons.water_drop_outlined,
                                        text:
                                            "${AppLocalizations.of(context)!.inText} ${item.wateringReminderFrequency} ${AppLocalizations.of(context)!.day}s",
                                        chipColor: AppColors.red,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 STATUS CHIP
  Widget _statusChip({
    required IconData icon,
    required String text,
    required Color chipColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacerSize6,
        vertical: spacerSize4,
      ),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(spacerSize20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: spacerSize12, color: AppColors.offWhite),
          SizedBox(width: spacerSize4),
          Flexible(
            child: BaseText(
              text: text,
              fontSize: fontSize9,
              fontFamily: AppKeys.inter,
              fontWeight: FontWeight.w500,
              textColor: AppColors.offWhite,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
