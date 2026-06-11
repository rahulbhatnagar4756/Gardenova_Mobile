import 'dart:io' show Platform;
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide appFlavor;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/firebase_options.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/app_config.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/network_services/network_connectivity_service.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import 'package:kasagardem/utils/utils.dart';

import 'base/widgets/base_calculate_remaining_days.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: "secret.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  String flavorString = String.fromEnvironment('appFlavor', defaultValue: 'dev');

  await FacebookAuth.i.webAndDesktopInitialize(
    appId: "1530353791540365",
    cookie: true,
    xfbml: true,
    version: "v19.0",
  );

  Flavor? currentFlavor;
  String? baseUrl;
  String? adMobId;
  String? bannerId;
  String? rewardId;

  switch (flavorString.toLowerCase()) {
    case 'dev':
      currentFlavor = Flavor.dev;
      baseUrl = dotenv.env['dev_url'];
      break;

    case 'prod':
      currentFlavor = Flavor.prod;
      baseUrl = dotenv.env['prod_url'];

      break;
  }
  if (Platform.isIOS) {
    adMobId = dotenv.env['android_admob_id'];
    bannerId = dotenv.env['android_banner_id'];
    rewardId = dotenv.env['android_reward_id'];
  } else {
    adMobId = dotenv.env['android_admob_id'];
    bannerId = dotenv.env['android_banner_id'];
    rewardId = dotenv.env['android_reward_id'];
  }
  AppConfig.create(
    appName: appName,
    baseUrl: baseUrl!,
    flavor: currentFlavor!,
    adMobId: adMobId,
    bannerId: bannerId,
    rewardId: rewardId,
  );

  SharedPrefsService sharedPrefsService = SharedPrefsService();
  await sharedPrefsService.init();
  String createdAt = sharedPrefsService.getString(AppKeys.createdAt) ?? "";

  if (createdAt.isNotEmpty) {
    BaseCalculateRemainingDays().calculateRemainingDays(createdAt);
  }

  var locale = sharedPrefsService.getString(AppKeys.selectedLang) ?? "en";

  Locale selectedLocale = locale.isEmpty
      // ? ptBR
      ? enUS
      : locale == ptBR.languageCode
      ? ptBR
      : enUS;
  selectedLocale = enUS;

  await initServices();
  MobileAds.instance.initialize();
  FlutterNativeSplash.remove();

  SharedPrefsService.instance.setString(AppKeys.selectedLang, Get.locale?.languageCode ?? 'en');
  runApp(MyApp(locale: selectedLocale));
}

Future<void> initServices() async {
  Get.put<NetworkConnectivityService>(NetworkConnectivityService(), permanent: true);
  await NotificationService.instance.initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.locale});

  final Locale? locale;

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
      child: SafeArea(
        top: false,
        bottom: true,
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
              locale: locale,
              supportedLocales: [enUS, ptBR],
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
                appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
              ),
              color: AppColors.offWhite,
              initialRoute: Routes.splash,
              defaultTransition: Transition.rightToLeftWithFade,
              getPages: Routes.getPages(),
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child!,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
