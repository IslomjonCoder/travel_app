import 'package:awesome_extensions/awesome_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_app/core/constants/colors.dart';
import 'package:travel_app/core/constants/images.dart';
import 'package:travel_app/core/constants/text_strings.dart';
import 'package:travel_app/core/constants/text_styles.dart';
import 'package:travel_app/features/splash_onboarding/manager/onboarding_cubit.dart';
import 'package:travel_app/features/navigation/pages/navigation_screen.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingCubit(),
      child: const Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            OnboardingPages(),
            BottomNavigation(),
          ],
        ),
      ),
    );
  }
}

class OnboardingPages extends StatelessWidget {
  const OnboardingPages({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, int>(
      builder: (context, currentPage) {
        final pageController = context.read<OnboardingCubit>().pageController;

        return SizedBox(
          height: context.height * 0.8,
          child: PageView(
            controller: pageController,
            onPageChanged: (index) => context.read<OnboardingCubit>().changePage(index),
            children: const [
              OnboardingPage(
                title: AppTexts.onBoardingTitle1,
                subtitle: AppTexts.onBoardingSubtitle1,
                image: AppImages.onBoardingImage1,
              ),
              OnboardingPage(
                title: AppTexts.onBoardingTitle2,
                subtitle: AppTexts.onBoardingSubtitle2,
                image: AppImages.onBoardingImage2,
              ),
              OnboardingPage(
                title: AppTexts.onBoardingTitle3,
                subtitle: AppTexts.onBoardingSubtitle3,
                image: AppImages.onBoardingImage3,
              ),
            ],
          ),
        );
      },
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        const Gap(16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTextStyle.headlineSemiboldH5,
                  textAlign: TextAlign.center,
                ),
                const Gap(16),
                Text(
                  subtitle,
                  style: AppTextStyle.subtitleS1.copyWith(color: AppColors.greyscale400),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<OnboardingCubit, int>(
            builder: (context, currentPage) {
              return Center(
                child: SmoothPageIndicator(
                  controller: context.read<OnboardingCubit>().pageController,
                  count: 3, // Make sure this count matches the number of pages in the PageView
                  effect: const WormEffect(
                    dotHeight: 8,
                    radius: 2,
                    dotWidth: 48,
                    dotColor: AppColors.greyscale300,
                    activeDotColor: AppColors.brandColor600,
                  ),
                ),
              );
            },
          ),
          const Gap(16),
          BlocBuilder<OnboardingCubit, int>(
            builder: (context, currentPage) {
              return FilledButton(

                onPressed: () {
                  if (currentPage == 2) {
                    context.pushReplacement(const NavigationScreen());
                    return;
                  }
                  context.read<OnboardingCubit>().nextPage();
                },
                child: Text(currentPage == 2 ? "Get Started" : "Next"),
              );
            },
          ),
        ],
      ),
    );
  }
}
