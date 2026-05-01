import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'authentication/auth_repository.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

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
      refreshToken();
    } else {
      navigateToIntroductionScreen();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Center(child: Image.asset(AppAssets.appLogo, scale: 2)),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> refreshToken() async {
    var response = await authRepository.refreshToken();
    if (response != null) {
      SharedPrefsService.instance.setString(
        AppKeys.idToken,
        response[ApiKeys.data][ApiKeys.token],
      );
      navigateToIntroductionScreen();
    }
  }

  void navigateToIntroductionScreen() {
    Get.back();
    Future.delayed(Duration(seconds: 1)).then((value) {
      if (SharedPrefsService.instance.getString(AppKeys.role) !=
          AppKeys.professional) {
        Get.offNamed(Routes.introduction);
      } else {
        Get.offAllNamed(Routes.professionalDashboard);
      }
    });
  }
}
