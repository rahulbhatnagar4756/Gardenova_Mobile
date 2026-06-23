import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

void addNoteDialog(
  BuildContext context,
  TextEditingController textController,
  String? title,
  RxString? notesValue,
  String? type,
) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: BaseText(text: title ?? ""),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: "${AppStrings.theNoteWillBeAttachedTo} ${type!}",
            fontSize: fontSize13,
            textColor: Colors.grey,
          ),

          SizedBox(height: spacerSize12),
          TextField(
            controller: textController,
            maxLines: 4,
            autofocus: true,
            decoration: InputDecoration(
              hintText: AppStrings.enterYourNoteHere,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: BaseText(text: AppStrings.cancel),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenColor),
          onPressed: () {
            notesValue!.value = textController.text;
            Navigator.pop(context);
          },
          child: BaseText(text: AppStrings.save, textColor: AppColors.whiteColor),
        ),
      ],
    ),
  );
}
