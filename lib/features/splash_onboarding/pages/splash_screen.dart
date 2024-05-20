import 'dart:async';

import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/images.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/core/singleton/local_storage/local_keys.dart';
import 'package:travel_app/core/singleton/local_storage/local_storage.dart';
import 'package:travel_app/features/router/router_screen.dart';
import 'package:travel_app/features/splash_onboarding/pages/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double opacity = 0;
  @override
  void initState() {
    Timer(const Duration(milliseconds: 500), () => setState(() => opacity = 1.0));
    initialize();
    super.initState();
  }

  void initialize() async {
    final isFirstTime = LocalStorageShared.hasKey(StorageKeys.isFirstTime);

    Future.delayed(
      const Duration(seconds: 3),
      () => context.pushReplacement(isFirstTime ? const OnBoardingScreen() : const RouterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(seconds: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                AppImages.logo,
                width: context.width * 0.4,
              ),
              const Gap(16),
              Text(
                'Uzbekistan Travel',
                style: AppTextStyle.headlineSemiboldH4.copyWith(color: AppColors.greyscale600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
