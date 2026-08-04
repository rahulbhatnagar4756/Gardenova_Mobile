import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/plants/allPlants/allPlantsDetails/all_plants_details_controller.dart';
import 'package:kasagardem/plants/model/plant_info_item.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class PlantPropertyCard extends StatelessWidget {
  const PlantPropertyCard({super.key, this.allPlantsDetailsController});
  final AllPlantsDetailsController? allPlantsDetailsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // First row always visible
        _buildRow(allPlantsDetailsController!.plantInfoList),

        // Extra rows on Show More
        //    if (_showMore) ...[const SizedBox(height: 20), _buildRow(_extraItems)],
        const SizedBox(height: 16),

        // Show More / Show Less toggle
        // GestureDetector(
        //   onTap: () => setState(() => _showMore = !_showMore),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(
        //         _showMore ? 'Show Less' : 'Show More',
        //         style: const TextStyle(color: _green, fontWeight: FontWeight.w600, fontSize: 14),
        //       ),
        //       const SizedBox(width: 4),
        //       AnimatedRotation(
        //         turns: _showMore ? 0.5 : 0,
        //         duration: const Duration(milliseconds: 250),
        //         child: const Icon(Icons.keyboard_arrow_down, color: _green, size: 20),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildRow(List<PlantInfoItem> items) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.asMap().entries.map((entry) {
          final int index = entry.key;
          final item = entry.value;

          return Expanded(
            child: Row(
              children: [
                Expanded(child: _buildInfoItem(item)),
                if (index < items.length - 1)
                  VerticalDivider(width: 1, thickness: 1, color: AppColors.grey, endIndent: 5),
                if (index < items.length - 1) SizedBox(width: spacerSize10),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoItem(PlantInfoItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(color: AppColors.lightGreen, shape: BoxShape.circle),
          child: Icon(item.icon, color: AppColors.greenColor, size: 20),
        ),
        const SizedBox(height: 8),
        BaseText(
          text: item.label,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          fontSize: fontSize11,
          textColor: AppColors.greenColor,
          fontWeight: FontWeight.w500,
        ),

        const SizedBox(height: 2),
        BaseText(
          text: item.value,
          textAlign: TextAlign.start,
          fontSize: fontSize12,
          textColor: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
