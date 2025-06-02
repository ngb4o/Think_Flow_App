part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingEvent {}

class OnboardingInitialEvent extends OnboardingEvent {}

class OnboardingUpdatePageEvent extends OnboardingEvent {
  final int index;
  OnboardingUpdatePageEvent({required this.index});
}

class OnboardingNextPageEvent extends OnboardingEvent {
  final BuildContext context;
  OnboardingNextPageEvent({required this.context});
}

class OnboardingSkipPageEvent extends OnboardingEvent {} 