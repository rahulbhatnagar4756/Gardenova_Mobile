import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/reminders/model/notification_response_model.dart';
import 'package:kasagardem/reminders/reminders_repository.dart';
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

  bool get isLoggedIn =>
      SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false;

  /// Care reminders only when there is at least one due/completed care item
  /// for today. Otherwise fall back to daily habit tasks (avoids 0/0).
  bool get isCareMode =>
      isLoggedIn && careLoaded.value && todayKeys.isNotEmpty;

  int get completedCount {
    if (isCareMode) {
      return todayKeys.where(completedIds.contains).length;
    }
    return DailyTaskId.values.where(isCompleted).length;
  }

  int get totalCount {
    if (isCareMode) return todayKeys.length;
    return DailyTaskId.values.length;
  }

  double get progress => totalCount == 0 ? 0 : completedCount / totalCount;

  bool get allComplete => totalCount > 0 && completedCount >= totalCount;

  List<TodaysCareTask> get visibleCareTasks =>
      liveTasks.take(_maxVisibleCareTasks).toList();

  bool get hasMoreCareTasks => liveTasks.length > _maxVisibleCareTasks;

  @override
  void onInit() {
    super.onInit();
    loadState();
    fetchTodaysCareTasks();
  }

  static void completeIfRegistered(DailyTaskId id) {
    if (Get.isRegistered<TodaysTasksController>()) {
      Get.find<TodaysTasksController>().completeTask(id);
    }
  }

  static void onRemoteReminderComplete(Tasks task) {
    if (!Get.isRegistered<TodaysTasksController>()) return;
    Get.find<TodaysTasksController>()._applyRemoteComplete(task);
  }

  bool isCompleted(DailyTaskId id) => completedIds.contains(id.name);

  bool isCareTaskCompleted(TodaysCareTask task) =>
      completedIds.contains(task.id);

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
    final raw =
        SharedPrefsService.instance.getString(AppKeys.todaysTasksState) ?? '';
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
          _lastCompleteDate !=
              _dateKey(DateTime.now().subtract(const Duration(days: 1)))) {
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
      liveTasks.removeWhere((item) => item.id == task.id);
    } catch (e) {
      debugPrint('Complete care task error: $e');
    } finally {
      completingId.value = '';
    }
  }

  void completeTask(DailyTaskId id) {
    _markIdComplete(id.name);
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
  }

  void _markIdComplete(String id) {
    if (completedIds.contains(id)) return;

    HapticFeedback.mediumImpact();
    completedIds.add(id);
    xp.value += taskXp;

    final l10n = AppLocalizations.of(Get.context!);
    if (allComplete) {
      _applyStreak();
      if (l10n != null) {
        RewardCelebration.showPopup(
          title: l10n.todaysTasksAllCompleteSnack,
          subtitle: '+$taskXp ${l10n.todaysTasksXp}',
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

    final yesterday = _dateKey(
      DateTime.now().subtract(const Duration(days: 1)),
    );
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
