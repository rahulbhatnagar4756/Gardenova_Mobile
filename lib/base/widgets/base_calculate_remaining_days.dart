import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../utils/constants/app_keys.dart';
import '../../utils/shared_prefs_service.dart';

class BaseCalculateRemainingDays {
  RxInt remainingDays = 0.obs;

  calculateRemainingDays(String createdAt) {
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
}
