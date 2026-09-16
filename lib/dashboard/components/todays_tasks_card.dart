import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_date_format.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/todays_tasks_controller.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

/// Garden-styled daily care / habit card for the dashboard.
class TodaysTasksCard extends GetView<TodaysTasksController> {
  const TodaysTasksCard({
    super.key,
    required this.onScanTap,
    required this.onRemindersTap,
  });

  final VoidCallback onScanTap;
  final VoidCallback onRemindersTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final allDone = controller.allComplete;

      return Card(
        margin: EdgeInsets.zero,
        elevation: 3,
        clipBehavior: Clip.antiAlias,
        shadowColor: AppColors.darkGreenColor.withValues(alpha: 0.18),
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: BorderSide(
            color: AppColors.greenColor.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(controller: controller, l10n: l10n, allDone: allDone),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ProgressBar(progress: controller.progress),
                  SizedBox(height: 10.h),
                  _buildBody(l10n, allDone),
                  if (allDone) ...[
                    SizedBox(height: 10.h),
                    _BonusRow(controller: controller, l10n: l10n),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBody(AppLocalizations l10n, bool allDone) {
    if (controller.isLoadingCare.value && !controller.careLoaded.value) {
      return Column(
        children: [
          for (var i = 0; i < 2; i++) ...[
            if (i > 0) SizedBox(height: 8.h),
            Container(
              height: 52.h,
              decoration: BoxDecoration(
                color: AppColors.toToLiteGreenColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ],
        ],
      );
    }

    if (controller.isCareMode) {
      if (allDone || controller.liveTasks.isEmpty) {
        if (allDone) return const SizedBox.shrink();
        return _InfoRow(
          text: l10n.noCareDueToday,
          action: l10n.todaysTasksViewAll,
          onTap: onRemindersTap,
        );
      }

      return Column(
        children: [
          for (var i = 0; i < controller.visibleCareTasks.length; i++) ...[
            if (i > 0) SizedBox(height: 8.h),
            _CareRow(
              task: controller.visibleCareTasks[i],
              l10n: l10n,
              active: i == 0,
              loading: controller.completingId.value ==
                  controller.visibleCareTasks[i].id,
              onTap: () =>
                  controller.completeCareTask(controller.visibleCareTasks[i]),
            ),
          ],
          if (controller.hasMoreCareTasks) ...[
            SizedBox(height: 6.h),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onRemindersTap,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BaseText(
                        text: l10n.todaysTasksViewAll,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.greenColor,
                        fontFamily: AppKeys.poppins,
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16.w,
                        color: AppColors.greenColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    }

    return Column(
      children: [
        for (final id in DailyTaskId.values) ...[
          if (id != DailyTaskId.values.first) SizedBox(height: 8.h),
          _HabitRow(
            id: id,
            label: _habitLabel(l10n, id),
            done: controller.isCompleted(id),
            active: controller.nextTask == id,
            onTap: () => _onHabit(id),
          ),
        ],
      ],
    );
  }

  void _onHabit(DailyTaskId id) {
    switch (id) {
      case DailyTaskId.water:
      case DailyTaskId.inspect:
      case DailyTaskId.fertilize:
      case DailyTaskId.prune:
        controller.completeTask(id);
        break;
      case DailyTaskId.scan:
        HapticFeedback.selectionClick();
        onScanTap();
        break;
      case DailyTaskId.reminders:
        HapticFeedback.selectionClick();
        onRemindersTap();
        break;
    }
  }

  String _habitLabel(AppLocalizations l10n, DailyTaskId id) {
    switch (id) {
      case DailyTaskId.water:
        return l10n.taskWaterShort;
      case DailyTaskId.inspect:
        return l10n.taskInspectShort;
      case DailyTaskId.fertilize:
        return l10n.taskFertilizeShort;
      case DailyTaskId.prune:
        return l10n.taskPruneShort;
      case DailyTaskId.scan:
        return l10n.taskScanShort;
      case DailyTaskId.reminders:
        return l10n.taskRemindersShort;
    }
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.controller,
    required this.l10n,
    required this.allDone,
  });

  final TodaysTasksController controller;
  final AppLocalizations l10n;
  final bool allDone;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.toToLiteGreenColor,
            AppColors.lightGreen.withValues(alpha: 0.55),
            AppColors.whiteColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.greenColor.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.greenColor.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              allDone ? Icons.eco_rounded : Icons.task_alt_rounded,
              color: AppColors.greenColor,
              size: 22.w,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  text: allDone
                      ? l10n.todaysTasksAllDoneTitle
                      : l10n.todaysTasks,
                  fontWeight: FontWeight.w700,
                  fontSize: 15.sp,
                  fontFamily: AppKeys.poppins,
                ),
                SizedBox(height: 2.h),
                BaseText(
                  text: allDone
                      ? l10n.todaysTasksAllDoneSubtitle
                      : '${controller.completedCount}/${controller.totalCount}  ·  ${l10n.todaysTasksSubtitle}',
                  fontSize: 10.sp,
                  textColor: AppColors.liteGreyColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _StatChip(
            icon: Icons.local_fire_department_rounded,
            color: AppColors.orangeColor,
            tint: AppColors.orangeColor.withValues(alpha: 0.12),
            value: '${controller.streak.value}',
          ),
          SizedBox(width: 6.w),
          _StatChip(
            icon: Icons.bolt_rounded,
            color: AppColors.burntGold,
            tint: AppColors.burntGold.withValues(alpha: 0.14),
            value: '${controller.xp.value}',
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.color,
    required this.tint,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final Color tint;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.w, color: color),
          SizedBox(width: 3.w),
          BaseText(
            text: value,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppKeys.poppins,
            textColor: AppColors.blackColor,
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        builder: (context, value, _) {
          return LinearProgressIndicator(
            value: value,
            minHeight: 8.h,
            backgroundColor: AppColors.toToLiteGreenColor,
            color: AppColors.greenColor,
          );
        },
      ),
    );
  }
}

class _HabitRow extends StatelessWidget {
  const _HabitRow({
    required this.id,
    required this.label,
    required this.done,
    required this.active,
    required this.onTap,
  });

  final DailyTaskId id;
  final String label;
  final bool done;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accent = _color(id);
    final isGo =
        !done && (id == DailyTaskId.scan || id == DailyTaskId.reminders);

    return Material(
      color: done
          ? AppColors.toToLiteGreenColor.withValues(alpha: 0.65)
          : active
              ? AppColors.lightGreen
              : AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: done
                  ? AppColors.greenColor.withValues(alpha: 0.2)
                  : active
                      ? AppColors.greenColor.withValues(alpha: 0.5)
                      : AppColors.borderLiteGreyColor,
              width: active && !done ? 1.4 : 1,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  decoration: BoxDecoration(
                    color: done ? AppColors.greenColor : accent,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(12.r),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Row(
                      children: [
                        AnimatedScale(
                          scale: done ? 1.05 : 1,
                          duration: const Duration(milliseconds: 180),
                          child: Container(
                            width: 34.w,
                            height: 34.w,
                            decoration: BoxDecoration(
                              color: done
                                  ? AppColors.greenColor.withValues(alpha: 0.14)
                                  : accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              done ? Icons.check_rounded : _icon(id),
                              size: 18.w,
                              color: done ? AppColors.greenColor : accent,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: BaseText(
                            text: label,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppKeys.poppins,
                            textColor: done
                                ? AppColors.liteGreyColor
                                : AppColors.blackColor,
                          ),
                        ),
                        if (!done)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: isGo
                                  ? AppColors.greenColor
                                  : AppColors.lightGreen,
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: BaseText(
                              text: isGo
                                  ? l10n.todaysTasksGo
                                  : '+${TodaysTasksController.taskXp}',
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              textColor: isGo
                                  ? AppColors.whiteColor
                                  : AppColors.greenColor,
                              fontFamily: AppKeys.poppins,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _icon(DailyTaskId id) {
    switch (id) {
      case DailyTaskId.water:
        return Icons.water_drop_rounded;
      case DailyTaskId.inspect:
        return Icons.spa_rounded;
      case DailyTaskId.fertilize:
        return Icons.science_outlined;
      case DailyTaskId.prune:
        return Icons.content_cut_rounded;
      case DailyTaskId.scan:
        return Icons.document_scanner_outlined;
      case DailyTaskId.reminders:
        return Icons.notifications_active_outlined;
    }
  }

  Color _color(DailyTaskId id) {
    switch (id) {
      case DailyTaskId.water:
        return AppColors.dodgerBlue;
      case DailyTaskId.inspect:
        return AppColors.greenColor;
      case DailyTaskId.fertilize:
        return AppColors.violet;
      case DailyTaskId.prune:
        return AppColors.sandColor;
      case DailyTaskId.scan:
        return AppColors.navyBlueColor;
      case DailyTaskId.reminders:
        return AppColors.orangeColor;
    }
  }
}

class _CareRow extends StatelessWidget {
  const _CareRow({
    required this.task,
    required this.l10n,
    required this.active,
    required this.loading,
    required this.onTap,
  });

  final TodaysCareTask task;
  final AppLocalizations l10n;
  final bool active;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final plant = task.plantName.isEmpty
        ? l10n.todaysTasksPlantFallback
        : task.plantName.capitalizeFirst ?? task.plantName;
    final overdue = task.eventType?.toLowerCase() == 'missed';
    final accent = _color(task.activityType);

    return Material(
      color: active ? AppColors.lightGreen : AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: loading ? null : onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: active
                  ? AppColors.greenColor.withValues(alpha: 0.5)
                  : AppColors.borderLiteGreyColor,
              width: active ? 1.4 : 1,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(12.r),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Container(
                          width: 34.w,
                          height: 34.w,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            _icon(task.activityType),
                            size: 18.w,
                            color: accent,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BaseText(
                                text: '${_verb(task.activityType)} $plant',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppKeys.poppins,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2.h),
                              BaseText(
                                text: _sub(overdue),
                                fontSize: 10.sp,
                                textColor: overdue
                                    ? AppColors.orangeColor
                                    : AppColors.liteGreyColor,
                              ),
                            ],
                          ),
                        ),
                        loading
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.greenColor,
                                ),
                              )
                            : Icon(
                                Icons.radio_button_unchecked_rounded,
                                size: 22.w,
                                color: AppColors.greenColor,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _sub(bool overdue) {
    if (overdue) return l10n.taskOverdue;
    final time = task.preferredTime?.trim() ?? '';
    if (time.isEmpty) return l10n.taskDueToday;
    try {
      return '${l10n.taskDueToday} · ${convertTo12Hour(time)}';
    } catch (_) {
      return l10n.taskDueToday;
    }
  }

  String _verb(String type) {
    switch (type.toLowerCase()) {
      case 'water':
        return l10n.taskWaterShort;
      case 'fertilize':
        return AppStrings.fertilize;
      case 'prune':
        return AppStrings.prune;
      default:
        return type.capitalizeFirst ?? type;
    }
  }

  IconData _icon(String type) {
    switch (type.toLowerCase()) {
      case 'water':
        return Icons.water_drop_rounded;
      case 'fertilize':
        return Icons.science_outlined;
      case 'prune':
        return Icons.content_cut_rounded;
      default:
        return Icons.spa_rounded;
    }
  }

  Color _color(String type) {
    switch (type.toLowerCase()) {
      case 'water':
        return AppColors.dodgerBlue;
      case 'fertilize':
        return AppColors.violet;
      case 'prune':
        return AppColors.sandColor;
      default:
        return AppColors.greenColor;
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.text,
    required this.action,
    required this.onTap,
  });

  final String text;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.toToLiteGreenColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.greenColor.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 34.w,
              height: 34.w,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.eco_rounded,
                color: AppColors.greenColor,
                size: 18.w,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: BaseText(
                text: text,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                fontFamily: AppKeys.poppins,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.greenColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: BaseText(
                text: action,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                textColor: AppColors.whiteColor,
                fontFamily: AppKeys.poppins,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BonusRow extends StatelessWidget {
  const _BonusRow({required this.controller, required this.l10n});

  final TodaysTasksController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final claimed = controller.bonusClaimed.value;

    return GestureDetector(
      onTap: claimed ? null : controller.claimBonus,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 12.w),
        decoration: BoxDecoration(
          gradient: claimed ? null : AppColors.linearGradientForBtn,
          color: claimed ? AppColors.toToLiteGreenColor : null,
          borderRadius: BorderRadius.circular(12.r),
          border: claimed
              ? Border.all(
                  color: AppColors.greenColor.withValues(alpha: 0.28),
                )
              : null,
          boxShadow: claimed
              ? null
              : [
                  BoxShadow(
                    color: AppColors.greenColor.withValues(alpha: 0.22),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              claimed ? Icons.verified_rounded : Icons.card_giftcard_rounded,
              size: 16.w,
              color: claimed ? AppColors.greenColor : AppColors.whiteColor,
            ),
            SizedBox(width: 8.w),
            BaseText(
              text: claimed
                  ? l10n.todaysTasksBonusClaimed
                  : '${l10n.todaysTasksClaimBonus}  +${TodaysTasksController.bonusXp}',
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppKeys.poppins,
              textColor: claimed ? AppColors.greenColor : AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}
