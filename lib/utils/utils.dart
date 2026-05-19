import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  Utils._();
  static const int transitionDuration = 320;
  static const Transition transition = Transition.rightToLeft;
  static const Transition noTransition = Transition.noTransition;
  static void hideKeyboard() {
    FocusScope.of(Get.context!).unfocus();
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

  
}
