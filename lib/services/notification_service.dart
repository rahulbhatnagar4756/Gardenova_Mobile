import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
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
const int kMaxNotificationBodyWords = 100;

String ellipsizeNotificationBody(String body, {int maxWords = kMaxNotificationBodyWords}) {
  final trimmed = body.trim();
  if (trimmed.isEmpty) return trimmed;

  final words = trimmed.split(RegExp(r'\s+'));
  if (words.length <= maxWords) return trimmed;

  return '${words.take(maxWords).join(' ')}...';
}

const AndroidNotificationChannel _reminderChannel = AndroidNotificationChannel(
  kReminderNotificationChannelId,
  'Plant Reminders',
  description: 'Plant care reminder notifications',
  importance: Importance.max,
  playSound: true,
);

const String _androidNotificationIcon = 'ic_notification';
const Color _androidNotificationAccentColor = Color(0xFF01AF55);

const DarwinNotificationDetails _iosNotificationDetails = DarwinNotificationDetails(
  presentAlert: true,
  presentBadge: true,
  presentSound: true,
);

AndroidNotificationDetails _buildAndroidNotificationDetails() {
  return AndroidNotificationDetails(
    _reminderChannel.id,
    _reminderChannel.name,
    channelDescription: _reminderChannel.description,
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    icon: _androidNotificationIcon,
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

  final payload = NotificationService.normalizeNotificationPayload(message);
  debugPrint('[PUSH][background] data=$payload');

  final prefs = await SharedPreferences.getInstance();
  final notificationsEnabled = prefs.getBool(AppKeys.notificationsEnabled) ?? true;
  if (!notificationsEnabled) return;

  // Android background tray display is handled by GardenovaMessagingReceiver.
  if (Platform.isAndroid) return;

  final title = payload['title']?.toString();
  final body = payload['body']?.toString() ?? payload['message']?.toString();
  if (title == null || body == null || title.isEmpty || body.isEmpty) return;
  if (message.notification != null) return;

  final plugin = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings(_androidNotificationIcon);
  const iosSettings = DarwinInitializationSettings();
  await plugin.initialize(
    settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  await plugin.show(
    id: message.messageId?.hashCode ?? message.hashCode,
    title: title,
    body: ellipsizeNotificationBody(body),
    notificationDetails: NotificationDetails(
      android: _buildAndroidNotificationDetails(),
      iOS: _iosNotificationDetails,
    ),
    payload: jsonEncode(payload),
  );
}

class NotificationService with WidgetsBindingObserver {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const MethodChannel _androidPushChannel = MethodChannel('com.gardenova.digisoft/push');
  static const MethodChannel _androidPushEventsChannel = MethodChannel(
    'com.gardenova.digisoft/push_events',
  );

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  RemoteMessage? _lastRemoteMessage;
  Timer? _debounce;
  StreamSubscription<RemoteMessage>? _onMessageSubscription;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSubscription;

  Map<String, dynamic>? _pendingNotificationData;
  Future<void>? _initializationFuture;

  void Function(Map<String, dynamic>)? onNotificationClick;
  void Function(RemoteMessage, Map<String, dynamic>)? onForegroundMessage;
  VoidCallback? onTokenRefreshed;
  VoidCallback? onAppResumed;

  bool get areNotificationsEnabled =>
      SharedPrefsService.instance.getBool(AppKeys.notificationsEnabled) ?? true;

  static bool areNotificationsEnabledInPrefs() =>
      SharedPrefsService.instance.getBool(AppKeys.notificationsEnabled) ?? true;

  Future<void> initialize() {
    _initializationFuture ??= _initializeInternal();
    return _initializationFuture!;
  }

  Future<void> _initializeInternal() async {
    try {
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      WidgetsBinding.instance.addObserver(this);

      const androidSettings = AndroidInitializationSettings(_androidNotificationIcon);
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

      await _localNotifications.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('[PUSH][local tap] payload=${response.payload}');
          if (response.payload != null && response.payload!.isNotEmpty) {
            _deliverNotificationTap(payload: response.payload);
            return;
          }
          if (_lastRemoteMessage != null) {
            _deliverNotificationTap(message: _lastRemoteMessage);
          }
        },
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      await _ensureAndroidNotificationChannel();
      // Disable default foreground notification display because we handle it manually
      // in the onMessage listener to avoid duplicates.
      await toggleForegroundNotifications(false);
      _registerAndroidTapHandler();

      _onMessageSubscription?.cancel();
      _onMessageOpenedAppSubscription?.cancel();

      _onMessageSubscription = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint('[PUSH][foreground] data=${message.data}');
        _lastRemoteMessage = message;

        final payload = normalizeNotificationPayload(message);
        onForegroundMessage?.call(message, payload);

        if (!areNotificationsEnabled) return;

        final notification = message.notification;
        final title = notification?.title ?? payload['title']?.toString();
        final body =
            notification?.body ?? payload['body']?.toString() ?? payload['message']?.toString();
        if (title == null || body == null || title.isEmpty || body.isEmpty) return;

        if (Platform.isAndroid) {
          _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            if (Get.currentRoute == Routes.plantRemindersListing &&
                _isReminderNotification(payload)) {
              return;
            }
            showNotification(
              title: title,
              body: body,
              payload: jsonEncode(payload),
              id: message.messageId?.hashCode ?? message.hashCode,
            );
          });
        }
      });

      _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
        RemoteMessage message,
      ) {
        debugPrint('[PUSH][opened_from_background] data=${message.data}');
        _lastRemoteMessage = message;
        _deliverNotificationTap(message: message);
      });

      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('[PUSH][cold_start] app opened from notification');
        _lastRemoteMessage = initialMessage;
        _pendingNotificationData = normalizeNotificationPayload(initialMessage);
      }

      await _captureLocalNotificationLaunch();
      unawaited(refreshFcmToken());
    } catch (e, stack) {
      log('Notification init failed: $e', stackTrace: stack);
    }
  }

  static Map<String, dynamic> normalizeNotificationPayload(RemoteMessage message) {
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

    if (!hasReminderData) {
      payload.putIfAbsent('type', () => 'plant_reminder');
      payload.putIfAbsent('route', () => Routes.plantRemindersListing);
    }

    return payload;
  }

  Future<void> toggleForegroundNotifications(bool show) async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: show,
      badge: show,
      sound: show,
    );
  }

  void _registerAndroidTapHandler() {
    if (!Platform.isAndroid) return;

    _androidPushEventsChannel.setMethodCallHandler((call) async {
      if (call.method == 'onNotificationTap') {
        final payload = call.arguments?.toString();
        debugPrint('[PUSH][native tap] payload=$payload');
        if (payload != null && payload.isNotEmpty) {
          _deliverNotificationTap(payload: payload);
        }
      }
      return null;
    });
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    int id = 10,
  }) async {
    if (!areNotificationsEnabled) return;

    final displayBody = ellipsizeNotificationBody(body);

    if (Platform.isAndroid) {
      try {
        await _androidPushChannel.invokeMethod<void>('showNotification', {
          'title': title,
          'body': displayBody,
          'payload': payload ?? '',
          'id': id,
        });
        return;
      } catch (e) {
        log('Native Android notification failed, falling back to local plugin: $e');
      }
    }

    await _localNotifications.show(
      id: id,
      title: title,
      body: displayBody,
      notificationDetails: NotificationDetails(
        android: _buildAndroidNotificationDetails(),
        iOS: _iosNotificationDetails,
      ),
      payload: payload,
    );
  }

  void setPendingNotificationData(Map<String, dynamic> data) {
    _pendingNotificationData = Map<String, dynamic>.from(data);
  }

  Future<void> consumePersistedNotificationTap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(AppKeys.pendingNotificationPayload);
      if (raw == null || raw.isEmpty) return;

      await prefs.remove(AppKeys.pendingNotificationPayload);
      _pendingNotificationData = Map<String, dynamic>.from(jsonDecode(raw));
      debugPrint('[PUSH][persisted] loaded tap payload: $_pendingNotificationData');
    } catch (e) {
      log('Failed to consume persisted notification tap: $e');
    }
  }

  Future<void> processLaunchNavigation() async {
    if (_pendingNotificationData == null) return;

    final data = Map<String, dynamic>.from(_pendingNotificationData!);
    _pendingNotificationData = null;
    _deliverNotificationTap(data: data);
  }

  void _deliverNotificationTap({
    RemoteMessage? message,
    String? payload,
    Map<String, dynamic>? data,
  }) {
    Map<String, dynamic> tapData;
    try {
      if (data != null) {
        tapData = data;
      } else if (message != null) {
        tapData = normalizeNotificationPayload(message);
      } else if (payload != null && payload.isNotEmpty) {
        tapData = Map<String, dynamic>.from(jsonDecode(payload));
      } else {
        debugPrint('[PUSH][click] No data found to deliver');
        return;
      }
    } catch (e) {
      log('Error parsing notification tap: $e');
      return;
    }

    debugPrint('[PUSH][click] Delivering tap: $tapData');
    _executeNotificationTap(tapData);

    if (Get.key.currentContext != null) return;

    for (final delayMs in [300, 600, 1200, 2000]) {
      Future.delayed(Duration(milliseconds: delayMs), () {
        _executeNotificationTap(tapData);
      });
    }
  }

  void _executeNotificationTap(Map<String, dynamic> tapData) {
    debugPrint('[PUSH][execute] Executing tap for route: ${tapData['route']}');
    if (onNotificationClick != null) {
      debugPrint('[PUSH][execute] Using onNotificationClick callback');
      onNotificationClick!(tapData);
      return;
    }

    final route = tapData['route'] ?? tapData['screen'];
    if (route != null && route.isNotEmpty) {
      debugPrint('[PUSH][execute] Navigating to: $route');
      Get.toNamed(route, arguments: tapData);
    } else {
      debugPrint('[PUSH][execute] No route found in tapData');
    }
  }

  Future<void> _captureLocalNotificationLaunch() async {
    final launchDetails = await _localNotifications.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payloadString = launchDetails!.notificationResponse?.payload;
      if (payloadString != null && payloadString.isNotEmpty) {
        try {
          _pendingNotificationData = Map<String, dynamic>.from(jsonDecode(payloadString));
        } catch (e) {
          log('Error parsing local notification launch payload: $e');
        }
      }
    }
  }

  bool _isReminderNotification(Map<String, dynamic> data) {
    final type = data['type'] ?? data['notification_type'] ?? data['category'] ?? data['action'];
    return type == 'plant_reminder' ||
        type == 'reminder' ||
        data['action'] == 'plant_reminder' ||
        data['route'] == Routes.plantRemindersListing;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleResumeIfNeeded();
    }
  }

  Future<void> _handleResumeIfNeeded() async {
    await consumePersistedNotificationTap();
    if (_pendingNotificationData != null) {
      debugPrint('[PUSH][lifecycle] app resumed — processing notification tap');
      final data = Map<String, dynamic>.from(_pendingNotificationData!);
      _pendingNotificationData = null;
      _deliverNotificationTap(data: data);
    }
    onAppResumed?.call();
  }

  Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) {
      await refreshFcmToken();
      onTokenRefreshed?.call();
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showSettingsDialog();
      return false;
    }

    final settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      await refreshFcmToken();
      onTokenRefreshed?.call();
      return true;
    }

    final requestStatus = await Permission.notification.request();
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
    if (targetContext == null) return;

    BaseDialog.showAlertDialog(
      context: targetContext,
      title: 'Notification Permission Required',
      description:
          'Notifications are currently disabled. Please enable them in system settings to receive plant care reminders.',
      buttonLabel: 'Open Settings',
      onButtonPressed: () {
        Get.back();
        openAppSettings();
      },
    );
  }

  Future<String?> refreshFcmToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      log('FCM TOKEN: $token');
      if (token != null) {
        await SharedPrefsService.instance.setString(AppKeys.fcmToken, token);
      }
      return token;
    } catch (e) {
      log('Error fetching FCM token: $e');
      return null;
    }
  }
}
