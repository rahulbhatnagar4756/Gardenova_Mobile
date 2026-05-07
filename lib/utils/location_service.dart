import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'constants/app_constants.dart';
import '../l10n/app_localizations.dart';

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
        message:  e.toString(),
      );
      return null;
    }
  }

  /// Core logic
  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   // ✅ Check if location services are enabled
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     await _showLocationServiceDialog();
  //     throw Exception('Location services are disabled.');
  //   }
  //
  //   // ✅ Check permission
  //   permission = await Geolocator.checkPermission();
  //
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       throw Exception('Location permission denied');
  //     }
  //   }
  //
  //   // ✅ Permanently denied
  //   if (permission == LocationPermission.deniedForever) {
  //     await _showPermissionDeniedDialog();
  //     throw Exception('Permission permanently denied');
  //   }
  //
  //   // ✅ Try getting current position (safe config)
  //   try {
  //     return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.medium,
  //       timeLimit: const Duration(seconds: 10),
  //     );
  //   } catch (e) {
  //     debugPrint("Primary location failed: $e");
  //     throw Exception("Unable to fetch location");
  //     // ✅ Fallback to last known location
  //     final lastPosition = await Geolocator.getLastKnownPosition();
  //
  //     if (lastPosition != null) {
  //       return lastPosition;
  //     }
  //
  //
  //   }
  // }


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check location service
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await _showLocationServiceDialog();
      throw Exception('Location services are disabled.');
    }

    // Check permission
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    // Permanently denied
    if (permission == LocationPermission.deniedForever) {
      await _showPermissionDeniedDialog();
      throw Exception('Permission permanently denied');
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

      throw Exception("Unable to fetch location");
    }
  }
  /// 🔹 Dialog: GPS OFF
  Future<void> _showLocationServiceDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text("Location Disabled"),
        content: const Text(
          "Please enable location services to continue.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await Geolocator.openLocationSettings();
              Get.back();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }

  /// 🔹 Dialog: Permission permanently denied
  Future<void> _showPermissionDeniedDialog() async {
    await Get.dialog(
      AlertDialog(
        title: const Text("Permission Required"),
        content: const Text(
          "Location permission is permanently denied. Enable it from settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await Geolocator.openAppSettings();
              Get.back();
            },
            child: const Text("Open Settings"),
          ),
        ],
      ),
    );
  }
}