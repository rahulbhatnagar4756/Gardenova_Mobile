import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class ExpansionTileLayout extends StatelessWidget {
  const ExpansionTileLayout({super.key, this.title, this.childWidget});

  final String? title;
  final Widget? childWidget;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.zero,
        iconColor: AppColors.burntGold,
        collapsedIconColor: AppColors.burntGold,
        tilePadding: EdgeInsets.zero,
        title: BaseText(
          text: title ?? "",
          fontFamily: AppKeys.poppins,
          fontWeight: FontWeight.bold,
          textColor: AppColors.burntGoldLight,
          textAlign: TextAlign.left,
          fontSize: fontSize20,
        ),
        children: [childWidget!],
      ),
    );
  }
}
