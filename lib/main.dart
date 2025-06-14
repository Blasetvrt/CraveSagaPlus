import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_floaty/flutter_floaty.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final WebViewController _controller;
  bool _isDragging = false;
  bool _isButtonVisible = true;
  Offset _currentPosition = Offset.zero;

  // Shake detector for floaty displaying
  late ShakeDetector shake;

  @override
  void initState() {
    super.initState();
    shake = ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent e) {
        if (!_isButtonVisible) {
          setState(() {
            _isButtonVisible = true;
          });
        }
      }
    );

    // Main webview component
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

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }


  // Floaty delete area
  Widget _buildDeleteArea(ColorScheme colorScheme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              colorScheme.error.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: Center(
          child: Icon(
            Icons.delete_outline,
            color: colorScheme.error,
            size: 40,
          ),
        ),
      ),
    );
  }

  // Dynamic themes
  static final _defaultLightColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light);

  static final _defaultDarkColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

  // Main floaty component
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        final lightScheme = lightColorScheme ?? _defaultLightColorScheme;
        final darkScheme = darkColorScheme ?? _defaultDarkColorScheme;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: lightScheme,
            useMaterial3: true,
            primaryColor: lightScheme.primary,
            brightness: Brightness.light,
          ),
          darkTheme: ThemeData(
            colorScheme: darkScheme,
            useMaterial3: true,
            primaryColor: darkScheme.primary,
            brightness: Brightness.dark,
          ),
          themeMode: ThemeMode.system,
          home: FutureBuilder(
            // Delay for dynamic scheme loading
            future: Future.delayed(const Duration(milliseconds: 500)),
            builder: (context, snapshot) {
              final colorScheme = Theme.of(context).colorScheme;
              final buttonSize = 60.0;
              final width = MediaQuery.of(context).size.width;
              final height = MediaQuery.of(context).size.height;
              final boundaries = Rect.fromLTWH(10, 10, width - 10, height - 10);

              return Scaffold(
                body: StatefulBuilder(
                  builder: (context, setState) {
                    return Stack(
                      children: [
                        WebViewWidget(controller: _controller),
                        Visibility(
                          visible: _isDragging,
                          child: _buildDeleteArea(colorScheme),
                        ),
                        if (snapshot.connectionState == ConnectionState.done)
                          Visibility(
                            visible: _isButtonVisible,
                            child: Positioned(
                              top: height * 0.25,
                              right: 10,
                              child: FlutterFloaty(
                                intrinsicBoundaries: boundaries,
                                width: buttonSize,
                                height: buttonSize,
                                initialX: width - buttonSize - 10,
                                initialY: height * 0.25,
                                builder: (context) => Icon(
                                  Icons.settings,
                                  color: colorScheme.onSecondaryContainer,
                                  size: 35,
                                ),
                                shadow: const BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                                backgroundColor: colorScheme.primary,
                                onDragBackgroundColor: colorScheme.primary.withValues(alpha: 0.3),
                                onDragStart: (details) {
                                  setState(() {
                                    _isDragging = true;
                                  });
                                },
                                onDragUpdate: (details) {
                                  _currentPosition = details.globalPosition;
                                },
                                onDragEnd: (details) {
                                  setState(() {
                                    _isDragging = false;
                                    // Check if the button is within the delete area (bottom 100 pixels)
                                    if (_currentPosition.dy > height - 100) {
                                      _isButtonVisible = false;
                                      Fluttertoast.showToast(
                                        msg: "Floaty hidden. Shake your *other* hand to make it reappear ;)",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                      );
                                    }
                                  });
                                },
                                borderRadius: 25,
                                growingFactor: 1.0,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}