import 'package:flutter/services.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/routes.dart';

class StatusBarStyle {
  StatusBarStyle._();

  static const _darkHeaderRoutes = {
    Routes.settings,
    Routes.profile,
    Routes.editProfile,
    Routes.changePassword,
  };

  static void applyForRoute(String? route) {
    if (_darkHeaderRoutes.contains(route)) {
      applyDarkHeader();
    } else {
      applyLightScreen();
    }
  }

  static void applyLightScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(appSystemOverlayStyle);
  }

  static void applyDarkHeader() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(darkHeaderSystemOverlayStyle);
  }
}
