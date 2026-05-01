import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_assets.dart';
import 'package:kasagardem/utils/constants/app_color.dart';

var enUS = Locale("en", "US");
var ptBR = Locale("pt", "BR");
String userRoleCode = "U";
String appName = "Kasagardem";

/*FontSize*/
const double fontSize9 = 9;
const double fontSize10 = 10;
const double fontSize11 = 11;
const double fontSize12 = 12;
const double fontSize13 = 13;
const double fontSize14 = 14;
const double fontSize15 = 15;
const double fontSize16 = 16;
const double fontSize17 = 17;
const double fontSize18 = 18;
const double fontSize20 = 20;
const double fontSize22 = 22;
const double fontSize24 = 24;
const double fontSize26 = 26;
const double fontSize30 = 30;
const double fontSize32 = 32;
const double fontSize35 = 32;
const double fontSize40 = 40;

/*Size*/
const double spacerSize0 = 0;
const double spacerSize1 = 1;
const double spacerSize2 = 2;
const double spacerSize3 = 3;
const double spacerSize4 = 4;
const double spacerSize5 = 5;
const double spacerSize6 = 6;
const double spacerSize8 = 8;
const double spacerSize10 = 10;
const double spacerSize12 = 12;
const double spacerSize15 = 15;
const double spacerSize17 = 17;
const double spacerSize14 = 14;
const double spacerSize16 = 16;
const double spacerSize18 = 18;
const double spacerSize20 = 20;
const double spacerSize24 = 24;
const double spacerSize25 = 25;
const double spacerSize28 = 28;
const double spacerSize30 = 30;
const double spacerSize35 = 35;
const double spacerSize38 = 38;
const double spacerSize40 = 40;
const double spacerSize42 = 42;
const double spacerSize45 = 45;
const double spacerSize48 = 48;
const double spacerSize50 = 50;
const double spacerSize55 = 55;
const double spacerSize60 = 60;
const double spacerSize65 = 65;
const double spacerSize70 = 70;
const double spacerSize75 = 75;
const double spacerSize80 = 80;
const double spacerSize85 = 85;
const double spacerSize90 = 90;
const double spacerSize95 = 95;
const double spacerSize100 = 100;
const double spacerSize105 = 105;
const double spacerSize110 = 110;
const double spacerSize115 = 115;
const double spacerSize120 = 120;
const double spacerSize125 = 125;
const double spacerSize130 = 130;
const double spacerSize135 = 135;
const double spacerSize140 = 140;
const double spacerSize145 = 145;
const double spacerSize150 = 150;
const double spacerSize155 = 155;
const double spacerSize160 = 160;
const double spacerSize165 = 165;
const double spacerSize170 = 170;
const double spacerSize180 = 180;
const double spacerSize190 = 190;
const double spacerSize200 = 200;
const double spacerSize210 = 210;
const double spacerSize215 = 215;
const double spacerSize250 = 250;
const double spacerSize300 = 300;
const double spacerSize310 = 310;
const double spacerSize320 = 320;
const double spacerSize350 = 350;
const double spacerSize370 = 370;
const double spacerSize400 = 400;
const double spacerSize500 = 500;
const double spacerSize600 = 600;

double deviceWidth = MediaQuery.of(Get.context!).size.width;
double deviceHeight = MediaQuery.of(Get.context!).size.height;

class BaseSnackBar {
  static show({String title = '', String message = ''}) {
    Get.snackbar(
      title,
      message,
      shouldIconPulse: true,
      boxShadows: [BoxShadow(color: AppColors.burntGold, spreadRadius: 1)],
      backgroundColor: AppColors.darkGreen,
      colorText: AppColors.offWhite,
      icon: Image.asset(AppAssets.appLogo).marginOnly(left: spacerSize5),
    );
  }
}

extension StringCasingExtension on String {
  String toTitleCase() {
    if (isEmpty) {
      return '';
    }
    if (length <= 1) {
      return toUpperCase();
    }

    final List<String> words = split(RegExp(r'\s+|-')).map((word) {
      if (word.isEmpty) return '';
      final String firstLetter = word.substring(0, 1).toUpperCase();
      final String remainingLetters = word.substring(1).toLowerCase();
      return '$firstLetter$remainingLetters';
    }).toList();

    return words.join(' ');
  }
}

final String emailRegexPattern =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
