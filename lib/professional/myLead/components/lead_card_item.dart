import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_date_format.dart';
import 'package:kasagardem/professional/myLead/my_lead_controller.dart';

import '../../../base/dialogs/base_dialog.dart';
import '../../../base/widgets/base_button.dart';
import '../../../base/widgets/base_text.dart';
import '../../../generated/assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_assets.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';
import '../../../utils/routes.dart';

class LeadCardItem extends StatelessWidget {
  final MyLeadController controller;

  const LeadCardItem({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return leadItemCard(context);
  }

  Widget leadItemCard(BuildContext context) {
    return Obx(
      () => controller.myLeadsList.isNotEmpty
          ? ListView.builder(
              itemCount: controller.myLeadsList.length,
              padding: EdgeInsets.only(
                left: spacerSize15,
                right: spacerSize12,
                bottom: 25.h,
              ),
              itemBuilder: (context, index) {
                var item = controller.myLeadsList[index];
                return Container(
                  padding: EdgeInsets.all(spacerSize12),
                  margin: EdgeInsets.only(bottom: spacerSize15),
                  decoration: BoxDecoration(
                    color: AppColors.appColor,
                    borderRadius: BorderRadius.circular(spacerSize15),
                    border: Border.all(color: AppColors.borderLiteGreyColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: spacerSize20,
                    children: [
                      Column(
                        spacing: spacerSize4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BaseText(
                                text: item.companyName ?? "",
                                textAlign: TextAlign.center,
                                fontFamily: AppKeys.poppins,
                                fontSize: fontSize16,
                                fontWeight: FontWeight.w700,
                              ),
                              InkWell(
                                onTap: () {
                                  updateStatus(item.leadId ?? "");
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: spacerSize12,
                                    vertical: spacerSize2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.greenColor,
                                    borderRadius: BorderRadius.circular(
                                      spacerSize20,
                                    ),
                                    border: Border.all(
                                      color: AppColors.borderGold,
                                    ),
                                  ),
                                  child: BaseText(
                                    text: item.leadsStatus ?? "",
                                    textAlign: TextAlign.center,
                                    fontFamily: AppKeys.inter,
                                    textColor: AppColors.offWhite,
                                    fontSize: fontSize13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            spacing: spacerSize4,
                            children: [
                              Image.asset(
                                color: AppColors.greenColor,
                                item.location?.address != null &&
                                        item.location!.address!.isNotEmpty
                                    ? AppAssets.location
                                    : Assets.imagesUser,
                                height: spacerSize14,
                                width: spacerSize14,
                              ),
                              Expanded(
                                child: BaseText(
                                  text:
                                      item.location?.address ??
                                      item.email ??
                                      "",
                                  fontSize: fontSize11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              BaseText(
                                text: timeAgo(item.createdAt ?? ""),
                                fontSize: fontSize11,
                                textColor: AppColors.liteGreyColor,
                                fontWeight: FontWeight.w400,
                              ).marginOnly(right: spacerSize8),
                            ],
                          ),
                          Row(
                            spacing: spacerSize8,
                            children: [
                              Container(
                                padding: EdgeInsets.all(spacerSize6),
                                decoration: BoxDecoration(
                                  color: AppColors.toLiteGreenColor,
                                  borderRadius: BorderRadius.circular(
                                    spacerSize8,
                                  ),
                                ),

                                child: Image.asset(
                                  Assets.imagesServiceRequest,
                                  height: spacerSize16,
                                  width: spacerSize16,
                                  color: AppColors.greenColor,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BaseText(
                                      text: AppLocalizations.of(
                                        Get.context!,
                                      )!.serviceRequested.toUpperCase(),
                                      fontSize: fontSize12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    BaseText(
                                      text:
                                          item.requestingUser!.description ??
                                          "",
                                      maxLines: 2,
                                      fontSize: fontSize14,
                                      textColor: AppColors.liteGreyColor,
                                      fontWeight: FontWeight.w400,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).marginOnly(top: spacerSize16),
                        ],
                      ),
                      Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              AppColors.blackColor.withValues(alpha: 0.6),
                              // soft black center
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 38.h,
                        child: BaseButton(
                          buttonPadding: EdgeInsets.only(bottom: 0),
                          linearBackgroundColor:
                              AppColors.linearGreenGradientForBtn,
                          textColor: AppColors.greenColor,
                          fontSize: fontSize15,
                          buttonLabel: AppLocalizations.of(
                            context,
                          )!.viewDetails,
                          onPressed: () {
                            Get.toNamed(
                              Routes.leadDetailsScreen,
                              arguments: controller.myLeadsList[index],
                            );
                          },
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Get.toNamed(
                      //       Routes.leadDetailsScreen,
                      //       arguments: controller.myLeadsList[index],
                      //     );
                      //   },
                      //   child: Container(
                      //     alignment: Alignment.center,
                      //     padding: EdgeInsets.all(spacerSize12),
                      //     decoration: BoxDecoration(
                      //       gradient: item.isSelected
                      //           ? LinearGradient(
                      //               colors: [
                      //                 AppColors.lightGold,
                      //                 AppColors.burntGold,
                      //               ],
                      //               begin: Alignment.topCenter,
                      //               end: Alignment.bottomCenter,
                      //             )
                      //           : null,
                      //       color: item.isSelected
                      //           ? AppColors.darkGold
                      //           : Colors.transparent,
                      //       borderRadius: BorderRadius.circular(spacerSize10),
                      //       border: Border.all(color: AppColors.offWhite10),
                      //     ),
                      //     child: BaseText(
                      //       text: AppLocalizations.of(context)!.viewDetails,
                      //       fontSize: fontSize15,
                      //       textColor: item.isSelected
                      //           ? AppColors.offWhite
                      //           : AppColors.amberGold,
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: BaseText(
                text: controller.noDataText,
                textAlign: TextAlign.center,
                fontFamily: AppKeys.poppins,
                fontSize: fontSize18,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  updateStatus(String leadId) {
    BaseDialog.showAlertDialog(
      context: Get.context!,
      buttonLabel: AppLocalizations.of(Get.context!)!.confirm,
      title: AppLocalizations.of(Get.context!)!.leadStatus,
      description: AppLocalizations.of(Get.context!)!.updateLeadStatus,
      onButtonPressed: () {
        controller.callUpdateLeadStatusApi(leadId);
      },
    );
  }
}
