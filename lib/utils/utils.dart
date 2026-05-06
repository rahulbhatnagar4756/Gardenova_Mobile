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
}