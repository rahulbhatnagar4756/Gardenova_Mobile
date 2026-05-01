import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../base/widgets/base_bordered_container.dart';
import '../../../base/widgets/base_shimmer.dart';
import '../../../base/widgets/base_text.dart';
import '../../../generated/assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';
import '../model/professional_dashboard_model.dart';

class ProfessionalItem extends StatelessWidget {
  const ProfessionalItem({
    super.key,
    this.isSelected = true,
    this.isSuccess = false,
    required this.professional,
  });

  final bool? isSelected;
  final bool? isSuccess;
  final ProfessionalCompany? professional;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: spacerSize10,
      children: [
        Stack(
          alignment: AlignmentGeometry.bottomRight,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(spacerSize8),
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: professional!.imageUrl ?? "",
                height: spacerSize190,
                width: double.infinity,
                placeholder: (context, url) {
                  return BaseShimmer();
                },
                errorWidget: (context, url, error) {
                  return Icon(
                    Icons.broken_image_rounded,
                    size: spacerSize60,
                    color: AppColors.offWhite10,
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(spacerSize10),
              padding: EdgeInsets.symmetric(
                horizontal: spacerSize10,
                vertical: spacerSize4,
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(spacerSize20),
                border: Border.all(
                  color: AppColors.grey.withValues(alpha: 0.7),
                  width: 1.5,
                ),
              ),
              child: Row(
                spacing: spacerSize8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Assets.imagesCar,
                    height: spacerSize12,
                    width: spacerSize12,
                    color: Colors.white,
                  ),

                  BaseText(
                    text: "${professional!.distanceKm.toString()}km",
                    fontSize: fontSize11,
                    fontFamily: AppKeys.inter,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.offWhite,
                  ),
                ],
              ),
            ),
          ],
        ),

        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Expanded(
                  child: BaseText(
                    text: professional!.companyName ?? "",
                    fontFamily: AppKeys.poppins,
                    textColor: AppColors.offWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: fontSize13,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.star_rate_rounded,
                      color: AppColors.offWhite70,
                      size: spacerSize16,
                    ),
                    BaseText(
                      text: professional!.rating.toString(),
                      fontSize: fontSize12,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.offWhite70,
                    ),
                  ],
                ),
              ],
            ),

            BaseText(
              text: professional!.legalName ?? "",
              textColor: AppColors.offWhite70,
              fontSize: fontSize11,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.start,
            ),

            Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: spacerSize4,
                    children: [
                      Image.asset(
                        AppAssets.location,
                        scale: 3,
                      ).marginOnly(top: spacerSize5),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BaseText(
                              text:
                                  '${professional!.state} ${professional!.city}',
                              fontSize: fontSize12,
                              textColor: AppColors.offWhite70,
                              fontWeight: FontWeight.w400,
                            ),
                            BaseText(
                              text: professional!.address ?? "",
                              fontSize: fontSize10,
                              textColor: AppColors.offWhite.withValues(
                                alpha: 0.3,
                              ),
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isSuccess!)
                  BaseBorderedContainer(
                    height: spacerSize25,
                    backgroundColor: isSelected!
                        ? AppColors.burntGold
                        : Colors.transparent,
                    width: spacerSize85,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      top: spacerSize2,
                      bottom: spacerSize2,
                      left: spacerSize5,
                      right: spacerSize5,
                    ),
                    childWidget: BaseText(
                      text: isSelected!
                          ? AppLocalizations.of(context)!.selected
                          : AppLocalizations.of(context)!.select,
                      textColor: AppColors.offWhite,
                      fontWeight: FontWeight.w400,
                      fontSize: fontSize12,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ).marginOnly(top: spacerSize12),
          ],
        ),
      ],
    ).marginSymmetric(vertical: spacerSize10, horizontal: spacerSize10);
  }

  Widget shimmerPlaceHolder() {
    return Shimmer(
      color: AppColors.offWhite10,
      colorOpacity: 0.25,
      interval: Duration(milliseconds: 20),
      duration: Duration(milliseconds: 2700),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColors.appColor,
      ),
    );
  }
}
