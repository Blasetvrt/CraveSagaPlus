import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:translator/translator.dart';

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

  Future<void> loadFileContent(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final content = await file.readAsString();
        final appDir = await getExternalStorageDirectory();
                if (appDir == null) {
                  print('Error: External storage directory is not available');
                  return Future.value(null);
                }
        final baseUrl = WebUri('file://${appDir.path}/scripts/');
        
        await webViewController?.loadData(
          data: content,
          mimeType: 'text/html',
          encoding: 'utf8',
          baseUrl: baseUrl,
          historyUrl: baseUrl,
        );
      } else {
        print('File does not exist: $filePath');
      }
    } catch (e) {
      print('Error loading file: $e');
    }
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
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url?.rawValue.toString() ?? '';
              if (url.endsWith('.txt')) {
                final fileName = path.basename(url);
                final appDir = await getExternalStorageDirectory();
                if (appDir == null) {
                  print('Error: External storage directory is not available');
                  return NavigationActionPolicy.ALLOW;
                }
                
                final targetFile = File('${appDir.path}/scripts/origin_jp/$fileName');
                if (await targetFile.exists()) {
                  try {
                    final content = await targetFile.readAsString();
                    final baseUrl = WebUri('file://${appDir.path}/scripts/prueba');
                    await controller.loadData(
                      data: content,
                      mimeType: 'text/html',
                      encoding: 'utf8',
                      baseUrl: baseUrl,
                      historyUrl: baseUrl,
                    );
                    return NavigationActionPolicy.CANCEL;
                  } catch (e) {
                    print('Error loading local file: $e');
                  }
                }
              }
              return NavigationActionPolicy.ALLOW;
            },
            // URL interceptor
            shouldInterceptRequest: (controller, request) async {
              print(request.url);
              final url = request.url.rawValue.toString();
              print(url);
              if (url.startsWith("https://gg-resource.crave-saga.net/1.0.0/") && url.endsWith(".txt")) {
                print(request.url);
                final fileName = path.basename(url);
                // Skip synopsis fules
                if (fileName.toLowerCase().contains('synopsis')) {
                  print('Skipping synopsis file: $fileName');
                  return Future.value(null);
                }
                final appDir = await getExternalStorageDirectory();
                if (appDir == null) {
                  print('Error: External storage directory is not available');
                  return Future.value(null);
                }
                final targetDir = Directory('${appDir.path}/scripts/origin_jp');
                final targetFile = File('${targetDir.path}/$fileName');
                
                try {
                  try {
                    await targetDir.create(recursive: true);
                  } catch (e) {
                    // Directory might already exist, which is fine
                    print('Directory might already exist: $e');
                  }
                  
                  try {
                    final httpClient = HttpClient();
                    final httpRequest = await httpClient.getUrl(Uri.parse(url));
                    final httpResponse = await httpRequest.close();
                    final bytes = await httpResponse.fold<List<int>>(
                      <int>[],
                      (previous, element) => previous..addAll(element),
                    );
                    
                    await targetFile.writeAsBytes(bytes);
                    print('Saved file: ${targetFile.path}');
                  } catch (e) {
                    print('Error downloading or saving file: $e');
                  }
                } catch (e) {
                  print('Error in file operations: $e');
                }
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