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

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling a background message: ${message.messageId}");
}

class NotificationService with WidgetsBindingObserver {
  NotificationService._privateConstructor();

  static final NotificationService instance =
      NotificationService._privateConstructor();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  void Function(Map<String, dynamic>)? onNotificationClick;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // name
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true,
  );

  /// Initialize Firebase Messaging & Local Notifications
  Future<void> initialize() async {
    // 1. Set background messaging handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 2. Add lifecycle observer
    WidgetsBinding.instance.addObserver(this);

    // 2. Initialize Local Notifications
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

    // 3. Create Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // 4. Configure foreground messaging options
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 5. Setup event listeners for messages
    _setupMessageListeners();

    // 6. Handle app launch from terminated state via notification click
    _handleInitialMessage();

    // 7. Log FCM token (useful for debugging)
    _logFcmToken();
  }

  /// Request permissions for iOS and Android 13+
  Future<bool> requestNotificationPermission() async {
    // Check current status
    PermissionStatus status = await Permission.notification.status;
    log('Current notification permission status: $status');

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      _showSettingsDialog();
      return false;
    }

    // Request permission via Firebase Messaging
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('Firebase Messaging permission granted');
      return true;
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      // _showSettingsDialog();
      return false;
    }

    // Fallback/secondary prompt via permission_handler (mostly for Android 13+ runtime prompt)
    final requestStatus = await Permission.notification.request();
    log('Permission handler requested notification status: $requestStatus');
    if (requestStatus.isGranted) {
      return true;
    } else if (requestStatus.isPermanentlyDenied) {
      _showSettingsDialog();
    }
    return false;
  }

  /// Helper to show settings redirection dialog
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
          "Notifications are currently disabled. Please enable them in system settings to receive updates and alerts.",
      buttonLabel: "Open Settings",
      onButtonPressed: () {
        Get.back();
        openAppSettings();
      },
    );
  }

  /// Fire a local notification manually
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int id = 0,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
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

  /// Set up listeners for FCM message events
  void _setupMessageListeners() {
    // Triggered when a message is received in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('FCM Foreground message received: ${message.messageId}');
      log('Message data: ${message.data}');

      RemoteNotification? notification = message.notification;
      if (notification != null) {
        showLocalNotification(
          title: notification.title ?? "",
          body: notification.body ?? "",
          payload: jsonEncode(message.data),
          id: notification.hashCode,
        );
      }
    });

    // Triggered when a background FCM message notification is clicked
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('FCM message clicked (app was in background): ${message.messageId}');
      _handleNotificationClick(jsonEncode(message.data));
    });
  }

  /// Handles app launch from terminated state via notification click
  Future<void> _handleInitialMessage() async {
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      log(
        'FCM message clicked (app was terminated): ${initialMessage.messageId}',
      );
      _handleNotificationClick(jsonEncode(initialMessage.data));
    }
  }

  /// Handler for notification clicks
  void _handleNotificationClick(String? payloadString) {
    if (payloadString == null || payloadString.isEmpty) return;
    try {
      final Map<String, dynamic> data = jsonDecode(payloadString);
      log("Processing notification click payload: $data");

      // 1. Invoke custom callback if registered
      if (onNotificationClick != null) {
        onNotificationClick!(data);
        return;
      }

      // 2. Default routing via GetX
      final String? route = data['route'] ?? data['screen'];
      if (route != null && route.isNotEmpty) {
        Get.toNamed(route, arguments: data['arguments'] ?? data);
      }
    } catch (e) {
      log("Error handling notification click: $e");
    }
  }

  /// Fetch and log FCM token
  Future<void> _logFcmToken() async {
    try {
      String? token = await _messaging.getToken();
      log("-----------------------------------------");
      log("FCM TOKEN: $token");
      log("-----------------------------------------");
      if (token != null) {
        await SharedPrefsService.instance.setString(AppKeys.fcmToken, token);
        log("Saved FCM Token to local storage.");
      }
    } catch (e) {
      log("Error fetching FCM token: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      log("App resumed. Checking notification permission status...");
      _checkPermissionAndRetrieveTokenOnResume();
    }
  }

  Future<void> _checkPermissionAndRetrieveTokenOnResume() async {
    final status = await Permission.notification.status;
    log("On resume, notification permission status is: $status");
    if (status.isGranted) {
      log("Permission is granted on resume! Asking FCM token...");
      await _logFcmToken();
    }
  }
}
