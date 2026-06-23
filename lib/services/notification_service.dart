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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");

  if (message.notification != null) return;

  final data = message.data;
  final title = data['title']?.toString();
  final body = data['body']?.toString() ?? data['message']?.toString();
  if (title == null || body == null || title.isEmpty || body.isEmpty) return;

  final plugin = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
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

  final androidDetails = AndroidNotificationDetails(
    _reminderChannel.id,
    _reminderChannel.name,
    channelDescription: _reminderChannel.description,
    importance: Importance.high,
    priority: Priority.high,
    playSound: true,
    icon: '@mipmap/ic_launcher',
  );

  await plugin.show(
    id: message.hashCode,
    title: title,
    body: body,
    notificationDetails: NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),
    payload: jsonEncode(data),
  );
}

class NotificationService with WidgetsBindingObserver {
  NotificationService._privateConstructor();

  static final NotificationService instance =
      NotificationService._privateConstructor();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  void Function(Map<String, dynamic>)? onNotificationClick;
  void Function(RemoteMessage)? onForegroundMessage;
  VoidCallback? onTokenRefreshed;

  Map<String, dynamic>? _pendingNotificationData;

  bool get canHandleNavigation => Get.key.currentContext != null;

  /// Initialize Firebase Messaging & Local Notifications
  Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    WidgetsBinding.instance.addObserver(this);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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

  void setPendingNotificationData(Map<String, dynamic> data) {
    _pendingNotificationData = data;
  }

  void processPendingNotificationClick() {
    if (_pendingNotificationData == null) return;
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
    if (!areNotificationsEnabled) return;

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _reminderChannel.id,
          _reminderChannel.name,
          channelDescription: _reminderChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
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
      log('FCM Foreground message received: ${message.messageId}');
      log('Message data: ${message.data}');

      onForegroundMessage?.call(message);

      if (!areNotificationsEnabled) return;

      final notification = message.notification;
      if (notification != null) {
        showLocalNotification(
          title: notification.title ?? '',
          body: notification.body ?? '',
          payload: jsonEncode(message.data),
          id: notification.hashCode,
        );
        return;
      }

      final title = message.data['title']?.toString();
      final body =
          message.data['body']?.toString() ?? message.data['message']?.toString();
      if (title != null && body != null && title.isNotEmpty && body.isNotEmpty) {
        showLocalNotification(
          title: title,
          body: body,
          payload: jsonEncode(message.data),
          id: message.hashCode,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('FCM message clicked (app was in background): ${message.messageId}');
      _handleNotificationClick(jsonEncode(message.data));
    });
  }

  Future<void> _captureInitialMessage() async {
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      log(
        'FCM message clicked (app was terminated): ${initialMessage.messageId}',
      );
      _pendingNotificationData = Map<String, dynamic>.from(initialMessage.data);
    }
  }

  void _handleNotificationClick(String? payloadString) {
    if (payloadString == null || payloadString.isEmpty) return;
    try {
      final Map<String, dynamic> data = jsonDecode(payloadString);
      _dispatchNotificationClick(data);
    } catch (e) {
      log("Error handling notification click: $e");
    }
  }

  void _dispatchNotificationClick(Map<String, dynamic> data) {
    log("Processing notification click payload: $data");

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
