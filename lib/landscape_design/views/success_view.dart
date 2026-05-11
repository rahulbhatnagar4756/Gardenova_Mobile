import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/base/widgets/clickable_image.dart';
import 'package:kasagardem/base/widgets/full_screen_image_preview.dart';
import 'package:kasagardem/landscape_design/landscape_design_view_model.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class LandscapeDesignSuccessView extends StatelessWidget {
  final LandscapeDesignViewModel controller;

  const LandscapeDesignSuccessView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final data = controller.landscapeResponse.value.data;
    if (data == null) return const SizedBox();

    return Stack(
      children: [
        /// 🔹 GENERATED IMAGE (MAIN BACKGROUND)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClickableImage(
            imageUrl: data.gardenUrl ?? "",
            height: spacerSize350,
            width: double.infinity,
            fit: BoxFit.cover,
            heroTag: "landscape_result_image",
          ),
        ),

        /// 🔹 SCROLLABLE CONTENT
        SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (data.gardenUrl != null && data.gardenUrl!.isNotEmpty) {
                    FullScreenImageView.open(
                      imageUrl: data.gardenUrl!,
                      heroTag: "landscape_result_image",
                    );
                  }
                },
                child: Container(
                  height: spacerSize300,
                  color: Colors.transparent,
                ),
              ),

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
                    const BaseText(
                      text: "Landscape Transformation",
                      fontSize: fontSize22,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppKeys.poppins,
                    ),
                    const SizedBox(height: spacerSize16),

                    /// 🔹 DESCRIPTION BOX
                    Container(
                      padding: const EdgeInsets.all(spacerSize16),
                      decoration: BoxDecoration(
                        color: AppColors.toToLiteGreenColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.liteGreenColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.auto_awesome,
                                color: AppColors.greenColor,
                                size: 20.sp,
                              ),
                              const SizedBox(width: 8),
                              const BaseText(
                                text: "AI Analysis & Suggestions",
                                fontWeight: FontWeight.w600,
                                textColor: AppColors.greenColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          BaseText(
                            text:
                                data.description ?? "No description available",
                            textColor: AppColors.liteGreyColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: spacerSize24),

                    /// 🔹 COMPARISON SECTION
                    const BaseText(
                      text: "Original Vision",
                      fontSize: fontSize18,
                      fontWeight: FontWeight.w600,
                      fontFamily: AppKeys.poppins,
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ClickableImage(
                        imageUrl: data.originalUrl ?? "",
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),

                    SizedBox(height: spacerSize28),
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
