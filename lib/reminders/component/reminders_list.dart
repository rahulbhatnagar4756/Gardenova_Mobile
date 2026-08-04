import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/reminders/component/reminder_card.dart';
import 'package:kasagardem/reminders/model/notification_response_model.dart';
import 'package:kasagardem/reminders/plant_reminder_controller.dart';

class ReminderList {
  ReminderList._();

  static Color statusColorFor(Tasks task) {
    final eventType = task.eventType?.toLowerCase() ?? '';
    switch (eventType) {
      case 'missed':
        return const Color(0xffFFD7D7);
      case 'completed':
        return const Color(0xffD5F8E3);
      default:
        return const Color(0xffDFF1FF);
    }
  }

  static Widget buildCard(Tasks task, PlantReminderController controller) {
    final eventType = task.eventType?.toLowerCase() ?? '';

    return ReminderCard(
      plantName: (task.commonName ?? '').capitalizeFirst ?? '',
      task: task.activityType ?? '',
      status: (task.eventType ?? '').capitalizeFirst ?? '',
      textColor: eventType == 'missed'
          ? Colors.red
          : eventType == 'completed'
          ? Colors.green
          : null,
      statusColor: statusColorFor(task),
      timeLabel: task.preferredTime ?? '',
      reminderTime: task.nextAt ?? "",
      note: task.note?.toString(),
      showActions: eventType == 'missed',
      onReschedule: () => controller.openRescheduleDialog(task),
      onMarkComplete: () => controller.markReminderComplete(task),
      onDisableReminder: () => controller.disableReminder(task),
    );
  }
}
