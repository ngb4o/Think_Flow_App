part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingSuccessState extends OnboardingState {
  final int currentPageIndex;
  final PageController pageController;

  OnboardingSuccessState({
    required this.currentPageIndex,
    required this.pageController,
  });
} 