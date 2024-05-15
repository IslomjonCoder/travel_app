part of 'settings_cubit.dart';

class SettingsState {
  final LanguageModel language;

  SettingsState({
    required this.language,
  });


  String get locale {
    if (language.locale.languageCode == 'uz') {
      return 'O`zbek';
    }
    if (language.locale.languageCode == 'ru') {
      return 'Русский';
    }
    return 'English';
  }
}

