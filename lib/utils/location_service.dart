import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

import '../base/dialogs/base_dialog.dart';
import '../l10n/app_localizations.dart';
import 'constants/app_constants.dart';

class LocationService {
  /// Public method
  Future<Position?> getCurrentLocation() async {
    try {
      final position = await _determinePosition();
      return position;
    } catch (e) {
      debugPrint("Location Error: $e");
      BaseSnackBar.show(
        title: AppLocalizations.of(Get.context!)!.error,
        message: e.toString(),
      );
      return null;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check location service
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await _showLocationServiceDialog();
      throw Exception(AppStrings.locationServicesDisabled);
    }

    // Check permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception(AppStrings.locationPermissionDenied);
      }
    }

    // Permanently denied
    if (permission == LocationPermission.deniedForever) {
      await _showPermissionDeniedDialog();
      throw Exception(AppStrings.permissionPermanentlyDenied);
    }

    try {
      // Better for emulator & slow GPS devices
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 20),
      );
    } catch (e) {
      debugPrint("Primary location failed: $e");

      // Fallback to cached location
      final lastPosition = await Geolocator.getLastKnownPosition();

      if (lastPosition != null) {
        debugPrint("Using last known location");
        return lastPosition;
      }

      throw Exception(AppStrings.unableToFetchLocation);
    }
  }

  /// 🔹 Dialog: GPS OFF
  // Future<void> _showLocationServiceDialog() async {
  //   await Get.dialog(
  //     AlertDialog(
  //       title: const Text(AppStrings.locationDisabled),

  //       content: const Text(AppStrings.enableLocationServices),

  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: const Text(AppStrings.cancel),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             await Geolocator.openLocationSettings();
  //             Get.back();
  //           },
  //           child: const Text(AppStrings.openSettings),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // /// 🔹 Dialog: Permission permanently denied
  // Future<void> _showPermissionDeniedDialog() async {
  //   await Get.dialog(
  //     AlertDialog(
  //       title: const Text(AppStrings.permissionRequired),
  //       content: const Text(AppStrings.locationPermissionPermanentlyDenied),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //           child: const Text(AppStrings.cancel),
  //         ),
  //         TextButton(
  //           onPressed: () async {
  //             await Geolocator.openAppSettings();
  //             Get.back();
  //           },
  //           child: const Text(AppStrings.openSettings),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// LOCATION SERVICE OFF
  Future<void> _showLocationServiceDialog() async {
    BaseDialog.showAlertDialog(
      context: Get.context!,
      title: AppStrings.locationDisabled,
      description: AppStrings.enableLocationServices,
      buttonLabel: AppStrings.openSettings,
      onButtonPressed: () async {
        Get.back();
        await Geolocator.openLocationSettings();
      },
    );
  }

  /// LOCATION PERMISSION DENIED FOREVER
  Future<void> _showPermissionDeniedDialog() async {
    BaseDialog.showAlertDialog(
      context: Get.context!,
      title: AppStrings.permissionRequired,
      description: AppStrings.locationPermissionPermanentlyDenied,
      buttonLabel: AppStrings.openSettings,
      onButtonPressed: () async {
        Get.back();
        await Geolocator.openAppSettings();
      },
    );
  }
}
