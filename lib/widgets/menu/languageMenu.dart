import 'package:flutter/material.dart';

// Lamguage menu widget
class LanguageMenu extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;
  final VoidCallback onBack;

  const LanguageMenu({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: onBack,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).colorScheme.primary,
                  size: 30,
                ),
              ),
            ),
          ),
        ),
        _buildLanguageOption(context, 'English'),
        _buildLanguageOption(context, 'Español'),
        _buildLanguageOption(context, '日本語'),
        _buildLanguageOption(context, '中文'),
      ],
    );
  }

  Widget _buildLanguageOption(BuildContext context, String language) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onLanguageChanged(language),
        child: ListTile(
          title: Text(language),
          trailing: currentLanguage == language 
            ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
            : null,
        ),
      ),
    );
  }
} 