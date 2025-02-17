import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _controller.runJavaScript("""
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
        ),
      )
      ..loadRequest(Uri.parse("https://play.games.dmm.co.jp/game/cravesagax"));

    // Ocultar la barra de notificaciones y la barra de gestos inferior
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _openOverlay() async {
    await FlutterOverlayWindow.showOverlay(
      height: 200,
      width: 300,
      enableDrag: true,
      overlayTitle: "Menu",
      overlayContent: "Opciones del menú",
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;  

        Future<void> _loadDynamicColors() async {
          CorePalette? corePalette = await DynamicColorPlugin.getCorePalette();
          if (corePalette != null) {
            setState(() {
              lightColorScheme = corePalette.toColorScheme();
              darkColorScheme = corePalette.toColorScheme(brightness: Brightness.dark);
            });
          }
        }
        _loadDynamicColors();        

        if (lightDynamic != null && darkDynamic != null) {
          lightColorScheme = lightDynamic.harmonized();
          darkColorScheme = darkDynamic.harmonized();
        } else {
          lightColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.blue);
          darkColorScheme = ColorScheme.fromSwatch(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: lightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme,
            useMaterial3: true,
          ),
          home: Scaffold(
            body: Stack(
              children: [
                WebViewWidget(controller: _controller),
                Positioned(
                  top: 1,
                  right: 1,
                  child: FloatingActionButton(
                    onPressed: _openOverlay,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
