import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/dialogs/app_form_dialog.dart';
import 'package:kasagardem/base/widgets/base_date_format.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/reminders/model/notification_response_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

typedef RescheduleSaveCallback = void Function(int frequency, String preferredTime);

void showRescheduleReminderDialog(
  BuildContext context, {
  required Tasks task,
  required RescheduleSaveCallback onSave,
}) {
  final formKey = GlobalKey<_RescheduleReminderFieldsState>();

  AppFormDialog.show(
    context: context,
    title: AppStrings.reschedule,
    primaryButtonLabel: AppStrings.save,
    secondaryButtonLabel: AppStrings.cancel,
    onPrimaryPressed: () {
      final state = formKey.currentState;
      if (state == null || !state.validate()) return;
      onSave(state.frequency, state.preferredTime);
      Navigator.pop(context);
    },
    content: _RescheduleReminderFields(key: formKey, task: task),
  );
}

class _RescheduleReminderFields extends StatefulWidget {
  const _RescheduleReminderFields({super.key, required this.task});

  final Tasks task;

  @override
  State<_RescheduleReminderFields> createState() => _RescheduleReminderFieldsState();
}

class _RescheduleReminderFieldsState extends State<_RescheduleReminderFields> {
  static const _frequencyOptions = [1, 2, 3, 5, 7, 10, 15, 20, 30, 45, 60, 90];

  late int frequency;
  late String preferredTime;

  @override
  void initState() {
    super.initState();
    frequency = widget.task.frequencyDays?.toInt() ?? 0;
    preferredTime = widget.task.preferredTime ?? '';
  }

  bool validate() {
    if (frequency == 0 || preferredTime.isEmpty) {
      if (!Get.isSnackbarOpen) {
        final loc = AppLocalizations.of(context)!;
        Get.snackbar(AppStrings.reschedule, frequency == 0 ? loc.selectFrequency : loc.selectTime);
      }
      return false;
    }
    return true;
  }

  String _frequencyLabel(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (frequency == 0) return loc.selectFrequency;
    final dayText = frequency == 1 ? loc.day : loc.days;
    return '${loc.every} $frequency $dayText';
  }

  String _preferredTimeLabel(BuildContext context) {
    if (preferredTime.isEmpty) {
      return AppLocalizations.of(context)!.selectTime;
    }
    return convertTo12Hour(preferredTime);
  }

  Future<void> _pickFrequency() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkGreen,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(spacerSize28)),
      ),
      builder: (sheetContext) {
        final loc = AppLocalizations.of(sheetContext)!;
        final listHeight = MediaQuery.sizeOf(sheetContext).height * 0.45;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(spacerSize20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BaseText(
                      text: loc.selectFrequency,
                      fontFamily: AppKeys.inter,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.greenColor,
                      fontSize: fontSize16,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: listHeight,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: _frequencyOptions.length,
                    separatorBuilder: (_, index) => Divider(color: AppColors.offWhite10),
                    itemBuilder: (_, index) {
                      final value = _frequencyOptions[index];
                      final dayText = value == 1 ? loc.day : loc.days;
                      final isSelected = value == frequency;
                      return InkWell(
                        onTap: () {
                          setState(() => frequency = value);
                          Navigator.pop(sheetContext);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: spacerSize10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BaseText(
                                text: '${loc.every} $value $dayText',
                                fontFamily: AppKeys.inter,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                textColor: isSelected ? AppColors.greenColor : Colors.white,
                                fontSize: fontSize15,
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.greenColor,
                                  size: spacerSize20,
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(spacerSize14),
        border: Border.all(color: AppColors.backgroundGrey),
      ),
      child: Column(
        children: [
          _SettingRow(
            icon: Icons.calendar_month,
            label: AppLocalizations.of(context)!.frequency,
            value: _frequencyLabel(context),
            onTap: _pickFrequency,
          ),
          Divider(color: AppColors.backgroundGrey, height: 1),
          _SettingRow(
            icon: Icons.access_time,
            label: AppLocalizations.of(context)!.preferred,
            value: _preferredTimeLabel(context),
            onTap: _pickPreferredTime,
          ),
        ],
      ),
    );
  }

  Future<void> _pickPreferredTime() async {
    TimeOfDay initialTime = TimeOfDay.now();
    if (preferredTime.isNotEmpty) {
      final parts = preferredTime.split(':');
      if (parts.length >= 2) {
        initialTime = TimeOfDay(
          hour: int.tryParse(parts[0]) ?? initialTime.hour,
          minute: int.tryParse(parts[1]) ?? initialTime.minute,
        );
      }
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.dial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: Colors.white,
                dialBackgroundColor: AppColors.darkGreen.withValues(alpha: 0.08),
                dialHandColor: AppColors.darkGreen,
                dialTextColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return Colors.white;
                  return Colors.green;
                }),
                hourMinuteColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return AppColors.greenColor;
                  return AppColors.darkGreen.withValues(alpha: 0.1);
                }),
                hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) return Colors.white;
                  return Colors.green;
                }),
                dayPeriodColor: AppColors.darkGreen.withValues(alpha: 0.12),
                dayPeriodTextColor: Colors.green,
                confirmButtonStyle: TextButton.styleFrom(
                  foregroundColor: AppColors.darkGreen,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
                cancelButtonStyle: TextButton.styleFrom(foregroundColor: Colors.green.shade600),
              ),
              colorScheme: const ColorScheme.light(
                primary: AppColors.darkGreen,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: Localizations.override(
              context: context,
              locale: const Locale('en', 'US'),
              child: child!,
            ),
          ),
        );
      },
    );

    if (picked == null || !mounted) return;

    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
    setState(() {
      preferredTime = BaseDateTimeFormat.format(dateTime: dateTime.toString(), format: 'HH:mm');
    });
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(spacerSize14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: spacerSize12, vertical: spacerSize14),
        child: Row(
          children: [
            Icon(icon, size: spacerSize20, color: AppColors.grey),
            const SizedBox(width: spacerSize8),
            BaseText(
              text: label,
              fontFamily: AppKeys.inter,
              fontSize: fontSize14,
              fontWeight: FontWeight.w400,
              textColor: AppColors.blackColor,
            ),
            const Spacer(),
            Flexible(
              child: BaseText(
                text: value,
                fontFamily: AppKeys.inter,
                fontSize: fontSize14,
                fontWeight: FontWeight.w500,
                textColor: AppColors.greenColor,
                textAlign: TextAlign.end,
              ),
            ),
            Icon(Icons.navigate_next_outlined, size: spacerSize20, color: AppColors.greenColor),
          ],
        ),
      ),
    );
  }
}
