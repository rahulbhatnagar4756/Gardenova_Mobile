import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/dashboard/dashboard_controller.dart';
import 'package:kasagardem/dashboard/missed_notifications/missed_notifications_repository.dart';
import 'package:kasagardem/dashboard/missed_notifications/model/missed_notification_model.dart';
import 'package:kasagardem/dashboard/todays_tasks_controller.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/routes.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import 'package:kasagardem/utils/utils.dart';

class MissedNotificationsController extends GetxController {
  final MissedNotificationsRepository _repository = MissedNotificationsRepository();
  final ScrollController scrollController = ScrollController();

  final RxList<MissedNotificationItem> items = <MissedNotificationItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadMoreRunning = false.obs;
  final RxBool hasNextPage = false.obs;
  final RxInt totalCount = 0.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final RxnString errorMessage = RxnString();

  bool _isFetching = false;

  static const int pageLimit = 20;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchPage(1);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 150 &&
        !_isFetching &&
        !isLoadMoreRunning.value &&
        hasNextPage.value) {
      loadMoreNotifications();
    }
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  Future<void> refreshNotifications() async {
    currentPage.value = 1;
    await fetchPage(1, append: false);
  }

  Future<void> loadMoreNotifications() async {
    if (_isFetching || !hasNextPage.value) return;
    await fetchPage(currentPage.value + 1, append: true);
  }

  Future<void> fetchPage(int page, {bool append = false}) async {
    if (_isFetching || page < 1) return;
    _isFetching = true;

    if (append) {
      isLoadMoreRunning.value = true;
    } else {
      if (items.isEmpty) {
        isLoading.value = true;
      }
      errorMessage.value = null;
    }

    try {
      final response = await _repository.fetchMissedNotifications(page: page, limit: pageLimit);
      if (response is! Map) {
        errorMessage.value = _loadError();
        if (items.isEmpty) totalCount.value = 0;
        return;
      }

      final parsed = MissedNotificationsResponseModel.fromJson(Map<String, dynamic>.from(response));
      final pagination = parsed.data?.pagination;
      final newItems = parsed.data?.items ?? const <MissedNotificationItem>[];

      if (append) {
        items.addAll(newItems);
      } else {
        items.assignAll(newItems);
      }

      currentPage.value = pagination?.page ?? page;
      totalPages.value = pagination?.totalPages ?? 1;
      totalCount.value = pagination?.total ?? items.length;
      hasNextPage.value = pagination?.hasNext ?? (currentPage.value < totalPages.value);
      errorMessage.value = parsed.success ? null : (parsed.message ?? _loadError());
    } catch (e) {
      debugPrint('MissedNotificationsController fetch error: $e');
      errorMessage.value = _loadError();
      if (items.isEmpty) totalCount.value = 0;
    } finally {
      isLoading.value = false;
      isLoadMoreRunning.value = false;
      _isFetching = false;
    }
  }

  String _loadError() {
    final context = Get.context;
    if (context == null) return 'Unable to load missed notifications';
    return AppLocalizations.of(context)!.unableToLoadMissedNotifications;
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
            'lat': SharedPrefsService.instance.getString(AppKeys.currentLatKey) ?? '0.0',
            'lng': SharedPrefsService.instance.getString(AppKeys.currentLongKey) ?? '0.0',
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

  Future<void> completeMissedNotification(String id) async {
    if (id.isEmpty) return;

    try {
      final response = await _repository.completeMissedNotification(id);
      if (response != null && response['success'] == true) {
        final message =
            response['message']?.toString() ??
            'Missed notification marked as completed successfully';

        BaseSnackBar.show(title: appName, message: message);

        items.removeWhere((item) => item.id == id);
        if (totalCount.value > 0) {
          totalCount.value -= 1;
        }

        if (items.length < 5 && hasNextPage.value) {
          loadMoreNotifications();
        }

        if (Get.isRegistered<TodaysTasksController>()) {
          Get.find<TodaysTasksController>().refreshTasks();
        }
      }
    } catch (e) {
      debugPrint('Complete missed notification error: $e');
    }
  }
}
