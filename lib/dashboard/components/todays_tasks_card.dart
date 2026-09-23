import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/model/daily_challenges_model.dart';
import 'package:kasagardem/dashboard/todays_tasks_controller.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

/// Garden-styled daily care / habit card for the dashboard.
class TodaysTasksCard extends GetView<TodaysTasksController> {
  const TodaysTasksCard({super.key, required this.onScanTap, required this.onRemindersTap});

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
          side: BorderSide(color: AppColors.greenColor.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(controller: controller, l10n: l10n, allDone: allDone),
            Padding(
              padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 12.h),
              child: _buildBody(l10n, allDone),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBody(AppLocalizations l10n, bool allDone) {
    if (controller.isLoadingChallenges.value && controller.challenges.isEmpty) {
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

    final items = <Widget>[];

    // Display tasks coming from daily challenges API only
    for (var i = 0; i < controller.challenges.length; i++) {
      final challenge = controller.challenges[i];
      items.add(_ChallengeRow(challenge: challenge, onTap: () => _onChallenge(challenge)));
    }

    if (items.isEmpty) {
      if (allDone) return const SizedBox.shrink();

      return _InfoRow(
        text: l10n.noCareDueToday,
        action: l10n.todaysTasksViewAll,
        onTap: onRemindersTap,
      );
    }

    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[if (i > 0) SizedBox(height: 8.h), items[i]],
      ],
    );
  }

  void _onChallenge(DailyChallenge challenge) {
    if (challenge.isCompleted) return;
    controller.completeChallengeApi(challenge);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller, required this.l10n, required this.allDone});

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
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.35), width: 1.5),
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
                  text: allDone ? l10n.todaysTasksAllDoneTitle : l10n.todaysTasks,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  fontFamily: AppKeys.poppins,
                ),
                if (allDone) ...[
                  SizedBox(height: 2.h),
                  BaseText(
                    text: l10n.todaysTasksAllDoneSubtitle,
                    fontSize: 10.sp,
                    textColor: AppColors.liteGreyColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          // _StatChip(
          //   icon: Icons.local_fire_department_rounded,
          //   color: AppColors.orangeColor,
          //   tint: AppColors.orangeColor.withValues(alpha: 0.12),
          //   value: '${controller.streak.value}',
          // ),
          // SizedBox(width: 6.w),
          // _StatChip(
          //   icon: Icons.bolt_rounded,
          //   color: AppColors.burntGold,
          //   tint: AppColors.burntGold.withValues(alpha: 0.14),
          //   value: '${controller.xp.value}',
          // ),
        ],
      ),
    );
  }
}

class _ChallengeRow extends StatelessWidget {
  const _ChallengeRow({required this.challenge, required this.onTap});

  final DailyChallenge challenge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final done = challenge.isCompleted;
    final accent = _color(challenge.code ?? '');
    final isActionable =
        !done &&
        (challenge.code == 'PLANT_SCAN' ||
            challenge.code == 'DIAGNOSIS' ||
            challenge.code == 'TODAYS_CARE' ||
            challenge.code == 'REMINDERS');

    final pts = challenge.points;
    final pointsLabel = (pts != null && pts > 0) ? '+$pts ${pts == 1 ? 'pt' : 'pts'}' : '';

    return Material(
      color: done ? AppColors.toToLiteGreenColor.withValues(alpha: 0.65) : AppColors.whiteColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: done ? null : onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: done
                  ? AppColors.greenColor.withValues(alpha: 0.2)
                  : AppColors.borderLiteGreyColor,
              width: 1,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Container(
                  width: 4.w,
                  decoration: BoxDecoration(
                    color: done ? AppColors.greenColor : accent,
                    borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Container(
                          width: 34.w,
                          height: 34.w,
                          decoration: BoxDecoration(
                            color: done
                                ? AppColors.greenColor.withValues(alpha: 0.14)
                                : accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            done ? Icons.check_rounded : _icon(challenge.code ?? ''),
                            size: 18.w,
                            color: done ? AppColors.greenColor : accent,
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BaseText(
                                text: challenge.title ?? '',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: AppKeys.poppins,
                                textColor: done ? AppColors.liteGreyColor : AppColors.blackColor,
                              ),
                              if (challenge.description != null &&
                                  challenge.description!.isNotEmpty) ...[
                                SizedBox(height: 2.h),
                                BaseText(
                                  text: challenge.description!,
                                  fontSize: 8.sp,
                                  textColor: AppColors.liteGreyColor,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        if (done)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: AppColors.greenColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 14.w,
                                  color: AppColors.greenColor,
                                ),
                                SizedBox(width: 4.w),
                                BaseText(
                                  text: pointsLabel.isNotEmpty ? pointsLabel : 'Completed',
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  textColor: AppColors.greenColor,
                                  fontFamily: AppKeys.poppins,
                                ),
                              ],
                            ),
                          )
                        else ...[
                          if (pointsLabel.isNotEmpty) ...[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: AppColors.burntGold.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: AppColors.burntGold.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.bolt_rounded, size: 12.w, color: AppColors.burntGold),
                                  SizedBox(width: 2.w),
                                  BaseText(
                                    text: pointsLabel,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w700,
                                    textColor: AppColors.burntGold,
                                    fontFamily: AppKeys.poppins,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 6.w),
                          ],
                          Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppColors.greenColor.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              size: 18.w,
                              color: isActionable ? AppColors.greenColor : AppColors.liteGreyColor,
                            ),
                          ),
                        ],
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

  IconData _icon(String code) {
    switch (code.toUpperCase()) {
      case 'WATER':
        return Icons.water_drop_rounded;
      case 'INSPECT':
        return Icons.spa_rounded;
      case 'FERTILIZE':
        return Icons.science_outlined;
      case 'PRUNE':
        return Icons.content_cut_rounded;
      case 'PLANT_SCAN':
      case 'DIAGNOSIS':
        return Icons.document_scanner_outlined;
      case 'TODAYS_CARE':
      case 'REMINDERS':
        return Icons.notifications_active_outlined;
      default:
        return Icons.eco_rounded;
    }
  }

  Color _color(String code) {
    switch (code.toUpperCase()) {
      case 'WATER':
        return AppColors.dodgerBlue;
      case 'INSPECT':
        return AppColors.greenColor;
      case 'FERTILIZE':
        return AppColors.violet;
      case 'PRUNE':
        return AppColors.sandColor;
      case 'PLANT_SCAN':
      case 'DIAGNOSIS':
        return AppColors.navyBlueColor;
      case 'TODAYS_CARE':
      case 'REMINDERS':
        return AppColors.orangeColor;
      default:
        return AppColors.greenColor;
    }
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.text, required this.action, required this.onTap});

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
          border: Border.all(color: AppColors.greenColor.withValues(alpha: 0.18)),
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
              child: Icon(Icons.eco_rounded, color: AppColors.greenColor, size: 18.w),
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
