import 'package:flutter/material.dart';

final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$');

enum Flavor { prod, dev }

class AppConfig {
  String appName = "";
  String baseUrl = "";
  MaterialColor primaryColor = Colors.blue;
  Flavor flavor = Flavor.dev;
  String? adMobId;
  String? bannerId;
  String? rewardId;

  static AppConfig shared = AppConfig.create();

  factory AppConfig.create({
    String appName = "",
    String baseUrl = "",
    MaterialColor primaryColor = Colors.blue,
    Flavor flavor = Flavor.dev,
    String? adMobId,
    String? bannerId,
    String? rewardId,
  }) {
    return shared = AppConfig(
      appName,
      baseUrl,
      primaryColor,
      flavor,
      adMobId,
      bannerId,
      rewardId,
    );
  }

  AppConfig(
    this.appName,
    this.baseUrl,
    this.primaryColor,
    this.flavor,
    this.adMobId,
    this.bannerId,
    this.rewardId,
  );
}
