/// =========================================================
/// FILE: plants_diagnostic/widgets/full_screen_image_view.dart
/// CREATE NEW FILE
/// =========================================================

import 'dart:io';

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
    debugPrint('open from full image view');
    if (imageUrl.trim().isEmpty) return;
    debugPrint('open image url is $imageUrl');
    Get.to(
      () => FullScreenImageView(imageUrl: imageUrl, heroTag: heroTag),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 250),
      opaque: false,
    );
  }

  // Image.asset(
  //                             AppAssets.appLogo,
  //                             fit: BoxFit.cover,
  //                           )
  ImageProvider _getImageProvider() {
    debugPrint('image url is $imageUrl');
    // Network image
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImageProvider(imageUrl);
    }

    // Asset image
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    }

    // Local file image
    return FileImage(File(imageUrl));
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
                imageProvider: _getImageProvider(),
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

// ---------------------------------------------------------------------------
// FullScreenGalleryView — swipeable gallery for multiple images.
// Existing FullScreenImageView is completely untouched.
// ---------------------------------------------------------------------------
class FullScreenGalleryView extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenGalleryView({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  /// Opens the gallery. Falls back to single-image view when only one image.
  static void openGallery({
    required List<String> images,
    int initialIndex = 0,
    String? heroTag,
  }) {
    if (images.isEmpty) return;
    if (images.length == 1) {
      FullScreenImageView.open(imageUrl: images.first, heroTag: heroTag);
      return;
    }
    Get.to(
      () => FullScreenGalleryView(
        images: images,
        initialIndex: initialIndex.clamp(0, images.length - 1),
      ),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 250),
      opaque: false,
    );
  }

  @override
  State<FullScreenGalleryView> createState() => _FullScreenGalleryViewState();
}

class _FullScreenGalleryViewState extends State<FullScreenGalleryView> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.images.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  ImageProvider _imageProviderFor(String url) {
    if (url.startsWith('http')) return CachedNetworkImageProvider(url);
    if (url.startsWith('assets/')) return AssetImage(url);
    return FileImage(File(url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      body: Stack(
        children: [
          // ── Swipeable gallery ──────────────────────────────────────────────
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (_, i) {
              return PhotoView(
                filterQuality: FilterQuality.high,
                imageProvider: _imageProviderFor(widget.images[i]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                // Allow horizontal swipe to propagate to PageView
                gestureDetectorBehavior: HitTestBehavior.translucent,
              );
            },
          ),

          // ── Counter pill ───────────────────────────────────────────────────
          Positioned(
            top: 57.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentIndex + 1} / ${widget.images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // ── Dot indicators ─────────────────────────────────────────────────
          Positioned(
            bottom: 30.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (i) {
                final bool active = i == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 20 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color:
                        active ? Colors.white : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),

          // ── Close button ───────────────────────────────────────────────────
          Positioned(
            top: 57.h,
            left: 10.w,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(7.w),
                decoration: const BoxDecoration(
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

