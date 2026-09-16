import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kasagardem/dashboard/todays_tasks_controller.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/reward_celebration.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

enum ChallengePeriod { daily, weekly, monthly }

enum ChallengeAction {
  care,
  catchUp,
  quiz,
  addPlant,
  diagnosis,
  landscape,
  streak,
}

class GardenChallenge {
  const GardenChallenge({
    required this.id,
    required this.title,
    required this.why,
    required this.xp,
    required this.period,
    required this.action,
    required this.icon,
    required this.color,
    this.progress = 0,
    this.goal = 1,
    this.careTask,
    this.quizAnswer,
  });

  final String id;
  final String title;
  final String why;
  final int xp;
  final ChallengePeriod period;
  final ChallengeAction action;
  final IconData icon;
  final Color color;
  final int progress;
  final int goal;
  final TodaysCareTask? careTask;
  final String? quizAnswer;

  bool get isComplete => progress >= goal;
}

class GardenReward {
  const GardenReward({
    required this.id,
    required this.title,
    required this.cost,
    required this.icon,
    this.mystery = false,
  });

  final String id;
  final String title;
  final int cost;
  final IconData icon;
  final bool mystery;
}

class LeaderboardEntry {
  const LeaderboardEntry({
    required this.name,
    required this.points,
    required this.isYou,
  });

  final String name;
  final int points;
  final bool isYou;
}

class ChallengesController extends GetxController {
  final selectedPeriod = ChallengePeriod.daily.obs;
  final claimedIds = <String>{}.obs;
  final redeemedIds = <String>{}.obs;
  final weeklyCare = 0.obs;
  final weeklyDiagnosis = 0.obs;
  final weeklyPlants = 0.obs;
  final monthlyDiagnosis = 0.obs;
  final monthlyLandscape = 0.obs;

  Worker? _completedWorker;
  Set<String> _seenCompleted = {};

  TodaysTasksController? get _tasks => Get.isRegistered<TodaysTasksController>()
      ? Get.find<TodaysTasksController>()
      : null;

  int get points => _tasks?.xp.value ?? 0;
  int get streak => _tasks?.streak.value ?? 0;

  String get levelName {
    final l10n = AppLocalizations.of(Get.context!)!;
    return _tasks?.gardenLevel(l10n) ?? l10n.gardenLevelSprout;
  }

  int get levelFloor {
    if (points >= 600) return 600;
    if (points >= 300) return 300;
    if (points >= 100) return 100;
    return 0;
  }

  int get nextLevelAt {
    if (points >= 600) return 600;
    if (points >= 300) return 600;
    if (points >= 100) return 300;
    return 100;
  }

  double get levelProgress {
    final span = nextLevelAt - levelFloor;
    if (span <= 0) return 1;
    return ((points - levelFloor) / span).clamp(0, 1);
  }

  int get rank {
    final board = fullLeaderboard;
    return board.indexWhere((e) => e.isYou) + 1;
  }

  @override
  void onInit() {
    super.onInit();
    _load();
    _seenCompleted = {...(_tasks?.completedIds ?? <String>{})};
    if (_tasks != null) {
      _completedWorker = ever(_tasks!.completedIds, (Set<String> ids) {
        final added = ids.difference(_seenCompleted);
        _seenCompleted = {...ids};
        for (final id in added) {
          if (id.startsWith('r_')) {
            weeklyCare.value += 1;
          } else if (id == DailyTaskId.scan.name) {
            weeklyDiagnosis.value += 1;
            monthlyDiagnosis.value += 1;
          }
        }
        _save();
      });
    }
  }

  @override
  void onClose() {
    _completedWorker?.dispose();
    super.onClose();
  }

  List<GardenChallenge> challengesFor(
    ChallengePeriod period,
    AppLocalizations l10n,
  ) {
    switch (period) {
      case ChallengePeriod.daily:
        return _daily(l10n);
      case ChallengePeriod.weekly:
        return _weekly(l10n);
      case ChallengePeriod.monthly:
        return _monthly(l10n);
    }
  }

  List<GardenReward> rewards(AppLocalizations l10n) => [
    GardenReward(
      id: 'chat',
      title: l10n.rewardChatCredits,
      cost: 250,
      icon: Icons.chat_bubble_outline,
    ),
    GardenReward(
      id: 'diagnosis',
      title: l10n.rewardExtraDiagnosis,
      cost: 500,
      icon: Icons.document_scanner_outlined,
    ),
    GardenReward(
      id: 'landscape',
      title: l10n.rewardExtraLandscape,
      cost: 1000,
      icon: Icons.yard_outlined,
    ),
    GardenReward(
      id: 'insights',
      title: l10n.rewardPlantInsights,
      cost: 750,
      icon: Icons.insights_outlined,
    ),
    GardenReward(
      id: 'exclusive',
      title: l10n.rewardExclusiveChallenge,
      cost: 500,
      icon: Icons.emoji_events_outlined,
    ),
    GardenReward(
      id: 'scan',
      title: l10n.rewardExtraScan,
      cost: 500,
      icon: Icons.qr_code_scanner,
    ),
    GardenReward(
      id: 'mystery',
      title: l10n.rewardMystery,
      cost: 1000,
      icon: Icons.card_giftcard_rounded,
      mystery: true,
    ),
    GardenReward(
      id: 'premium',
      title: l10n.rewardPremiumTrial,
      cost: 2000,
      icon: Icons.workspace_premium_outlined,
    ),
  ];

  List<({String label, int points, IconData icon})> earningGuide(
    AppLocalizations l10n,
  ) => [
    (label: l10n.earnAddPlant, points: 100, icon: Icons.local_florist_outlined),
    (
      label: l10n.earnDiagnosis,
      points: 200,
      icon: Icons.document_scanner_outlined,
    ),
    (label: l10n.earnLandscape, points: 300, icon: Icons.yard_outlined),
    (label: l10n.earnPlantCare, points: 50, icon: Icons.water_drop_outlined),
    (label: l10n.earnDailyChallenge, points: 50, icon: Icons.flag_outlined),
    (
      label: l10n.earnCareStreak,
      points: 100,
      icon: Icons.local_fire_department_outlined,
    ),
    (
      label: l10n.earnAchievement,
      points: 250,
      icon: Icons.military_tech_outlined,
    ),
    (label: l10n.earn30Day, points: 1000, icon: Icons.calendar_month_outlined),
  ];

  List<LeaderboardEntry> get leaderboard => fullLeaderboard.take(5).toList();

  List<LeaderboardEntry> get fullLeaderboard {
    final youName = (SharedPrefsService.instance.getString(AppKeys.name) ?? '')
        .trim();
    final you = LeaderboardEntry(
      name: youName.isEmpty ? 'You' : youName,
      points: points,
      isYou: true,
    );
    final others = [
      const LeaderboardEntry(name: 'Maya', points: 2840, isYou: false),
      const LeaderboardEntry(name: 'Liam', points: 1960, isYou: false),
      const LeaderboardEntry(name: 'Sofia', points: 1420, isYou: false),
      const LeaderboardEntry(name: 'Noah', points: 870, isYou: false),
      const LeaderboardEntry(name: 'Ava', points: 540, isYou: false),
      const LeaderboardEntry(name: 'Kai', points: 410, isYou: false),
      const LeaderboardEntry(name: 'Elena', points: 320, isYou: false),
      const LeaderboardEntry(name: 'Omar', points: 210, isYou: false),
    ];
    final board = [...others, you]
      ..sort((a, b) => b.points.compareTo(a.points));
    return board;
  }

  bool isClaimed(String id) => claimedIds.contains(id);
  bool isRedeemed(String id) => redeemedIds.contains(id);

  Future<void> startChallenge(
    GardenChallenge challenge, {
    required VoidCallback onQuiz,
    VoidCallback? onDiagnosis,
    VoidCallback? onLandscape,
  }) async {
    if (isClaimed(challenge.id)) return;

    switch (challenge.action) {
      case ChallengeAction.care:
        final task = challenge.careTask;
        if (task != null && _tasks != null) {
          await _tasks!.completeCareTask(task);
          if (_tasks!.isCareTaskCompleted(task) ||
              !_tasks!.liveTasks.any((t) => t.id == task.id)) {
            _claim(challenge);
          }
        } else {
          Get.toNamed(Routes.plantRemindersListing);
        }
        break;
      case ChallengeAction.catchUp:
        Get.toNamed(Routes.plantRemindersListing);
        break;
      case ChallengeAction.quiz:
        onQuiz();
        break;
      case ChallengeAction.addPlant:
        Get.toNamed(Routes.allPlantsScreen);
        break;
      case ChallengeAction.diagnosis:
        onDiagnosis?.call();
        break;
      case ChallengeAction.landscape:
        onLandscape?.call();
        break;
      case ChallengeAction.streak:
        if (streak >= challenge.goal) {
          _claim(challenge);
        } else {
          Get.toNamed(Routes.plantRemindersListing);
        }
        break;
    }
  }

  void completeQuiz(GardenChallenge challenge, String answer) {
    if (isClaimed(challenge.id)) return;
    final expected = (challenge.quizAnswer ?? '').toLowerCase().trim();
    final l10n = AppLocalizations.of(Get.context!)!;
    if (answer.toLowerCase().trim() == expected && expected.isNotEmpty) {
      _claim(challenge, quizCorrectMessage: l10n.challengesQuizCorrect);
    } else {
      BaseSnackBar.show(title: appName, message: l10n.challengesQuizWrong);
    }
  }

  void redeem(GardenReward reward) {
    final l10n = AppLocalizations.of(Get.context!)!;
    if (isRedeemed(reward.id)) return;
    if (points < reward.cost) {
      BaseSnackBar.show(
        title: appName,
        message: l10n.challengesNotEnoughPoints,
      );
      return;
    }

    HapticFeedback.mediumImpact();
    if (!(_tasks?.spendXp(reward.cost) ?? false)) {
      BaseSnackBar.show(
        title: appName,
        message: l10n.challengesNotEnoughPoints,
      );
      return;
    }
    redeemedIds.add(reward.id);
    _save();

    RewardCelebration.showPopup(
      title: reward.title,
      subtitle: reward.mystery
          ? l10n.challengesMysteryOpened
          : l10n.challengesRedeemSuccess,
      icon: reward.icon,
    );
  }

  void _claim(GardenChallenge challenge, {String? quizCorrectMessage}) {
    if (claimedIds.contains(challenge.id)) return;
    HapticFeedback.mediumImpact();
    claimedIds.add(challenge.id);
    _tasks?.addXp(challenge.xp);
    _save();

    final l10n = AppLocalizations.of(Get.context!);
    RewardCelebration.showPopup(
      title: challenge.title,
      subtitle: quizCorrectMessage ??
          (l10n != null
              ? '+${challenge.xp} ${l10n.todaysTasksXp} · ${l10n.challengesClaimed}'
              : '+${challenge.xp} XP'),
      icon: challenge.icon,
    );
  }

  List<GardenChallenge> _daily(AppLocalizations l10n) {
    final live = _tasks?.liveTasks ?? <TodaysCareTask>[];
    final items = <GardenChallenge>[];

    final water = live
        .where((t) => t.activityType.toLowerCase() == 'water')
        .toList();
    if (water.isNotEmpty) {
      final task = water.first;
      final plant = task.plantName.isEmpty
          ? l10n.todaysTasksPlantFallback
          : task.plantName;
      final time = (task.preferredTime ?? '').trim();
      items.add(
        GardenChallenge(
          id: 'daily_${task.id}',
          title: '${l10n.taskWaterShort} $plant',
          why: time.isEmpty
              ? l10n.taskDueToday
              : '${l10n.taskDueToday} · $time',
          xp: 10,
          period: ChallengePeriod.daily,
          action: ChallengeAction.care,
          icon: Icons.water_drop_rounded,
          color: AppColors.dodgerBlue,
          careTask: task,
        ),
      );
    } else {
      items.add(
        GardenChallenge(
          id: 'daily_water_fallback',
          title: l10n.challengeWaterFallback,
          why: l10n.challengeWaterFallbackWhy,
          xp: 10,
          period: ChallengePeriod.daily,
          action: ChallengeAction.catchUp,
          icon: Icons.water_drop_rounded,
          color: AppColors.dodgerBlue,
        ),
      );
    }

    final missed = live
        .where((t) => t.eventType?.toLowerCase() == 'missed')
        .toList();
    if (missed.isNotEmpty) {
      final names = missed
          .map((t) => t.plantName)
          .where((n) => n.trim().isNotEmpty)
          .take(2)
          .join(' & ');
      items.add(
        GardenChallenge(
          id: 'daily_catchup',
          title: l10n.challengeCatchUpTitle,
          why: names.isEmpty ? l10n.challengeCatchUpWhy : names,
          xp: 15,
          period: ChallengePeriod.daily,
          action: ChallengeAction.catchUp,
          icon: Icons.replay_circle_filled_rounded,
          color: AppColors.orangeColor,
          progress: 0,
          goal: missed.length.clamp(1, 5),
        ),
      );
    }

    final quizSource = live.isNotEmpty ? live.first : null;
    final plant = quizSource == null || quizSource.plantName.isEmpty
        ? l10n.todaysTasksPlantFallback
        : quizSource.plantName;
    items.add(
      GardenChallenge(
        id: 'daily_quiz',
        title: '${l10n.challengeQuizTitle} · $plant',
        why: l10n.challengeQuizWhy,
        xp: 5,
        period: ChallengePeriod.daily,
        action: ChallengeAction.quiz,
        icon: Icons.psychology_alt_outlined,
        color: AppColors.violet,
        quizAnswer: (quizSource?.source.scientificName ?? '').trim().isNotEmpty
            ? quizSource!.source.scientificName!.trim()
            : 'Monstera deliciosa',
      ),
    );

    return items;
  }

  List<GardenChallenge> _weekly(AppLocalizations l10n) => [
    GardenChallenge(
      id: 'weekly_plants',
      title: l10n.challengeAddPlants,
      why: l10n.earnAddPlant,
      xp: 100,
      period: ChallengePeriod.weekly,
      action: ChallengeAction.addPlant,
      icon: Icons.local_florist_rounded,
      color: AppColors.siltColor,
      progress: weeklyPlants.value,
      goal: 2,
    ),
    GardenChallenge(
      id: 'weekly_care',
      title: l10n.challengeCareActivities,
      why: l10n.earnPlantCare,
      xp: 150,
      period: ChallengePeriod.weekly,
      action: ChallengeAction.catchUp,
      icon: Icons.water_drop_rounded,
      color: AppColors.dodgerBlue,
      progress: weeklyCare.value,
      goal: 5,
    ),
    GardenChallenge(
      id: 'weekly_scan',
      title: l10n.challengeDiagnoses,
      why: l10n.earnDiagnosis,
      xp: 200,
      period: ChallengePeriod.weekly,
      action: ChallengeAction.diagnosis,
      icon: Icons.document_scanner_outlined,
      color: AppColors.greenColor,
      progress: weeklyDiagnosis.value,
      goal: 2,
    ),
    GardenChallenge(
      id: 'weekly_streak',
      title: l10n.challengeWeekStreak,
      why: l10n.earnCareStreak,
      xp: 250,
      period: ChallengePeriod.weekly,
      action: ChallengeAction.streak,
      icon: Icons.local_fire_department_rounded,
      color: AppColors.orangeColor,
      progress: streak.clamp(0, 7),
      goal: 7,
    ),
  ];

  List<GardenChallenge> _monthly(AppLocalizations l10n) => [
    GardenChallenge(
      id: 'monthly_plants',
      title: l10n.challengeMaintainPlants,
      why: l10n.earnAddPlant,
      xp: 500,
      period: ChallengePeriod.monthly,
      action: ChallengeAction.addPlant,
      icon: Icons.spa_rounded,
      color: AppColors.siltColor,
      progress: weeklyPlants.value.clamp(0, 5),
      goal: 5,
    ),
    GardenChallenge(
      id: 'monthly_scan',
      title: l10n.challengeMonthDiagnoses,
      why: l10n.earnDiagnosis,
      xp: 500,
      period: ChallengePeriod.monthly,
      action: ChallengeAction.diagnosis,
      icon: Icons.document_scanner_outlined,
      color: AppColors.greenColor,
      progress: monthlyDiagnosis.value,
      goal: 5,
    ),
    GardenChallenge(
      id: 'monthly_landscape',
      title: l10n.challengeMonthLandscape,
      why: l10n.earnLandscape,
      xp: 600,
      period: ChallengePeriod.monthly,
      action: ChallengeAction.landscape,
      icon: Icons.yard_outlined,
      color: AppColors.sandColor,
      progress: monthlyLandscape.value,
      goal: 2,
    ),
    GardenChallenge(
      id: 'monthly_streak',
      title: l10n.challengeMonthStreak,
      why: l10n.earn30Day,
      xp: 1000,
      period: ChallengePeriod.monthly,
      action: ChallengeAction.streak,
      icon: Icons.emoji_events_rounded,
      color: AppColors.burntGold,
      progress: streak.clamp(0, 30),
      goal: 30,
    ),
  ];

  void _load() {
    final raw =
        SharedPrefsService.instance.getString(AppKeys.challengesState) ?? '';
    if (raw.isEmpty) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      claimedIds.addAll(List<String>.from(map['claimed'] ?? const []));
      redeemedIds.addAll(List<String>.from(map['redeemed'] ?? const []));
      weeklyCare.value = (map['weeklyCare'] as num?)?.toInt() ?? 0;
      weeklyDiagnosis.value = (map['weeklyDiagnosis'] as num?)?.toInt() ?? 0;
      weeklyPlants.value = (map['weeklyPlants'] as num?)?.toInt() ?? 0;
      monthlyDiagnosis.value = (map['monthlyDiagnosis'] as num?)?.toInt() ?? 0;
      monthlyLandscape.value = (map['monthlyLandscape'] as num?)?.toInt() ?? 0;
    } catch (e) {
      debugPrint('Challenges load error: $e');
    }
  }

  Future<void> _save() async {
    await SharedPrefsService.instance.setString(
      AppKeys.challengesState,
      jsonEncode({
        'claimed': claimedIds.toList(),
        'redeemed': redeemedIds.toList(),
        'weeklyCare': weeklyCare.value,
        'weeklyDiagnosis': weeklyDiagnosis.value,
        'weeklyPlants': weeklyPlants.value,
        'monthlyDiagnosis': monthlyDiagnosis.value,
        'monthlyLandscape': monthlyLandscape.value,
      }),
    );
  }
}
