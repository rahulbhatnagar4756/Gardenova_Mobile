import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/circular_bottom_app_bar.dart';
import 'package:kasagardem/dashboard/components/full_drawer.dart';
import 'package:kasagardem/dashboard/missed_notifications/components/missed_notification_card.dart';
import 'package:kasagardem/dashboard/missed_notifications/missed_notifications_controller.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class MissedNotificationsScreen extends GetView<MissedNotificationsController> {
  const MissedNotificationsScreen({super.key});

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
      body: RefreshIndicator(
        color: AppColors.greenColor,
        onRefresh: controller.refreshNotifications,
        child: Obx(() {
          if (controller.isLoading.value && controller.items.isEmpty) {
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.fromLTRB(spacerSize20, spacerSize16, spacerSize20, 88.h),
              itemCount: 6,
              separatorBuilder: (_, _) => SizedBox(height: spacerSize10),
              itemBuilder: (_, _) => const MissedNotificationCardShimmer(),
            );
          }

          if (controller.items.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: 120.h),
                _EmptyState(
                  title: l10n.noMissedNotifications,
                  subtitle: controller.errorMessage.value ?? l10n.noMissedNotificationsDescription,
                ),
              ],
            );
          }

          final itemCount = controller.items.length + (controller.isLoadMoreRunning.value ? 1 : 0);

          return ListView.separated(
            controller: controller.scrollController,
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            padding: EdgeInsets.fromLTRB(spacerSize20, spacerSize16, spacerSize20, spacerSize24),
            itemCount: itemCount,
            separatorBuilder: (_, _) => SizedBox(height: spacerSize10),
            itemBuilder: (context, index) {
              if (index < controller.items.length) {
                final item = controller.items[index];
                return MissedNotificationCard(
                  item: item,
                  onTap: () => controller.completeMissedNotification(item.id),
                );
              }
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: AppColors.greenColor,
                    ),
                  ),
                ),
              );
            },
          );
        }),
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
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 76.w,
            height: 76.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [AppColors.toToLiteGreenColor, AppColors.lightGreen.withValues(alpha: 0.6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greenColor.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.verified_rounded, size: 40.w, color: AppColors.greenColor),
          ),
          SizedBox(height: spacerSize16),
          BaseText(
            text: title,
            fontFamily: AppKeys.poppins,
            fontSize: fontSize16,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            textColor: AppColors.blackColor,
          ),
          SizedBox(height: spacerSize8),
          BaseText(
            text: subtitle,
            fontFamily: AppKeys.inter,
            fontSize: fontSize12,
            textColor: AppColors.liteGreyColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
