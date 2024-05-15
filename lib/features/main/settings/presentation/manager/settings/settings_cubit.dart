import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/core/singleton/local_storage/local_keys.dart';
import 'package:travel_app/core/singleton/local_storage/local_storage.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(language: LanguageRepository.languages[1]));

  init() async {
    final languageCode = LocalStorageShared.getString(StorageKeys.language, defaultValue: 'uz');
    final language = LanguageRepository.languages.firstWhere((element) => element.locale.languageCode == languageCode);
    emit(SettingsState(language: language));
  }

  void changeLanguage(LanguageModel language) async {
    await LocalStorageShared.setString(StorageKeys.language, language.locale.languageCode);
    emit(SettingsState(language: language));
  }


}

class LanguageModel {
  final String name;
  final FlagsCode code;
  final Locale locale;

  LanguageModel({
    required this.name,
    required this.code,
    required this.locale,
  });
}

class LanguageRepository {
  static final List<LanguageModel> languages = [
    LanguageModel(
      name: 'English',
      code: FlagsCode.US,
      locale: const Locale('en'),
    ),
    LanguageModel(
      name: 'Uzbek',
      code: FlagsCode.UZ,
      locale: const Locale('uz'),
    ),
    LanguageModel(
      name: 'Russian',
      code: FlagsCode.RU,
      locale: const Locale('ru'),
    ),
  ];
}
