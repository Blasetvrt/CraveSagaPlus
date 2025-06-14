import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _languageKey = 'language';
  static const String _darkModeKey = 'darkMode';
  static const String _dynamicColorKey = 'dynamicColor';
  static const String _translationEnabledKey = 'translationEnabled';
  static const String _sourceLanguageKey = 'sourceLanguage';
  static const String _targetLanguageKey = 'targetLanguage';
  static const String _translatorKey = 'translator';
  static SharedPreferences? _prefs;

  // Theme mode values
  static const int _themeModeLight = 0;
  static const int _themeModeDark = 1;
  static const int _themeModeSystem = 2;

  static Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveLanguage(String language) async {
    await _initPrefs();
    await _prefs!.setString(_languageKey, language);
  }

  static Future<String> getLanguage() async {
    await _initPrefs();
    return _prefs!.getString(_languageKey) ?? 'English';
  }

  static Future<void> saveThemeMode(int themeMode) async {
    await _initPrefs();
    await _prefs!.setInt(_darkModeKey, themeMode);
  }

  static Future<int> getThemeMode() async {
    await _initPrefs();
    return _prefs!.getInt(_darkModeKey) ?? _themeModeSystem;
  }

  static Future<void> saveDynamicColor(bool isDynamicColor) async {
    await _initPrefs();
    await _prefs!.setBool(_dynamicColorKey, isDynamicColor);
  }

  static Future<bool> getDynamicColor() async {
    await _initPrefs();
    return _prefs!.getBool(_dynamicColorKey) ?? true;
  }

  static Future<void> saveTranslationEnabled(bool isEnabled) async {
    await _initPrefs();
    await _prefs!.setBool(_translationEnabledKey, isEnabled);
  }

  static Future<bool> getTranslationEnabled() async {
    await _initPrefs();
    return _prefs!.getBool(_translationEnabledKey) ?? false;
  }

  static Future<void> saveSourceLanguage(String language) async {
    await _initPrefs();
    await _prefs!.setString(_sourceLanguageKey, language);
  }

  static Future<String> getSourceLanguage() async {
    await _initPrefs();
    return _prefs!.getString(_sourceLanguageKey) ?? 'en';
  }

  static Future<void> saveTargetLanguage(String language) async {
    await _initPrefs();
    await _prefs!.setString(_targetLanguageKey, language);
  }

  static Future<String> getTargetLanguage() async {
    await _initPrefs();
    return _prefs!.getString(_targetLanguageKey) ?? 'es';
  }

  static Future<void> saveTranslator(String translator) async {
    await _initPrefs();
    await _prefs!.setString(_translatorKey, translator);
  }

  static Future<String> getTranslator() async {
    await _initPrefs();
    return _prefs!.getString(_translatorKey) ?? 'google';
  }
} 