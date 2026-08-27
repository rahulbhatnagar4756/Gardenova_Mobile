import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
import 'package:kasagardem/dashboard/components/full_drawer.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/plants/plant_analysis/components/plant_scan_card.dart';
import 'package:kasagardem/plants/plant_analysis/plant_analysis_controller.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';

class PlantAnalysisScreen extends GetView<PlantAnalysisController> {
  const PlantAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.appColor,
      drawer: FullScreenDrawer(onTap: controller.navigateToNext),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.h + 30.h),
        child: Builder(
          builder: (context) {
            return CircularBottomAppBar(
              isBackButtonVisible: true,
              showMenuIcon: true,
              onSettingPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              spacerSize20,
              spacerSize16,
              spacerSize20,
              spacerSize8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  text: l10n.myPlantAnalysis,
                  fontFamily: AppKeys.poppins,
                  fontSize: fontSize20,
                  fontWeight: FontWeight.w600,
                ),
                
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: AppColors.greenColor,
              onRefresh: controller.refreshScans,
              child: Obx(() {
                if (controller.isLoading.value && controller.scans.isEmpty) {
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      spacerSize20,
                      spacerSize8,
                      spacerSize20,
                      88.h,
                    ),
                    itemCount: 6,
                    separatorBuilder: (_, _) => SizedBox(height: spacerSize8),
                    itemBuilder: (_, _) => const PlantScanCardShimmer(),
                  );
                }

                if (controller.scans.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 120.h),
                      _EmptyState(
                        title: l10n.noPlantAnalysisFound,
                        subtitle:
                            controller.errorMessage.value ??
                            l10n.noPlantAnalysisFoundDescription,
                      ),
                    ],
                  );
                }

                return ListView.separated(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: EdgeInsets.fromLTRB(
                    spacerSize20,
                    spacerSize8,
                    spacerSize20,
                    88.h,
                  ),
                  itemCount:
                      controller.scans.length +
                      (controller.isLoadMoreRunning.value ? 1 : 0),
                  separatorBuilder: (_, _) => SizedBox(height: spacerSize8),
                  itemBuilder: (context, index) {
                    if (index >= controller.scans.length) {
                      return const PlantScanCardShimmer();
                    }
                    return PlantScanCard(
                      scan: controller.scans[index],
                      onTap: () {
                        Get.toNamed(
                          Routes.plantAnalysisDetail,
                          arguments: controller.scans[index].id,
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyState({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacerSize40),
      child: Column(
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 48.w,
            color: AppColors.greenColor.withValues(alpha: 0.7),
          ),
          SizedBox(height: spacerSize16),
          BaseText(
            text: title,
            fontFamily: AppKeys.poppins,
            fontSize: fontSize16,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacerSize8),
          BaseText(
            text: subtitle,
            fontFamily: AppKeys.inter,
            fontSize: fontSize13,
            textColor: AppColors.liteGreyColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
