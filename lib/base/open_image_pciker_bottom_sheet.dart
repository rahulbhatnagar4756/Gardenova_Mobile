import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

class OpenImagePickerBottomSheet {
  final Function(bool isCamera) onPickImage;
  final Function() onThenCall;

  OpenImagePickerBottomSheet({
    required this.onPickImage,
    required this.onThenCall,
  });

  void show() {
    Get.bottomSheet(
      Container(
        height: Get.height * .2,
        color: AppColors.offWhite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.greenColor),
              title: BaseText(text: AppLocalizations.of(Get.context!)!.camera),
              onTap: () async {
                Get.back();
                onPickImage(true);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.greenColor),
              title: BaseText(text: AppLocalizations.of(Get.context!)!.gallery),
              onTap: () async {
                Get.back();
                onPickImage(false);
              },
            ),
          ],
        ),
      ),
    ).then((value) {
      onThenCall();
    });
  }
}
