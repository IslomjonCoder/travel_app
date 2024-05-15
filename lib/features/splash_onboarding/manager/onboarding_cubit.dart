import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  final pageController = PageController();

  OnboardingCubit() : super(0);

  void nextPage() {
    if (state < 2) {
      pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      emit(state + 1);
    } else {
      // Handle completion of onboarding, e.g., navigate to the home screen
    }
  }

  void previousPage() {
    if (state > 0) {
      emit(state - 1);
    }
  }

  void changePage(int index) {
    emit(index);
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
