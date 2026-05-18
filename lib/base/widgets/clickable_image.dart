/// =========================================================
/// FILE: plants_diagnostic/widgets/clickable_image.dart
/// CREATE NEW FILE
/// =========================================================

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

  void _onTap() {
    final images = allImages;
    if (images != null && images.length > 1) {
      FullScreenGalleryView.openGallery(
        images: images,
        initialIndex: initialIndex.clamp(0, images.length - 1),
        heroTag: heroTag,
      );
    } else {
      FullScreenImageView.open(imageUrl: imageUrl, heroTag: heroTag);
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) => BaseShimmer(height: height, width: width),
      errorWidget: (_, __, ___) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          print('onClick erro image');
          FullScreenImageView.open(imageUrl: errorImageUrl, heroTag: heroTag);
        },
        child: errorWidget ?? const Center(child: Icon(Icons.broken_image)),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: Hero(
        tag: heroTag ?? imageUrl,
        child: borderRadius != null
            ? ClipRRect(borderRadius: borderRadius!, child: imageWidget)
            : imageWidget,
      ),
    );
  }
}
