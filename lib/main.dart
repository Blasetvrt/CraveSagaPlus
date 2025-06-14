import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shake/shake.dart';
import 'widgets/floaty/floaty_button.dart';
import 'widgets/floaty/delete_area.dart';
import 'widgets/menu/language_menu.dart';
import 'widgets/menu/main_menu.dart';
import 'dictionary/dictionary.dart';

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
  double _deleteAreaScale = 1.0;
  double _deletePadding = 10;
  Color _deleteIconColor = Colors.white;
  bool _isMenuOpen = false;
  String _currentLanguage = 'English';
  bool _showingLanguageMenu = false;
  bool _isDarkMode = false;
  bool _isDynamicColor = true;

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

  void _showMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  if (_showingLanguageMenu) {
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 140));
                    setDialogState(() => _showingLanguageMenu = false);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _showingLanguageMenu 
                  ? LanguageMenu(
                      currentLanguage: _currentLanguage,
                      onLanguageChanged: (language) {
                        setState(() => _currentLanguage = language);
                      },
                      onBack: () {
                        setDialogState(() => _showingLanguageMenu = false);
                      },
                    )
                  : MainMenu(
                      currentLanguage: _currentLanguage,
                      isDarkMode: _isDarkMode,
                      isDynamicColor: _isDynamicColor,
                      onLanguageTap: () async {
                        await Future.delayed(const Duration(milliseconds: 100));
                        setDialogState(() => _showingLanguageMenu = true);
                      },
                      onSettingsTap: () {
                        Navigator.pop(context);
                        // TODO: Implement settings
                      },
                      onAboutTap: () {
                        Navigator.pop(context);
                        // TODO: Implement about
                      },
                      onThemeChanged: (isDark) {
                        setState(() => _isDarkMode = isDark);
                      },
                      onDynamicColorChanged: (isDynamic) {
                        setState(() => _isDynamicColor = isDynamic);
                      },
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dynamic themes
  static final _defaultLightColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light);

  static final _defaultDarkColorScheme =
      ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        final lightScheme = _isDynamicColor ? (lightColorScheme ?? _defaultLightColorScheme) : _defaultLightColorScheme;
        final darkScheme = _isDynamicColor ? (darkColorScheme ?? _defaultDarkColorScheme) : _defaultDarkColorScheme;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: darkScheme,
            useMaterial3: true,
            primaryColor: darkScheme.primary,
            brightness: Brightness.dark,
          ),
          darkTheme: ThemeData(
            colorScheme: lightScheme,
            useMaterial3: true,
            primaryColor: lightScheme.primary,
            brightness: Brightness.light,
          ),
          themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: FutureBuilder(
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
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedOpacity(
                            opacity: _isDragging ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: DeleteArea(
                              scale: _deleteAreaScale,
                              padding: _deletePadding,
                              iconColor: _deleteIconColor,
                            ),
                          ),
                        ),
                        if (snapshot.connectionState == ConnectionState.done)
                          Visibility(
                            visible: _isButtonVisible,
                            child: Positioned(
                              top: height * 0.25,
                              right: 10,
                              child: FloatyButton(
                                colorScheme: colorScheme,
                                boundaries: boundaries,
                                buttonSize: buttonSize,
                                initialX: width - buttonSize - 10,
                                initialY: height * 0.25,
                                onMenuTap: () => _showMenu(context),
                                onDragStart: (details) {
                                  setState(() {
                                    _isDragging = true;
                                  });
                                },
                                onDragUpdate: (details) {
                                  _currentPosition = details.globalPosition;

                                  if (_currentPosition.dy > height - 100 && ((_currentPosition.dx > width / 3) && (_currentPosition.dx < width * 2/3)) ) {
                                    setState(() {
                                      _deleteAreaScale = 1.4;
                                      _deletePadding = 20;
                                      _deleteIconColor = Colors.red;
                                    });
                                  } else {
                                    setState(() {
                                      _deleteAreaScale = 1.0;
                                      _deletePadding = 10;
                                      _deleteIconColor = Colors.white;
                                    });
                                  }
                                },
                                onDragEnd: (details) {
                                  setState(() {
                                    _isDragging = false;
                                    if (_currentPosition.dy > height - 100 && ((_currentPosition.dx > width / 3) && (_currentPosition.dx < width * 2/3)) ) {
                                      _isButtonVisible = false;
                                      Fluttertoast.showToast(
                                        msg: Dictionary.t(_currentLanguage, 'floaty_hidden'),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                      );
                                    }
                                  });
                                },
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