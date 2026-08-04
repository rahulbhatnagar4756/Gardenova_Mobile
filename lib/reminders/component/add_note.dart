import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class AddNote extends StatelessWidget {
  const AddNote({super.key, this.title, this.onTap});

  final String? title;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(color: AppColors.backgroundGrey, indent: 0, endIndent: 0),
        InkWell(
          onTap: onTap!,
          child: Padding(
            padding: EdgeInsets.only(left: spacerSize12, bottom: spacerSize12, right: spacerSize5),
            child: Row(
              children: [
                Icon(Icons.event_note, size: spacerSize20, color: AppColors.grey),
                SizedBox(width: spacerSize4),
                BaseText(
                  text: title ?? "",
                  fontFamily: AppKeys.inter,
                  fontSize: fontSize12,
                  fontWeight: FontWeight.w400,
                ),
                Spacer(),

                Icon(Icons.navigate_next_outlined, color: AppColors.greenColor, size: spacerSize20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
