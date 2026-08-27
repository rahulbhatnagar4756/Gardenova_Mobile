/// =========================================================
/// FILE: plants_diagnostic/widgets/clickable_image.dart
/// CREATE NEW FILE
/// =========================================================

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';

import '../../utils/constants/app_assets.dart';
import 'full_screen_image_preview.dart';

class ClickableImage extends StatelessWidget {
  final String imageUrl;
  final String errorImageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? heroTag;
  final Widget? errorWidget;

  /// When provided and contains more than one URL, tapping opens the
  /// swipeable [FullScreenGalleryView] starting at [initialIndex].
  /// When null or a single item, falls back to the normal single-image view.
  final List<String>? allImages;
  final int initialIndex;

  const ClickableImage({
    super.key,
    required this.imageUrl,
    this.errorImageUrl = AppAssets.appLogo,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.heroTag,
    this.errorWidget,
    this.allImages,
    this.initialIndex = 0,
  });

  void _onTap(BuildContext context) {
    final images = allImages;
    final urlToOpen = imageUrl.trim().isEmpty ? errorImageUrl : imageUrl;
    final box = context.findRenderObject() as RenderBox?;
    Rect? origin;
    if (box != null && box.hasSize) {
      origin = box.localToGlobal(Offset.zero) & box.size;
    }

    if (images != null && images.length > 1) {
      FullScreenGalleryView.openGallery(
        images: images,
        initialIndex: initialIndex.clamp(0, images.length - 1),
        heroTag: heroTag,
      );
    } else {
      FullScreenImageView.open(
        imageUrl: urlToOpen,
        heroTag: heroTag,
        originRect: origin,
        originRadius: borderRadius ?? BorderRadius.zero,
        context: context,
      );
    }
  }

  Widget _buildImage() {
    final url = imageUrl.trim();
    if (url.isEmpty || url.startsWith('assets/')) {
      return Image.asset(
        url.isEmpty ? errorImageUrl : url,
        height: height,
        width: width,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) =>
            errorWidget ?? const Center(child: Icon(Icons.broken_image)),
      );
    }
    if (url.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => BaseShimmer(height: height, width: width),
        errorWidget: (_, __, ___) =>
            errorWidget ?? const Center(child: Icon(Icons.broken_image)),
      );
    }
    return Image.file(
      File(url),
      height: height,
      width: width,
      fit: fit,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) =>
          errorWidget ?? const Center(child: Icon(Icons.broken_image)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = _buildImage();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _onTap(context),
      child: borderRadius != null
          ? ClipRRect(borderRadius: borderRadius!, child: imageWidget)
          : imageWidget,
    );
  }
}
