/// =========================================================
/// FILE: plants_diagnostic/widgets/clickable_image.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';

import 'full_screen_image_preview.dart';

class ClickableImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? heroTag;
  final Widget? errorWidget;

  const ClickableImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.heroTag,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) => BaseShimmer(height: height, width: width),
      errorWidget: (_, __, ___) =>
          errorWidget ?? const Center(child: Icon(Icons.broken_image)),
    );

    return GestureDetector(
      onTap: () {
        FullScreenImageView.open(imageUrl: imageUrl, heroTag: heroTag);
      },
      child: Hero(
        tag: heroTag ?? imageUrl,
        child: borderRadius != null
            ? ClipRRect(borderRadius: borderRadius!, child: imageWidget)
            : imageWidget,
      ),
    );
  }
}
