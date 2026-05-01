import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_app_bar.dart';
import 'package:kasagardem/base/widgets/base_back_button.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
import 'package:kasagardem/dashboard/components/full_drawer.dart';
import 'package:kasagardem/dashboard/components/heading_ui_layout.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/recommended_professionals/components/professional_card_layout.dart';
import 'package:kasagardem/recommended_professionals/recommended_professionals_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

import '../professional/professionalDashBoard/components/professional_item.dart';
import 'components/service_bottom_sheet.dart';

class RecommendedProfessionals
    extends GetWidget<RecommendedProfessionalsViewModel> {
  const RecommendedProfessionals({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isUserLoggedIn.value =
          SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false;
    });
    return Obx(
          () =>
          Scaffold(
            backgroundColor: AppColors.appColor,
            appBar: controller.isUserLoggedIn.value
                ? PreferredSize(
                preferredSize: const Size.fromHeight(spacerSize80),
                child: Builder(
                  builder: (context) {
                    return CircularBottomAppBar(
                      showMenuIcon: true,
                      onSettingPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ))
                : BaseAppBar(),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal:spacerSize20,vertical: spacerSize6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                        () =>
                    controller.professionalsList.isNotEmpty
                        ? BaseButton(
                      buttonLabel: AppLocalizations.of(
                        context,
                      )!.requestAQuote,
                      buttonWidth: Get.width,
                      onPressed: () {
                        if (controller.professionalsList.any(
                                (professional) =>
                            professional.isSelected == true)) {
                          Get.toNamed(Routes.createRequestScreen,
                              arguments: controller);
                        } else {
                          BaseSnackBar.show(
                            title: AppLocalizations.of(Get.context!)!
                                .error,
                            message: AppLocalizations.of(
                              Get.context!,
                            )!.pleaseSelectAtLeastOneProfessional,
                          );
                        }
                      },
                    )
                        : const SizedBox.shrink(),
                  ),
                  BaseBackButton().marginOnly(
                    top: spacerSize6,
                    bottom: spacerSize6,
                  ),
                ],
              ),
            ),
            drawer: FullScreenDrawer(
              onTap: (index) {
                controller.navigateToNext(index);
              },
            ),
            body: HeadingUiLayout(
               spacing: spacerSize20,
               sectionTitle: AppLocalizations.of(
                 context,
               )!.recommendedProfessionals,
               isFilterShow: true,
               onTabFilter: () {
                 ServiceBottomSheet.show(
                   categories: controller.categories,
                   selectedKey: controller.selectedService.value,
                   onSelect: (key, value) {
                     controller.selectedService.value = value;
                     controller.serviceController.text = value;
                     controller.callGetProfessionalListApi();
                   },
                 );
               },
               child: Expanded(
                 child: Obx(
                       () =>
                   controller.isLoading.value
                       ? ListView.builder(
                     physics: NeverScrollableScrollPhysics(),
                     itemCount: 4,
                     itemBuilder: (context, index) =>
                         BaseShimmer().marginOnly(bottom: spacerSize10),
                   )
                       : controller.professionalsList.isEmpty
                       ? Center(
                     child: BaseText(
                       text: AppLocalizations.of(
                         context,
                       )!.noProfessionalsAvailable,
                       textAlign: TextAlign.center,
                       fontFamily: AppKeys.poppins,
                       textColor: AppColors.offWhite,
                       fontSize: fontSize18,
                       fontWeight: FontWeight.bold,
                     ),
                   )
                       : RefreshIndicator(
                     onRefresh: () async {
                       await controller.callGetProfessionalListApi();
                     },
                     child: NotificationListener<ScrollNotification>(
                       onNotification: (ScrollNotification scrollInfo) {
                         if (!controller.isLoadMoreRunning.value &&
                             scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                             controller.isLoadMoreVisible.value) {
                           controller.loadMoreProfessional();
                         }
                         return false;
                       },
                       child: ListView.builder(
                         padding: EdgeInsets.zero,
                         itemCount: controller.isLoading.value
                             ? 4
                             : controller.professionalsList.length,
                         itemBuilder: (context, index) {
                           if (controller.isLoading.value) {
                             return BaseShimmer().marginOnly(bottom: spacerSize10);
                           }
                           return GestureDetector(
                             onTap: () {
                               controller.onTapToSelect(index);
                             },
                             child: BaseBorderedContainer(
                               height: spacerSize320,
                               width: Get.width,
                               backgroundColor: AppColors.darkGreen,
                               borderColor: controller.professionalsList[index].isSelected
                                   ? AppColors.burntGold
                                   : AppColors.offWhite10,

                               childWidget: ProfessionalItem(
                                 professional: controller.professionalsList[index],
                                 isSuccess: false,
                                 isSelected: controller.professionalsList[index].isSelected,
                               ),
                             ).marginOnly(bottom: spacerSize10),
                           );
                         },
                       ),
                     )
                   ),
                 ),
               ),
             ).marginSymmetric(horizontal: spacerSize20, vertical: spacerSize10),
          ),
    );
  }

}
