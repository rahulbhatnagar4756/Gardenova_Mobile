import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/professional/professionalDashBoard/components/custom_tab.dart';
import 'package:kasagardem/professional/professionalDashBoard/components/professional_item.dart';
import 'package:kasagardem/professional/professionalDashBoard/professional_dashboard_controller.dart';
import '../../base/widgets/base_bordered_container.dart';
import '../../base/widgets/base_shimmer.dart';
import '../../base/widgets/base_text.dart';
import '../../base/widgets/circular_bottom_app_bar.dart';
import '../../dashboard/components/full_drawer.dart';
import '../../l10n/app_localizations.dart';
import '../../recommended_professionals/components/service_bottom_sheet.dart';
import '../../utils/constants/app_color.dart';
import '../../utils/constants/app_constants.dart';
import '../../utils/constants/app_keys.dart';
import '../../utils/routes.dart';
import 'components/professional_heading_item.dart';

class ProfessionalDashboardScreen
    extends GetWidget<ProfessionalDashboardController> {
  const ProfessionalDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar:  PreferredSize(
            preferredSize: Size.fromHeight(spacerSize80),
            child : Builder(
              builder: (context) {
                return CircularBottomAppBar(
                  showMenuIcon: true,
                  onSettingPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            )),
        backgroundColor: AppColors.appColor,
        drawer: FullScreenDrawer(
          isProfessional: true,
          onTap: (index) {
            controller.navigateToNext(index);
          },
        ),
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacerSize20,
                    vertical: spacerSize20,
                  ),
                  child: CustomTopTabs(
                    selectedIndex: controller.selectedTabIndex.value,
                    onTap: (int p1) {
                      controller.onTabChanged(p1);
                    },
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: spacerSize16,
                    ),
                    child: controller.selectedTabIndex.value == 0
                        ? professionalTab(context)
                        : wholesalerTab(context),
                  ),
                ),

                /*Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacerSize20,
                    vertical: spacerSize15,
                  ),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Column(
                        spacing: spacerSize8,
                        children: [
                          if (controller.professionalsList.isNotEmpty)
                            BaseButton(
                              buttonLabel: AppLocalizations.of(
                                context,
                              )!.requestAQuote,
                              buttonWidth: Get.width,
                              onPressed: () {
                                if (controller.professionalsList.any(
                                  (professional) =>
                                      professional.isSelected == true,
                                )) {
                                  if (controller.selectedTabIndex.value == 0) {
                                    controller.createLeadForProfessional();
                                  } else {
                                    controller.createLeadForWholesale();
                                  }
                                } else {
                                  BaseSnackBar.show(
                                    title: AppLocalizations.of(
                                      Get.context!,
                                    )!.error,
                                    message: AppLocalizations.of(
                                      Get.context!,
                                    )!.pleaseSelectAtLeastOneProfessional,
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
            Obx(
              () => Visibility(
                visible: !controller.hidePopUp.value,
                child: upgradePlan(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget professionalTab(BuildContext context) {
    return Obx(
      () => ProfessionalHeadingItem(
        controller: controller,
        spacing: spacerSize20,
        isFilterShow: true,
        sectionTitle: AppLocalizations.of(context)!.recommendedProfessionals,
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
        child: Expanded(child: buildList(context)),
      ),
    );
  }

  Widget wholesalerTab(BuildContext context) {
    return Obx(
      () => ProfessionalHeadingItem(
        spacing: spacerSize20,
        controller: controller,
        sectionTitle: AppLocalizations.of(context)!.wholesaleSuppliers,
        isFilterShow: true,
        onTabFilter: (){

        },
        child: Expanded(child: buildList(context)),
      ),
    );
  }

  Widget buildList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (controller.selectedTabIndex.value == 0) {
          controller.pageNumber.value = 1;
          controller.callGetProfessionalListApi();
        } else {
          controller.callGetWholesaleSupplierListApi();
        }
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
      ),
    );
  }

  Widget upgradePlan(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(spacerSize12),
      child: Card(
        elevation: 3,
        color: AppColors.appColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacerSize12),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: spacerSize12,
            vertical: spacerSize14,
          ),
          decoration: BoxDecoration(
            color: AppColors.appColor,
            borderRadius: BorderRadius.circular(spacerSize12),
            border: Border.all(color: AppColors.offWhite10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                size: spacerSize16,
                color: AppColors.darkGold,
              ),

              SizedBox(width: spacerSize8),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      text: AppLocalizations.of(
                        context,
                      )!.youAreOnA30DayFreeTrial,
                      textColor: AppColors.offWhite70,
                      fontSize: fontSize13,
                    ),
                    SizedBox(height: spacerSize4),
                    InkWell(
                      onTap: () {
                        Get.toNamed(
                          Routes.upgradePlan,
                          arguments: {AppKeys.screenType: AppKeys.dashboard},
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.upgradeNow,
                        style: TextStyle(
                          fontSize: fontSize14,
                          fontFamily: AppKeys.inter,
                          color: AppColors.darkGold,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.darkGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              InkWell(
                onTap: controller.onTabHidePopup,
                child: Padding(
                  padding: EdgeInsets.only(left: spacerSize8),
                  child: Icon(
                    Icons.clear,
                    size: spacerSize16,
                    color: AppColors.offWhite50,
                  ),
                ),
              ),
            ],
          ),
        ),
      ).marginOnly(bottom: spacerSize30),
    );
  }
}
