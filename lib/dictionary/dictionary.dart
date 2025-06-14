// Dictionary for menu strings in each language
class Dictionary {
  static final Map<String, Map<String, String>> dictionary = {
    'English': {
      'translate': 'Translate script',
      'language': 'Language',
      'settings': 'Settings',
      'about': 'About',
      'floaty_hidden': 'Floaty hidden. Shake your *other* hand to make it reappear ;)',
      'source_language': 'Source Language',
      'target_language': 'Target Language',
      'translator': 'Translator',
    },
    'Español': {
      'translate': 'Traducir guión',
      'language': 'Idioma',
      'settings': 'Ajustes',
      'about': 'Acerca de',
      'floaty_hidden': 'Floaty oculto. Agita tu *otra* mano para que vuelva a aparecer ;)',
      'source_language': 'Idioma de origen',
      'target_language': 'Idioma de destino',
      'translator': 'Traductor',
    },
    '日本語': {
      'translate': 'スクリプト翻訳の意味ないだろー',
      'language': '言語',
      'settings': '設定',
      'about': 'アプリについて',
      'floaty_hidden': 'フローティを隠しました。*もう片方の*手を振ることで再表示されます ;)',
      'source_language': '元の言語',
      'target_language': '翻訳先の言語',
      'translator': '翻訳サービス',
    },
    '中文': {
      'translate': '翻译脚本',
      'language': '语言',
      'settings': '设置',
      'about': '关于',
      'floaty_hidden': '浮动按钮已隐藏。摇动你的*另一只*手让它重新出现 ;)',
      'source_language': '源语言',
      'target_language': '目标语言',
      'translator': '翻译器',
    },
  };

  static String t(String language, String key) => 
    dictionary[language]?[key] ?? dictionary['English']![key]!;
} 