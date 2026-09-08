/// =========================================================
/// FILE: plants_diagnostic/widgets/full_screen_image_view.dart
/// CREATE NEW FILE
/// =========================================================

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/utils.dart';
import 'package:photo_view/photo_view.dart';

import 'safe_cached_network_image.dart';

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;
  final Rect? originRect;
  final BorderRadius originRadius;
  final Animation<double> animation;

  const FullScreenImageView({
    super.key,
    required this.imageUrl,
    required this.animation,
    this.heroTag,
    this.originRect,
    this.originRadius = BorderRadius.zero,
  });

  static void open({
    required String imageUrl,
    String? heroTag,
    Rect? originRect,
    BorderRadius? originRadius,
    BuildContext? context,
  }) {
    if (imageUrl.trim().isEmpty) return;
    final navContext = context ?? Get.overlayContext ?? Get.context;
    if (navContext == null) return;

    precacheImage(_providerFor(imageUrl), navContext);

    Navigator.of(navContext, rootNavigator: true).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.transparent,
        transitionDuration: const Duration(milliseconds: 340),
        reverseTransitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FullScreenImageView(
            imageUrl: imageUrl,
            heroTag: heroTag,
            originRect: originRect,
            originRadius: originRadius ?? BorderRadius.zero,
            animation: animation,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
    );
  }

  static ImageProvider _providerFor(String imageUrl) {
    if (Utils.isValidNetworkImageUrl(imageUrl)) {
      return CachedNetworkImageProvider(imageUrl.trim());
    }
    if (imageUrl.startsWith('assets/')) {
      return AssetImage(imageUrl);
    }
    return FileImage(File(imageUrl));
  }

  ImageProvider get _imageProvider => _providerFor(imageUrl);

  Widget _closeButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: EdgeInsets.all(7.w),
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white),
      ),
    );
  }

  Rect _destinationRect(Size screen, Rect origin) {
    final aspect = origin.width == 0 ? 1.0 : origin.width / origin.height;
    final maxW = screen.width;
    final maxH = screen.height;
    late final double width;
    late final double height;
    if (maxW / maxH > aspect) {
      height = maxH;
      width = height * aspect;
    } else {
      width = maxW;
      height = width / aspect;
    }
    return Rect.fromCenter(
      center: Offset(screen.width / 2, screen.height / 2),
      width: width,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final curved = Curves.easeInOutCubic.transform(animation.value);
        final backdrop = GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(color: Colors.black.withValues(alpha: 0.85 * curved)),
        );

        if (originRect == null) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Positioned.fill(child: backdrop),
                FadeTransition(
                  opacity: animation,
                  child: PhotoView(
                    filterQuality: FilterQuality.high,
                    imageProvider: _imageProvider,
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 3,
                    backgroundDecoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    errorBuilder: (_, __, ___) => const BrokenImageView(
                      iconSize: 64,
                      color: Colors.white54,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
                Positioned(
                  top: 57.h,
                  left: 10.w,
                  child: FadeTransition(
                    opacity: animation,
                    child: _closeButton(context),
                  ),
                ),
              ],
            ),
          );
        }

        final destRect = _destinationRect(MediaQuery.sizeOf(context), originRect!);
        final rect = Rect.lerp(originRect, destRect, curved)!;
        final radius = BorderRadius.lerp(originRadius, BorderRadius.zero, curved)!;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(child: backdrop),
              Positioned.fromRect(
                rect: rect,
                child: ClipRRect(
                  borderRadius: radius,
                  child: Image(
                    image: _imageProvider,
                    fit: BoxFit.cover,
                    gaplessPlayback: true,
                    filterQuality: FilterQuality.high,
                    width: rect.width,
                    height: rect.height,
                    errorBuilder: (_, __, ___) => const BrokenImageView(
                      iconSize: 48,
                      color: Colors.white54,
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 57.h,
                left: 10.w,
                child: Opacity(
                  opacity: curved,
                  child: _closeButton(context),
                ),
              ),
            ],
          ),
        );
      },
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
    if (Utils.isValidNetworkImageUrl(url)) {
      return CachedNetworkImageProvider(url.trim());
    }
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
                errorBuilder: (_, __, ___) => const BrokenImageView(
                  iconSize: 64,
                  color: Colors.white54,
                  backgroundColor: Colors.transparent,
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
