/// =========================================================
/// FILE: plants_diagnostic/widgets/full_screen_image_view.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;

  const FullScreenImageView({super.key, required this.imageUrl, this.heroTag});

  static void open({required String imageUrl, String? heroTag}) {
    if (imageUrl.trim().isEmpty) return;

    Get.to(
      () => FullScreenImageView(imageUrl: imageUrl, heroTag: heroTag),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 250),
      opaque: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.7),
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: heroTag ?? imageUrl,
              child: PhotoView(
                filterQuality: FilterQuality.high,
                imageProvider: CachedNetworkImageProvider(imageUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),

          Positioned(
            top: 57.h,
            left: 10.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
