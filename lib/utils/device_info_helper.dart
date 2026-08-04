import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfoHelper {
  /// Gets the application version name (e.g. "1.0.0").
  static Future<String> getAppVersion() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      debugPrint('Error getting app version: $e');
      return '1.0.0';
    }
  }

  /// Gets the build number of the app (e.g. "9").
  static Future<String> getBuildNumber() async {
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.buildNumber;
    } catch (e) {
      debugPrint('Error getting build number: $e');
      return '1';
    }
  }
}
