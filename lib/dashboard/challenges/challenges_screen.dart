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
import 'package:kasagardem/utils/routes.dart';

class ChallengesScreen extends GetView<ChallengesController> {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appSystemOverlayStyle,
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        body: SafeArea(
          child: Obx(() {
            controller.selectedPeriod.value;
            controller.claimedIds.length;
            controller.redeemedIds.length;
            controller.points;
            controller.streak;
            controller.weeklyCare.value;
            controller.weeklyDiagnosis.value;
            controller.weeklyPlants.value;
            controller.monthlyDiagnosis.value;
            controller.monthlyLandscape.value;
            if (Get.isRegistered<TodaysTasksController>()) {
              Get.find<TodaysTasksController>().liveTasks.length;
              Get.find<TodaysTasksController>().xp.value;
              Get.find<TodaysTasksController>().streak.value;
            }

            final period = controller.selectedPeriod.value;
            final challenges = controller.challengesFor(period, l10n);
            final rewards = controller.rewards(l10n);
            final claimedCount =
                challenges.where((c) => controller.isClaimed(c.id)).length;
            final periodTitle = switch (period) {
              ChallengePeriod.daily => l10n.challengesDaily,
              ChallengePeriod.weekly => l10n.challengesWeekly,
              ChallengePeriod.monthly => l10n.challengesMonthly,
            };

            return Column(
              children: [
                _Header(
                  points: controller.points,
                  streak: controller.streak,
                  l10n: l10n,
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 28.h),
                    children: [
                      _HeroCard(controller: controller, l10n: l10n),
                      SizedBox(height: 18.h),
                      _PeriodTabs(controller: controller, l10n: l10n),
                      SizedBox(height: 14.h),
                      _SectionLabel(
                        title: periodTitle,
                        trailing: '$claimedCount/${challenges.length}',
                      ),
                      SizedBox(height: 10.h),
                      for (var i = 0; i < challenges.length; i++) ...[
                        if (i > 0) SizedBox(height: 10.h),
                        _ChallengeCard(
                          challenge: challenges[i],
                          claimed: controller.isClaimed(challenges[i].id),
                          l10n: l10n,
                          onStart: () =>
                              _onStart(context, challenges[i], l10n),
                        ),
                      ],
                      SizedBox(height: 22.h),
                      _SectionLabel(title: l10n.challengesHowToEarn),
                      SizedBox(height: 10.h),
                      _EarnGuide(items: controller.earningGuide(l10n)),
                      SizedBox(height: 22.h),
                      _SectionLabel(title: l10n.challengesRewardsTitle),
                      SizedBox(height: 10.h),
                      for (var i = 0; i < rewards.length; i++) ...[
                        if (i > 0) SizedBox(height: 10.h),
                        _RewardCard(
                          reward: rewards[i],
                          unlocked: controller.isRedeemed(rewards[i].id),
                          canAfford: controller.points >= rewards[i].cost,
                          points: controller.points,
                          l10n: l10n,
                          onRedeem: () => controller.redeem(rewards[i]),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Future<void> _onStart(
    BuildContext context,
    GardenChallenge challenge,
    AppLocalizations l10n,
  ) async {
    await controller.startChallenge(
      challenge,
      onQuiz: () => _showQuizSheet(challenge, l10n),
      onDiagnosis: () => Get.back(result: 'diagnosis'),
      onLandscape: () => Get.back(result: 'landscape'),
    );
  }

  void _showQuizSheet(GardenChallenge challenge, AppLocalizations l10n) {
    final answerCtrl = TextEditingController();
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.borderGreyColor,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: 52.w,
                height: 52.w,
                decoration: BoxDecoration(
                  color: challenge.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: challenge.color.withValues(alpha: 0.25),
                  ),
                ),
                child: Icon(challenge.icon, color: challenge.color, size: 26.w),
              ),
              SizedBox(height: 12.h),
              BaseText(
                text: challenge.title,
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                fontFamily: AppKeys.poppins,
              ),
              SizedBox(height: 4.h),
              BaseText(
                text: challenge.why,
                fontSize: 12.sp,
                textColor: AppColors.liteGreyColor,
              ),
              SizedBox(height: 14.h),
              TextField(
                controller: answerCtrl,
                autofocus: true,
                style: TextStyle(fontFamily: AppKeys.poppins, fontSize: 14.sp),
                decoration: InputDecoration(
                  hintText: 'Scientific name',
                  hintStyle: TextStyle(
                    color: AppColors.liteGreyColor,
                    fontSize: 13.sp,
                  ),
                  filled: true,
                  fillColor: AppColors.toToLiteGreenColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.linearGradientForBtn,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.greenColor.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: AppColors.whiteColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      controller.completeQuiz(challenge, answerCtrl.text);
                    },
                    child: BaseText(
                      text: l10n.challengesStart,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.whiteColor,
                      fontFamily: AppKeys.poppins,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
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
              text: l10n.challengesHubTitle,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: AppKeys.poppins,
            ),
          ),
          CommonClickWidget(
            onTap: () => Get.toNamed(Routes.leaderboard),
            child: Container(
              width: 34.w,
              height: 34.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.burntGold.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.burntGold.withValues(alpha: 0.28),
                ),
              ),
              child: Icon(
                Icons.emoji_events_rounded,
                size: 16.w,
                color: AppColors.burntGold,
              ),
            ),
          ),
          SizedBox(width: 6.w),
          _StatPill(
            icon: Icons.local_fire_department_rounded,
            iconColor: AppColors.orangeColor,
            tint: AppColors.orangeColor.withValues(alpha: 0.12),
            value: '$streak',
          ),
          SizedBox(width: 6.w),
          _StatPill(
            icon: Icons.bolt_rounded,
            iconColor: AppColors.burntGold,
            tint: AppColors.burntGold.withValues(alpha: 0.14),
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
    required this.tint,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final Color tint;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: iconColor.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.w, color: iconColor),
          SizedBox(width: 3.w),
          BaseText(
            text: value,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppKeys.poppins,
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.controller, required this.l10n});

  final ChallengesController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return CommonClickWidget(
      onTap: () => Get.toNamed(Routes.leaderboard),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: AppColors.linearGradientForBtn,
          boxShadow: [
            BoxShadow(
              color: AppColors.greenColor.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -18.w,
              top: -22.h,
              child: Container(
                width: 110.w,
                height: 110.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.organicColor.withValues(alpha: 0.16),
                ),
              ),
            ),
            Positioned(
              right: 28.w,
              bottom: -30.h,
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.whiteColor.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              left: -12.w,
              bottom: 18.h,
              child: Icon(
                Icons.eco_rounded,
                size: 54.w,
                color: AppColors.whiteColor.withValues(alpha: 0.08),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54.w,
                        height: 54.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor.withValues(alpha: 0.16),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.organicColor.withValues(
                              alpha: 0.65,
                            ),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.spa_rounded,
                          color: AppColors.organicColor,
                          size: 26.w,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BaseText(
                              text: controller.levelName,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              textColor: AppColors.whiteColor,
                              fontFamily: AppKeys.poppins,
                            ),
                            SizedBox(height: 3.h),
                            BaseText(
                              text: l10n.challengesHubSubtitle,
                              fontSize: 11.sp,
                              textColor: AppColors.whiteColor.withValues(
                                alpha: 0.82,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.whiteColor.withValues(alpha: 0.75),
                        size: 24.w,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(
                        begin: 0,
                        end: controller.levelProgress.clamp(0.0, 1.0),
                      ),
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      builder: (context, value, _) {
                        return LinearProgressIndicator(
                          value: value,
                          minHeight: 8.h,
                          backgroundColor: AppColors.whiteColor.withValues(
                            alpha: 0.22,
                          ),
                          color: AppColors.organicColor,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: BaseText(
                          text:
                              '${l10n.challengesNextLevel} · ${controller.nextLevelAt} XP',
                          fontSize: 11.sp,
                          textColor: AppColors.whiteColor.withValues(
                            alpha: 0.85,
                          ),
                        ),
                      ),
                      BaseText(
                        text: '${controller.points} XP',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.organicColor,
                        fontFamily: AppKeys.poppins,
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: _HeroStat(
                          icon: Icons.local_fire_department_rounded,
                          label: l10n.todaysTasksStreak,
                          value: '${controller.streak}',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _HeroStat(
                          icon: Icons.emoji_events_outlined,
                          label: l10n.challengesRank,
                          value: '#${controller.rank}',
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _HeroStat(
                          icon: Icons.flag_rounded,
                          label: l10n.challengesPoints,
                          value: '${controller.points}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.whiteColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15.w, color: AppColors.organicColor),
          SizedBox(height: 6.h),
          BaseText(
            text: value,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            textColor: AppColors.whiteColor,
            fontFamily: AppKeys.poppins,
          ),
          BaseText(
            text: label,
            fontSize: 10.sp,
            textColor: AppColors.whiteColor.withValues(alpha: 0.75),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs({required this.controller, required this.l10n});

  final ChallengesController controller;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final items = [
      (ChallengePeriod.daily, l10n.challengesDaily, Icons.today_rounded),
      (
        ChallengePeriod.weekly,
        l10n.challengesWeekly,
        Icons.date_range_rounded,
      ),
      (
        ChallengePeriod.monthly,
        l10n.challengesMonthly,
        Icons.calendar_month_rounded,
      ),
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.toToLiteGreenColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.greenColor.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          for (final item in items)
            Expanded(
              child: GestureDetector(
                onTap: () => controller.selectedPeriod.value = item.$1,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: controller.selectedPeriod.value == item.$1
                        ? AppColors.greenColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(11.r),
                    boxShadow: controller.selectedPeriod.value == item.$1
                        ? [
                            BoxShadow(
                              color: AppColors.greenColor.withValues(
                                alpha: 0.28,
                              ),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        item.$3,
                        size: 15.w,
                        color: controller.selectedPeriod.value == item.$1
                            ? AppColors.whiteColor
                            : AppColors.liteGreyColor,
                      ),
                      SizedBox(height: 3.h),
                      BaseText(
                        text: item.$2,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        textColor: controller.selectedPeriod.value == item.$1
                            ? AppColors.whiteColor
                            : AppColors.liteGreyColor,
                        fontFamily: AppKeys.poppins,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 14.h,
          decoration: BoxDecoration(
            color: AppColors.greenColor,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: BaseText(
            text: title,
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            fontFamily: AppKeys.poppins,
          ),
        ),
        if (trailing != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.greenColor.withValues(alpha: 0.2),
              ),
            ),
            child: BaseText(
              text: trailing!,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              textColor: AppColors.greenColor,
              fontFamily: AppKeys.poppins,
            ),
          ),
      ],
    );
  }
}

class _ChallengeCard extends StatelessWidget {
  const _ChallengeCard({
    required this.challenge,
    required this.claimed,
    required this.l10n,
    required this.onStart,
  });

  final GardenChallenge challenge;
  final bool claimed;
  final AppLocalizations l10n;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final progress = (challenge.progress / challenge.goal).clamp(0.0, 1.0);
    final showProgress = challenge.goal > 1;

    return Material(
      color: claimed ? AppColors.toToLiteGreenColor : AppColors.whiteColor,
      elevation: claimed ? 0 : 1.5,
      shadowColor: AppColors.darkGreenColor.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: claimed ? null : onStart,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: claimed
                  ? AppColors.greenColor.withValues(alpha: 0.28)
                  : AppColors.borderLiteGreyColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: challenge.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: challenge.color.withValues(alpha: 0.22),
                      ),
                    ),
                    child: Icon(
                      claimed ? Icons.check_rounded : challenge.icon,
                      color: challenge.color,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BaseText(
                          text: challenge.title,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          fontFamily: AppKeys.poppins,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        BaseText(
                          text: challenge.why,
                          fontSize: 11.sp,
                          textColor: AppColors.liteGreyColor,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: claimed
                          ? AppColors.greenColor
                          : AppColors.lightGreen,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: BaseText(
                      text: claimed
                          ? l10n.challengesClaimed
                          : '+${challenge.xp}',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      textColor: claimed
                          ? AppColors.whiteColor
                          : AppColors.greenColor,
                      fontFamily: AppKeys.poppins,
                    ),
                  ),
                ],
              ),
              if (showProgress) ...[
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6.h,
                          backgroundColor: AppColors.toToLiteGreenColor,
                          color: challenge.color,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    BaseText(
                      text: '${challenge.progress}/${challenge.goal}',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      textColor: AppColors.liteGreyColor,
                      fontFamily: AppKeys.poppins,
                    ),
                  ],
                ),
              ],
              if (!claimed) ...[
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      gradient: AppColors.linearGradientForBtn,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.greenColor.withValues(alpha: 0.22),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BaseText(
                          text: l10n.challengesStart,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          textColor: AppColors.whiteColor,
                          fontFamily: AppKeys.poppins,
                        ),
                        SizedBox(width: 2.w),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14.w,
                          color: AppColors.whiteColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EarnGuide extends StatelessWidget {
  const _EarnGuide({required this.items});

  final List<({String label, int points, IconData icon})> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 122.w,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: AppColors.greenColor.withValues(alpha: 0.14),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkGreenColor.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: Icon(
                    item.icon,
                    size: 16.w,
                    color: AppColors.greenColor,
                  ),
                ),
                const Spacer(),
                BaseText(
                  text: item.label,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  fontFamily: AppKeys.poppins,
                ),
                SizedBox(height: 2.h),
                BaseText(
                  text: '+${item.points}',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.greenColor,
                  fontFamily: AppKeys.poppins,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({
    required this.reward,
    required this.unlocked,
    required this.canAfford,
    required this.points,
    required this.l10n,
    required this.onRedeem,
  });

  final GardenReward reward;
  final bool unlocked;
  final bool canAfford;
  final int points;
  final AppLocalizations l10n;
  final VoidCallback onRedeem;

  @override
  Widget build(BuildContext context) {
    final progress = (points / reward.cost).clamp(0.0, 1.0);

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: unlocked ? AppColors.toToLiteGreenColor : AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: unlocked
              ? AppColors.greenColor.withValues(alpha: 0.28)
              : canAfford
                  ? AppColors.greenColor.withValues(alpha: 0.35)
                  : AppColors.borderLiteGreyColor,
        ),
        boxShadow: unlocked
            ? null
            : [
                BoxShadow(
                  color: AppColors.darkGreenColor.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: unlocked
                      ? AppColors.greenColor.withValues(alpha: 0.15)
                      : AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(13.r),
                  border: Border.all(
                    color: AppColors.greenColor.withValues(alpha: 0.18),
                  ),
                ),
                child: Icon(
                  unlocked ? Icons.lock_open_rounded : reward.icon,
                  color: AppColors.greenColor,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      text: reward.title,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontFamily: AppKeys.poppins,
                    ),
                    SizedBox(height: 2.h),
                    BaseText(
                      text: '${reward.cost} XP',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.burntGold,
                      fontFamily: AppKeys.poppins,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: unlocked ? null : onRedeem,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    gradient: !unlocked && canAfford
                        ? AppColors.linearGradientForBtn
                        : null,
                    color: unlocked
                        ? AppColors.lightGreen
                        : canAfford
                            ? null
                            : AppColors.borderLiteGreyColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: BaseText(
                    text: unlocked
                        ? l10n.challengesRedeemed
                        : l10n.challengesRedeem,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    textColor: unlocked
                        ? AppColors.greenColor
                        : canAfford
                            ? AppColors.whiteColor
                            : AppColors.liteGreyColor,
                    fontFamily: AppKeys.poppins,
                  ),
                ),
              ),
            ],
          ),
          if (!unlocked) ...[
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5.h,
                backgroundColor: AppColors.toToLiteGreenColor,
                color: canAfford ? AppColors.greenColor : AppColors.clayColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
