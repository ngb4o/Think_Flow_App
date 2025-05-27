import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:think_flow/presentation/router/router_imports.gr.dart';
import 'package:think_flow/utils/utils.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial()) {
    on<OnboardingInitialEvent>(onboardingInitialEvent);
    on<OnboardingUpdatePageEvent>(onboardingUpdatePageEvent);
    on<OnboardingNextPageEvent>(onboardingNextPageEvent);
    on<OnboardingSkipPageEvent>(onboardingSkipPageEvent);
  }

  FutureOr<void> onboardingInitialEvent(
    OnboardingInitialEvent event,
    Emitter<OnboardingState> emit,
  ) {
    emit(OnboardingSuccessState(
      currentPageIndex: 0,
      pageController: PageController(),
    ));
  }

  FutureOr<void> onboardingUpdatePageEvent(
    OnboardingUpdatePageEvent event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingSuccessState) {
      final currentState = state as OnboardingSuccessState;
      emit(OnboardingSuccessState(
        currentPageIndex: event.index,
        pageController: currentState.pageController,
      ));
    }
  }

  FutureOr<void> onboardingNextPageEvent(
    OnboardingNextPageEvent event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingSuccessState) {
      final currentState = state as OnboardingSuccessState;
      if (currentState.currentPageIndex == 2) {
        Utils.setIsFirstTime(false);
        AutoRouter.of(event.context).replace(LoginScreenRoute());
      }
      currentState.pageController.jumpToPage(currentState.currentPageIndex + 1);
      emit(OnboardingSuccessState(
        currentPageIndex: currentState.currentPageIndex + 1,
        pageController: currentState.pageController,
      ));
    }
  }

  FutureOr<void> onboardingSkipPageEvent(
    OnboardingSkipPageEvent event,
    Emitter<OnboardingState> emit,
  ) {
    if (state is OnboardingSuccessState) {
      final currentState = state as OnboardingSuccessState;
      currentState.pageController.jumpToPage(2);
      emit(OnboardingSuccessState(
        currentPageIndex: 2,
        pageController: currentState.pageController,
      ));
    }
  }
}
