import 'package:flutter/material.dart';
import '../../dictionary/dictionary.dart';

class MainMenu extends StatelessWidget {
  final String currentLanguage;
  final int themeMode;
  final bool isDynamicColor;
  final bool isTranslationEnabled;
  final VoidCallback onLanguageTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onAboutTap;
  final Function(int) onThemeChanged;
  final Function(bool) onDynamicColorChanged;
  final Function(bool) onTranslationChanged;

  // Main settings menu
  const MainMenu({
    super.key,
    required this.currentLanguage,
    required this.themeMode,
    required this.isDynamicColor,
    required this.isTranslationEnabled,
    required this.onLanguageTap,
    required this.onSettingsTap,
    required this.onAboutTap,
    required this.onThemeChanged,
    required this.onDynamicColorChanged,
    required this.onTranslationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(
                themeMode == 0 ? Icons.light_mode : 
                themeMode == 1 ? Icons.dark_mode : 
                Icons.brightness_auto,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                // Cycle through theme modes: System -> Light -> Dark -> System
                onThemeChanged((themeMode + 1) % 3);
              },
            ),
            IconButton(
              icon: Icon(
                isDynamicColor ? Icons.palette : Icons.palette_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => onDynamicColorChanged(!isDynamicColor),
            ),
          ],
        ),
        ListTile(
          leading: Icon(Icons.translate, color: Theme.of(context).colorScheme.primary),
          title: Text(Dictionary.t(currentLanguage, 'translate')),
          trailing: currentLanguage == '日本語' ? null : SizedBox(
            width: 48,
            child: Switch(
              value: isTranslationEnabled,
              onChanged: onTranslationChanged,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        _buildMenuItem(
          context,
          icon: Icons.language,
          title: '${Dictionary.t(currentLanguage, 'language')}: $currentLanguage',
          onTap: onLanguageTap,
        ),
        _buildMenuItem(
          context,
          icon: Icons.settings,
          title: Dictionary.t(currentLanguage, 'settings'),
          onTap: onSettingsTap,
        ),
        _buildMenuItem(
          context,
          icon: Icons.info,
          title: Dictionary.t(currentLanguage, 'about'),
          onTap: onAboutTap,
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title),
        ),
      ),
    );
  }
} 