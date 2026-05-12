import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../generated/assets.dart';

class HeadingUiLayout extends StatelessWidget {
  final String? sectionTitle;
  final Widget? child;
  final double spacing;
  final bool? isFilterShow;
  final Function()? onTabFilter;


  const HeadingUiLayout({
    super.key,
    this.child,
    this.sectionTitle,
    this.spacing = spacerSize10,
    this.isFilterShow =false,
    this.onTabFilter
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
              fontFamily: AppKeys.poppins,
              fontSize: fontSize17,
              fontWeight: FontWeight.w500,
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
                    gradient: AppColors.linearGradientForBtn,
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
