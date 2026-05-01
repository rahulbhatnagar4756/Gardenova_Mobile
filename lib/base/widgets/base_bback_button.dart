import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

import '../../utils/constants/app_assets.dart';

class BasBBackButton extends StatelessWidget {
  const BasBBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Row(
        spacing: spacerSize4,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(AppAssets.backBtnIc,
          width: 20.w,
          height: 20.w,)

        ],
      ),
    );
  }
}
