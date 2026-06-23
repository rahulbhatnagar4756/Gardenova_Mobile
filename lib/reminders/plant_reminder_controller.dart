import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:kasagardem/reminders/model/category_model.dart';
import 'package:kasagardem/reminders/model/notification_response_model.dart';
import 'package:kasagardem/reminders/reminders_repository.dart';
import 'package:kasagardem/services/reminder_push_notification_service.dart';
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
  RxInt pageNumber = 1.obs;
  int pageSize = 5;
  RxBool isLoadMoreVisible = false.obs;
  RxBool isSearching = false.obs;
  RxBool isLoadMoreRunning = false.obs;
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

  void updateStatus(CategoryModel status) {
    selectedStatus.value = status;
    _resetPagination();
    getAllNotifications();
    selectedStatus.refresh();
  }

  void updateType(CategoryModel type) {
    selectedType.value = type;
    _resetPagination();
    getAllNotifications();
    selectedType.refresh();
  }
}
