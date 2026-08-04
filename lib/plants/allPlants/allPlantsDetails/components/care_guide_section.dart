import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../dashboard/plants_diagnostic/widgets/care_info_tile.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../../../../utils/constants/app_strings.dart';
import '../../../model/plant_details_model.dart';

class CareGuideSection extends StatelessWidget {
  final Care care;

  const CareGuideSection({super.key, required this.care});

  @override
  Widget build(BuildContext context) {
    bool watering = false;
    bool sunLight = false;
    bool pruning = false;
    if (care.watering != null && care.watering!.isNotEmpty) {
      watering = true;
    }
    if (care.sunlight != null && care.sunlight!.isNotEmpty) {
      sunLight = true;
    }
    if (care.pruning != null && care.pruning!.isNotEmpty) {
      pruning = true;
    }
    if (watering == false && sunLight == false && pruning == false) {
      return SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //
        Row(
          children: [
            Icon(
              Icons.content_paste,
              color: AppColors.greenColor,
              size: spacerSize18,
            ),
            SizedBox(width: spacerSize8),
            BaseText(
              text: AppStrings.careGuide,
              fontFamily: AppKeys.poppins,
              fontSize: fontSize15,
              fontWeight: FontWeight.w700,
              textColor: AppColors.greenColor,
            ),
          ],
        ),
        SizedBox(height: spacerSize16),
        if (watering) ...[
          CareInfoTile(
            title: AppStrings.watering,
            value: care.watering!,
            icon: Icons.water_drop_outlined,
          ),
          SizedBox(height: sunLight ? 12.h : 0),
        ],
        if (sunLight) ...[
          CareInfoTile(
            title: AppStrings.lightCondition,
            value: care.sunlight!,
            icon: Icons.sunny,
          ),
          SizedBox(height: pruning ? 12.h : 0),
        ],
        if (pruning) ...[
          CareInfoTile(
            title: AppLocalizations.of(context)!.pruning,
            value: care.pruning!,
            icon: Icons.content_cut,
          ),
        ],
        SizedBox(height: 15.h),
      ],
    );
  }
}
