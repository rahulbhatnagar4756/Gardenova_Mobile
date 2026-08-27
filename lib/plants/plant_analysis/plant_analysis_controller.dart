import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
import 'package:kasagardem/plants/plant_analysis/model/plant_scan_model.dart';
import 'package:kasagardem/plants/plant_analysis/plant_analysis_repository.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import 'package:kasagardem/utils/utils.dart';

class PlantAnalysisController extends GetxController {
  final PlantAnalysisRepository _repository = PlantAnalysisRepository();
  final ScrollController scrollController = ScrollController();

  final RxList<PlantScan> scans = <PlantScan>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadMoreRunning = false.obs;
  final RxInt totalCount = 0.obs;
  final RxnString errorMessage = RxnString();

  int _page = 1;
  bool _hasMore = false;
  bool _isFetching = false;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchScans(reset: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients || !_hasMore || _isFetching) return;
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 150) {
      fetchScans();
    }
  }

  Future<void> refreshScans() => fetchScans(reset: true);

  Future<void> fetchScans({bool reset = false}) async {
    if (_isFetching) return;
    _isFetching = true;

    if (reset) {
      _page = 1;
      _hasMore = false;
      isLoading.value = true;
      errorMessage.value = null;
    } else {
      isLoadMoreRunning.value = true;
    }

    try {
      final response = await _repository.fetchPlantScans(page: _page);
      if (response is! Map<String, dynamic>) {
        errorMessage.value = 'Unable to load plant analysis';
        if (scans.isEmpty) totalCount.value = 0;
        return;
      }

      final parsed = PlantScansResponseModel.fromJson(response);
      final pagination = parsed.data?.pagination;
      final newScans = parsed.data?.scans ?? const <PlantScan>[];

      if (reset) {
        scans.assignAll(newScans);
      } else {
        scans.addAll(newScans);
      }

      totalCount.value = pagination?.totalCount ?? scans.length;
      _hasMore = pagination?.hasMore ?? false;
      if (_hasMore) _page++;
      errorMessage.value = parsed.success ? null : parsed.message;
    } catch (e) {
      debugPrint('PlantAnalysisController fetchScans error: $e');
      errorMessage.value = 'Unable to load plant analysis';
      if (scans.isEmpty) totalCount.value = 0;
    } finally {
      isLoading.value = false;
      isLoadMoreRunning.value = false;
      _isFetching = false;
    }
  }

  void navigateToNext(int index) {
    switch (index) {
      case 0:
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().getGardenInsights();
        }
        Get.until((route) => route.settings.name == Routes.dashboard);
        break;
      case 1:
        Get.back();
        Get.toNamed(
          Routes.recommendedProfessionals,
          arguments: {
            'lat':
                SharedPrefsService.instance.getString(AppKeys.currentLatKey) ??
                '0.0',
            'lng':
                SharedPrefsService.instance.getString(AppKeys.currentLongKey) ??
                '0.0',
          },
        );
        break;
      case 5:
        Get.back();
        Utils.callSettingBasicApi();
        Get.toNamed(Routes.profile);
        break;
      case 6:
        Get.back();
        Get.toNamed(Routes.myPlantsScreen);
        break;
      case 7:
        Get.back();
        Utils.callSettingBasicApi();
        Get.toNamed(Routes.settings);
        break;
      default:
        Get.back();
        break;
    }
  }
}
