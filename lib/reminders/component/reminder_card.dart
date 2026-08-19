import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_date_format.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class ReminderCard extends StatelessWidget {
  final String plantName;
  final String task;
  final String status;
  final Color statusColor;
  final Color? textColor;
  final String timeLabel;
  final String? note;
  final String? reminderTime;
  final bool showActions;
  final VoidCallback? onReschedule;
  final VoidCallback? onMarkComplete;
  final VoidCallback? onDisableReminder;

  const ReminderCard({
    super.key,
    required this.plantName,
    required this.reminderTime,
    required this.task,
    required this.status,
    required this.statusColor,
    required this.textColor,
    required this.timeLabel,
    this.note,
    this.showActions = false,
    this.onReschedule,
    this.onMarkComplete,
    this.onDisableReminder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(spacerSize14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(spacerSize25),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), blurRadius: spacerSize4)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: spacerSize65,
                height: spacerSize65,
                decoration: BoxDecoration(
                  color: getIconColor(task).withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(spacerSize18),
                ),
                child: Icon(getActivityIcon(task), color: getIconColor(task)),
              ),
              const SizedBox(width: spacerSize14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(text: plantName, fontSize: fontSize14, fontWeight: FontWeight.w600),
                    BaseText(
                      text: getActivityTitle(task),
                      fontSize: fontSize13,
                      textColor: AppColors.lightGreyColor,
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: spacerSize10,
                  vertical: spacerSize6,
                ),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(spacerSize30),
                ),
                child: BaseText(
                  text: status,
                  fontSize: fontSize12,
                  fontWeight: FontWeight.w600,
                  textColor: textColor ?? AppColors.navyBlueColor,
                ),
              ),
              if (status.toLowerCase() != AppStrings.completed.toLowerCase())
                PopupMenuButton<String>(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(spacerSize10),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  menuPadding: EdgeInsets.zero,
                  onSelected: (value) {
                    if (value == 'complete') {
                      onMarkComplete?.call();
                    } else if (value == 'reschedule') {
                      onReschedule?.call();
                    } else if (value == 'disable') {
                      onDisableReminder?.call();
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 'complete',
                        child: Row(
                          spacing: spacerSize3,
                          children: [
                            Icon(Icons.check, color: AppColors.blackColor.withAlpha(120)),
                            BaseText(text: AppStrings.markAsComplete, fontSize: fontSize12, fontWeight: FontWeight.w500),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'reschedule',
                        child: Row(
                          spacing: spacerSize6,
                          children: [
                            Icon(Icons.date_range, color: AppColors.blackColor.withAlpha(120)),
                            BaseText(text: AppStrings.reschedule, fontSize: fontSize12, fontWeight: FontWeight.w500),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'disable',
                        child: Row(
                          spacing: spacerSize6,
                          children: [
                            Icon(
                              Icons.notifications_off,
                              color: AppColors.lightGreyColor.withAlpha(120),
                            ),
                            BaseText(text: AppStrings.disableReminder, fontSize: fontSize12, fontWeight: FontWeight.w500),
                          ],
                        ),
                      ),
                    ];
                  },
                  icon: const Icon(Icons.more_vert, color: AppColors.lightGreyColor),
                ),
            ],
          ),

          const SizedBox(height: spacerSize10),

          Row(
            spacing: spacerSize12,
            children: [
              const Icon(Icons.access_time, size: spacerSize18, color: AppColors.lightGreyColor),
              if (timeLabel.isNotEmpty)
                BaseText(
                  text: convertTo12Hour(timeLabel),
                  fontSize: fontSize12,
                  textColor: AppColors.lightGreyColor,
                ),
              if (reminderTime != null && reminderTime!.isNotEmpty) ...[
                BaseText(text: "•", fontSize: fontSize14, textColor: AppColors.reminderTimeTextColor),
                BaseText(
                  text: BaseDateTimeFormat.format(dateTime: reminderTime!, format: "EEE, MMMM d"),
                  fontSize: fontSize12,
                  textColor: AppColors.reminderTimeTextColor,
                ),
              ],
            ],
          ),

          if (reminderTime != null && reminderTime!.isNotEmpty) ...[
            const SizedBox(height: spacerSize8),
            Align(
              alignment: Alignment.centerLeft,
              child: BaseText(
                text: formatReminderTime(reminderTime!),
                fontSize: fontSize13,
                textColor: status == AppStrings.missed ? Colors.red : AppColors.reminderTimeTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

         if (note != null && note!.isNotEmpty) ...[
            const SizedBox(height: spacerSize8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(spacerSize14),
              decoration: BoxDecoration(
                color: const Color(0xffeee9e0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(note??'', style: const TextStyle(fontStyle: FontStyle.italic)),
            ),
         ],

          if (showActions) ...[
            const SizedBox(height: spacerSize18),
            Row(
              children: [
                FilledButton(
                  onPressed: onMarkComplete,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.chartBorderColor.withValues(alpha: .25),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.done, size: spacerSize18, color: AppColors.chartBorderColor),
                      const SizedBox(width: spacerSize6),
                      BaseText(
                        text: AppStrings.done,
                        textColor: AppColors.chartBorderColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: spacerSize10),
                FilledButton(
                  onPressed: onReschedule,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.mossGold.withValues(alpha: .2),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.date_range, size: spacerSize18, color: AppColors.grey),
                      const SizedBox(width: spacerSize6),
                      BaseText(
                        text: AppStrings.reschedule,
                        textColor: AppColors.blackColor.withValues(alpha: .6),
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String getActivityTitle(String? activityType) {
    switch (activityType) {
      case "water":
        return AppStrings.watering;
      case "fertilize":
        return AppStrings.fertilizing;
      case "prune":
        return AppStrings.pruning;
      case "generic":
        return AppStrings.generalCare;
    }
    return "";
  }

  IconData getActivityIcon(String? activityType) {
    switch (activityType) {
      case "water":
        return Icons.water_drop;
      case "fertilize":
        return Icons.science_outlined;
      case "prune":
        return Icons.cut_sharp;
      case "generic":
        return Icons.spa_outlined;
    }
    return Icons.water_drop;
  }

  Color getIconColor(String? activityType) {
    switch (activityType) {
      case "water":
        return AppColors.dodgerBlue;
      case "fertilize":
        return AppColors.violet;
      case "prune":
        return AppColors.sandColor;
      case "generic":
        return AppColors.siltColor;
    }
    return AppColors.dodgerBlue;
  }
}
