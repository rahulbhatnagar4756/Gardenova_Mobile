import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../../../model/plant_details_model.dart';

class PlantBasicRequirementsSection extends StatelessWidget {
  final PlantModelDetails? plant;

  const PlantBasicRequirementsSection({super.key, required this.plant});

  String _cap(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    if (plant == null) return const SizedBox();

    String careLevel = _cap(plant?.careLevel ?? "");
    String watering = _cap(plant?.watering ?? "");
    String sunlight = _cap(plant?.sunlight ?? "");
    bool poisonousToPets = plant?.poisonousToPets ?? false;
    bool poisonousToHumans = plant?.poisonousToHumans ?? false;

    String toxicity = "Non-Toxic";
    if (poisonousToPets && poisonousToHumans) {
      toxicity = "Toxic";
    } else if (poisonousToPets) {
      toxicity = "Toxic to Pets";
    } else if (poisonousToHumans) {
      toxicity = "Toxic to Humans";
    }

    List<Widget> items = [];

    if (careLevel.isNotEmpty) {
      items.add(
        _buildRequirementCard(
          Icons.spa_rounded,
          "Care Level",
          careLevel,
          AppColors.greenColor,
          AppColors.greenColor.withOpacity(0.1),
        ),
      );
    }
    if (watering.isNotEmpty) {
      items.add(
        _buildRequirementCard(
          Icons.water_drop_rounded,
          "Water",
          watering,
          Colors.blue,
          Colors.blue.withOpacity(0.1),
        ),
      );
    }
    if (sunlight.isNotEmpty) {
      items.add(
        _buildRequirementCard(
          Icons.wb_sunny_rounded,
          "Light",
          sunlight,
          Colors.orange,
          Colors.orange.withOpacity(0.1),
        ),
      );
    }
    if (toxicity.isNotEmpty) {
      items.add(
        _buildRequirementCard(
          toxicity == "Non-Toxic"
              ? Icons.health_and_safety_rounded
              : Icons.warning_amber_rounded,
          "Toxicity",
          toxicity,
          toxicity == "Non-Toxic" ? Colors.green : Colors.redAccent,
          toxicity == "Non-Toxic"
              ? Colors.green.withOpacity(0.1)
              : Colors.redAccent.withOpacity(0.1),
        ),
      );
    }

    if (items.isEmpty) return const SizedBox();

    List<Widget> rows = [];
    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: items[i]),
              SizedBox(width: 12.w),
              if (i + 1 < items.length)
                Expanded(child: items[i + 1])
              else
                Expanded(child: const SizedBox()),
            ],
          ),
        ),
      );
      if (i + 2 < items.length) {
        rows.add(SizedBox(height: 12.h));
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: rows);
  }

  Widget _buildRequirementCard(
    IconData icon,
    String title,
    String value,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.toToLiteGreenColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.liteGreenColor, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BaseText(
                  text: title,
                  fontFamily: AppKeys.inter,
                  fontSize: fontSize11,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.liteGreyColor,
                ),
                SizedBox(height: 2.h),
                BaseText(
                  text: value,
                  fontFamily: AppKeys.inter,
                  fontSize: fontSize13,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.blackColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
