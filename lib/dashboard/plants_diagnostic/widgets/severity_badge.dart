/// =========================================================
/// FILE: widgets/severity_badge.dart
/// CREATE NEW FILE
/// =========================================================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kasagardem/base/widgets/base_text.dart';

class SeverityBadge extends StatelessWidget {
  final String severity;

  const SeverityBadge({super.key, required this.severity});

  @override
  Widget build(BuildContext context) {
    final value = severity.toLowerCase();

    Color color;

    switch (value) {
      case "high":
        color = Colors.red;
        break;

      case "medium":
        color = Colors.orange;
        break;

      default:
        color = Colors.green;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: BaseText(
        text: severity.toUpperCase(),
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        textColor: color,
      ),
    );
  }
}
