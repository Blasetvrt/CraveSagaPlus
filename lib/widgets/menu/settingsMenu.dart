import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import '../menu/language.dart';
import '../../dictionary/dictionary.dart';

class SettingsMenu extends StatelessWidget {
  final String currentLanguage;
  final String sourceLanguage;
  final String targetLanguage;
  final String translator;
  final Function(String) onSourceLanguageChanged;
  final Function(String) onTargetLanguageChanged;
  final Function(String) onTranslatorChanged;
  final VoidCallback onBack;

  const SettingsMenu({
    super.key,
    required this.currentLanguage,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.translator,
    required this.onSourceLanguageChanged,
    required this.onTargetLanguageChanged,
    required this.onTranslatorChanged,
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
        _buildLanguageSelector(
          context,
          title: Dictionary.t(currentLanguage, 'source_language'),
          value: sourceLanguage,
          onChanged: onSourceLanguageChanged,
        ),
        _buildLanguageSelector(
          context,
          title: Dictionary.t(currentLanguage, 'target_language'),
          value: targetLanguage,
          onChanged: onTargetLanguageChanged,
        ),
        _buildTranslatorSelector(
          context,
          title: Dictionary.t(currentLanguage, 'translator'),
          value: translator,
          onChanged: onTranslatorChanged,
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context, {
    required String title,
    required String value,
    required Function(String) onChanged,
  }) {
    final bool isSourceLanguage = title == Dictionary.t(currentLanguage, 'source_language');
    final Map<String, String> availableLanguages = isSourceLanguage
        ? {
            'auto': 'Auto Detect',
            'en': 'English',
            'zh-TW': 'Chinese (Traditional)',
            'zh-CN': 'Chinese (Simplified)',
            'ja': 'Japanese',
          }
        : LanguageList.languages;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: DropdownButton<String>(
                  value: value,
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  menuMaxHeight: 300,
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  items: availableLanguages.entries.map((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      onChanged(newValue);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslatorSelector(
    BuildContext context, {
    required String title,
    required String value,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Container(
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                items: const [
                  DropdownMenuItem<String>(
                    value: 'google',
                    child: Text('Google Translate'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'deepl',
                    child: Text('DeepL'),
                  ),
                ],
                onChanged: (newValue) {
                  if (newValue != null) {
                    onChanged(newValue);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
} 