import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class LandscapeDesignProcessingView extends StatelessWidget {
  final String? imageUrl;

  const LandscapeDesignProcessingView({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// 🔹 BACKGROUND IMAGE (Blurred)
          if (imageUrl != null && imageUrl!.isNotEmpty)
            Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(color: Colors.black),
            ),

          /// 🔹 BLUR OVERLAY
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          /// 🔹 PROCESSING CONTENT
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// 🔹 FANCY LOADER
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 100.w,
                      width: 100.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.greenColor,
                      ),
                    ),
                    Icon(
                      Icons.auto_awesome,
                      color: AppColors.greenColor,
                      size: 40.sp,
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                const BaseText(
                  text: "AI is crafting your vision...",
                  fontSize: fontSize22,
                  fontWeight: FontWeight.bold,
                  textColor: Colors.white,
                ),

                SizedBox(height: 12.h),

                BaseText(
                  text: "Reimagining your space with the new style",
                  fontSize: fontSize14,
                  textColor: Colors.white70,
                  textAlign: TextAlign.center,
                ).paddingSymmetric(horizontal: 40.w),
              ],
            ),
          ),

          /// 🔹 BACK BUTTON (Safety)
          Positioned(
            top: 40.h,
            left: 20.w,
            child: CircleAvatar(
              backgroundColor: Colors.black38,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
