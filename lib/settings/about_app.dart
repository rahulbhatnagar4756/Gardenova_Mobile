import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../base/widgets/base_app_bar.dart';
import '../generated/assets.dart';
import '../utils/constants/app_keys.dart';
import '../utils/device_info_helper.dart';
import '../utils/status_bar_style.dart';

class AboutAppScreen extends StatefulWidget {
  final String? filePath;

  const AboutAppScreen({super.key, this.filePath});

  @override
  State createState() {
    return AboutAppScreenState();
  }
}

class AboutAppScreenState extends State<AboutAppScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    debugPrint(
      "language::::${SharedPrefsService.instance.getString(AppKeys.selectedLang) ?? "en"}",
    );
    loadHtmlFromAssets(
      languageCode: SharedPrefsService.instance.getString(
        AppKeys.selectedLang,
      ) ?? 'en',
    );
  }

  Future<void> loadHtmlFromAssets({required String languageCode}) async {
    debugPrint("languageCode:::$languageCode");
    final String path = languageCode == 'en'
        ? Assets.htmlAboutEn
        : Assets.htmlAboutPt;

    final String htmlTemplate = await rootBundle.loadString(path);
    final String appVersion = await DeviceInfoHelper.getAppVersion();
    final String htmlContent = htmlTemplate.replaceAll(
      '{{APP_VERSION}}',
      appVersion,
    );

    await _controller.loadRequest(
      Uri.dataFromString(
        htmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ),
    );
    StatusBarStyle.applyLightScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: AppColors.appColor,
      appBar: BaseAppBar(
        isBackButtonVisible: true,
        isAppIconVisible: false,
        title: AppLocalizations.of(context)!.aboutApp,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: WebViewWidget(controller: _controller)),
            Container(
              margin: EdgeInsets.only(top: 20.h),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: BaseButton(
                bottomPadding: true,
                textColor: AppColors.offWhite,
                buttonLabel: AppLocalizations.of(context)!.close,
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
