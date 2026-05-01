import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../../../base/widgets/base_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_keys.dart';

class PlantToggleCard extends StatelessWidget {
  final String icon;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? child;

  const PlantToggleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: spacerSize4,
          children: [
            Image.asset(icon, height: spacerSize18, width: spacerSize18),
            BaseText(
              text: title,
              fontFamily: AppKeys.inter,
              fontSize: fontSize14,
              fontWeight: FontWeight.w400,
              textColor: AppColors.offWhite,
            ),

            const Spacer(),

            GestureDetector(
              onTap: () => onChanged(!value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                width: spacerSize48,
                height: spacerSize25,
                padding: const EdgeInsets.all(spacerSize2),
                decoration: BoxDecoration(
                  color: value ? AppColors.darkGold : Colors.transparent,
                  borderRadius: BorderRadius.circular(spacerSize40),
                  border: Border.all(
                    color: value ? AppColors.darkGold : AppColors.borderGold,
                  ),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  alignment: value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: spacerSize20,
                    height: spacerSize20,
                    decoration: BoxDecoration(
                      color: value ? AppColors.offWhite : AppColors.offWhite50,
                      shape: BoxShape.circle,
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
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(spacerSize14),
              border: Border.all(color: AppColors.backgroundGrey),
            ),
            child: child,
          ),
      ],
    );
  }
}
