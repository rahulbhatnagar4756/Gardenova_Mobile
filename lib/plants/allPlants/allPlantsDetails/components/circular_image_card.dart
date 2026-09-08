import 'package:flutter/material.dart';
import 'package:kasagardem/base/widgets/safe_cached_network_image.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

class CircularImageCard extends StatelessWidget {
  final String imageUrl;
  final double size;

  const CircularImageCard({super.key, required this.imageUrl, this.size = 150});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: SafeCachedNetworkImage(
          imageUrl: imageUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => BrokenImageView(
            height: size,
            width: size,
            iconSize: size * 0.4,
            backgroundColor: AppColors.backgroundGrey,
          ),
        ),
      ),
    );
  }
}
