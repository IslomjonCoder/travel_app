
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/features/main/settings/presentation/manager/settings/settings_cubit.dart';
import 'package:travel_app/generated/l10n.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();
    final selectedLanguageModel = context.watch<SettingsCubit>().state.language;

    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).language)),
      body: LanguageList(
        languages: LanguageRepository.languages,
        selectedLanguage: selectedLanguageModel,
        onLanguageSelected: (language) async {
          await S.load(language.locale);
          settingsCubit.changeLanguage(language);
        },
      ),
    );
  }
}

class LanguageItem extends StatelessWidget {
  final LanguageModel language;
  final LanguageModel selectedLanguage;
  final Function(LanguageModel) onLanguageSelected;

  const LanguageItem({
    super.key,
    required this.language,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onLanguageSelected(language);
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Flag.fromCode(
              language.code,
              height: 32,
              width: 32,
              borderRadius: 8,
            ),
            const Gap(8),
            Text(language.name, style: AppTextStyle.subtitleS1),
            const Spacer(),
            Radio(
              value: language,
              groupValue: selectedLanguage,
              onChanged: (value) {
                onLanguageSelected(value!);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageList extends StatelessWidget {
  final List<LanguageModel> languages;
  final LanguageModel selectedLanguage;
  final Function(LanguageModel) onLanguageSelected;

  const LanguageList({
    super.key,
    required this.languages,
    required this.selectedLanguage,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      itemBuilder: (context, index) {
        final language = languages[index];
        return LanguageItem(
          language: language,
          selectedLanguage: selectedLanguage,
          onLanguageSelected: onLanguageSelected,
        );
      },
      separatorBuilder: (context, index) => const Gap(16),
      itemCount: languages.length,
    );
  }
}
