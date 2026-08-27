import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasagardem/base/open_image_pciker_bottom_sheet.dart';
import 'package:kasagardem/plants/plant_analysis/model/plant_scan_compare_model.dart';
import 'package:kasagardem/plants/plant_analysis/model/plant_scan_detail_model.dart';
import 'package:kasagardem/plants/plant_analysis/plant_analysis_controller.dart';
import 'package:kasagardem/plants/plant_analysis/plant_analysis_repository.dart';
import 'package:kasagardem/services/admob_service.dart';
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/network_services/app_exceptions.dart';
import 'package:kasagardem/utils/permission_manager.dart';
import 'package:kasagardem/utils/routes.dart';

class PlantAnalysisCompareController extends GetxController {
  final PlantAnalysisRepository _repository = PlantAnalysisRepository();

  late final PlantScanDetail previous;
  final Rxn<File> imageFile = Rxn<File>();
  final Rxn<PlantScanCompareItem> previousPlant = Rxn<PlantScanCompareItem>();
  final Rxn<PlantScanCompareItem> currentPlant = Rxn<PlantScanCompareItem>();

  final RxBool isLoading = false.obs;
  final RxBool isApiComplete = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map) {
      previous = args['previous'] as PlantScanDetail;
      final path = args[ApiKeys.imagePath]?.toString() ?? '';
      if (path.isNotEmpty) {
        imageFile.value = File(path);
      }
    } else {
      previous = const PlantScanDetail();
    }
    compareScans();
  }

  Future<void> compareScans() async {
    final file = imageFile.value;
    if (file == null || !file.existsSync()) {
      errorMessage.value = 'Unable to compare plant scans';
      previousPlant.value = null;
      currentPlant.value = null;
      return;
    }

    if (previous.id.isEmpty) {
      errorMessage.value = 'Plant scan not found';
      previousPlant.value = null;
      currentPlant.value = null;
      return;
    }

    isLoading.value = true;
    isApiComplete.value = false;
    errorMessage.value = '';
    previousPlant.value = null;
    currentPlant.value = null;

    try {
      final imageBytes = await file.readAsBytes();
      final base64String = base64Encode(imageBytes);
      final response = await _repository.comparePlantScan(
        id: previous.id,
        imageBase64: 'data:image/png;base64, $base64String',
      );

      if (response is! Map<String, dynamic>) {
        errorMessage.value = 'Unable to compare plant scans';
        return;
      }

      final parsed = PlantScanCompareResponse.fromJson(response);
      if (!parsed.success || parsed.plants.isEmpty) {
        errorMessage.value = _cleanErrorMessage(
          parsed.message ?? 'Unable to compare plant scans',
        );
        return;
      }

      _assignPlants(parsed.plants);

      if (Get.isRegistered<PlantAnalysisController>()) {
        Get.find<PlantAnalysisController>().refreshScans();
      }
    } catch (e) {
      debugPrint('PlantAnalysisCompareController compareScans error: $e');
      if (e is BadRequestException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is FetchDataException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is UnauthorisedException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is NotFoundException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else if (e is ConflictException) {
        errorMessage.value = _cleanErrorMessage(e.message);
      } else {
        errorMessage.value = 'Unable to compare plant scans';
      }
      previousPlant.value = null;
      currentPlant.value = null;
    } finally {
      isApiComplete.value = true;
    }
  }

  void _assignPlants(List<PlantScanCompareItem> plants) {
    PlantScanCompareItem? matchedPrevious;
    PlantScanCompareItem? matchedCurrent;

    for (final plant in plants) {
      if (plant.scanId == previous.id) {
        matchedPrevious = plant;
      } else {
        matchedCurrent = plant;
      }
    }

    previousPlant.value =
        matchedPrevious ??
        (plants.isNotEmpty ? plants.first : PlantScanCompareItem.fromDetail(previous));
    currentPlant.value =
        matchedCurrent ??
        (plants.length > 1 ? plants.last : previousPlant.value);
  }

  void onLoadingAnimationComplete() {
    isLoading.value = false;
    isApiComplete.value = false;
  }

  void rescanCurrent() {
    OpenImagePickerBottomSheet(
      onPickImage: (isCamera) async {
        await Future.delayed(const Duration(milliseconds: 200));
        await _pickCompareImage(isCamera: isCamera);
      },
      onThenCall: () {},
    ).show();
  }

  Future<void> _pickCompareImage({required bool isCamera}) async {
    try {
      String? imagePath;

      if (isCamera) {
        final hasPermission = await PermissionManager.handleCameraPermission();
        if (!hasPermission) return;

        final result = await Get.toNamed(Routes.cameraCapture);
        if (result is XFile) {
          imagePath = result.path;
        }
      } else {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          requestFullMetadata: true,
          imageQuality: 70,
        );
        if (pickedFile != null && pickedFile.path.isNotEmpty) {
          imagePath = pickedFile.path;
        }
      }

      if (imagePath == null || imagePath.isEmpty) return;

      final path = imagePath;
      AdMobService.instance.showRewardedAdAndProceed(() {
        imageFile.value = File(path);
        compareScans();
      });
    } catch (e) {
      debugPrint('PlantAnalysisCompareController pickCompareImage error: $e');
    }
  }

  String _cleanErrorMessage(String errorMsg) {
    if (errorMsg.contains('{') && errorMsg.contains('}')) {
      try {
        final startIndex = errorMsg.indexOf('{');
        final endIndex = errorMsg.lastIndexOf('}');
        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
          final jsonPart = errorMsg.substring(startIndex, endIndex + 1);
          final decoded = jsonDecode(jsonPart);
          if (decoded is Map) {
            if (decoded.containsKey('message')) {
              return decoded['message'].toString();
            } else if (decoded.containsKey('error')) {
              return decoded['error'].toString();
            }
          }
        }
      } catch (_) {}
    }

    final messageMatch = RegExp(
      r'"message"\s*:\s*"([^"]+)"',
    ).firstMatch(errorMsg);
    if (messageMatch != null && messageMatch.groupCount >= 1) {
      return messageMatch.group(1)!;
    }

    return errorMsg;
  }
}
