import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/services/reminder_push_notification_service.dart';
import 'package:kasagardem/settings/settings_view_model.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/network_services/api_repository.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';

class Utils {
  Utils._();
  static const int transitionDuration = 320;
  static const Transition transition = Transition.rightToLeft;
  static const Transition noTransition = Transition.noTransition;
  static void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    final context = Get.context;
    if (context != null) {
      FocusScope.of(context).unfocus();
    }
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  static bool parseBool(dynamic value) {
    if (value == null) return false;

    if (value is bool) return value;

    final val = value.toString().toLowerCase();

    return val == "true" || val == "1";
  }

  static int? parseInt(dynamic value) {
    if (value == null) return null;

    if (value is int) return value;

    return int.tryParse(value.toString());
  }

  static DateTime? parseDate(dynamic value) {
    if (value == null) return null;

    try {
      return DateTime.parse(value.toString()).toLocal();
    } catch (_) {
      return null;
    }
  }

  static Future<void> callSettingBasicApi() async {
    if (Get.isRegistered<SettingsViewModel>()) {
      await Get.find<SettingsViewModel>().initFunctions();
    }
  }

  static Future<void> logoutUser() async {
    ApiRepository.instance.showLoader();
    await Future<void>.delayed(Duration.zero);
    try {
      await ReminderPushNotificationService.instance.onUserLogout();
      SharedPrefsService.instance.setBool(AppKeys.isLoggedIn, false);
      SharedPrefsService.instance.clear();
      SharedPrefsService.instance.setString(AppKeys.role, AppKeys.user);
    } finally {
      ApiRepository.instance.hideLoader();
    }
    Get.offAllNamed(Routes.login);
  }
}
