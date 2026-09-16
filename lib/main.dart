import 'dart:async';
import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb, kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide appFlavor;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/firebase_options.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/services/admob_service.dart';
import 'package:kasagardem/utils/app_config.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/network_services/network_connectivity_service.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import 'package:kasagardem/utils/status_bar_style.dart';
import 'package:kasagardem/utils/utils.dart';
import 'base/widgets/base_calculate_remaining_days.dart';
import 'services/notification_service.dart';
import 'services/reminder_push_notification_service.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  Locale selectedLocale = enUS;
  try {
    // Must load env before Firebase options / any dotenv.env access.
    await dotenv.load(fileName: 'secret.env');
    if (!dotenv.isInitialized) {
      throw StateError('secret.env failed to initialize');
    }

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    try {
      NotificationService.registerBackgroundHandler();
    } catch (e) {
      debugPrint('Background FCM handler registration deferred: $e');
    }

    if (kReleaseMode) {
      FlutterError.onError = (errorDetails) {
        if (_shouldIgnoreCrashlyticsError(errorDetails.exception, details: errorDetails)) {
          debugPrint('Ignored Crashlytics FlutterError: ${errorDetails.exception}');
          return;
        }
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        if (_shouldIgnoreCrashlyticsError(error)) {
          debugPrint('Ignored Crashlytics async error: $error');
          return true;
        }
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };
    }

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(appSystemOverlayStyle);

    // Web/desktop Facebook SDK only — mobile uses the native Facebook SDK.
    if (kIsWeb) {
      await FacebookAuth.i.webAndDesktopInitialize(
        appId: '1530353791540365',
        cookie: true,
        xfbml: true,
        version: 'v19.0',
      );
    }

    final flavorString = const String.fromEnvironment('appFlavor', defaultValue: 'dev');
    late final Flavor currentFlavor;
    late final String baseUrl;
    switch (flavorString.toLowerCase()) {
      case 'prod':
        currentFlavor = Flavor.prod;
        baseUrl = dotenv.env['prod_url']!;
        break;
      case 'dev':
      default:
        currentFlavor = Flavor.dev;
        baseUrl = dotenv.env['dev_url']!;
        break;
    }

    AppConfig.create(
      appName: appName,
      baseUrl: baseUrl,
      flavor: currentFlavor,
      adMobId: dotenv.env['android_admob_id'],
      bannerId: dotenv.env['android_banner_id'],
      rewardId: dotenv.env['android_reward_id'],
    );

    final sharedPrefsService = SharedPrefsService();
    await sharedPrefsService.init();

    final createdAt = sharedPrefsService.getString(AppKeys.createdAt) ?? '';
    if (createdAt.isNotEmpty) {
      BaseCalculateRemainingDays().calculateRemainingDays(createdAt);
    }

    final locale = sharedPrefsService.getString(AppKeys.selectedLang) ?? 'en';
    selectedLocale = locale == ptBR.languageCode ? ptBR : enUS;
    selectedLocale = enUS;

    Get.put<NetworkConnectivityService>(NetworkConnectivityService(), permanent: true);

    SharedPrefsService.instance.setString(AppKeys.selectedLang, Get.locale?.languageCode ?? 'en');

    runApp(MyApp(locale: selectedLocale));

    // Heavy SDKs after first frame — ads + push are not required to paint UI.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_initDeferredServices());
    });
  } catch (error, stack) {
    try {
      if (kReleaseMode) {
        debugPrint('Error: $error');
        debugPrint('Stack: $stack');
        await FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        debugPrint('Error recorded to Crashlytics');
        debugPrint('Crashlytics instance: ${FirebaseCrashlytics.instance}');
      }
    } catch (_) {}
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Startup failed: $error')),
        ),
      ),
    );
  } finally {
    FlutterNativeSplash.remove();
  }
}

Future<void> _initDeferredServices() async {
  try {
    await NotificationService.instance.initialize();
    ReminderPushNotificationService.instance.configure();
  } catch (e, stack) {
    if (kReleaseMode) {
      await FirebaseCrashlytics.instance.recordError(e, stack, reason: 'Notification init failed');
    }
  }

  try {
    await AdMobService.instance.ensureInitialized();
  } catch (e, stack) {
    if (kReleaseMode) {
      await FirebaseCrashlytics.instance.recordError(e, stack, reason: 'MobileAds init failed');
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.locale});

  final Locale? locale;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      StatusBarStyle.applyForRoute(Get.currentRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (result, didPop) {
        if (didPop != null) return;
        BaseDialog.showAlertDialog(
          context: context,
          title: appName,
          description: AppLocalizations.of(context)!.exitAppContent,
          buttonLabel: AppLocalizations.of(context)!.exit,
          onButtonPressed: () {
            SystemNavigator.pop();
          },
        );
      },
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: false,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Utils.hideKeyboard(),
          child: GetMaterialApp(
              scrollBehavior: const MaterialScrollBehavior().copyWith(
                overscroll: false,
                physics: ClampingScrollPhysics(),
              ),
              fallbackLocale: enUS,
              popGesture: true,
              locale: widget.locale,
              supportedLocales: [enUS],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                scaffoldBackgroundColor: AppColors.appColor,
                colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appColor),
                useMaterial3: true,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                appBarTheme: const AppBarTheme(
                  surfaceTintColor: Colors.transparent,
                  systemOverlayStyle: appSystemOverlayStyle,
                ),
              ),
              color: AppColors.offWhite,
              initialRoute: Routes.splash,
              defaultTransition: Transition.rightToLeftWithFade,
              getPages: Routes.getPages(),
              routingCallback: (routing) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  StatusBarStyle.applyForRoute(routing?.current);
                });
              },
              builder: (context, child) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: appSystemOverlayStyle,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                    child: child!,
                  ),
                );
              },
            ),
          ),
        ),
    );
  }
}

/// Missing/corrupt images and HTTP load failures are expected at runtime
/// and should not be reported as crashes.
bool _shouldIgnoreCrashlyticsError(Object error, {FlutterErrorDetails? details}) {
  final library = details?.library?.toLowerCase() ?? '';
  if (library.contains('image')) return true;

  final context = details?.context?.toString().toLowerCase() ?? '';
  if (context.contains('resolving an image') ||
      context.contains('loading an image') ||
      context.contains('decoding an image')) {
    return true;
  }

  if (error is NetworkImageLoadException) return true;

  final typeName = error.runtimeType.toString();
  if (typeName == 'HttpException' ||
      typeName == 'HttpExceptionWithStatus' ||
      typeName == 'ClientException') {
    return true;
  }

  final message = error.toString().toLowerCase();
  if (message.contains('this adwidget is already in the widget tree')) {
    return true;
  }
  if (message.contains('unable to find explicit activity class') &&
      message.contains('facebook')) {
    return true;
  }

  const ignorableSnippets = [
    'networkimageloadexception',
    'httpexception',
    'httpexceptionwithstatus',
    'invalid statuscode',
    'statuscode: 403',
    'status code: 403',
    'statuscode: 404',
    'status code: 404',
    'http request failed',
    'failed to load network image',
    'invalid image data',
    'could not instantiate image codec',
    'exception: invalid image data',
    'no host specified in uri',
  ];
  if (ignorableSnippets.any(message.contains)) return true;

  final looksLikeMissingImage =
      message.contains('image') &&
      (message.contains('403') ||
          message.contains('404') ||
          message.contains('forbidden') ||
          message.contains('not found') ||
          message.contains('corrupt') ||
          message.contains('decode'));
  return looksLikeMissingImage;
}