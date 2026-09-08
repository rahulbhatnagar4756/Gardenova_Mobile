/// =========================================================
/// FILE: plants_diagnostic/widgets/clickable_image.dart
/// CREATE NEW FILE
/// =========================================================

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/base/widgets/safe_cached_network_image.dart';
import 'package:kasagardem/utils/utils.dart';

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

  Widget _fallback() {
    return errorWidget ?? BrokenImageView(height: height, width: width);
  }

  Widget _buildImage() {
    final url = imageUrl.trim();
    if (url.isEmpty || url.startsWith('assets/')) {
      if (url.isEmpty) return _fallback();
      return Image.asset(
        url,
        height: height,
        width: width,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    if (Utils.isValidNetworkImageUrl(url)) {
      return SafeCachedNetworkImage(
        imageUrl: url,
        height: height,
        width: width,
        fit: fit,
        placeholder: (context, url) => BaseShimmer(height: height, width: width),
        errorWidget: (_, __, ___) => _fallback(),
      );
    }
    if (url.startsWith('http')) {
      return _fallback();
    }
    return Image.file(
      File(url),
      height: height,
      width: width,
      fit: fit,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => _fallback(),
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
