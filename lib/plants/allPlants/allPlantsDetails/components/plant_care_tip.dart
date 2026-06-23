import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class PlantCareTipCard extends StatelessWidget {
  const PlantCareTipCard({super.key, required this.green, required this.lightGreen});
  final Color green;
  final Color lightGreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: lightGreen, shape: BoxShape.circle),
            child: Image.asset(
              AppAssets.plant,
              height: spacerSize40,
              width: spacerSize40,
            ).paddingAll(spacerSize10),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plant Care Tip',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Mulch in spring and fall to retain moisture and regulate soil temperature',
                  style: TextStyle(fontSize: 12.5, color: Color(0xFF616161), height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Image.asset(AppAssets.plantPic, height: 110, width: 120),
        ],
      ),
    );
  }
}
