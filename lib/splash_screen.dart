import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
    if (SharedPrefsService.instance.getBool(AppKeys.isLoggedIn) ?? false) {
      log('user t11');
      refreshToken();
    } else {
      log('user t12');
      navigateToIntroductionScreen(isUserAlreadyLogedIn: false);
    }
    super.initState();
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
    var response = await authRepository.refreshToken();
    if (response != null) {
      await SharedPrefsService.instance.setString(
        AppKeys.idToken,
        response[ApiKeys.data][ApiKeys.token],
      );
      log('user t13');
    } else {
      log('user t131');
    }
    navigateToIntroductionScreen(isUserAlreadyLogedIn: true);
  }

  void navigateToIntroductionScreen({required bool isUserAlreadyLogedIn}) {
    // Get.back();
    Future.delayed(Duration(seconds: 1)).then((value) {
      if (SharedPrefsService.instance.getString(AppKeys.role) !=
          AppKeys.professional) {
        // need change
        if (isUserAlreadyLogedIn) {
          Get.offAllNamed(Routes.dashboard);
        } else {
          Get.offAllNamed(Routes.login);
        }
        log('user t14');
        // Get.offAllNamed(Routes.dashboard);
      } else {
        log('user t15');
        Get.offAllNamed(Routes.professionalDashboard);
      }
    });
  }
}
