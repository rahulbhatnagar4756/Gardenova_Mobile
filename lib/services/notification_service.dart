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

const String _androidNotificationIcon = 'ic_stat_notify';
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
    priority: Priority.max,
    playSound: true,
    icon: _androidNotificationIcon,
    color: _androidNotificationAccentColor,
    category: AndroidNotificationCategory.reminder,
    visibility: NotificationVisibility.public,
    autoCancel: true,
  );
}

void _logPush(String stage, String message) {
  final line = '[PUSH][$stage] $message';
  debugPrint(line);
  log(line, name: 'PUSH');
}

String _summarizeRemoteMessage(RemoteMessage message) {
  final title = message.notification?.title ?? message.data['title'] ?? '';
  final body = message.notification?.body ?? message.data['body'] ?? message.data['message'] ?? '';
  return 'id=${message.messageId} hasNotification=${message.notification != null} '
      'title="$title" body="$body" data=${message.data}';
}

@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse response) async {
  final payload = response.payload;
  _logPush('tap', 'background local tap payload=$payload');
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
  _logPush('received', 'background ${_summarizeRemoteMessage(message)}');

  final prefs = await SharedPreferences.getInstance();
  final notificationsEnabled = prefs.getBool(AppKeys.notificationsEnabled) ?? true;
  if (!notificationsEnabled) {
    _logPush('skipped', 'background — notifications disabled in prefs');
    return;
  }

  final title = NotificationService.extractNotificationTitle(message, payload);
  final body = NotificationService.extractNotificationBody(message, payload);
  if (title == null || body == null || title.isEmpty || body.isEmpty) {
    _logPush('skipped', 'background — missing title/body payload=$payload');
    return;
  }
  if (message.notification != null) {
    _logPush('skipped', 'background — OS/native will display notification payload');
    return;
  }

  final plugin = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings(_androidNotificationIcon);
  const iosSettings = DarwinInitializationSettings();
  await plugin.initialize(
    settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  final id = NotificationService.notificationIdFor(message, payload);
  await plugin.show(
    id: id,
    title: title,
    body: ellipsizeNotificationBody(body),
    notificationDetails: NotificationDetails(
      android: _buildAndroidNotificationDetails(),
      iOS: _iosNotificationDetails,
    ),
    payload: jsonEncode(payload),
  );
  _logPush('shown', 'user received notification (background local) id=$id title="$title"');
}

class NotificationService with WidgetsBindingObserver {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

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

  static void registerBackgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

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
          _logPush('tap', 'local tray payload=${response.payload}');
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
      // iOS: present the system banner while the app is open. Android ignores this
      // API; foreground Android display is handled in onMessage / native FCM service.
      await toggleForegroundNotifications(true);
      _registerAndroidTapHandler();

      _onMessageSubscription?.cancel();
      _onMessageOpenedAppSubscription?.cancel();

      _onMessageSubscription = FirebaseMessaging.onMessage.listen(_handleForegroundRemoteMessage);

      _onMessageOpenedAppSubscription = FirebaseMessaging.onMessageOpenedApp.listen((
        RemoteMessage message,
      ) {
        _logPush('tap', 'opened from background ${_summarizeRemoteMessage(message)}');
        _lastRemoteMessage = message;
        _deliverNotificationTap(message: message);
      });

      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _logPush('tap', 'cold start ${_summarizeRemoteMessage(initialMessage)}');
        _lastRemoteMessage = initialMessage;
        _pendingNotificationData = normalizeNotificationPayload(initialMessage);
      }

      await _captureLocalNotificationLaunch();
      unawaited(refreshFcmToken());
      _logPush('init', 'listeners ready platform=${Platform.operatingSystem}');
    } catch (e, stack) {
      _logPush('error', 'Notification init failed: $e');
      log('Notification init failed: $e', stackTrace: stack);
    }
  }

  void _handleForegroundRemoteMessage(RemoteMessage message) {
    _logPush('received', 'foreground ${_summarizeRemoteMessage(message)}');
    _lastRemoteMessage = message;

    final payload = normalizeNotificationPayload(message);
    onForegroundMessage?.call(message, payload);
    _presentForegroundNotification(message, payload);
  }

  void _handleNativeForegroundPush(String raw) {
    try {
      final payload = Map<String, dynamic>.from(jsonDecode(raw));
      final message = RemoteMessage(data: Map<String, dynamic>.from(payload));
      _lastRemoteMessage = message;
      onForegroundMessage?.call(message, payload);
    } catch (e) {
      log('Failed to parse native foreground push: $e');
    }
  }

  void _presentForegroundNotification(RemoteMessage message, Map<String, dynamic> payload) {
    if (!areNotificationsEnabled) {
      _logPush('skipped', 'foreground — notifications disabled in prefs');
      return;
    }

    if (Get.currentRoute == Routes.plantRemindersListing && _isReminderNotification(payload)) {
      _logPush('skipped', 'foreground — already on reminders listing');
      return;
    }

    final title = extractNotificationTitle(message, payload);
    final body = extractNotificationBody(message, payload);
    if (title == null || body == null || title.isEmpty || body.isEmpty) {
      _logPush('skipped', 'foreground — missing title/body payload=$payload');
      return;
    }

    if (Platform.isIOS && message.notification != null) {
      _logPush('shown', 'user received notification (iOS system banner) title="$title"');
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _logPush('show', 'foreground posting tray title="$title"');
      showNotification(
        title: title,
        body: body,
        payload: jsonEncode(payload),
        id: notificationIdFor(message, payload),
      );
    });
  }

  static String? extractNotificationTitle(RemoteMessage message, Map<String, dynamic> payload) {
    return _firstNonEmpty([
      message.notification?.title,
      payload['title'],
      payload['notification_title'],
      payload['Title'],
    ]);
  }

  static String? extractNotificationBody(RemoteMessage message, Map<String, dynamic> payload) {
    return _firstNonEmpty([
      message.notification?.body,
      payload['body'],
      payload['message'],
      payload['notification_body'],
      payload['Body'],
    ]);
  }

  static String? _firstNonEmpty(List<dynamic> values) {
    for (final value in values) {
      final text = value?.toString().trim();
      if (text != null && text.isNotEmpty) return text;
    }
    return null;
  }

  static int notificationIdFor(RemoteMessage message, Map<String, dynamic> payload) {
    final logId = payload['notification_log_id']?.toString();
    if (logId != null && logId.isNotEmpty) return logId.hashCode;
    return message.messageId?.hashCode ?? message.hashCode;
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
        _logPush('tap', 'native payload=$payload');
        if (payload != null && payload.isNotEmpty) {
          _deliverNotificationTap(payload: payload);
        }
        return null;
      }
      if (call.method == 'onForegroundPush') {
        final raw = call.arguments?.toString();
        _logPush('received', 'native foreground payload=$raw');
        if (raw != null && raw.isNotEmpty) {
          _handleNativeForegroundPush(raw);
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
    if (!areNotificationsEnabled) {
      _logPush('skipped', 'showNotification — notifications disabled');
      return;
    }

    final displayBody = ellipsizeNotificationBody(body);

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
    _logPush('shown', 'user received notification (local plugin) id=$id title="$title"');
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

  bool _permissionDialogOpen = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _closePermissionDialogIfGranted();
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

  Future<bool> _isNotificationGranted() async {
    final status = await Permission.notification.status;
    if (status.isGranted) return true;
    try {
      final settings = await _firebaseMessaging.getNotificationSettings();
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      _logPush('error', 'getNotificationSettings failed: $e');
      return false;
    }
  }

  Future<void> _waitForAndroidActivity({int attempts = 20}) async {
    for (var i = 0; i < attempts; i++) {
      final ctx = Get.overlayContext ?? Get.context;
      if (ctx != null && ctx.mounted) {
        await WidgetsBinding.instance.endOfFrame;
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  bool _isMissingActivityError(Object error) {
    return error.toString().contains('Unable to detect current Android Activity');
  }

  Future<bool> _tryRequestOsPermission() async {
    if (await _isNotificationGranted()) {
      await _markGranted();
      return true;
    }

    final status = await Permission.notification.status;
    if (status.isPermanentlyDenied) return false;

    for (var attempt = 0; attempt < 12; attempt++) {
      await _waitForAndroidActivity();
      try {
        // Android 13+ POST_NOTIFICATIONS. Do not call FCM requestPermission on
        // Android — it crashes if the Activity is not attached yet.
        if (Platform.isAndroid) {
          final requestStatus = await Permission.notification.request();
          if (requestStatus.isGranted) {
            await _markGranted();
            return true;
          }
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
          await _markGranted();
          return true;
        }

        final requestStatus = await Permission.notification.request();
        if (requestStatus.isGranted) {
          await _markGranted();
          return true;
        }
        return false;
      } catch (e) {
        if (_isMissingActivityError(e) && attempt < 11) {
          _logPush('error', 'permission prompt before Activity ready, retry ${attempt + 1}');
          await Future.delayed(Duration(milliseconds: 250 * (attempt + 1)));
          continue;
        }
        _logPush('error', 'OS permission request failed: $e');
        return false;
      }
    }
    return false;
  }

  Future<void> _markGranted() async {
    await refreshFcmToken();
    onTokenRefreshed?.call();
  }

  Future<bool> isNotificationGranted() => _isNotificationGranted();

  /// Requests the OS prompt when possible. If denied, shows a skippable
  /// settings popup and then continues into the app.
  Future<bool> ensureNotificationPermissionGranted() {
    return requestNotificationPermission();
  }

  Future<bool> requestNotificationPermission() async {
    try {
      if (await _tryRequestOsPermission()) {
        await _persistNotificationsEnabled(true);
        return true;
      }
      await _showSettingsDialog();
      if (await _isNotificationGranted()) {
        await _markGranted();
        await _persistNotificationsEnabled(true);
        return true;
      }
      await _persistNotificationsEnabled(false);
      return false;
    } catch (e, stack) {
      _logPush('error', 'requestNotificationPermission failed: $e');
      log('requestNotificationPermission failed: $e', stackTrace: stack);
      return false;
    }
  }

  Future<void> _persistNotificationsEnabled(bool enabled) async {
    await SharedPrefsService.instance.setBool(
      AppKeys.notificationsEnabled,
      enabled,
    );
  }

  Future<void> _closePermissionDialogIfGranted() async {
    if (!_permissionDialogOpen) return;
    if (!await _isNotificationGranted()) return;
    final ctx = Get.overlayContext ?? Get.context;
    if (ctx != null && Navigator.of(ctx, rootNavigator: true).canPop()) {
      Navigator.of(ctx, rootNavigator: true).pop();
    }
  }

  Future<void> _showSettingsDialog() async {
    if (_permissionDialogOpen) return;

    BuildContext? targetContext = Get.overlayContext ?? Get.context;
    for (var i = 0; i < 30 && targetContext == null; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      targetContext = Get.overlayContext ?? Get.context;
    }
    if (targetContext == null) {
      await Future.delayed(const Duration(milliseconds: 200));
      return;
    }

    _permissionDialogOpen = true;
    await BaseDialog.showAlertDialog(
      context: targetContext,
      barrierDismissible: false,
      showCancel: true,
      canPop: true,
      title: 'Enable Notifications',
      description:
          'Notifications are currently disabled. Enable them in system settings to receive plant care reminders, or continue without them.',
      buttonLabel: 'Open Settings',
      onButtonPressed: () {
        openAppSettings();
      },
    );
    _permissionDialogOpen = false;
  }

  Future<String?> refreshFcmToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      _logPush('token', 'FCM token=${token ?? "(null)"}');
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
