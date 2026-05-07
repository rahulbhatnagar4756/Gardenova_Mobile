/// =========================================================
/// FILE: plants_diagnostic/widgets/taxonomy_section.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/model/plant_diagnosis_response_model.dart';
import 'package:kasagardem/dashboard/plants_diagnostic/widgets/diagnosis_section_card.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/constants/app_keys.dart';

class TaxonomySection extends StatelessWidget {
  final Taxonomy? taxonomy;

  const TaxonomySection({
    super.key,
    required this.taxonomy,
  });

  @override
  Widget build(BuildContext context) {
    if (taxonomy == null) return const SizedBox();

    return DiagnosisSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BaseText(
            text: "Plant Taxonomy",
            fontFamily: AppKeys.poppins,
            fontWeight: FontWeight.w700,
            fontSize: fontSize18,
          ),

          SizedBox(height: 16.h),

          _tile("Kingdom", taxonomy?.kingdom),
          _tile("Family", taxonomy?.family),
          _tile("Genus", taxonomy?.genus),
          _tile("Order", taxonomy?.order),
        ],
      ),
    );
  }

  Widget _tile(String title, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: BaseText(
              text: title,
              fontWeight: FontWeight.w700,
            ),
          ),
          Expanded(
            flex: 3,
            child: BaseText(text: value ?? "-"),
          ),
        ],
      ),
    );
  }
}