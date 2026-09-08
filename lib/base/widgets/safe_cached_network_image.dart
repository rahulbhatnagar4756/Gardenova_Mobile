import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/utils.dart';

/// Fallback shown when a network image is missing, corrupt, or has no host.
class BrokenImageView extends StatelessWidget {
  const BrokenImageView({
    super.key,
    this.height,
    this.width,
    this.iconSize = 40,
    this.color,
    this.backgroundColor,
  });

  final double? height;
  final double? width;
  final double iconSize;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? AppColors.backgroundGrey,
      child: SizedBox(
        height: height,
        width: width,
        child: Center(
          child: Icon(
            Icons.broken_image_rounded,
            size: iconSize,
            color: color ?? AppColors.greyIconColor,
          ),
        ),
      ),
    );
  }
}

/// [CachedNetworkImage] that never starts a download for empty/relative URLs.
/// Those values throw `Invalid argument(s): No host specified in URI` inside
/// flutter_cache_manager and bypass [errorWidget].
class SafeCachedNetworkImage extends StatelessWidget {
  const SafeCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.useOldImageOnUrlChange = false,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;
  final bool useOldImageOnUrlChange;

  Widget _brokenImage(BuildContext context, String url, Object error) {
    final fallback = errorWidget != null
        ? errorWidget!(context, url, error)
        : BrokenImageView(height: height, width: width);
    if (height == null && width == null) return fallback;
    return SizedBox(height: height, width: width, child: fallback);
  }

  @override
  Widget build(BuildContext context) {
    if (!Utils.isValidNetworkImageUrl(imageUrl)) {
      return _brokenImage(
        context,
        imageUrl,
        ArgumentError('No host specified in URI'),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl.trim(),
      height: height,
      width: width,
      fit: fit,
      placeholder: placeholder,
      errorWidget: _brokenImage,
      useOldImageOnUrlChange: useOldImageOnUrlChange,
    );
  }
}
