import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

import '../../../base/widgets/base_button.dart';
import '../../../base/widgets/base_outline_button.dart';
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
          alignment: AlignmentGeometry.topCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.only(
                topLeft: Radius.circular(spacerSize16),
                topRight: Radius.circular(spacerSize16),
              ),
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
                    color: AppColors.liteGreyColor,
                  );
                },
              ),
            ),
            Positioned(
              top: 3.w,
              left: 3.w,
              child: Container(
                margin: EdgeInsets.all(spacerSize10),
                padding: EdgeInsets.symmetric(
                  horizontal: spacerSize10,
                  vertical: spacerSize4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: .4),
                  borderRadius: BorderRadius.circular(spacerSize20),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: .4),
                    width: 1,
                  ),
                ),
                child: Row(
                  spacing: spacerSize8,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Assets.navigationIc,
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
            ),
            Positioned(
              bottom: 3.w,
              right: 3.w,
              child: Container(
                margin: EdgeInsets.all(spacerSize10),
                padding: EdgeInsets.symmetric(
                  horizontal: spacerSize5,
                  vertical: spacerSize4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.orangeColor,
                  borderRadius: BorderRadius.circular(spacerSize20),
                ),
                child: Center(
                  child: Row(
                    spacing: spacerSize8,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rate_rounded,
                        color: AppColors.offWhite70,
                        size: spacerSize16,
                      ),
                      BaseText(
                        text: professional!.rating.toString(),
                        fontSize: fontSize11,
                        fontFamily: AppKeys.inter,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.offWhite,
                      ),
                      SizedBox(width: 0.2.w),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacerSize10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BaseText(
                        text: professional!.companyName ?? "",
                        fontFamily: AppKeys.poppins,
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize13,
                      ),

                      professional?.legalName?.isNotEmpty == true
                          ? BaseText(
                              text: professional!.legalName ?? "",
                              textColor: AppColors.whiteColor,
                              fontSize: fontSize11,
                              fontWeight: FontWeight.w300,
                              textAlign: TextAlign.start,
                            )
                          : const SizedBox(),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: spacerSize4,
                              children: [
                                Image.asset(
                                  AppAssets.location,
                                  color: AppColors.greenColor,
                                  scale: 3,
                                ).marginOnly(top: spacerSize5),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      BaseText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        text:
                                            '${professional!.state} ${professional!.city}',
                                        fontSize: fontSize12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      BaseText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        text: professional!.address ?? "",
                                        fontSize: fontSize10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ).marginOnly(top: spacerSize6),
                    ],
                  ),
                ),
                isSelected == false
                    ? IgnorePointer(
                        ignoring: true,
                        child: SizedBox(
                          width: double.infinity,
                          height: spacerSize45,
                          child: BaseOutlineButton(
                            buttonPadding: EdgeInsets.only(bottom: 0),
                            textColor: AppColors.greenColor,
                            fontSize: fontSize17,
                            buttonLabel: AppLocalizations.of(context)!.select,
                            onPressed: () {
                              // Get.offAllNamed(Routes.login);
                            },
                          ),
                        ),
                      )
                    : IgnorePointer(
                        ignoring: true,
                        child: SizedBox(
                          width: double.infinity,
                          height: spacerSize45,
                          child: BaseButton(
                            tickPrefixIcon: true,
                            buttonPadding: EdgeInsets.only(bottom: 0),
                            linearBackgroundColor:
                                AppColors.linearGreenGradientForBtn,
                            textColor: AppColors.greenColor,
                            fontSize: fontSize15,
                            buttonLabel: AppLocalizations.of(context)!.selected,
                            onPressed: () {
                              // Get.offAllNamed(Routes.login);
                            },
                          ),
                        ),
                      ),
                SizedBox(height: 15.h),
                // BaseBorderedContainer(
                //   height: spacerSize40,
                //   backgroundColor: isSelected!
                //       ? AppColors.burntGold
                //       : Colors.transparent,
                //   width: double.infinity,
                //   alignment: Alignment.center,
                //   padding: EdgeInsets.only(
                //     top: spacerSize4,
                //     bottom: spacerSize4,
                //     left: spacerSize5,
                //     right: spacerSize5,
                //   ),
                //   borderRadius: 10.r,
                //   childWidget: BaseText(
                //     text: isSelected!
                //         ? AppLocalizations.of(context)!.selected
                //         : AppLocalizations.of(context)!.select,
                //     textColor:isSelected==true? AppColors.offWhite:AppColors.greenColor,
                //     fontWeight: FontWeight.w400,
                //     fontSize: fontSize12,
                //     textAlign: TextAlign.center,
                //   ),
                // ).paddingOnly(top: 10.h),
              ],
            ),
          ),
        ),
      ],
    );
    // ).marginSymmetric(vertical: spacerSize10, horizontal: spacerSize10);
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
