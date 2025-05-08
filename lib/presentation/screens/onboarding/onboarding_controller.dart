
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';
import 'package:think_flow/presentation/router/router_imports.gr.dart';
import 'package:think_flow/utils/utils.dart';

part 'onboarding_controller.g.dart';


class OnboardingController = _OnboardingController with _$OnboardingController;

abstract class _OnboardingController with Store {
  @observable
  int currentPageIndex = 0;

  @observable
  PageController pageController = PageController();

  @action
  void updatePageIndicator(int index) {
    currentPageIndex = index;
  }

  @action
  void nextPage(BuildContext context) {
    if (currentPageIndex == 2) {
      Utils.setIsFirstTime(false);
      AutoRouter.of(context).replace(LoginScreenRoute());
    }
    currentPageIndex++;
    pageController.jumpToPage(currentPageIndex);
  }

  @action
  skipPage() {
    currentPageIndex = 2;
    pageController.jumpToPage(2);
  }
}