import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/reminders/component/reminders_list.dart';
import 'package:kasagardem/reminders/component/upcoming_task.dart';
import 'package:kasagardem/reminders/plant_reminder_controller.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class PlantReminderListScreen extends GetWidget<PlantReminderController> {
  const PlantReminderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: spacerSize5),

            /// Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: spacerSize10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.arrow_back, size: spacerSize28),
                  ),
                  const BaseText(
                    text: AppStrings.plantCareReminders,
                    fontSize: fontSize18,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppKeys.poppins,
                  ),
                ],
              ),
            ),

            const SizedBox(height: spacerSize20),

            /// Status Tabs
            Obx(
              () => SizedBox(
                height: spacerSize50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: spacerSize10),
                  itemCount: controller.statuses.length,
                  separatorBuilder: (context, index) => const SizedBox(width: spacerSize12),
                  itemBuilder: (context, index) {
                    final status = controller.statuses[index];
                    return GestureDetector(
                      onTap: () => controller.updateStatus(status),
                      child: StatusChip(
                        title: status.title!,
                        count: status.counter!,
                        selected: controller.selectedStatus.value.code == status.code,
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: spacerSize20),

            /// Summary
            Obx(
              () => UpcomingTask(
                isVisible: controller.hasUpcomingTask.value,
                taskCount: controller.upcomingCount.value,
              ),
            ),

            const SizedBox(height: spacerSize20),

            /// Type Filters
            Obx(
              () => SizedBox(
                height: spacerSize50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: spacerSize10),
                  itemCount: controller.types.length,
                  separatorBuilder: (context, index) => const SizedBox(width: spacerSize10),
                  itemBuilder: (context, index) {
                    final type = controller.types[index];
                    return GestureDetector(
                      onTap: () => controller.updateType(type),
                      child: Obx(
                        () => FilterChipWidget(
                          type.title!,
                          controller.selectedType.value.code == type.code,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: spacerSize20),

            /// Reminder List
            Expanded(
              child: Obx(
                () => RefreshIndicator(
                  onRefresh: () async {
                    controller.pageNumber.value = 1;
                    controller.isLoadMoreVisible.value = false;
                    await controller.getAllNotifications();
                  },
                  child: CustomScrollView(
                    controller: controller.scrollController,
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    slivers: [
                      if (controller.reminderList.isEmpty && controller.isLoading.value == false)
                        const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: BaseText(
                              text: AppStrings.noRemindersFound,
                              fontSize: fontSize16,
                              textColor: Colors.grey,
                            ),
                          ),
                        )
                      else
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(
                            spacerSize10,
                            0,
                            spacerSize10,
                            spacerSize20,
                          ),
                          sliver: SliverList.separated(
                            itemCount: controller.reminderList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: spacerSize16),
                            itemBuilder: (context, index) {
                              return ReminderList.buildCard(
                                controller.reminderList[index],
                                controller,
                              );
                            },
                          ),
                        ),
                      if (controller.isLoadMoreRunning.value)
                        const SliverPadding(
                          padding: EdgeInsets.symmetric(vertical: spacerSize20),
                          sliver: SliverToBoxAdapter(
                            child: Center(child: CircularProgressIndicator()),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  final String title;
  final String count;
  final bool selected;

  const StatusChip({super.key, required this.title, required this.count, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: spacerSize24),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greenColor.withValues(alpha: .2)),
        color: selected ? AppColors.greenColor : AppColors.lightGreen,
        borderRadius: BorderRadius.circular(spacerSize28),
      ),
      child: Row(
        children: [
          BaseText(
            text: title,
            fontSize: fontSize18,
            textColor: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(width: spacerSize6),
          CircleAvatar(
            radius: spacerSize12,
            backgroundColor: selected
                ? AppColors.whiteColor.withValues(alpha: .3)
                : AppColors.lightGrey,
            child: BaseText(text: count, fontSize: fontSize12),
          ),
        ],
      ),
    );
  }
}

class FilterChipWidget extends StatelessWidget {
  final String text;
  final bool selected;

  const FilterChipWidget(this.text, this.selected, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: spacerSize20),
      decoration: BoxDecoration(
        color: selected ? AppColors.lightGreenColor : Colors.white,
        borderRadius: BorderRadius.circular(spacerSize30),
        border: Border.all(color: selected ? AppColors.darkGreen : Colors.black26),
      ),
      child: Center(
        child: Row(
          children: [
            if (text != AppStrings.allTypes) ...[
              Icon(
                getActivityIcon(text),
                color: selected ? AppColors.darkGreen : AppColors.blackColor.withValues(alpha: .8),
              ),
              const SizedBox(width: spacerSize6),
            ],
            BaseText(
              text: text,
              fontSize: fontSize16,
              textColor: selected ? AppColors.darkGreen : AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }

  IconData getActivityIcon(String? activityType) {
    switch (activityType) {
      case AppStrings.water:
        return Icons.water_drop;
      case AppStrings.fertilize:
        return Icons.science_outlined;
      case AppStrings.prune:
        return Icons.cut_sharp;
      case AppStrings.generic:
        return Icons.spa_outlined;

      default:
        return Icons.water_drop;
    }
  }
}
