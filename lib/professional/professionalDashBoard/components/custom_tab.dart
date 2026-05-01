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
        onTap: () => onTap(index),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(spacerSize10),
              child: BaseText(
                text: title,
                textColor: isSelected
                    ? AppColors.offWhite
                    : AppColors.offWhite50,
                fontFamily: AppKeys.inter,
                fontWeight: FontWeight.w500,
                fontSize: fontSize12,
              ),
            ),
            Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.darkGold : AppColors.offWhite10,
                borderRadius: BorderRadius.circular(spacerSize6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
