import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kasagardem/base/open_image_pciker_bottom_sheet.dart';
import 'package:kasagardem/plants/plant_analysis/model/plant_scan_detail_model.dart';
import 'package:kasagardem/plants/plant_analysis/plant_analysis_repository.dart';
import 'package:kasagardem/services/admob_service.dart';
import 'package:kasagardem/utils/constants/api_keys.dart';
import 'package:kasagardem/utils/permission_manager.dart';
import 'package:kasagardem/utils/routes.dart';

class PlantAnalysisDetailController extends GetxController {
  final PlantAnalysisRepository _repository = PlantAnalysisRepository();

  final RxBool isLoading = false.obs;
  final RxnString errorMessage = RxnString();
  final Rxn<PlantScanDetail> detail = Rxn<PlantScanDetail>();

  late final String scanId;

  @override
  void onInit() {
    super.onInit();
    scanId = _resolveScanId(Get.arguments);
    fetchDetail();
  }

  String _resolveScanId(dynamic arguments) {
    if (arguments is String) return arguments;
    if (arguments is Map) {
      return arguments['id']?.toString() ?? '';
    }
    return '';
  }

  Future<void> fetchDetail() async {
    if (scanId.isEmpty) {
      errorMessage.value = 'Plant scan not found';
      detail.value = null;
      return;
    }

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final response = await _repository.fetchPlantScanDetail(id: scanId);
      if (response is! Map<String, dynamic>) {
        errorMessage.value = 'Unable to load plant analysis';
        detail.value = null;
        return;
      }

      final parsed = PlantScanDetailResponse.fromJson(response);
      if (!parsed.success || parsed.data == null) {
        errorMessage.value = parsed.message ?? 'Unable to load plant analysis';
        detail.value = null;
        return;
      }

      detail.value = parsed.data;
    } catch (e) {
      debugPrint('PlantAnalysisDetailController fetchDetail error: $e');
      errorMessage.value = 'Unable to load plant analysis';
      detail.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void onCompareTap() {
    if (detail.value == null) return;

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

      final previous = detail.value;
      if (previous == null) return;

      final path = imagePath;
      AdMobService.instance.showRewardedAdAndProceed(() {
        Get.toNamed(
          Routes.plantAnalysisCompare,
          arguments: {
            'previous': previous,
            ApiKeys.imagePath: path,
          },
        );
      });
    } catch (e) {
      debugPrint('PlantAnalysisDetailController pickCompareImage error: $e');
    }
  }
}
