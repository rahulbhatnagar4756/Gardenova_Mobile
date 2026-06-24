import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/scheduler.dart';
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
    NotificationService.instance.onAppResumed = onAppReady;

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
      debugPrint('[PUSH][logout] deregister failed: $e');
    }
  }

  void onAppReady() {
    debugPrint('[PUSH][app_ready] marking navigation ready');
    NotificationService.instance.markNavigationReady();
  }

  bool consumePendingReminderRefresh() {
    if (!pendingReminderRefresh) return false;
    pendingReminderRefresh = false;
    return true;
  }

  void _handleForegroundMessage(RemoteMessage message, Map<String, dynamic> payload) {
    final isReminder = isReminderNotification(payload);
    debugPrint(
      '[PUSH][reminder] foreground received | isReminder=$isReminder | payload=$payload',
    );

    if (!isReminder) return;

    log('Reminder push intercepted (foreground): $payload');
    pendingReminderRefresh = true;
    onRemindersShouldRefresh?.call();
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    debugPrint('[PUSH][reminder] click received | data=$data');
    log('Notification click intercepted: $data');

    if (!_isLoggedIn) {
      NotificationService.instance.setPendingNotificationData(data);
      return;
    }

    if (!NotificationService.instance.canHandleNavigation) {
      NotificationService.instance.setPendingNotificationData(data);
      return;
    }

    pendingReminderRefresh = true;
    _navigateToReminders(data);
  }

  bool isReminderNotification(Map<String, dynamic> data) {
    final type = data['type'] ?? data['notification_type'] ?? data['category'];
    return type == 'plant_reminder' ||
        type == 'reminder' ||
        data['route'] == Routes.plantRemindersListing ||
        data.containsKey('activity_type') ||
        data.containsKey('activityType') ||
        data.containsKey('user_plant_id') ||
        data.containsKey('userPlantId');
  }

  void _navigateToReminders(Map<String, dynamic> data) {
    debugPrint('[PUSH][reminder] navigating to reminders list');

    void navigate() {
      if (Get.currentRoute == Routes.plantRemindersListing) {
        onRemindersShouldRefresh?.call();
        return;
      }

      Get.toNamed(Routes.plantRemindersListing, arguments: data)?.then((_) {
        onRemindersShouldRefresh?.call();
      });
    }

    if (WidgetsBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      navigate();
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => navigate());
  }
}
