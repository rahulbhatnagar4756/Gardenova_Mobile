import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/diagnosis_section_card.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

import '../../../base/widgets/clickable_image.dart';
import '../../../base/widgets/safe_cached_network_image.dart';
import 'package:kasagardem/utils/constants/app_strings.dart';

class SimilarImagesSection extends StatelessWidget {
  final List<String> images;

  const SimilarImagesSection({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox();

    return DiagnosisSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: AppStrings.similarPlantImages,
            fontFamily: AppKeys.poppins,
            fontWeight: FontWeight.bold,
            fontSize: fontSize18,
          ),

          SizedBox(height: 16.h),

          SizedBox(
            height: 110.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),

              itemBuilder: (_, index) {
                return ClickableImage(
                  imageUrl: images[index],
                  height: 110.h,
                  width: 110.w,
                  fit: BoxFit.cover,
                  heroTag: "similar_image_$index",
                  borderRadius: BorderRadius.circular(18.r),
                  allImages: images,
                  initialIndex: index,
                  errorWidget: BrokenImageView(
                    height: 110.h,
                    width: 110.w,
                    iconSize: 36,
                  ),
                );
                // return GestureDetector(
                //   onTap: () {
                //     Get.to(
                //       () => FullScreenImagePreview(
                //         images: images,
                //         initialIndex: index,
                //       ),
                //       transition: Transition.fadeIn,
                //     );
                //   },
                //
                //   child: Hero(
                //     tag: image,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(18.r),
                //       child: CachedNetworkImage(
                //         imageUrl: image,
                //         width: 110.w,
                //         fit: BoxFit.cover,
                //
                //         placeholder: (_, __) {
                //           return Container(
                //             width: 110.w,
                //             color: AppColors.greenColor.withValues(alpha: .08),
                //             child: const Center(
                //               child: CircularProgressIndicator(strokeWidth: 2),
                //             ),
                //           );
                //         },
                //
                //         errorWidget: (_, __, ___) {
                //           return Container(
                //             width: 110.w,
                //             color: AppColors.greenColor.withValues(alpha: .08),
                //             child: Icon(
                //               Icons.broken_image_outlined,
                //               color: AppColors.greenColor,
                //             ),
                //           );
                //         },
                //       ),
                //     ),
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }
}
