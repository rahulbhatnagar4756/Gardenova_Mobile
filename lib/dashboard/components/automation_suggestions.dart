import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_bordered_container.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class AutomationSuggestions extends StatelessWidget {
  const AutomationSuggestions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: spacerSize10,
      children: [
        suggestionItem(
          itemTitle: AppLocalizations.of(context)!.smartWateringSystem,
          assetPath: AppAssets.waterDrop,
        ),
        suggestionItem(
          itemTitle: AppLocalizations.of(context)!.lightControl,
          assetPath: AppAssets.light,
        ),
        suggestionItem(
          itemTitle: AppLocalizations.of(context)!.temperatureMonitoring,
          assetPath: AppAssets.thermometer,
        ),
      ],
    );
  }

  suggestionItem({String? itemTitle, String? assetPath}) {
    return Expanded(
      child: BaseBorderedContainer(
        height: spacerSize125,
        width: spacerSize105,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          vertical: spacerSize15,
          horizontal: spacerSize10,
        ),
        childWidget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: spacerSize10,
          children: [
            BaseBorderedContainer(
              height: spacerSize50,
              width: spacerSize50,
              borderRadius: spacerSize100,
              backgroundColor: AppColors.superDullWhite,
              borderColor: Colors.transparent,
              alignment: Alignment.center,
              padding: EdgeInsets.all(spacerSize0),
              childWidget: Image.asset(
                assetPath!,
                color: AppColors.burntGold,
                scale: 2,
              ),
            ),
            Expanded(
              child: BaseText(
                text: itemTitle ?? "",
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                fontSize: fontSize11,
                textColor: AppColors.offWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
