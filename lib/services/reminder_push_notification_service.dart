import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kasagardem/reminders/reminders_repository.dart';
import 'package:kasagardem/services/notification_service.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

class ReminderPushNotificationService {
  ReminderPushNotificationService._();

  static final ReminderPushNotificationService instance =
      ReminderPushNotificationService._();

  final RemindersRepository _repository = RemindersRepository();

  VoidCallback? onRemindersShouldRefresh;

  void configure() {
    NotificationService.instance.onNotificationClick = _handleNotificationClick;
    NotificationService.instance.onForegroundMessage = _handleForegroundMessage;
    NotificationService.instance.onTokenRefreshed = registerDeviceTokenIfNeeded;

    FirebaseMessaging.instance.onTokenRefresh.listen((_) {
      registerDeviceTokenIfNeeded();
    });
  }

  bool get _isLoggedIn =>
      SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false;

  bool get _notificationsEnabled =>
      SharedPrefsService.instance.getBool(AppKeys.notificationsEnabled) ?? true;

  Future<void> registerDeviceTokenIfNeeded() async {
    if (!_isLoggedIn || !_notificationsEnabled) return;

    final token = await NotificationService.instance.refreshFcmToken();
    if (token == null || token.isEmpty) return;

    final lastRegistered =
        SharedPrefsService.instance.getString(AppKeys.lastRegisteredFcmToken);
    if (lastRegistered == token) return;

    final response = await _repository.registerDeviceToken(
      fcmToken: token,
      deviceType: Platform.isIOS ? 'ios' : 'android',
      enabled: true,
    );

    if (response != null) {
      await SharedPrefsService.instance.setString(
        AppKeys.lastRegisteredFcmToken,
        token,
      );
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
  }

  void processPendingNotificationClick() {
    NotificationService.instance.processPendingNotificationClick();
  }

  void _handleForegroundMessage(RemoteMessage message) {
    if (!isReminderNotification(message.data)) return;
    onRemindersShouldRefresh?.call();
  }

  void _handleNotificationClick(Map<String, dynamic> data) {
    if (!NotificationService.instance.canHandleNavigation) {
      NotificationService.instance.setPendingNotificationData(data);
      return;
    }

    if (isReminderNotification(data)) {
      _navigateToReminders(data);
      return;
    }

    final String? route = data['route']?.toString() ?? data['screen']?.toString();
    if (route != null && route.isNotEmpty) {
      Get.toNamed(route, arguments: data['arguments'] ?? data);
    }
  }

  bool isReminderNotification(Map<String, dynamic> data) {
    final type = data['type'] ?? data['notification_type'] ?? data['category'];
    return type == 'plant_reminder' ||
        type == 'reminder' ||
        data['route'] == Routes.plantRemindersListing ||
        data.containsKey('activity_type') ||
        data.containsKey('user_plant_id');
  }

  void _navigateToReminders(Map<String, dynamic> data) {
    if (Get.currentRoute == Routes.plantRemindersListing) {
      onRemindersShouldRefresh?.call();
      return;
    }

    Get.toNamed(Routes.plantRemindersListing, arguments: data)?.then((_) {
      onRemindersShouldRefresh?.call();
    });
  }
}
