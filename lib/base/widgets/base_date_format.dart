import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

class BaseDateTimeFormat {
  static String format({required String dateTime, String? format}) {
    try {
      DateTime parsed;
      if (dateTime.contains("-")) {
        parsed = DateTime.parse(dateTime);
      } else if (dateTime.contains(":")) {
        final now = DateTime.now();
        final parts = dateTime.split(":");
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final second = parts.length > 2 ? int.parse(parts[2]) : 0;

        parsed = DateTime(now.year, now.month, now.day, hour, minute, second);
      } else {
        return dateTime;
      }
      return DateFormat(format ?? "dd-MM-yyyy hh:mm a").format(parsed);
    } catch (e) {
      return dateTime;
    }
  }
}

String timeAgo(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
  Duration diff = DateTime.now().difference(dateTime);

  if (diff.inSeconds < 60) {
    return "${diff.inSeconds} sec\t${AppLocalizations.of(Get.context!)!.ago}";
  } else if (diff.inMinutes < 60) {
    return "${diff.inMinutes} min\t${AppLocalizations.of(Get.context!)!.ago}";
  } else if (diff.inHours < 24) {
    return "${diff.inHours} hr\t${AppLocalizations.of(Get.context!)!.ago}";
  } else if (diff.inDays < 7) {
    return "${diff.inDays} ${AppLocalizations.of(Get.context!)!.days}\t${AppLocalizations.of(Get.context!)!.ago}";
  } else if (diff.inDays < 30) {
    return "${(diff.inDays / 7).floor()} weeks\t${AppLocalizations.of(Get.context!)!.ago}";
  } else if (diff.inDays < 365) {
    return "${(diff.inDays / 30).floor()} months\t${AppLocalizations.of(Get.context!)!.ago}";
  } else {
    return "${(diff.inDays / 365).floor()} years\t${AppLocalizations.of(Get.context!)!.ago}";
  }
}

String formatReminderTime(String scheduledTimeStr) {
  DateTime? scheduledTime;

  try {
    scheduledTime = DateTime.parse(scheduledTimeStr);
  } catch (e) {
    // Fallback if it's not in ISO format (e.g. "2026-06-10 13:42:00")
    // Adjust this pattern to match whatever format your string actually is
    try {
      scheduledTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(scheduledTimeStr);
    } catch (e2) {
      return ''; // or throw, depending on how strict you want to be
    }
  }
  print("Before convert $scheduledTime");
  print("Before after ${scheduledTime.toLocal()}");
  scheduledTime.toLocal();

  final now = DateTime.now();
  final difference = scheduledTime.difference(now);
  final isFuture = difference.inSeconds > 0;
  final absDiff = difference.abs();

  final today = DateTime(now.year, now.month, now.day);
  final scheduledDay = DateTime(scheduledTime.year, scheduledTime.month, scheduledTime.day);
  final dayDifference = today.difference(scheduledDay).inDays;

  if (absDiff.inSeconds < 60) {
    return 'Just now';
  }

  if (absDiff.inMinutes < 60) {
    final value = absDiff.inMinutes;
    final unit = value == 1 ? 'minute' : 'minutes';
    return isFuture ? 'In $value $unit' : '$value $unit ago';
  }

  if (absDiff.inHours < 24) {
    final value = absDiff.inHours;
    final unit = value == 1 ? 'hour' : 'hours';
    return isFuture ? 'In $value $unit' : '$value $unit ago';
  }

  if (!isFuture && dayDifference == 1) {
    return 'Yesterday';
  }

  if (isFuture && dayDifference == -1) {
    return 'Tomorrow';
  }

  final value = absDiff.inDays;
  final unit = value == 1 ? 'day' : 'days';
  return isFuture ? 'In $value $unit' : '$value $unit ago';
}

String convertTo12Hour(String time24) {
  final parts = time24.split(':');
  int hour = int.parse(parts[0]);
  final minute = parts[1];

  final period = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  if (hour == 0) hour = 12;

  return '$hour:$minute $period';
}
