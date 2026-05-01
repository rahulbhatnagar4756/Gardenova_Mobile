import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonClickWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget child;
  final bool test;
  final double leftPadding;
  final double rightPadding;
  final double topPadding;
  final double bottomPadding;

  const CommonClickWidget({
    super.key,
    required this.child,
    this.onTap,
    this.test=false,
    this.leftPadding=0,
    this.rightPadding=0,
    this.topPadding=0,
    this.bottomPadding=0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        // 👇 Hide keyboard (GetX way)
        Get.focusScope?.unfocus();
        if (onTap != null) {
          onTap!();
        }
      },
      child:
          Container(

            padding: EdgeInsets.only(
              left: leftPadding,
              right: rightPadding,
              top:topPadding ,
              bottom: bottomPadding,
            ),
            color:test?Colors.red:Colors.transparent,
              child:child
          )
    );
  }
}