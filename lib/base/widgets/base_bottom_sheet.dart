import 'package:flutter/material.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';

class BaseBottomSheet extends StatelessWidget {
  const BaseBottomSheet({super.key, this.mainWidget});

  final Widget? mainWidget;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: deviceHeight * 0.78,
        width: deviceWidth,
        padding: EdgeInsets.only(
          top: spacerSize30,
          left: spacerSize20,
          right: spacerSize20,
          bottom: spacerSize10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(spacerSize28),
            topRight: Radius.circular(spacerSize28),
          ),
        ),
        child: mainWidget,
      ),
    );
  }
}
