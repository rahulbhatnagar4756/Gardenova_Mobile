import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/dialogs/app_form_dialog.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

void addNoteDialog(
  BuildContext context,
  TextEditingController textController,
  String? title,
  RxString? notesValue,
  String? type,
) {
  AppFormDialog.show(
    context: context,
    title: title ?? AppStrings.addNote,
    description: '${AppStrings.theNoteWillBeAttachedTo} ${type ?? ''}',
    barrierDismissible: false,
    primaryButtonLabel: AppStrings.save,
    secondaryButtonLabel: AppStrings.cancel,
    onSecondaryPressed: () => Navigator.pop(context),
    onPrimaryPressed: () {
      notesValue?.value = textController.text;
      Navigator.pop(context);
    },
    content: TextField(
      controller: textController,
      maxLines: 4,
      autofocus: true,
      style: TextStyle(
        color: AppColors.blackColor,
        fontWeight: FontWeight.w400,
        fontFamily: AppKeys.inter,
        fontSize: fontSize14,
      ),
      decoration: InputDecoration(
        hintText: AppStrings.enterYourNoteHere,
        hintStyle: TextStyle(
          color: AppColors.liteGreyColor,
          fontWeight: FontWeight.w300,
          fontFamily: AppKeys.inter,
          fontSize: fontSize14,
        ),
        filled: true,
        fillColor: AppColors.backgroundGrey,
        contentPadding: const EdgeInsets.all(spacerSize14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(spacerSize12),
          borderSide: const BorderSide(color: AppColors.borderGreyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(spacerSize12),
          borderSide: const BorderSide(color: AppColors.greenColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(spacerSize12),
          borderSide: const BorderSide(color: AppColors.borderGreyColor),
        ),
      ),
    ),
  );
}
