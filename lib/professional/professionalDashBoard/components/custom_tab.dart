import 'package:flutter/material.dart';

import '../../../base/widgets/base_text.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/constants/app_color.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/constants/app_keys.dart';

class CustomTopTabs extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomTopTabs({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        tabItem(title: AppLocalizations.of(context)!.professionals, index: 0),
        SizedBox(width: spacerSize10),
        tabItem(
          title: AppLocalizations.of(context)!.wholesaleSuppliers,
          index: 1,
        ),
      ],
    );
  }

  Widget tabItem({required String title, required int index}) {
    final bool isSelected = selectedIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onTap(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: spacerSize6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.greenColor : Colors.transparent,
            borderRadius: BorderRadius.circular(3),
            border: Border.all(color: AppColors.greenColor, width: 1),
          ),
          alignment: Alignment.center,
          child: BaseText(
            text: title,
            textColor: isSelected ? AppColors.whiteColor : AppColors.greenColor,
            fontFamily: AppKeys.inter,
            fontWeight: FontWeight.w500,
            fontSize: fontSize12,
          ),
        ),
      ),
    );
  }
}
