import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:kasagardem/utils/constants/app_constants.dart';
import 'package:kasagardem/utils/shared_prefs_service.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../generated/assets.dart';
import '../utils/constants/app_keys.dart';

class TermsAndConditions extends StatefulWidget {
  final String? filePath;

  const TermsAndConditions({super.key, this.filePath});

  @override
  State createState() {
    return TermsAndConditionsState();
  }
}

class TermsAndConditionsState extends State<TermsAndConditions> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController();
    debugPrint(
      "language::::${SharedPrefsService.instance.getString(AppKeys.selectedLang) ?? "pt"}",
    );
    loadHtmlFromAssets(
      languageCode: SharedPrefsService.instance.getString(
        AppKeys.selectedLang,
      )!,
    );
  }

  /*  Future<void> _loadHtmlFromAssets() async {
    final String htmlContent = await rootBundle.loadString(widget.filePath!);
    await _controller.loadRequest(

      Uri.dataFromString(htmlContent, mimeType: 'text/html', encoding: Encoding.getByName('utf-8')),
    );
  }*/

  Future<void> loadHtmlFromAssets({required String languageCode}) async {
    debugPrint("languageCode:::$languageCode");
    final String path = languageCode == 'en'
        ? Assets.htmlTermsAndConditionsEn
        : Assets.htmlTermsAndConditionsPt;

    final String htmlContent = await rootBundle.loadString(path);

    await _controller.loadRequest(
      Uri.dataFromString(
        htmlContent,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          WebViewWidget(
            controller: _controller,
          ).marginOnly(bottom: spacerSize50),
          Positioned(
            bottom: spacerSize0,
            child: BaseButton(
              textColor: AppColors.offWhite,
              buttonLabel: AppLocalizations.of(context)!.close,
              backgroundColor: AppColors.darkGold,
              onPressed: () => Get.back(),
            ).marginOnly(bottom: spacerSize10),
          ),
        ],
      ),
    );
  }
}
