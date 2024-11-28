import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'app_loader_widget.dart';

class CustomWebView extends StatefulWidget {
  const CustomWebView({Key? key, required this.webUrl}) : super(key: key);

  final String webUrl;

  @override
  State<CustomWebView> createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    final WebViewController controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
          onProgress: (int progress) {
            showAppLoader();
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            closeAppLoader();
          }))
      ..loadRequest(Uri.parse(widget.webUrl));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
