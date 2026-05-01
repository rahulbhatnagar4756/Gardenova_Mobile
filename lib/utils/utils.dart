import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  Utils._();
  static void hideKeyboard() {
    FocusScope.of(Get.context!).unfocus();
  }
}