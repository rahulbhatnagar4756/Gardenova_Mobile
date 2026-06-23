import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../../../base/widgets/base_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_keys.dart';

class PlantToggleCard extends StatelessWidget {
  final dynamic icon;
  final String title;
  final String subTitle;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? child;

  const PlantToggleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.value,
    required this.onChanged,
    required this.backgroundColor,
    required this.iconColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: AppColors.greenColor, width: 3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.blackColor.withValues(alpha: 50),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: spacerSize5,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: backgroundColor ?? AppColors.dodgerBlue.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: icon is String
                    ? Image.asset(
                        icon,
                        height: spacerSize18,
                        width: spacerSize18,
                        fit: BoxFit.contain,
                        color: iconColor ?? AppColors.dodgerBlue,
                      ).paddingAll(spacerSize10)
                    : Icon(icon, color: iconColor ?? AppColors.dodgerBlue),
              ),

              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseText(
                      text: title,
                      fontFamily: AppKeys.inter,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.blackColor,
                    ),
                    BaseText(
                      text: subTitle,
                      fontFamily: AppKeys.inter,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.blackColor,
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => onChanged(!value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: spacerSize48,
                    height: spacerSize30,
                    padding: const EdgeInsets.all(spacerSize2),
                    decoration: BoxDecoration(
                      color: value ? AppColors.greenColor : Colors.transparent,
                      borderRadius: BorderRadius.circular(spacerSize40),
                      border: Border.all(
                        color: value ? AppColors.greenColor : AppColors.liteGreyColor,
                      ),
                    ),
                    child: AnimatedAlign(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        width: spacerSize20,
                        height: spacerSize30,
                        decoration: BoxDecoration(
                          color: value ? AppColors.offWhite : AppColors.liteGreyColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (child != null)
            Container(
              margin: const EdgeInsets.only(top: spacerSize16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(spacerSize14),
                border: Border.all(color: AppColors.backgroundGrey),
              ),
              child: child,
            ),
        ],
      ),
    );
  }
}
