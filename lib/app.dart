import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/features/main/settings/presentation/manager/settings/settings_cubit.dart';
import 'package:travel_app/features/navigation/pages/navigation_screen.dart';
import 'package:travel_app/features/splash_onboarding/pages/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:travel_app/generated/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SettingsCubit()..init()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorSchemeSeed: AppColors.brandColor500Default,
        textTheme: Typography().black.apply(bodyColor: AppColors.greyscale600),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          hintStyle: AppTextStyle.subtitleS2.copyWith(color: AppColors.greyscale400),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.greyscale300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.greyscale600),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
              fixedSize: const Size.fromHeight(48),
              backgroundColor: AppColors.brandColor600,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ),
      // TODO: Remove this
      home:  const SplashScreen(),
      // home:  const NavigationScreen(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: context.watch<SettingsCubit>().state.language.locale,
      supportedLocales: LanguageRepository.languages.map((e) => e.locale).toList(),
    );
  }
}
