import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import 'package:permission_handler/permission_handler.dart';

const AndroidNotificationChannel _reminderChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important notifications.',
  importance: Importance.high,
  playSound: true,
);

const String _androidNotificationIcon = 'ic_notification';
const String _androidNotificationLargeIcon = '@mipmap/ic_launcher';
const Color _androidNotificationAccentColor = Color(0xFF01AF55);

AndroidNotificationDetails _buildAndroidNotificationDetails() {
  return AndroidNotificationDetails(
    _reminderChannel.id,
    _reminderChannel.name,
    channelDescription: _reminderChannel.description,
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    icon: _androidNotificationIcon,
    largeIcon: const DrawableResourceAndroidBitmap(_androidNotificationLargeIcon),
    color: _androidNotificationAccentColor,
  );
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
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final payload = normalizeNotificationPayload(message);
  _logPushNotification('background', message, payload);

  if (!NotificationService.areNotificationsEnabledInPrefs()) {
    debugPrint('[PUSH][background] skipped: notifications disabled in settings');
    return;
  }

  final title = payload['title']?.toString();
  final body = payload['body']?.toString() ?? payload['message']?.toString();
  if (title == null || body == null || title.isEmpty || body.isEmpty) {
    debugPrint('[PUSH][background] skipped: missing title/body');
    return;
  }

  // Notification payload is shown by the OS when present; show local only for data-only.
  if (message.notification != null) {
    debugPrint('[PUSH][background] skipped local show: OS handles notification payload');
    return;
  }

  debugPrint('[PUSH][background] showing local notification');
  final plugin = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings(_androidNotificationIcon);
  const iosSettings = DarwinInitializationSettings();
  await plugin.initialize(
    settings: const InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    ),
  );

  await plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(_reminderChannel);

  final androidDetails = _buildAndroidNotificationDetails();

  await plugin.show(
    id: message.hashCode,
    title: title,
    body: body,
    notificationDetails: NotificationDetails(
      android: androidDetails,
      iOS: _iosNotificationDetails,
    ),
    payload: jsonEncode(payload),
  );
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

  return payload;
}

class NotificationService with WidgetsBindingObserver {
  NotificationService._privateConstructor();

  static final NotificationService instance =
      NotificationService._privateConstructor();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  void Function(Map<String, dynamic>)? onNotificationClick;
  void Function(RemoteMessage, Map<String, dynamic>)? onForegroundMessage;
  VoidCallback? onTokenRefreshed;
  VoidCallback? onAppResumed;

  Map<String, dynamic>? _pendingNotificationData;
  bool _isNavigationReady = false;

  bool get canHandleNavigation =>
      _isNavigationReady && Get.key.currentContext != null;

  void markNavigationReady() {
    _isNavigationReady = true;
    processPendingNotificationClick();
  }

  /// Initialize Firebase Messaging & Local Notifications
  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    WidgetsBinding.instance.addObserver(this);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(_androidNotificationIcon);

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('[PUSH][local tap] payload=${response.payload}');
        _handleNotificationClick(response.payload);
      },
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_reminderChannel);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _setupMessageListeners();
    await _captureInitialMessage();
    await refreshFcmToken();
  }

  bool get areNotificationsEnabled =>
      SharedPrefsService.instance.getBool(AppKeys.notificationsEnabled) ?? true;

  static bool areNotificationsEnabledInPrefs() =>
      SharedPrefsService.instance.getBool(AppKeys.notificationsEnabled) ?? true;

  void setPendingNotificationData(Map<String, dynamic> data) {
    _pendingNotificationData = data;
  }

  void processPendingNotificationClick() {
    if (_pendingNotificationData == null) return;
    debugPrint('[PUSH][cold_start] processing pending click: $_pendingNotificationData');
    final data = Map<String, dynamic>.from(_pendingNotificationData!);
    _pendingNotificationData = null;
    _dispatchNotificationClick(data);
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

  Future<void> _captureInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      final payload = normalizeNotificationPayload(initialMessage);
      _logPushNotification('cold_start', initialMessage, payload);
      _pendingNotificationData = payload;
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

  void _dispatchNotificationClick(Map<String, dynamic> data) {
    debugPrint('[PUSH][click] processing payload: $data');
    log('Processing notification click payload: $data');

    if (!canHandleNavigation) {
      setPendingNotificationData(data);
      return;
    }

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
      onAppResumed?.call();
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
