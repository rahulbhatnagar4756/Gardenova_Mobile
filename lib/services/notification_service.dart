import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kReminderNotificationChannelId = 'plant_reminders';

const AndroidNotificationChannel _reminderChannel = AndroidNotificationChannel(
  kReminderNotificationChannelId,
  'Plant Reminders',
  description: 'Plant care reminder notifications',
  importance: Importance.max,
  playSound: true,
);

const String _androidNotificationIcon = 'ic_notification_large';
const String _androidNotificationLargeIcon = '@mipmap/ic_launcher';
const Color _androidNotificationAccentColor = Color(0xFF01AF55);

AndroidNotificationDetails _buildAndroidNotificationDetails() {
  return AndroidNotificationDetails(
    _reminderChannel.id,
    _reminderChannel.name,
    channelDescription: _reminderChannel.description,
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    icon: _androidNotificationIcon,
    largeIcon: const DrawableResourceAndroidBitmap(_androidNotificationLargeIcon),
    color: _androidNotificationAccentColor,
    category: AndroidNotificationCategory.reminder,
    visibility: NotificationVisibility.public,
    autoCancel: true,
  );
}

@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse response) async {
  final payload = response.payload;
  if (payload == null || payload.isEmpty) return;

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(AppKeys.pendingNotificationPayload, payload);
}

Future<void> _persistNotificationTap(Map<String, dynamic> data) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppKeys.pendingNotificationPayload, jsonEncode(data));
  } catch (e) {
    log('Failed to persist notification tap payload: $e');
  }
}

const DarwinNotificationDetails _iosNotificationDetails = DarwinNotificationDetails(
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
);

void _logPushNotification(
  String source,
  RemoteMessage message,
  Map<String, dynamic> payload, {
  String? extra,
}) {
  final title = message.notification?.title ?? payload['title'];
  final body = message.notification?.body ?? payload['body'] ?? payload['message'];
  final messageLog =
      '[PUSH][$source] id=${message.messageId} | title=$title | body=$body | data=$payload${extra != null ? ' | $extra' : ''}';
  log(messageLog);
  debugPrint(messageLog);
}

@pragma('vm:entry-point')
Future<void> _ensureAndroidNotificationChannel() async {
  final plugin = FlutterLocalNotificationsPlugin();
  await plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_reminderChannel);
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await _ensureAndroidNotificationChannel();
  final payload = normalizeNotificationPayload(message);
  _logPushNotification('background', message, payload);

  final prefs = await SharedPreferences.getInstance();
  final notificationsEnabled = prefs.getBool(AppKeys.notificationsEnabled) ?? true;
  if (!notificationsEnabled) {
    debugPrint('[PUSH][background] skipped: notifications disabled in settings');
    return;
  }

  final title = payload['title']?.toString();
  final body = payload['body']?.toString() ?? payload['message']?.toString();
  if (title == null || body == null || title.isEmpty || body.isEmpty) {
    debugPrint('[PUSH][background] skipped: missing title/body');
    return;
  }

  // FCM auto-displays notification-payload messages in the tray — skip local to avoid duplicates.
  // Tap is handled via onMessageOpenedApp / getInitialMessage after the activity is ready.
  if (message.notification != null) {
    debugPrint(
      '[PUSH][background] OS notification shown — tap via onMessageOpenedApp/getInitialMessage',
    );
    return;
  }

  debugPrint('[PUSH][background] showing local notification for data-only message');
  final plugin = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings(_androidNotificationIcon);
  const iosSettings = DarwinInitializationSettings();
  await plugin.initialize(
    settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  final androidDetails = _buildAndroidNotificationDetails();
  final notificationId = _notificationIdForPayload(payload, message);

  await plugin.show(
    id: notificationId,
    title: title,
    body: body,
    notificationDetails: NotificationDetails(android: androidDetails, iOS: _iosNotificationDetails),
    payload: jsonEncode(payload),
  );
}

int _notificationIdForPayload(Map<String, dynamic> payload, RemoteMessage message) {
  final logId = payload['notification_log_id']?.toString();
  if (logId != null && logId.isNotEmpty) return logId.hashCode;

  return message.messageId?.hashCode ?? message.hashCode;
}

Map<String, dynamic> normalizeNotificationPayload(RemoteMessage message) {
  final payload = Map<String, dynamic>.from(message.data);
  final notification = message.notification;

  if (notification?.title != null && notification!.title!.isNotEmpty) {
    payload.putIfAbsent('title', () => notification.title);
  }
  if (notification?.body != null && notification!.body!.isNotEmpty) {
    payload.putIfAbsent('body', () => notification.body);
  }
  payload.putIfAbsent('openedFromNotification', () => true);

  final hasReminderData =
      payload.containsKey('activity_type') ||
      payload.containsKey('activityType') ||
      payload.containsKey('user_plant_id') ||
      payload.containsKey('userPlantId') ||
      payload['type'] == 'plant_reminder' ||
      payload['action'] == 'plant_reminder' ||
      payload['type'] == 'reminder' ||
      payload['route'] == Routes.plantRemindersListing;

  if (!hasReminderData && (notification != null || payload['openedFromNotification'] == true)) {
    payload.putIfAbsent('type', () => 'plant_reminder');
    payload.putIfAbsent('route', () => Routes.plantRemindersListing);
  }

  return payload;
}

class NotificationService with WidgetsBindingObserver {
  NotificationService._privateConstructor();

  static final NotificationService instance = NotificationService._privateConstructor();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  void Function(Map<String, dynamic>)? onNotificationClick;
  void Function(RemoteMessage, Map<String, dynamic>)? onForegroundMessage;
  VoidCallback? onTokenRefreshed;
  VoidCallback? onAppResumed;

  Map<String, dynamic>? _pendingNotificationData;
  bool _isNavigationReady = false;
  bool _isPendingClickScheduled = false;
  bool _fcmLaunchMessageChecked = false;

  bool get isNavigationReady => _isNavigationReady;

  bool get hasPendingNotificationData => _pendingNotificationData != null;

  bool get hasPendingLaunchNotification =>
      _pendingNotificationData != null || _fcmLaunchMessageChecked;

  bool get canHandleNavigation => _isNavigationReady && Get.key.currentContext != null;

  void markNavigationReady() {
    _isNavigationReady = true;
    schedulePendingNotificationClick();
  }

  /// Initialize Firebase Messaging & Local Notifications
  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    WidgetsBinding.instance.addObserver(this);

    _setupMessageListeners();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(_androidNotificationIcon);

    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('[PUSH][local tap] payload=${response.payload}');
        _handleNotificationClick(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _ensureAndroidNotificationChannel();

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _captureLocalNotificationLaunch();
    await refreshFcmToken();
  }

  bool get areNotificationsEnabled =>
      SharedPrefsService.instance.getBool(AppKeys.notificationsEnabled) ?? true;

  static bool areNotificationsEnabledInPrefs() =>
      SharedPrefsService.instance.getBool(AppKeys.notificationsEnabled) ?? true;

  void setPendingNotificationData(Map<String, dynamic> data, {bool persist = true}) {
    _pendingNotificationData = Map<String, dynamic>.from(data);
    if (persist) {
      _persistNotificationTap(data);
    }
  }

  Future<void> consumePersistedNotificationTap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(AppKeys.pendingNotificationPayload);
      if (raw == null || raw.isEmpty) return;

      await prefs.remove(AppKeys.pendingNotificationPayload);
      final data = Map<String, dynamic>.from(jsonDecode(raw));
      debugPrint('[PUSH][persisted] loaded notification tap payload: $data');
      setPendingNotificationData(data, persist: false);
    } catch (e) {
      log('Failed to consume persisted notification tap: $e');
    }
  }

  void schedulePendingNotificationClick({int delayMs = 450}) {
    if (_pendingNotificationData == null) return;

    if (canHandleNavigation) {
      processPendingNotificationClick();
      return;
    }

    if (_isPendingClickScheduled) return;
    _isPendingClickScheduled = true;

    void attemptProcess() {
      _isPendingClickScheduled = false;
      if (_pendingNotificationData == null) return;
      if (!canHandleNavigation) {
        schedulePendingNotificationClick(delayMs: delayMs);
        return;
      }
      processPendingNotificationClick();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: delayMs), attemptProcess);
    });
  }

  /// Call once after the first home screen is mounted (activity must be attached).
  Future<void> tryCaptureFcmLaunchMessage() async {
    if (_fcmLaunchMessageChecked) return;
    _fcmLaunchMessageChecked = true;

    // Wait for Android activity + FCM plugin to process the launch intent.
    await Future.delayed(const Duration(milliseconds: 600));

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final payload = normalizeNotificationPayload(initialMessage);
      _logPushNotification('cold_start', initialMessage, payload);
      setPendingNotificationData(payload);
      debugPrint('[PUSH][cold_start] captured FCM launch message after home ready');
      return;
    }

    debugPrint('[PUSH][cold_start] no FCM launch message');
  }

  /// @deprecated Use [tryCaptureFcmLaunchMessage] after the home screen mounts.
  Future<void> captureFcmInitialMessageOnce() => tryCaptureFcmLaunchMessage();

  /// Call after the first home screen is mounted to process any launch notification.
  Future<void> captureTerminatedNotificationLaunch() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await consumePersistedNotificationTap();
  }

  Future<void> processLaunchNavigation({int delayMs = 600}) async {
    await tryCaptureFcmLaunchMessage();
    await captureTerminatedNotificationLaunch();

    if (!isNavigationReady) {
      markNavigationReady();
    } else {
      schedulePendingNotificationClick(delayMs: delayMs);
    }

    Future.delayed(Duration(milliseconds: delayMs + 500), () {
      if (_pendingNotificationData != null) {
        schedulePendingNotificationClick(delayMs: 200);
      }
    });
  }

  void processPendingNotificationClick() {
    if (_pendingNotificationData == null || !canHandleNavigation) return;
    debugPrint('[PUSH][pending] processing click: $_pendingNotificationData');
    final data = Map<String, dynamic>.from(_pendingNotificationData!);
    _pendingNotificationData = null;
    _executeNotificationClick(data);
  }

  /// Request permissions for iOS and Android 13+
  Future<bool> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    log('Current notification permission status: $status');

    if (status.isGranted) {
      await refreshFcmToken();
      onTokenRefreshed?.call();
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showSettingsDialog();
      return false;
    }

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('Firebase Messaging permission granted');
      await refreshFcmToken();
      onTokenRefreshed?.call();
      return true;
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return false;
    }

    final requestStatus = await Permission.notification.request();
    log('Permission handler requested notification status: $requestStatus');
    if (requestStatus.isGranted) {
      await refreshFcmToken();
      onTokenRefreshed?.call();
      return true;
    } else if (requestStatus.isPermanentlyDenied) {
      _showSettingsDialog();
    }
    return false;
  }

  void _showSettingsDialog() {
    final targetContext = Get.context;
    if (targetContext == null) {
      log("Unable to show settings dialog: BuildContext is null");
      return;
    }

    BaseDialog.showAlertDialog(
      context: targetContext,
      title: "Notification Permission Required",
      description:
          "Notifications are currently disabled. Please enable them in system settings to receive plant care reminders.",
      buttonLabel: "Open Settings",
      onButtonPressed: () {
        Get.back();
        openAppSettings();
      },
    );
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    if (!areNotificationsEnabled) {
      debugPrint('[PUSH][local show] skipped: notifications disabled in settings');
      return;
    }

    debugPrint('[PUSH][local show] title=$title | body=$body | payload=$payload');

    final androidDetails = _buildAndroidNotificationDetails();

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: _iosNotificationDetails,
    );

    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: payload,
    );
  }

  void _setupMessageListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final payload = normalizeNotificationPayload(message);
      _logPushNotification('foreground', message, payload);

      onForegroundMessage?.call(message, payload);

      if (!areNotificationsEnabled) {
        debugPrint('[PUSH][foreground] skipped display: notifications disabled in settings');
        return;
      }
      _presentForegroundNotification(message, payload);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final payload = normalizeNotificationPayload(message);
      _logPushNotification('opened_from_background', message, payload);
      _prepareForBackgroundNotificationTap();
      _dispatchNotificationClick(payload);
    });
  }

  Future<void> _presentForegroundNotification(
    RemoteMessage message,
    Map<String, dynamic> payload,
  ) async {
    final notification = message.notification;
    if (notification != null) {
      await showLocalNotification(
        title: notification.title ?? payload['title']?.toString() ?? '',
        body: notification.body ?? payload['body']?.toString() ?? '',
        payload: jsonEncode(payload),
        id: notification.hashCode,
      );
      return;
    }

    final title = payload['title']?.toString();
    final body = payload['body']?.toString() ?? payload['message']?.toString();
    if (title != null && body != null && title.isNotEmpty && body.isNotEmpty) {
      await showLocalNotification(
        title: title,
        body: body,
        payload: jsonEncode(payload),
        id: message.hashCode,
      );
    }
  }

  Future<void> _captureLocalNotificationLaunch() async {
    final launchDetails = await _localNotifications.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payloadString = launchDetails!.notificationResponse?.payload;
      if (payloadString != null && payloadString.isNotEmpty) {
        try {
          final data = Map<String, dynamic>.from(jsonDecode(payloadString));
          setPendingNotificationData(data);
          debugPrint('[PUSH][cold_start] stored local notification launch payload');
        } catch (e) {
          log('Error parsing local notification launch payload: $e');
        }
      }
    }
  }

  void _handleNotificationClick(String? payloadString) {
    if (payloadString == null || payloadString.isEmpty) {
      debugPrint('[PUSH][click] skipped: empty payload');
      return;
    }
    try {
      final Map<String, dynamic> data = jsonDecode(payloadString);
      _dispatchNotificationClick(data);
    } catch (e) {
      log('Error handling notification click: $e');
      debugPrint('[PUSH][click] error parsing payload: $e | raw=$payloadString');
    }
  }

  void _prepareForBackgroundNotificationTap() {
    _isNavigationReady = true;
    debugPrint('[PUSH][background tap] navigation marked ready');
  }

  void _dispatchNotificationClick(Map<String, dynamic> data) {
    debugPrint('[PUSH][click] payload: $data');
    log('Processing notification click payload: $data');
    setPendingNotificationData(data);
    _prepareForBackgroundNotificationTap();

    if (canHandleNavigation) {
      processPendingNotificationClick();
      return;
    }

    schedulePendingNotificationClick(delayMs: 500);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (_pendingNotificationData != null) {
        schedulePendingNotificationClick(delayMs: 200);
      }
    });
  }

  void _executeNotificationClick(Map<String, dynamic> data) {
    debugPrint('[PUSH][click] executing payload: $data');

    if (onNotificationClick != null) {
      onNotificationClick!(data);
      return;
    }

    final String? route = data['route'] ?? data['screen'];
    if (route != null && route.isNotEmpty) {
      Get.toNamed(route, arguments: data['arguments'] ?? data);
    }
  }

  Future<String?> refreshFcmToken() async {
    try {
      final token = await _messaging.getToken();
      log("FCM TOKEN: $token");
      if (token != null) {
        await SharedPrefsService.instance.setString(AppKeys.fcmToken, token);
      }
      return token;
    } catch (e) {
      log("Error fetching FCM token: $e");
      return null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionAndRetrieveTokenOnResume();
      _prepareForBackgroundNotificationTap();
      consumePersistedNotificationTap().then((_) {
        onAppResumed?.call();
        schedulePendingNotificationClick(delayMs: 300);
      });
    }
  }

  Future<void> _checkPermissionAndRetrieveTokenOnResume() async {
    final status = await Permission.notification.status;
    if (status.isGranted) {
      await refreshFcmToken();
      onTokenRefreshed?.call();
    }
  }
}
