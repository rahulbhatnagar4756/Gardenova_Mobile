import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class PlantAnalysisDetailLoadingView extends StatelessWidget {
  const PlantAnalysisDetailLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BaseShimmer(height: spacerSize350, width: double.infinity),
          ),
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: spacerSize300),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(spacerSize20),
                  decoration: const BoxDecoration(
                    color: AppColors.appColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(spacerSize30),
                    ),
                    border: Border(
                      top: BorderSide(color: AppColors.greenColor, width: 1),
                    ),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BaseShimmer(height: 24, width: 180, borderRadious: 6),
                      SizedBox(height: spacerSize8),
                      BaseShimmer(height: 16, width: 120, borderRadious: 4),
                      SizedBox(height: spacerSize24),
                      BaseShimmer(height: 90, borderRadious: 16),
                      SizedBox(height: spacerSize16),
                      BaseShimmer(height: 140, borderRadious: 16),
                      SizedBox(height: spacerSize16),
                      BaseShimmer(height: 140, borderRadious: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
