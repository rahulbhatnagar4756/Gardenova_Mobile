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
  bool _homeScreenReady = false;

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
      debugPrint('[PUSH][logout] deregister failed: $e');
    }
  }

  void _onAppResumed() {
    debugPrint('[PUSH][app_resumed] processing pending notification navigation');
    _ensureHomeScreenReady();
    NotificationService.instance.consumePersistedNotificationTap().then((_) {
      NotificationService.instance.schedulePendingNotificationClick(delayMs: 300);
    });
  }

  Future<void> onAppReady() async {
    if (!_isLoggedIn) return;

    if (!_homeScreenReady) {
      _homeScreenReady = true;
      debugPrint('[PUSH][app_ready] home screen ready, processing launch notification');
    }

    await NotificationService.instance.processLaunchNavigation();
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

    _ensureHomeScreenReady();
    if (!NotificationService.instance.isNavigationReady) {
      NotificationService.instance.markNavigationReady();
    }
    pendingReminderRefresh = true;
    _navigateToReminders(data);
  }

  void _ensureHomeScreenReady() {
    if (_homeScreenReady) return;
    if (!_isLoggedIn || Get.key.currentContext == null) return;

    _homeScreenReady = true;
    if (!NotificationService.instance.isNavigationReady) {
      NotificationService.instance.markNavigationReady();
    }
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

  void _navigateToReminders(Map<String, dynamic> data) {
    debugPrint('[PUSH][reminder] navigating to reminders list from ${Get.currentRoute}');

    void navigate() {
      if (Get.currentRoute == Routes.plantRemindersListing) {
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
