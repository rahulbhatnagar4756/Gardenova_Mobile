import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class MyPlantDetailsLoadingView extends StatelessWidget {
  const MyPlantDetailsLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔹 TOP IMAGE SHIMMER
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: BaseShimmer(
            height: spacerSize350,
            width: double.infinity,
          ),
        ),

        /// 🔹 SCROLLABLE CONTENT SHIMMER
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              // Transparent spacer to allow image to show
              const SizedBox(height: spacerSize300),

              // Content Card
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
                    /// 🔹 HEADER SHIMMER (Name & Action)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BaseShimmer(height: 24, width: 180, borderRadious: 6),
                            const SizedBox(height: 8),
                            const BaseShimmer(height: 16, width: 120, borderRadious: 4),
                          ],
                        ),
                        const BaseShimmer(height: 48, width: 48, borderRadious: 12),
                      ],
                    ),

                    const SizedBox(height: spacerSize24),

                    /// 🔹 PERSONALIZED CARE SHIMMER
                    const BaseShimmer(height: 22, width: 150, borderRadious: 6),
                    const SizedBox(height: spacerSize16),
                    const BaseShimmer(height: 120, borderRadious: 18),

                    const SizedBox(height: spacerSize24),

                    /// 🔹 PLANT STATS SHIMMER
                    const BaseShimmer(height: 22, width: 150, borderRadious: 6),
                    const SizedBox(height: spacerSize16),
                    Row(
                      children: List.generate(3, (index) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: index == 2 ? 0 : 10),
                          child: const BaseShimmer(height: 140, borderRadious: 16),
                        ),
                      )),
                    ),

                    const SizedBox(height: spacerSize24),

                    /// 🔹 UPCOMING EVENTS SHIMMER
                    const BaseShimmer(height: 22, width: 150, borderRadious: 6),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: const BaseShimmer(height: 140, borderRadious: 16)),
                        const SizedBox(width: 15),
                        Expanded(child: const BaseShimmer(height: 140, borderRadious: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// 🔹 BACK BUTTON SHIMMER/UI
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: spacerSize10, top: spacerSize16),
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
