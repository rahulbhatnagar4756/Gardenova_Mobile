import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/professional/professionalDashBoard/professional_dashboard_controller.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../../generated/assets.dart';

class ProfessionalHeadingItem extends StatelessWidget {
  final ProfessionalDashboardController controller;

  final String? sectionTitle;
  final Widget? child;
  final double spacing;
  final bool? isFilterShow;
  final Function()? onTabFilter;

  const ProfessionalHeadingItem({
    super.key,
    this.child,
    this.sectionTitle,
    this.isFilterShow,
    this.spacing = spacerSize10,
    this.onTabFilter,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: spacing,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BaseText(
              textColor: AppColors.offWhite,
              fontFamily: AppKeys.poppins,
              fontSize: fontSize18,
              fontWeight: FontWeight.w400,
              text: sectionTitle ?? "",
            ),
            Visibility(
              visible: isFilterShow??false,
              child: InkWell(
                onTap: (){
                  onTabFilter?.call();
                },
                child: Container(
                  padding: const EdgeInsets.all(spacerSize10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.lightGold, AppColors.burntGold],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(spacerSize10),
                  ),
                  child: Image.asset(
                    Assets.imageFilter,
                    height: spacerSize16,
                    width: spacerSize16,
                  ),
                ),
              ),
            ),
          ],
        ),
        child!,
      ],
    );
  }

}
