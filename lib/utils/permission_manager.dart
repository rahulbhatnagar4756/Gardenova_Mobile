import 'package:get/get.dart';
import 'package:kasagardem/base/dialogs/base_dialog.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static bool _cameraPermanentlyDeniedOnce = false;
  static bool _galleryPermanentlyDeniedOnce = false;

  /// CAMERA PERMISSION
  static Future<bool> handleCameraPermission() async {
    PermissionStatus status = await Permission.camera.status;

    /// Already granted
    if (status.isGranted) {
      _cameraPermanentlyDeniedOnce = false;
      return true;
    }

    /// Permanently denied before request
    if (status.isPermanentlyDenied) {
      if (_cameraPermanentlyDeniedOnce) {
        await _showPermissionDialog(
          title: 'Camera Permission',
          message:
              'Camera permission is permanently denied. Please enable it from settings.',
        );
      } else {
        _cameraPermanentlyDeniedOnce = true;

        BaseSnackBar.show(
          title: 'Permission Denied',
          message: 'Camera permission is required',
        );
      }

      return false;
    }

    /// Request permission
    status = await Permission.camera.request();

    /// Granted
    if (status.isGranted) {
      _cameraPermanentlyDeniedOnce = false;
      return true;
    }
    if (status.isPermanentlyDenied) {
      _cameraPermanentlyDeniedOnce = true;
    }

    /// Denied after request
    BaseSnackBar.show(
      title: 'Permission Denied',
      message: 'Camera permission is required',
    );

    return false;
  }

  /// GALLERY PERMISSION
  static Future<bool> handleGalleryPermission() async {
    PermissionStatus status = await Permission.photos.status;

    /// Already granted
    if (status.isGranted || status.isLimited) {
      _galleryPermanentlyDeniedOnce = false;
      return true;
    }

    /// Permanently denied before request
    if (status.isPermanentlyDenied) {
      if (_galleryPermanentlyDeniedOnce) {
        await _showPermissionDialog(
          title: 'Gallery Permission',
          message:
              'Gallery permission is permanently denied. Please enable it from settings.',
        );
      } else {
        _galleryPermanentlyDeniedOnce = true;

        BaseSnackBar.show(
          title: 'Permission Denied',
          message: 'Gallery permission is required',
        );
      }

      return false;
    }

    /// Request permission
    status = await Permission.photos.request();

    /// Granted
    if (status.isGranted || status.isLimited) {
      _galleryPermanentlyDeniedOnce = false;
      return true;
    }
    if (status.isPermanentlyDenied) {
      _galleryPermanentlyDeniedOnce = true;
    }

    /// Denied after request
    BaseSnackBar.show(
      title: 'Permission Denied',
      message: 'Gallery permission is required',
    );

    return false;
  }

  /// SETTINGS DIALOG
  static Future<void> _showPermissionDialog({
    required String title,
    required String message,
  }) async {
    BaseDialog.showAlertDialog(
      context: Get.context!,
      title: title,
      description: message,
      buttonLabel: 'Open Settings',
      onButtonPressed: () async {
        Get.back();
        await openAppSettings();
      },
    );
  }
}
