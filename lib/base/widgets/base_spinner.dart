import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

class BaseSpinner extends StatelessWidget {
  const BaseSpinner({super.key, this.isSpinnerVisible = true});

  final bool? isSpinnerVisible;

  @override
  Widget build(BuildContext context) {
    return isSpinnerVisible!
        ? SpinKitSpinningLines(color: AppColors.burntGold)
        : SizedBox();
  }
}
