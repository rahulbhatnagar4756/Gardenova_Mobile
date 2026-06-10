import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

import '../../base/dialogs/base_dialog.dart';
import '../../l10n/app_localizations.dart';
import '../../professional/myLead/model/my_lead_model.dart';
import '../constants/app_constants.dart';

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
      final LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.low,
      );
      return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
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

  Future<LocationModel?> getCurrentLocationDetails() async {
    try {
      final position = await _determinePosition();

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        throw Exception("Unable to fetch address details");
      }

      final place = placemarks.first;

      return LocationModel(
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        country: place.country ?? "",
        state: place.administrativeArea ?? "",
        city: place.locality ?? "",
        address: [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(", "),
        postalCode: place.postalCode ?? "",
      );
    } catch (e) {
      debugPrint("Location Details Error: $e");

      BaseSnackBar.show(
        title: AppLocalizations.of(Get.context!)!.error,
        message: e.toString(),
      );

      return null;
    }
  }
}
