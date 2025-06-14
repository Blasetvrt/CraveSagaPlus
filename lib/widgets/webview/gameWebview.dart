import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Webview Component
class GameWebView extends StatefulWidget {
  const GameWebView({super.key});

  @override
  State<GameWebView> createState() => _GameWebViewState();
}

class _GameWebViewState extends State<GameWebView> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (webViewController != null) {
          if (await webViewController!.canGoBack()) {
            webViewController!.goBack();
            return false;
          }
        }
        return true;
      },
      child: Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(
              url: WebUri("https://play.games.dmm.co.jp/game/cravesagax"),
            ),
            initialSettings: InAppWebViewSettings(
              useShouldOverrideUrlLoading: true,
              mediaPlaybackRequiresUserGesture: false,
              useOnLoadResource: true,
              javaScriptEnabled: true,
              cacheEnabled: true,
              transparentBackground: true,
              useHybridComposition: true,
              allowFileAccess: true,
              allowUniversalAccessFromFileURLs: true,
              useShouldInterceptRequest: true,
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            /*shouldOverrideUrlLoading: (controller, navigationAction) {
              
            },*/
            // URL interceptor
            shouldInterceptRequest: (controller, request) {
              print(request.url);
              final url = request.url.rawValue.toString();
              print(url);
              if (url.endsWith(".txt")) {
                print(request.url);
              }
              return Future.value(null);
            },
            onLoadStop: (controller, url) async {
              // Inject JavaScript to hide the menu button
              await controller.evaluateJavascript(source: """
                const observer = new MutationObserver(mutations => {
                  let btn = document.querySelector('button[aria-label="menu"]');
                  if (btn) {
                    btn.style.display = "none";
                    observer.disconnect();
                  }
                });

                observer.observe(document.body, { childList: true, subtree: true });
              """);
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
          progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container(),
        ],
      ),
    );
  }
} 