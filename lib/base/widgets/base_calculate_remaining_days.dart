import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../utils/constants/app_keys.dart';
import '../../utils/shared_prefs_service.dart';

class BaseCalculateRemainingDays {
  RxInt remainingDays = 0.obs;

  /// Legacy trial calculation from account start date (90-day trial window).
  void calculateRemainingDays(String createdAt) {
    const int trialDays = 90;
    try {
      final DateTime created = DateTime.parse(createdAt).toLocal();
      final DateTime now = DateTime.now();
      final DateTime startDate = DateTime(
        created.year,
        created.month,
        created.day,
      );
      final DateTime today = DateTime(now.year, now.month, now.day);
      if (startDate.isAfter(today)) {
        remainingDays.value = trialDays;

        return;
      }

      final int daysPassed = today.difference(startDate).inDays;
      final int remaining = (trialDays - daysPassed).clamp(0, trialDays);
      remainingDays.value = remaining;
      debugPrint("remainingDays $remainingDays");
      SharedPrefsService.instance.setString(
        AppKeys.remainingDays,
        remainingDays.value.toString(),
      );
    } catch (_) {
      remainingDays.value = 0;
    }
  }

  /// Remaining calendar days until subscription [endDate].
  ///
  /// `0` = expires today, negative = already past, positive = days left.
  static int daysUntilEndDate(String? endDate) {
    if (endDate == null || endDate.trim().isEmpty) return 0;
    try {
      final expirationDate = DateTime.parse(endDate).toLocal();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final exp = DateTime(
        expirationDate.year,
        expirationDate.month,
        expirationDate.day,
      );
      return exp.difference(today).inDays;
    } catch (_) {
      return 0;
    }
  }

  /// True when expiry calendar day is today (still valid today).
  static bool isExpiringToday(String? endDate) {
    if (endDate == null || endDate.trim().isEmpty) return false;
    return daysUntilEndDate(endDate) == 0;
  }

  /// True when a stored/display remaining-days value is zero (never show "0 days").
  static bool isZeroRemainingDays(String? remainingDays) {
    final parsed = int.tryParse((remainingDays ?? '').trim());
    return parsed == null || parsed <= 0;
  }

  /// True when expiry calendar day is before today.
  static bool isExpired(String? endDate) {
    if (endDate == null || endDate.trim().isEmpty) return false;
    return daysUntilEndDate(endDate) < 0;
  }

  /// True while expiry day is today or in the future.
  static bool isEndDateStillValid(String? endDate) {
    if (endDate == null || endDate.trim().isEmpty) return true;
    return daysUntilEndDate(endDate) >= 0;
  }

  static void persistFromEndDate(String? endDate) {
    final remaining = daysUntilEndDate(endDate).clamp(0, 365);
    SharedPrefsService.instance.setString(
      AppKeys.remainingDays,
      remaining.toString(),
    );
  }
}
