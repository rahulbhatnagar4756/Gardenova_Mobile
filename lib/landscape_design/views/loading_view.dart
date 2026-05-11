import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class LandscapeDesignLoadingView extends StatelessWidget {
  const LandscapeDesignLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔹 TOP IMAGE SHIMMER (The AI is "working" on the image)
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: BaseShimmer(height: spacerSize350, width: double.infinity),
        ),

        /// 🔹 SCROLLABLE CONTENT SHIMMER
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 TITLE SHIMMER
                    const BaseShimmer(height: 28, width: 220, borderRadious: 8),
                    const SizedBox(height: spacerSize16),

                    /// 🔹 DESCRIPTION TEXT SHIMMER
                    ...List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: BaseShimmer(
                          height: 14,
                          width: index == 3 ? 200 : double.infinity,
                          borderRadious: 4,
                        ),
                      ),
                    ),

                    SizedBox(height: spacerSize28),

                    /// 🔹 COMPARISON CARD SHIMMER
                    const BaseShimmer(height: 200, borderRadious: 20),

                    const SizedBox(height: spacerSize24),

                    /// 🔹 ADDITIONAL INFO BLOCKS
                    const BaseShimmer(height: 100, borderRadious: 16),

                    const SizedBox(height: spacerSize24),

                    /// 🔹 COMPARISON CARD SHIMMER
                    const BaseShimmer(height: 200, borderRadious: 20),

                    const SizedBox(height: spacerSize24),

                    /// 🔹 ADDITIONAL INFO BLOCKS
                    const BaseShimmer(height: 100, borderRadious: 16),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// 🔹 BACK BUTTON
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: spacerSize10,
              top: spacerSize16,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.black38,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
