import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/services/notification_service.dart';
import 'package:kasagardem/services/reminder_push_notification_service.dart';
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

import 'authentication/auth_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AuthRepository authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _start();
    });
  }

  Future<void> _start() async {
    final isUserAlreadyLogedIn =
        SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false;
    log(isUserAlreadyLogedIn ? 'user t11' : 'user t12');
    await _ensureNotificationPermission();
    if (!mounted) return;
    navigateToIntroductionScreen(isUserAlreadyLogedIn: isUserAlreadyLogedIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Center(
        child: SizedBox(
          width: 220.w,
          height: 215.h,
          child: Image.asset(AppAssets.appLogoFull, scale: 2),
        ),
      ),
    );      
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refreshToken() async {
    try {
      final response = await authRepository.refreshToken().timeout(
        const Duration(seconds: 10),
        onTimeout: () => null,
      );
      if (response != null) {
        await SharedPrefsService.instance.setString(
          AppKeys.idToken,
          response[ApiKeys.data][ApiKeys.token],
        );
        await SharedPrefsService.instance.setString(
          ApiKeys.refreshToken,
          response[ApiKeys.data][ApiKeys.refreshToken],
        );
        log('user t13');
      } else {
        log('user t131');
      }
    } catch (e) {
      log('refreshToken failed: $e');
    } finally {
      navigateToIntroductionScreen(isUserAlreadyLogedIn: true);
    }
  }

  void navigateToIntroductionScreen({required bool isUserAlreadyLogedIn}) {
    bool isSoftLogin = SharedPrefsService.instance.getBool(AppKeys.isSoftLoggedIn) ?? false;
    String currentRole = SharedPrefsService.instance.getString(AppKeys.role) ?? '';

    // Short brand beat only — token refresh already awaited when logged in.
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      if (currentRole != AppKeys.professional) {
        if (isUserAlreadyLogedIn) {
          Get.offAllNamed(Routes.dashboard);
        } else if (isSoftLogin) {
          Get.offAllNamed(Routes.question);
        } else {
          Get.offAllNamed(Routes.login);
        }
        log('user t14');
      } else {
        log('user t15');
        Get.offAllNamed(Routes.professionalDashboard);
      }
    });
  }

  Future<void> _ensureNotificationPermission() async {
    await NotificationService.instance.initialize();
    final granted =
        await NotificationService.instance.ensureNotificationPermissionGranted();
    if (granted) {
      await ReminderPushNotificationService.instance.registerDeviceTokenIfNeeded();
    }
  }
}
