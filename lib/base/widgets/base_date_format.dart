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
