import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kasagardem/dashboard/dashboard_repository.dart';
import 'package:kasagardem/dashboard/model/daily_challenges_model.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/reminders/model/notification_response_model.dart';
import 'package:kasagardem/reminders/reminders_repository.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/reward_celebration.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

enum DailyTaskId { water, inspect, fertilize, prune, scan, reminders }

class TodaysCareTask {
  const TodaysCareTask({
    required this.id,
    required this.activityType,
    required this.plantName,
    required this.source,
    this.preferredTime,
    this.eventType,
    this.nextAt,
  });

  final String id;
  final String activityType;
  final String plantName;
  final String? preferredTime;
  final String? eventType;
  final String? nextAt;
  final Tasks source;
}

class TodaysTasksController extends GetxController {
  static const taskXp = 25;
  static const bonusXp = 50;
  static const _maxVisibleCareTasks = 3;

  final RemindersRepository _remindersRepository = RemindersRepository();
  final DashboardRepository _dashboardRepository = DashboardRepository();

  final challenges = <DailyChallenge>[].obs;
  final isLoadingChallenges = false.obs;
  final completedIds = <String>{}.obs;
  final streak = 0.obs;
  final xp = 0.obs;
  final bonusClaimed = false.obs;
  final liveTasks = <TodaysCareTask>[].obs;
  final todayKeys = <String>{}.obs;
  final careLoaded = false.obs;
  final isLoadingCare = false.obs;
  final completingId = ''.obs;

  String _lastCompleteDate = '';

  bool get isLoggedIn => SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false;

  /// Care reminders only when there is at least one due/completed care item
  /// for today. Otherwise fall back to dynamic challenges from API.
  bool get isCareMode => isLoggedIn && careLoaded.value && todayKeys.isNotEmpty;

  int get completedCount => challenges.where((c) => c.isCompleted).length;

  int get totalCount => challenges.length;

  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;

  bool get allComplete => totalCount > 0 && completedCount >= totalCount;

  List<TodaysCareTask> get visibleCareTasks => liveTasks.take(_maxVisibleCareTasks).toList();

  bool get hasMoreCareTasks => liveTasks.length > _maxVisibleCareTasks;

  @override
  void onInit() {
    super.onInit();
    loadState();
    if (isLoggedIn) {
      refreshTasks();
    }
  }

  Future<void> refreshTasks() async {
    await Future.wait([fetchChallenges(), fetchTodaysCareTasks()]);
  }

  static void completeIfRegistered(String code) {
    if (Get.isRegistered<TodaysTasksController>()) {
      Get.find<TodaysTasksController>().completeTask(code);
    }
  }

  static void onRemoteReminderComplete(Tasks task) {
    if (!Get.isRegistered<TodaysTasksController>()) return;
    Get.find<TodaysTasksController>()._applyRemoteComplete(task);
  }

  bool isCompleted(DailyTaskId id) => completedIds.contains(id.name);

  bool isCareTaskCompleted(TodaysCareTask task) => completedIds.contains(task.id);

  DailyTaskId? get nextTask {
    for (final id in DailyTaskId.values) {
      if (!isCompleted(id)) return id;
    }
    return null;
  }

  String gardenLevel(AppLocalizations l10n) {
    if (xp.value >= 600) return l10n.gardenLevelMaster;
    if (xp.value >= 300) return l10n.gardenLevelBloom;
    if (xp.value >= 100) return l10n.gardenLevelSeedling;
    return l10n.gardenLevelSprout;
  }

  void loadState() {
    final raw = SharedPrefsService.instance.getString(AppKeys.todaysTasksState) ?? '';
    if (raw.isEmpty) return;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      xp.value = (map['xp'] as num?)?.toInt() ?? 0;
      streak.value = (map['streak'] as num?)?.toInt() ?? 0;
      _lastCompleteDate = map['lastCompleteDate'] as String? ?? '';
      final savedDate = map['date'] as String? ?? '';
      final today = _dateKey(DateTime.now());

      if (_lastCompleteDate.isNotEmpty &&
          _lastCompleteDate != today &&
          _lastCompleteDate != _dateKey(DateTime.now().subtract(const Duration(days: 1)))) {
        streak.value = 0;
      }

      if (savedDate == today) {
        completedIds
          ..clear()
          ..addAll(List<String>.from(map['completed'] ?? const []));
        bonusClaimed.value = map['bonusClaimed'] == true;
      } else {
        completedIds.clear();
        bonusClaimed.value = false;
      }
    } catch (e) {
      debugPrint('Today\'s tasks load error: $e');
    }
  }

  Future<void> fetchChallenges() async {
    if (!isLoggedIn) {
      challenges.clear();
      return;
    }
    isLoadingChallenges.value = true;
    try {
      final response = await _dashboardRepository.fetchDailyChallenges();
      if (response != null) {
        final model = DailyChallengesResponseModel.fromJson(response);
        final fetched = model.data?.challenges ?? [];
        challenges.assignAll(fetched);

        for (final c in fetched) {
          if (c.isCompleted) {
            if (c.id != null) completedIds.add(c.id!);
            if (c.code != null) {
              completedIds.add(c.code!);
              completedIds.add(c.code!.toUpperCase());
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Fetch challenges error: $e');
    } finally {
      isLoadingChallenges.value = false;
    }
  }

  Future<void> fetchTodaysCareTasks() async {
    if (!isLoggedIn) {
      careLoaded.value = false;
      liveTasks.clear();
      todayKeys.clear();
      return;
    }

    isLoadingCare.value = true;
    try {
      final results = await Future.wait([
        _remindersRepository.fetchAllPlants(
          activityType: 'all',
          eventType: 'upcoming',
          pageNumber: '1',
          pageSize: '10',
          showDefaultLoader: false,
        ),
        _remindersRepository.fetchAllPlants(
          activityType: 'all',
          eventType: 'missed',
          pageNumber: '1',
          pageSize: '10',
          showDefaultLoader: false,
        ),
      ]);

      final due = <String, TodaysCareTask>{};
      for (final response in results) {
        if (response == null) continue;
        final model = NotificationResponseModel.fromJson(response);
        for (final task in model.data?.tasks ?? const <Tasks>[]) {
          if (!_isDueToday(task)) continue;
          final mapped = _mapCareTask(task);
          if (mapped == null) continue;
          if (completedIds.contains(mapped.id)) continue;
          due[mapped.id] = mapped;
        }
      }

      liveTasks.assignAll(due.values.toList());
      todayKeys
        ..clear()
        ..addAll(due.keys)
        ..addAll(completedIds.where((id) => id.startsWith('r_')));
      careLoaded.value = true;
    } catch (e) {
      debugPrint('Today\'s care tasks error: $e');
      careLoaded.value = false;
    } finally {
      isLoadingCare.value = false;
    }
  }

  Future<void> completeCareTask(TodaysCareTask task) async {
    if (isCareTaskCompleted(task) || completingId.value == task.id) return;

    final userPlantId = task.source.userPlantId;
    final activityType = task.source.activityType;
    if (userPlantId == null || userPlantId.isEmpty || activityType == null) {
      return;
    }

    completingId.value = task.id;
    try {
      final response = await _remindersRepository.completeReminder(
        userPlantId: userPlantId,
        activityType: activityType,
      );
      if (response == null) return;
      _markIdComplete(task.id);
      _markIdComplete('TODAYS_CARE');
      liveTasks.removeWhere((item) => item.id == task.id);
      fetchChallenges();
    } catch (e) {
      debugPrint('Complete care task error: $e');
    } finally {
      completingId.value = '';
    }
  }

  void completeTask(String code) {
    _markIdComplete(code);
  }

  Future<void> completeChallengeApi(DailyChallenge challenge) async {
    final challengeId = challenge.id;
    if (challengeId == null || challengeId.isEmpty || challenge.isCompleted) return;

    try {
      final response = await _dashboardRepository.completeDailyChallenge(challengeId);

      if (response != null && response['success'] == true) {
        RewardCelebration.burstConfetti(big: true);

        final pts = challenge.points ?? taskXp;
        final l10n = AppLocalizations.of(Get.context!);
        RewardCelebration.showPopup(
          title: challenge.title ?? 'Challenge Completed!',
          subtitle: '+$pts ${l10n?.todaysTasksXp ?? 'XP'}',
          icon: Icons.emoji_events_rounded,
        );

        _markIdComplete(challengeId);
        if (challenge.code != null) {
          _markIdComplete(challenge.code!);
        }

        await fetchChallenges();
      } else {
        final message =
            (response != null &&
                response['message'] != null &&
                response['message'].toString().trim().isNotEmpty)
            ? response['message'].toString()
            : "Complete today's care tasks first to unlock this reward! 🌿";

        BaseSnackBar.show(title: "Garden Challenge 🌿", message: message);
      }
    } catch (e) {
      debugPrint('Complete challenge API error: $e');
      BaseSnackBar.show(
        title: "Garden Challenge 🌿",
        message: "Complete today's care tasks first to unlock this reward! 🌿",
      );
    }
  }

  void addXp(int amount) {
    if (amount <= 0) return;
    xp.value += amount;
    _save();
  }

  bool spendXp(int amount) {
    if (amount <= 0 || xp.value < amount) return false;
    xp.value -= amount;
    _save();
    return true;
  }

  void claimBonus() {
    if (!allComplete || bonusClaimed.value) return;

    HapticFeedback.heavyImpact();
    bonusClaimed.value = true;
    xp.value += bonusXp;
    _save();

    final l10n = AppLocalizations.of(Get.context!);
    if (l10n != null) {
      RewardCelebration.showPopup(
        title: l10n.todaysTasksBonusClaimed,
        subtitle: '+$bonusXp ${l10n.todaysTasksXp}\n${l10n.todaysTasksBonusSnack}',
        icon: Icons.card_giftcard_rounded,
      );
    }
  }

  void _applyRemoteComplete(Tasks task) {
    final mapped = _mapCareTask(task);
    if (mapped == null) return;
    todayKeys.add(mapped.id);
    liveTasks.removeWhere((item) => item.id == mapped.id);
    _markIdComplete(mapped.id);
    _markIdComplete('TODAYS_CARE');
    fetchChallenges();
  }

  void _markIdComplete(String idOrCode) {
    final cleanCode = idOrCode.replaceAll('DailyTaskId.', '').toUpperCase();
    if (completedIds.contains(idOrCode) && completedIds.contains(cleanCode)) return;

    final index = challenges.indexWhere(
      (c) =>
          c.id == idOrCode ||
          c.code?.toUpperCase() == cleanCode ||
          c.code?.toUpperCase() == idOrCode.toUpperCase() ||
          _isCodeAlias(c.code, cleanCode),
    );

    int earnedXp = taskXp;

    if (index != -1) {
      final challenge = challenges[index];
      if (!challenge.isCompleted) {
        challenge.progressCount = challenge.targetCount ?? ((challenge.progressCount ?? 0) + 1);
        challenge.status = 'completed';
        challenges[index] = challenge;
        challenges.refresh();

        earnedXp = challenge.points ?? taskXp;
      }
      if (challenge.id != null) completedIds.add(challenge.id!);
      if (challenge.code != null) {
        completedIds.add(challenge.code!);
        completedIds.add(challenge.code!.toUpperCase());
      }
    }

    completedIds.add(idOrCode);
    completedIds.add(cleanCode);

    HapticFeedback.mediumImpact();
    xp.value += earnedXp;

    final l10n = AppLocalizations.of(Get.context!);
    if (allComplete) {
      _applyStreak();
      if (l10n != null) {
        RewardCelebration.showPopup(
          title: l10n.todaysTasksAllCompleteSnack,
          subtitle: '+$earnedXp ${l10n.todaysTasksXp}',
          icon: Icons.local_florist_rounded,
        );
      } else {
        RewardCelebration.burstConfetti(big: true);
      }
    } else {
      RewardCelebration.burstConfetti();
    }

    _save();
  }

  bool _isCodeAlias(String? code, String input) {
    if (code == null) return false;
    final c = code.toUpperCase();
    if ((c == 'PLANT_SCAN' || c == 'DIAGNOSIS') &&
        (input == 'SCAN' || input == 'PLANT_SCAN' || input == 'DIAGNOSIS')) {
      return true;
    }
    if ((c == 'TODAYS_CARE' || c == 'REMINDERS') &&
        (input == 'TODAYS_CARE' || input == 'REMINDERS' || input == 'CARE')) {
      return true;
    }
    return false;
  }

  TodaysCareTask? _mapCareTask(Tasks task) {
    final userPlantId = task.userPlantId;
    final activityType = task.activityType;
    if (userPlantId == null ||
        userPlantId.isEmpty ||
        activityType == null ||
        activityType.isEmpty) {
      return null;
    }

    return TodaysCareTask(
      id: 'r_${userPlantId}_$activityType',
      activityType: activityType,
      plantName: (task.commonName ?? '').trim(),
      preferredTime: task.preferredTime,
      eventType: task.eventType,
      nextAt: task.nextAt,
      source: task,
    );
  }

  bool _isDueToday(Tasks task) {
    final event = task.eventType?.toLowerCase() ?? '';
    if (event == 'completed') return false;
    if (event == 'missed') return true;

    final next = _parseDate(task.nextAt);
    if (next == null) return event == 'upcoming';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(next.year, next.month, next.day);
    return !dueDay.isAfter(today);
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    try {
      return DateTime.parse(value).toLocal();
    } catch (_) {
      return DateTime.tryParse(value);
    }
  }

  void _applyStreak() {
    final today = _dateKey(DateTime.now());
    if (_lastCompleteDate == today) return;

    final yesterday = _dateKey(DateTime.now().subtract(const Duration(days: 1)));
    streak.value = _lastCompleteDate == yesterday ? streak.value + 1 : 1;
    _lastCompleteDate = today;
  }

  Future<void> _save() async {
    await SharedPrefsService.instance.setString(
      AppKeys.todaysTasksState,
      jsonEncode({
        'date': _dateKey(DateTime.now()),
        'completed': completedIds.toList(),
        'bonusClaimed': bonusClaimed.value,
        'streak': streak.value,
        'xp': xp.value,
        'lastCompleteDate': _lastCompleteDate,
      }),
    );
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
