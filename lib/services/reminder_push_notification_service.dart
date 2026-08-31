import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kasagardem/reminders/reminders_repository.dart';
import 'package:kasagardem/services/notification_service.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

class ReminderPushNotificationService {
  ReminderPushNotificationService._();

  static final ReminderPushNotificationService instance = ReminderPushNotificationService._();

  final RemindersRepository _repository = RemindersRepository();

  VoidCallback? onRemindersShouldRefresh;
  bool pendingReminderRefresh = false;

  void configure() {
    NotificationService.instance.onNotificationClick = _handleNotificationClick;
    NotificationService.instance.onForegroundMessage = _handleForegroundMessage;
    NotificationService.instance.onTokenRefreshed = registerDeviceTokenIfNeeded;
    NotificationService.instance.onAppResumed = _onAppResumed;

    FirebaseMessaging.instance.onTokenRefresh.listen((_) {
      registerDeviceTokenIfNeeded();
    });
  }

  bool get _isLoggedIn => SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false;

  bool get _notificationsEnabled =>
      SharedPrefsService.instance.getBool(AppKeys.notificationsEnabled) ?? true;

  Future<void> registerDeviceTokenIfNeeded() async {
    if (!_isLoggedIn || !_notificationsEnabled) return;

    final token = await NotificationService.instance.refreshFcmToken();
    if (token == null || token.isEmpty) return;

    final lastRegistered = SharedPrefsService.instance.getString(AppKeys.lastRegisteredFcmToken);
    if (lastRegistered == token) return;

    final response = await _repository.registerDeviceToken(
      fcmToken: token,
      deviceType: Platform.isIOS ? 'ios' : 'android',
      enabled: true,
    );

    if (response != null) {
      await SharedPrefsService.instance.setString(AppKeys.lastRegisteredFcmToken, token);
      log('FCM token registered for plant care reminders.');
    }
  }

  Future<void> unregisterDeviceToken() async {
    final token =
        SharedPrefsService.instance.getString(AppKeys.fcmToken) ??
        await NotificationService.instance.refreshFcmToken();
    if (token == null || token.isEmpty) return;

    await _repository.registerDeviceToken(
      fcmToken: token,
      deviceType: Platform.isIOS ? 'ios' : 'android',
      enabled: false,
    );
    await SharedPrefsService.instance.setString(AppKeys.lastRegisteredFcmToken, '');
    log('FCM token deregistered for plant care reminders.');
  }

  Future<void> onUserLogout() async {
    try {
      await unregisterDeviceToken();
      await FirebaseMessaging.instance.deleteToken();
      await SharedPrefsService.instance.setString(AppKeys.fcmToken, '');
      debugPrint('[PUSH][logout] FCM token deregistered and deleted');
    } catch (e) {
      log('Failed to deregister FCM token on logout: $e');
    }
  }

  Future<void> onAppReady() async {
    if (!_isLoggedIn) return;
    await NotificationService.instance.processLaunchNavigation();
  }

  void _onAppResumed() {
    debugPrint('[PUSH][app_resumed] background tap handling complete');
  }

  bool consumePendingReminderRefresh() {
    if (!pendingReminderRefresh) return false;
    pendingReminderRefresh = false;
    return true;
  }

  void _handleForegroundMessage(RemoteMessage message, Map<String, dynamic> payload) {
    debugPrint('[PUSH][received] reminder foreground payload=$payload');
    if (!isReminderNotification(payload)) {
      debugPrint('[PUSH][skipped] foreground message is not a plant reminder');
      return;
    }

    log('Reminder push intercepted (foreground): $payload');
    pendingReminderRefresh = true;
    onRemindersShouldRefresh?.call();
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    debugPrint('[PUSH][reminder] click received | data=$data');

    if (!_isLoggedIn) {
      debugPrint('[PUSH][reminder] User not logged in, persisting data for later');
      NotificationService.instance.setPendingNotificationData(data);
      return;
    }

    pendingReminderRefresh = true;
    debugPrint('[PUSH][reminder] Navigating to reminders screen');
    _navigateToReminders(data);
  }

  bool isReminderNotification(Map<String, dynamic> data) {
    final type = data['type'] ?? data['notification_type'] ?? data['category'] ?? data['action'];
    return type == 'plant_reminder' ||
        type == 'reminder' ||
        data['action'] == 'plant_reminder' ||
        data['route'] == Routes.plantRemindersListing ||
        data.containsKey('activity_type') ||
        data.containsKey('activityType') ||
        data.containsKey('user_plant_id') ||
        data.containsKey('userPlantId');
  }

  void _navigateToReminders(Map<String, dynamic> data, {int attempt = 0}) {
    if (Get.key.currentContext == null && attempt < 20) {
      debugPrint('[PUSH][reminder] No context yet, retrying navigation ($attempt)...');
      Future.delayed(const Duration(milliseconds: 250), () {
        _navigateToReminders(data, attempt: attempt + 1);
      });
      return;
    }

    void navigate() {
      debugPrint(
        '[PUSH][reminder] Internal navigate() called | current route: ${Get.currentRoute}',
      );
      if (Get.currentRoute == Routes.plantRemindersListing) {
        debugPrint('[PUSH][reminder] Already on reminders screen, refreshing...');
        onRemindersShouldRefresh?.call();
        return;
      }

      Get.until((route) {
        final name = route.settings.name;
        return name == Routes.plantRemindersListing ||
            name == Routes.dashboard ||
            name == Routes.professionalDashboard ||
            route.isFirst;
      });

      if (Get.currentRoute == Routes.plantRemindersListing) {
        onRemindersShouldRefresh?.call();
        return;
      }

      Get.toNamed(Routes.plantRemindersListing, arguments: data, preventDuplicates: false)?.then((
        _,
      ) {
        onRemindersShouldRefresh?.call();
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 350), navigate);
    });
  }
}
