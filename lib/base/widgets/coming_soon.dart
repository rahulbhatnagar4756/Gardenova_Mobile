import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Center(
        child: BaseText(
          text: AppLocalizations.of(context)!.comingSoon,
          textColor: AppColors.offWhite70,
          fontFamily: AppKeys.poppins,
          fontSize: fontSize26,
        ),
      ),
    );
  }
}
