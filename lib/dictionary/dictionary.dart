class Dictionary {
  static final Map<String, Map<String, String>> dictionary = {
    'English': {
      'language': 'Language',
      'settings': 'Settings',
      'about': 'About',
      'floaty_hidden': 'Floaty hidden. Shake your *other* hand to make it reappear ;)',
    },
    'Español': {
      'language': 'Idioma',
      'settings': 'Ajustes',
      'about': 'Acerca de',
      'floaty_hidden': 'Floaty oculto. Agita tu *otra* mano para que vuelva a aparecer ;)',
    },
    '日本語': {
      'language': '言語',
      'settings': '設定',
      'about': 'アプリについて',
      'floaty_hidden': 'フローティを隠しました。*もう片方の*手を振ることで再表示されます ;)',
    },
    '中文': {
      'language': '语言',
      'settings': '设置',
      'about': '关于',
      'floaty_hidden': '浮动按钮已隐藏。摇动你的*另一只*手让它重新出现 ;)',
    },
  };

  static String t(String language, String key) => 
    dictionary[language]?[key] ?? dictionary['English']![key]!;
} 