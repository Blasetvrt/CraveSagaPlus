import 'package:flutter/material.dart';
import '../../dictionary/dictionary.dart';

class MainMenu extends StatelessWidget {
  final String currentLanguage;
  final bool isDarkMode;
  final bool isDynamicColor;
  final VoidCallback onLanguageTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onAboutTap;
  final Function(bool) onThemeChanged;
  final Function(bool) onDynamicColorChanged;

  const MainMenu({
    super.key,
    required this.currentLanguage,
    required this.isDarkMode,
    required this.isDynamicColor,
    required this.onLanguageTap,
    required this.onSettingsTap,
    required this.onAboutTap,
    required this.onThemeChanged,
    required this.onDynamicColorChanged,
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
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => onThemeChanged(!isDarkMode),
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