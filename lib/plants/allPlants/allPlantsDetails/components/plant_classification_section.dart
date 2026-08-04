import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../../../model/plant_details_model.dart';
import 'plant_section_title.dart';

class PlantClassificationSection extends StatelessWidget {
  final PlantModelDetails? plant;

  const PlantClassificationSection({super.key, required this.plant});

  String _cap(String s) {
    if (s.isEmpty) return s;

    // If it contains '|', treat it as list
    if (s.contains('|')) {
      return s
          .split('|')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map((e) => e[0].toUpperCase() + e.substring(1))
          .join(', ');
    }

    // Normal single value
    return s[0].toUpperCase() + s.substring(1);
  }

  // String _cap(String s) {
  //   if (s.isEmpty) return s;
  //   return s[0].toUpperCase() + s.substring(1);
  // }

  Widget item({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: spacerSize8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BaseText(
            text: title,
            fontFamily: AppKeys.inter,
            fontSize: fontSize13,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(width: 50.w),
          Flexible(
            child: BaseText(
              text: value,
              fontFamily: AppKeys.inter,
              fontSize: fontSize12,
              fontWeight: FontWeight.w400,
              textColor: AppColors.liteGreyColor,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (plant == null) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlantSectionTitle(
          title: "Classification",
          icon: Icons.category_outlined,
        ),

        SizedBox(height: spacerSize16),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(spacerSize16),
          decoration: BoxDecoration(
            color: AppColors.toToLiteGreenColor,
            borderRadius: BorderRadius.circular(spacerSize18),
            border: Border.all(color: AppColors.liteGreenColor),
          ),
          child: Column(
            children: [
              if (plant?.family != null) ...[
                item(title: "Family", value: _cap(plant!.family!)),
                Divider(),
              ],
              if (plant?.genus != null) ...[
                item(title: "Genus", value: _cap(plant!.genus!)),
              ],
              if (plant?.speciesEpithet != null) ...[
                Divider(),
                item(title: "Species", value: _cap(plant!.speciesEpithet!)),
              ],
              if (plant?.origin != null && plant!.origin!.isNotEmpty) ...[
                Divider(),
                item(title: "Origin", value: _cap(plant!.origin!)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
