import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class SettingsItemLayout extends StatelessWidget {
  const SettingsItemLayout({super.key, this.icon, this.title, this.onTap});

  final IconData? icon;
  final String? title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.all(spacerSize10),
                decoration: BoxDecoration(
                  color: AppColors.dullGold15,
                  borderRadius: BorderRadius.circular(spacerSize10),
                ),
                child: Icon(icon, color: AppColors.burntGold),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: BaseText(
              text: title ?? "",
              fontWeight: FontWeight.w500,
              fontSize: fontSize16,
              textColor: AppColors.offWhite,
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward_ios_outlined,
                color: AppColors.offWhite50,
                size: fontSize18,
              ),
            ),
          ),
        ],
      ).marginSymmetric(vertical: spacerSize10),
    );
  }
}
