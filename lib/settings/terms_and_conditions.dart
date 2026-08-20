// import 'dart:convert';
import 'dart:collection';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:kasagardem/base/widgets/base_button.dart';
import 'package:kasagardem/l10n/app_localizations.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
// import 'package:kasagardem/utils/shared_prefs_service.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import '../base/widgets/base_app_bar.dart';
// import '../generated/assets.dart';
// import '../utils/constants/app_keys.dart';

class TermsAndConditions extends StatefulWidget {
  final String? filePath;

  const TermsAndConditions({super.key, this.filePath});

  @override
  State createState() {
    return TermsAndConditionsState();
  }
}

class TermsAndConditionsState extends State<TermsAndConditions> {
  // late final WebViewController _controller;
  InAppWebViewController? webViewController;
  bool isLoading = true;

  static const _hideWebsiteNavScript = '''
    (function() {
      if (document.getElementById('hide-site-nav')) return;
      var style = document.createElement('style');
      style.id = 'hide-site-nav';
      style.textContent = 'header, nav, footer, .gn-nav, .nav-toggle, .mobile-menu, .gn-footer, .footer_bottom_outter, .footer-bottom { display: none !important; } .legal-page { padding-top: 24px !important; padding-bottom: 24px !important; }';
      (document.head || document.documentElement).appendChild(style);
    })();
  ''';

  Future<void> _hideWebsiteNavigation(InAppWebViewController controller) async {
    await controller.evaluateJavascript(source: _hideWebsiteNavScript);
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = WebViewController();
  //   debugPrint(
  //     "language::::${SharedPrefsService.instance.getString(AppKeys.selectedLang) ?? "en"}",
  //   );
  //   loadHtmlFromAssets(
  //     languageCode: SharedPrefsService.instance.getString(
  //       AppKeys.selectedLang,
  //     )!,
  //   );
  // }

  // Future<void> loadHtmlFromAssets({required String languageCode}) async {
  //   debugPrint("languageCode:::$languageCode");
  //   final String path = languageCode == 'en'
  //       ? Assets.htmlTermsAndConditionsEn
  //       : Assets.htmlTermsAndConditionsPt;

  //   final String htmlContent = await rootBundle.loadString(path);

  //   await _controller.loadRequest(
  //     Uri.dataFromString(
  //       htmlContent,
  //       mimeType: 'text/html',
  //       encoding: Encoding.getByName('utf-8'),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: BaseAppBar(
        isBackButtonVisible: true,
        isAppIconVisible: false,
        toolbarHeightScale: 1.0,
        
        title: AppLocalizations.of(context)!.termsAndCondition,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri('https://gardenova.ai/terms-and-conditions'),
                  ),
                  initialSettings: InAppWebViewSettings(
                    javaScriptEnabled: true,
                    useHybridComposition: true,
                    transparentBackground: true,
                  ),
                  initialUserScripts: UnmodifiableListView<UserScript>([
                    UserScript(
                      source: _hideWebsiteNavScript,
                      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                    ),
                    UserScript(
                      source: _hideWebsiteNavScript,
                      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
                    ),
                  ]),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) {
                    setState(() {
                      isLoading = true;
                    });
                  },
                  onLoadStop: (controller, url) async {
                    await _hideWebsiteNavigation(controller);
                    setState(() {
                      isLoading = false;
                    });
                  },
                  onReceivedError: (controller, request, error) {
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                if (isLoading)
                  ColoredBox(
                    color: AppColors.appColor,
                    child: const Center(
                      child: SpinKitSpinningLines(color: AppColors.greenColor),
                    ),
                  ),
              ],
            ),
          ),
          // Expanded(child: WebViewWidget(controller: _controller)),
          Container(
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
    );
  }
}
