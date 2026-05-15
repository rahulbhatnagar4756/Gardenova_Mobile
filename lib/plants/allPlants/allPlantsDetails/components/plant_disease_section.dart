import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../base/widgets/base_text.dart';
import '../../../../base/widgets/clickable_image.dart';
import '../../../../base/widgets/expandable_text.dart';
import '../../../../utils/constants/app_color.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../utils/constants/app_keys.dart';
import '../../../model/plant_details_model.dart';
import 'plant_section_title.dart';

class PlantDiseaseSection extends StatelessWidget {
  final DiseaseModel? disease;
  final bool showImage;

  const PlantDiseaseSection({
    super.key,
    required this.disease,
    this.showImage = true,
  });
  String _cap(String s) {
    if (s.isEmpty) return s;

    // If it contains '|', treat it as list
    if (s.contains('|')) {
      return s
          .split('|')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .map((e) => e[0].toUpperCase() + e.substring(1))
          .join(', ');
    }

    // Normal single value
    return s[0].toUpperCase() + s.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    if (disease == null ||
        (disease?.description == null &&
            disease?.solution == null &&
            disease?.host == null)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlantSectionTitle(
          title: "Diagnosis Result",
          icon: Icons.health_and_safety_outlined,
          // color: AppColors.red,
        ),
        SizedBox(height: spacerSize16),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(spacerSize16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF5F5), // Very light red/pink background
            borderRadius: BorderRadius.circular(spacerSize18),
            border: Border.all(color: AppColors.red.withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: AppColors.red.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showImage &&
                  disease?.localImageDiseasePath != null &&
                  disease!.localImageDiseasePath!.isNotEmpty) ...[
                ClickableImage(
                  imageUrl: disease!.localImageDiseasePath!,
                  height: 150.h,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(spacerSize12),
                  heroTag: "disease_image_${disease!.localImageDiseasePath!}",
                ),
                SizedBox(height: spacerSize16),
              ],
              if (disease?.host != null && disease!.host!.isNotEmpty)
                _buildInfoItem(
                  "Affected Area",
                  disease!.host!,
                  Icons.coronavirus_outlined,
                ),
              if (disease?.description != null &&
                  disease!.description!.isNotEmpty)
                _buildInfoItem(
                  "Description",
                  disease!.description!,
                  Icons.info_outline_rounded,
                ),
              if (disease?.solution != null && disease!.solution!.isNotEmpty)
                _buildInfoItem(
                  "Treatment & Solution",
                  disease!.solution!,
                  Icons.healing_outlined,
                  isSuccess: true,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    String title,
    String content,
    IconData icon, {
    bool isSuccess = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacerSize12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(spacerSize8),
            decoration: BoxDecoration(
              color: isSuccess
                  ? AppColors.greenColor.withOpacity(0.12)
                  : AppColors.red.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 16.sp,
              color: isSuccess ? AppColors.greenColor : AppColors.red,
            ),
          ),
          SizedBox(width: spacerSize12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BaseText(
                  text: title,
                  fontFamily: AppKeys.poppins,
                  fontSize: fontSize13,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.blackColor,
                ),
                SizedBox(height: spacerSize4),

                // BaseText(
                //   text: content,
                //   fontFamily: AppKeys.inter,
                //   fontSize: fontSize12,
                //   fontWeight: FontWeight.w400,
                //   textColor: AppColors.liteGreyColor,
                // ),
                ExpandableText(
                  text: _cap(content),
                  trimLines: 3,
                  textColor: AppColors.liteGreyColor,
                  lineHeight: 1.5,
                  showMoreTxtColor: AppColors.red,
                  // showMoreTxtColor: AppColors.red.withOpacity(0.50),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
