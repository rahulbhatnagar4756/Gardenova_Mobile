/// =========================================================
/// FILE: plants_diagnostic/views/diagnosis_loading_view.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class DiagnosisLoadingView extends StatelessWidget {
  const DiagnosisLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔹 TOP IMAGE SHIMMER
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: const BaseShimmer(
            height: spacerSize350,
            width: double.infinity,
          ),
        ),

        /// 🔹 SCROLLABLE CONTENT SHIMMER
        SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              // Spacer for image
              const SizedBox(height: spacerSize300),

              // Content Card Shimmer
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(spacerSize20),
                decoration: const BoxDecoration(
                  color: AppColors.appColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(spacerSize30),
                  ),
                  border: Border(
                    top: BorderSide(color: AppColors.backgroundGrey, width: 1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 HEADER SHIMMER (Name & Button)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BaseShimmer(
                              height: 24,
                              width: 180,
                              borderRadious: 6,
                            ),
                            const SizedBox(height: 8),
                            const BaseShimmer(
                              height: 16,
                              width: 120,
                              borderRadious: 4,
                            ),
                          ],
                        ),
                        const BaseShimmer(
                          height: 45,
                          width: 100,
                          borderRadious: 16,
                        ),
                      ],
                    ),

                    const SizedBox(height: spacerSize24),

                    /// 🔹 DESCRIPTION SHIMMER
                    const BaseShimmer(
                      height: 14,
                      width: double.infinity,
                      borderRadious: 4,
                    ),
                    const SizedBox(height: 8),
                    const BaseShimmer(
                      height: 14,
                      width: double.infinity,
                      borderRadious: 4,
                    ),
                    const SizedBox(height: 8),
                    const BaseShimmer(height: 14, width: 200, borderRadious: 4),

                    const SizedBox(height: spacerSize24),

                    /// 🔹 SUMMARY CARD SHIMMER
                    const BaseShimmer(height: 140, borderRadious: 20),

                    const SizedBox(height: spacerSize24),

                    /// 🔹 CARE GUIDE SHIMMER
                    const BaseShimmer(height: 22, width: 150, borderRadious: 6),
                    const SizedBox(height: 16),
                    ...List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: const BaseShimmer(height: 60, borderRadious: 12),
                      ),
                    ),

                    const SizedBox(height: spacerSize24),

                    /// 🔹 SIMILAR IMAGES SHIMMER
                    const BaseShimmer(height: 22, width: 150, borderRadious: 6),
                    const SizedBox(height: 16),
                    Row(
                      children: List.generate(
                        3,
                        (index) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index == 2 ? 0 : 10,
                            ),
                            child: const BaseShimmer(
                              height: 100,
                              borderRadious: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        /// 🔹 BACK BUTTON
        // SafeArea(
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: spacerSize10, top: spacerSize16),
        //     child: CircleAvatar(
        //       backgroundColor: Colors.black38,
        //       child: IconButton(
        //         icon: const Icon(Icons.arrow_back, color: Colors.white),
        //         onPressed: () => Navigator.of(context).pop(),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
