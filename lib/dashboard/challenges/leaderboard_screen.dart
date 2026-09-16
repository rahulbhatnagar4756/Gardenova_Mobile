import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/common_click_widget.dart';
import 'package:kasagardem/dashboard/challenges/challenges_controller.dart';
import 'package:kasagardem/dashboard/todays_tasks_controller.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class LeaderboardScreen extends GetView<ChallengesController> {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appSystemOverlayStyle,
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        body: SafeArea(
          child: Obx(() {
            if (Get.isRegistered<TodaysTasksController>()) {
              Get.find<TodaysTasksController>().xp.value;
              Get.find<TodaysTasksController>().streak.value;
            }

            final board = controller.fullLeaderboard;
            final youRank = math.max(1, board.indexWhere((e) => e.isYou) + 1);
            final top = board.take(3).toList();
            final rest = board.length > 3
                ? board.skip(3).toList()
                : <LeaderboardEntry>[];
            final youEntry = board.firstWhere(
              (e) => e.isYou,
              orElse: () => LeaderboardEntry(
                name: l10n.challengesYou,
                points: controller.points,
                isYou: true,
              ),
            );

            return Column(
              children: [
                _Header(
                  points: controller.points,
                  streak: controller.streak,
                  l10n: l10n,
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 16.h),
                    children: [
                      _StatsCard(
                        rank: youRank,
                        level: controller.levelName,
                        streak: controller.streak,
                        points: controller.points,
                        progress: controller.levelProgress,
                        nextLevel: controller.nextLevelAt,
                        l10n: l10n,
                      ),
                      SizedBox(height: 18.h),
                      if (top.length >= 3) ...[
                        _Podium(entries: top, l10n: l10n),
                        SizedBox(height: 16.h),
                      ],
                      if (rest.isNotEmpty || top.length < 3)
                        _RankList(
                          entries: rest.isNotEmpty ? rest : board,
                          startRank: rest.isNotEmpty ? 4 : 1,
                          l10n: l10n,
                        ),
                    ],
                  ),
                ),
                if (youRank > 3)
                  _StickyYouBar(rank: youRank, entry: youEntry, l10n: l10n),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.points,
    required this.streak,
    required this.l10n,
  });

  final int points;
  final int streak;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 6.h, 16.w, 6.h),
      child: Row(
        children: [
          CommonClickWidget(
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Image.asset(
                AppAssets.backBtnIc,
                width: 20.w,
                height: 20.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: BaseText(
              text: l10n.challengesLeaderboardTitle,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: AppKeys.poppins,
            ),
          ),
          _StatPill(
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.orangeColor,
            value: '$streak',
          ),
          SizedBox(width: 6.w),
          _StatPill(
            icon: Icons.bolt_rounded,
            iconColor: AppColors.burntGold,
            value: '$points',
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.icon,
    required this.iconColor,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.w, color: iconColor),
          SizedBox(width: 3.w),
          BaseText(
            text: value,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            fontFamily: AppKeys.poppins,
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.rank,
    required this.level,
    required this.streak,
    required this.points,
    required this.progress,
    required this.nextLevel,
    required this.l10n,
  });

  final int rank;
  final String level;
  final int streak;
  final int points;
  final double progress;
  final int nextLevel;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: AppColors.linearGradientForBtn,
        boxShadow: [
          BoxShadow(
            color: AppColors.greenColor.withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: BaseText(
                  text: '#$rank',
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.whiteColor,
                  fontFamily: AppKeys.poppins,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      text: level,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.whiteColor,
                      fontFamily: AppKeys.poppins,
                    ),
                    SizedBox(height: 2.h),
                    BaseText(
                      text:
                          '${l10n.challengesRank} · $points ${l10n.challengesPoints}',
                      fontSize: 12.sp,
                      textColor: AppColors.whiteColor.withValues(alpha: 0.85),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_fire_department_rounded,
                      size: 14.w,
                      color: AppColors.organicColor,
                    ),
                    SizedBox(width: 3.w),
                    BaseText(
                      text: '$streak',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.whiteColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6.h,
              backgroundColor: AppColors.whiteColor.withValues(alpha: 0.22),
              color: AppColors.organicColor,
            ),
          ),
          SizedBox(height: 6.h),
          BaseText(
            text: '${l10n.challengesNextLevel} · $nextLevel XP',
            fontSize: 11.sp,
            textColor: AppColors.whiteColor.withValues(alpha: 0.85),
          ),
        ],
      ),
    );
  }
}

class _Podium extends StatelessWidget {
  const _Podium({required this.entries, required this.l10n});

  final List<LeaderboardEntry> entries;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _PodiumSeat(
            rank: 2,
            entry: entries[1],
            height: 78.h,
            color: AppColors.liteGreenColor,
            l10n: l10n,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _PodiumSeat(
            rank: 1,
            entry: entries[0],
            height: 104.h,
            color: AppColors.greenColor,
            l10n: l10n,
            isFirst: true,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _PodiumSeat(
            rank: 3,
            entry: entries[2],
            height: 64.h,
            color: AppColors.clayColor,
            l10n: l10n,
          ),
        ),
      ],
    );
  }
}

class _PodiumSeat extends StatelessWidget {
  const _PodiumSeat({
    required this.rank,
    required this.entry,
    required this.height,
    required this.color,
    required this.l10n,
    this.isFirst = false,
  });

  final int rank;
  final LeaderboardEntry entry;
  final double height;
  final Color color;
  final AppLocalizations l10n;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    final ringColor = isFirst
        ? AppColors.burntGold
        : rank == 2
        ? AppColors.mediumGrey
        : AppColors.orangeColor;

    return Column(
      children: [
        if (isFirst)
          Icon(
            Icons.workspace_premium_rounded,
            color: AppColors.burntGold,
            size: 22.w,
          ),
        Container(
          width: isFirst ? 52.w : 44.w,
          height: isFirst ? 52.w : 44.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.lightGreen,
            shape: BoxShape.circle,
            border: Border.all(color: ringColor, width: 2.5),
          ),
          child: BaseText(
            text: entry.name.trim().isEmpty
                ? '?'
                : entry.name.trim().characters.first.toUpperCase(),
            fontSize: isFirst ? 18.sp : 15.sp,
            fontWeight: FontWeight.w700,
            textColor: AppColors.darkGreenColor,
            fontFamily: AppKeys.poppins,
          ),
        ),
        SizedBox(height: 6.h),
        BaseText(
          text: entry.isYou ? l10n.challengesYou : entry.name,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          fontFamily: AppKeys.poppins,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        BaseText(
          text: '${entry.points} XP',
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          textColor: AppColors.greenColor,
        ),
        SizedBox(height: 8.h),
        Container(
          height: height,
          width: double.infinity,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.only(top: 10.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
          ),
          child: BaseText(
            text: '$rank',
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            textColor: AppColors.whiteColor,
            fontFamily: AppKeys.poppins,
          ),
        ),
      ],
    );
  }
}

class _RankList extends StatelessWidget {
  const _RankList({
    required this.entries,
    required this.startRank,
    required this.l10n,
  });

  final List<LeaderboardEntry> entries;
  final int startRank;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 3,
      shadowColor: Colors.black.withValues(alpha: 0.5),
      color: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.r),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < entries.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 16.w,
                endIndent: 16.w,
                color: AppColors.backgroundGrey,
              ),
            _RankTile(rank: startRank + i, entry: entries[i], l10n: l10n),
          ],
        ],
      ),
    );
  }
}

class _RankTile extends StatelessWidget {
  const _RankTile({
    required this.rank,
    required this.entry,
    required this.l10n,
  });

  final int rank;
  final LeaderboardEntry entry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: entry.isYou ? AppColors.lightGreen.withValues(alpha: 0.65) : null,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          SizedBox(
            width: 28.w,
            child: BaseText(
              text: '$rank',
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              textColor: entry.isYou
                  ? AppColors.greenColor
                  : AppColors.liteGreyColor,
              fontFamily: AppKeys.poppins,
            ),
          ),
          Container(
            width: 38.w,
            height: 38.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              shape: BoxShape.circle,
            ),
            child: BaseText(
              text: entry.name.trim().isEmpty
                  ? '?'
                  : entry.name.trim().characters.first.toUpperCase(),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              textColor: AppColors.greenColor,
              fontFamily: AppKeys.poppins,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: BaseText(
              text: entry.isYou
                  ? '${entry.name} · ${l10n.challengesYou}'
                  : entry.name,
              fontSize: 13.sp,
              fontWeight: entry.isYou ? FontWeight.w600 : FontWeight.w500,
              fontFamily: AppKeys.poppins,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          BaseText(
            text: '${entry.points} XP',
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            textColor: AppColors.greenColor,
            fontFamily: AppKeys.poppins,
          ),
        ],
      ),
    );
  }
}

class _StickyYouBar extends StatelessWidget {
  const _StickyYouBar({
    required this.rank,
    required this.entry,
    required this.l10n,
  });

  final int rank;
  final LeaderboardEntry entry;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        gradient: AppColors.linearGreenGradientForBtn,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenColor.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 34.w,
            height: 34.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.whiteColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: BaseText(
              text: '#$rank',
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              textColor: AppColors.whiteColor,
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: BaseText(
              text: '${l10n.challengesYou} · ${l10n.challengesRank}',
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              textColor: AppColors.whiteColor,
              fontFamily: AppKeys.poppins,
            ),
          ),
          BaseText(
            text: '${entry.points} XP',
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            textColor: AppColors.whiteColor,
          ),
        ],
      ),
    );
  }
}
