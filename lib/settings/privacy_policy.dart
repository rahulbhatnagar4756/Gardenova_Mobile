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
import '../utils/status_bar_style.dart';
// import '../generated/assets.dart';
// import '../utils/constants/app_keys.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  final String? filePath;

  const PrivacyPolicyScreen({super.key, this.filePath});

  @override
  State createState() {
    return PrivacyPolicyScreenState();
  }
}

class PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
    if (!mounted) return;
    await controller.evaluateJavascript(source: _hideWebsiteNavScript);
  }

  void _setLoading(bool loading) {
    if (!mounted) return;
    setState(() {
      isLoading = loading;
    });
  }

  @override
  void dispose() {
    webViewController = null;
    super.dispose();
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
  //       ? Assets.htmlPrivacyPolicyEn
  //       : Assets.htmlPrivacyPolicyPt;

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
        toolbarHeightScale: 1.0,
        isAppIconVisible: false,
        title: AppLocalizations.of(context)!.privacyPolicy,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri('https://gardenova.ai/privacy-policy'),
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
                      _setLoading(true);
                    },
                    onLoadStop: (controller, url) async {
                      await _hideWebsiteNavigation(controller);
                      if (!mounted) return;
                      StatusBarStyle.applyLightScreen();
                      _setLoading(false);
                    },
                    onReceivedError: (controller, request, error) {
                      _setLoading(false);
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
