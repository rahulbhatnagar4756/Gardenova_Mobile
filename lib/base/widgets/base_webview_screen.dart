import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kasagardem/utils/constants/app_color.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'base_app_bar.dart';
import 'base_button.dart';
import '../../utils/status_bar_style.dart';

class BaseWebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const BaseWebViewScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<BaseWebViewScreen> createState() => _BaseWebViewScreenState();
}

class _BaseWebViewScreenState extends State<BaseWebViewScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            StatusBarStyle.applyLightScreen();
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint("WebView Error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: BaseAppBar(
        isBackButtonVisible: true,
        isAppIconVisible: false,
        title: widget.title,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: WebViewWidget(controller: _controller)),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                child: BaseButton(
                  bottomPadding: true,
                  textColor: AppColors.offWhite,
                  buttonLabel: "Close",
                  onPressed: () => Get.back(),
                ),
              ),
            ],
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.greenColor,
              ),
            ),
        ],
      ),
    );
  }
}
