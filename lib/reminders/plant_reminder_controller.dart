import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:kasagardem/reminders/component/reschedule_reminder_dialog.dart';
import 'package:kasagardem/reminders/model/category_model.dart';
import 'package:kasagardem/reminders/model/notification_response_model.dart';
import 'package:kasagardem/reminders/reminders_repository.dart';
import 'package:kasagardem/services/reminder_push_notification_service.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class PlantReminderController extends GetxController {
  Rx<CategoryModel> selectedStatus = CategoryModel(
    title: AppStrings.all,
    code: "all",
    counter: "10",
  ).obs;
  Rx<CategoryModel> selectedType = CategoryModel(title: AppStrings.allTypes, code: "all").obs;
  RemindersRepository remindersRepository = RemindersRepository();

  RxList<CategoryModel> statuses = <CategoryModel>[].obs;
  RxList<CategoryModel> types = <CategoryModel>[].obs;
  RxList<Tasks> reminderList = <Tasks>[].obs;

  RxBool isLoading = false.obs;
  RxBool hasUpcomingTask = false.obs;
  RxString upcomingCount = "".obs;
  RxBool isRefreshing = false.obs;
  RxBool isLoadMoreVisible = false.obs;
  RxBool isSearching = false.obs;
  RxBool isLoadMoreRunning = false.obs;
  RxInt pageNumber = 1.obs;
  int pageSize = 5;

  final debouncer = Debouncer(delay: const Duration(milliseconds: 1000));

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    statuses.value = remindersRepository.fetchStatuses();
    types.value = remindersRepository.fetchTypes();
    selectedStatus.value = statuses[0];
    selectedType.value = types[0];

    scrollController.addListener(_onScroll);
    ReminderPushNotificationService.instance.onRemindersShouldRefresh = () {
      _resetPagination();
      getAllNotifications();
    };
    if (ReminderPushNotificationService.instance.consumePendingReminderRefresh()) {
      _resetPagination();
    }
    ReminderPushNotificationService.instance.registerDeviceTokenIfNeeded();
    getAllNotifications();
    super.onInit();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 150 &&
        !isLoadMoreRunning.value &&
        isLoadMoreVisible.value) {
      loadMoreNotifications();
    }
  }

  @override
  void onClose() {
    if (ReminderPushNotificationService.instance.onRemindersShouldRefresh != null) {
      ReminderPushNotificationService.instance.onRemindersShouldRefresh = null;
    }
    scrollController.dispose();
    super.onClose();
  }

  Future<void> getAllNotifications({bool append = false, bool showDefaultLoader = true}) async {
    isLoading.value = true;
    var response = await remindersRepository.fetchAllPlants(
      eventType: selectedStatus.value.code,
      activityType: selectedType.value.code,
      pageNumber: pageNumber.value.toString(),
      pageSize: pageSize.toString(),
      showDefaultLoader: showDefaultLoader,
    );

    if (response != null) {
      NotificationResponseModel notificationResponse = NotificationResponseModel.fromJson(response);

      var notificationData = notificationResponse.data;
      statuses[0].counter = notificationData!.counts!.all.toString();
      statuses[1].counter = notificationData.counts!.upcoming.toString();
      statuses[2].counter = notificationData.counts!.missed.toString();
      statuses[3].counter = notificationData.counts!.completed.toString();
      statuses.refresh();

      if (notificationData.upcomingIn5Hours != null &&
          notificationData.upcomingIn5Hours!.count != null &&
          notificationData.upcomingIn5Hours!.count! > 0) {
        hasUpcomingTask.value = true;
        upcomingCount.value = notificationData.upcomingIn5Hours!.count.toString();
      } else {
        hasUpcomingTask.value = false;
      }

      final tasks = notificationData.tasks ?? [];
      if (append) {
        reminderList.addAll(tasks);
      } else {
        reminderList.assignAll(tasks);
      }

      final totalCount = _totalCountForSelectedFilter(notificationData.counts!);
      isLoadMoreVisible.value = reminderList.length < totalCount;
    }
    isLoading.value = false;
  }

  Future<void> loadMoreNotifications() async {
    if (isLoadMoreRunning.value || !isLoadMoreVisible.value) return;

    isLoadMoreRunning.value = true;
    pageNumber.value++;
    await getAllNotifications(append: true, showDefaultLoader: false);
    isLoadMoreRunning.value = false;
  }

  int _totalCountForSelectedFilter(Counts counts) {
    switch (selectedStatus.value.code) {
      case 'upcoming':
        return counts.upcoming?.toInt() ?? 0;
      case 'missed':
        return counts.missed?.toInt() ?? 0;
      case 'completed':
        return counts.completed?.toInt() ?? 0;
      default:
        return counts.all?.toInt() ?? 0;
    }
  }

  void _resetPagination() {
    pageNumber.value = 1;
    isLoadMoreVisible.value = false;
    isLoadMoreRunning.value = false;
  }

  void openRescheduleDialog(Tasks task) {
    final context = Get.context;
    if (context == null) return;

    showRescheduleReminderDialog(
      context,
      task: task,
      onSave: (frequency, preferredTime) {
        rescheduleReminder(task, frequency, preferredTime);
      },
    );
  }

  Future<void> rescheduleReminder(Tasks task, int frequency, String preferredTime) async {
    final userPlantId = task.userPlantId;
    final activityType = task.activityType;
    if (userPlantId == null || userPlantId.isEmpty || activityType == null) return;

    final response = await remindersRepository.rescheduleReminder(
      userPlantId: userPlantId,
      activityType: activityType,
      preferredTime: _formatPreferredTimeForApi(preferredTime),
      frequency: frequency,
    );

    if (response != null) {
      _resetPagination();
      _scrollToTop();
      await getAllNotifications();
      _showReminderActionSuccessSnackBar(
        title: AppStrings.reschedule,
        message: AppStrings.reminderRescheduledSuccess,
      );
    }
  }

  Future<void> markReminderComplete(Tasks task) async {
    final userPlantId = task.userPlantId;
    final activityType = task.activityType;
    if (userPlantId == null || userPlantId.isEmpty || activityType == null) return;

    final response = await remindersRepository.completeReminder(
      userPlantId: userPlantId,
      activityType: activityType,
    );

    if (response != null) {
      _resetPagination();
      _scrollToTop();
      await getAllNotifications();
      _showReminderActionSuccessSnackBar(
        title: AppStrings.markAsComplete,
        message: AppStrings.reminderMarkedCompleteSuccess,
      );
    }
  }

  Future<void> disableReminder(Tasks task) async {
    final userPlantId = task.userPlantId;
    final activityType = task.activityType;
    if (userPlantId == null || userPlantId.isEmpty || activityType == null) return;

    final response = await remindersRepository.disableReminder(
      userPlantId: userPlantId,
      activityType: activityType,
    );

    if (response != null) {
      _resetPagination();
      _scrollToTop();
      await getAllNotifications();
      _showReminderActionSuccessSnackBar(
        title: AppStrings.disableReminder,
        message: AppStrings.reminderDisabledSuccess,
      );
    }
  }

  void _showReminderActionSuccessSnackBar({
    required String title,
    required String message,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        BaseSnackBar.show(title: title, message: message);
      });
    });
  }

  String _formatPreferredTimeForApi(String time) {
    final parts = time.split(':');
    if (parts.length == 2) return '$time:00';
    return time;
  }

  void _scrollToTop() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void updateStatus(CategoryModel status) {
    selectedStatus.value = status;
    _resetPagination();
    _scrollToTop();
    getAllNotifications();
    selectedStatus.refresh();
  }

  void updateType(CategoryModel type) {
    selectedType.value = type;
    _resetPagination();
    _scrollToTop();
    getAllNotifications();
    selectedType.refresh();
  }
}
