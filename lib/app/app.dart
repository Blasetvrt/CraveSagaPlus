import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shake/shake.dart';
import '../widgets/floaty/floatyButton.dart';
import '../widgets/menu/languageMenu.dart';
import '../widgets/menu/mainMenu.dart';
import '../widgets/menu/settingsMenu.dart';
import '../widgets/webview/gameWebview.dart';
import '../dictionary/dictionary.dart';
import '../main.dart';
import '../services/settingsService.dart';

// main app component

class MyAppState extends State<MyApp> {
  bool _isDragging = false;
  bool _isButtonVisible = true;
  Offset _currentPosition = Offset.zero;
  double _deleteAreaScale = 1.0;
  double _deletePadding = 10;
  Color _deleteIconColor = Colors.white;
  String _currentLanguage = 'English';
  bool _showingLanguageMenu = false;
  bool _showingSettingsMenu = false;
  int _themeMode = 2; // Default to system theme
  bool _isDynamicColor = true;
  bool _isTranslationEnabled = false;
  String _sourceLanguage = 'en';
  String _targetLanguage = 'es';
  String _translator = 'google';

  // Shake detector for floaty displaying
  late ShakeDetector shake;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    shake = ShakeDetector.autoStart(
      onPhoneShake: (ShakeEvent e) {
        if (!_isButtonVisible) {
          setState(() {
            _isButtonVisible = true;
          });
        }
      }
    );
  }

  Future<void> _loadSettings() async {
    final language = await SettingsService.getLanguage();
    final themeMode = await SettingsService.getThemeMode();
    final isDynamicColor = await SettingsService.getDynamicColor();
    final isTranslationEnabled = await SettingsService.getTranslationEnabled();
    final sourceLanguage = await SettingsService.getSourceLanguage();
    final targetLanguage = await SettingsService.getTargetLanguage();
    final translator = await SettingsService.getTranslator();
    
    setState(() {
      _currentLanguage = language;
      _themeMode = themeMode;
      _isDynamicColor = isDynamicColor;
      _isTranslationEnabled = isTranslationEnabled;
      _sourceLanguage = sourceLanguage;
      _targetLanguage = targetLanguage;
      _translator = translator;
    });
  }

  // Main settings menu builder
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
                  if (_showingLanguageMenu || _showingSettingsMenu) {
                    Navigator.pop(context);
                    await Future.delayed(const Duration(milliseconds: 140));
                    setDialogState(() {
                      _showingLanguageMenu = false;
                      _showingSettingsMenu = false;
                    });
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
                      onLanguageChanged: (language) async {
                        await SettingsService.saveLanguage(language);
                        setState(() => _currentLanguage = language);
                      },
                      onBack: () {
                        setDialogState(() => _showingLanguageMenu = false);
                      },
                    )
                  : _showingSettingsMenu
                    ? SettingsMenu(
                        currentLanguage: _currentLanguage,
                        sourceLanguage: _sourceLanguage,
                        targetLanguage: _targetLanguage,
                        translator: _translator,
                        onSourceLanguageChanged: (language) async {
                          await SettingsService.saveSourceLanguage(language);
                          setState(() => _sourceLanguage = language);
                        },
                        onTargetLanguageChanged: (language) async {
                          await SettingsService.saveTargetLanguage(language);
                          setState(() => _targetLanguage = language);
                        },
                        onTranslatorChanged: (translator) async {
                          await SettingsService.saveTranslator(translator);
                          setState(() => _translator = translator);
                        },
                        onBack: () {
                          setDialogState(() => _showingSettingsMenu = false);
                      },
                    )
                  : MainMenu(
                      currentLanguage: _currentLanguage,
                        themeMode: _themeMode,
                      isDynamicColor: _isDynamicColor,
                        isTranslationEnabled: _isTranslationEnabled,
                      onLanguageTap: () async {
                        await Future.delayed(const Duration(milliseconds: 100));
                        setDialogState(() => _showingLanguageMenu = true);
                      },
                        onSettingsTap: () async {
                          await Future.delayed(const Duration(milliseconds: 100));
                          setDialogState(() => _showingSettingsMenu = true);
                      },
                      onAboutTap: () {
                        Navigator.pop(context);
                        // TODO: Implement about
                      },
                        onThemeChanged: (themeMode) async {
                          await SettingsService.saveThemeMode(themeMode);
                          setState(() => _themeMode = themeMode);
                      },
                        onDynamicColorChanged: (isDynamic) async {
                          await SettingsService.saveDynamicColor(isDynamic);
                        setState(() => _isDynamicColor = isDynamic);
                      },
                        onTranslationChanged: (isEnabled) async {
                          await SettingsService.saveTranslationEnabled(isEnabled);
                          setState(() => _isTranslationEnabled = isEnabled);
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

  // Main material app widget component builder
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        final lightScheme = _isDynamicColor ? (lightColorScheme ?? _defaultLightColorScheme) : _defaultLightColorScheme;
        final darkScheme = _isDynamicColor ? (darkColorScheme ?? _defaultDarkColorScheme) : _defaultDarkColorScheme;

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
          themeMode: _themeMode == 0 ? ThemeMode.light : 
                    _themeMode == 1 ? ThemeMode.dark : 
                    ThemeMode.system,
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
                        const GameWebView(),
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