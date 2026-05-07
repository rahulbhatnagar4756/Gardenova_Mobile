/// =========================================================
/// FILE: plants_diagnostic/views/diagnosis_loading_view.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_shimmer.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class DiagnosisLoadingView extends StatelessWidget {
  const DiagnosisLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(spacerSize20.w),
      child: Column(
        children: [
          BaseShimmer(
            height: 280.h,
            borderRadious: spacerSize24,
          ),

          SizedBox(height: 20.h),

          ...List.generate(
            6,
                (index) => Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: BaseShimmer(
                height: 100.h,
                borderRadious: spacerSize20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}