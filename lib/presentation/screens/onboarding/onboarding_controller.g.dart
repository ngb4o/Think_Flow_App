// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OnboardingController on _OnboardingController, Store {
  late final _$currentPageIndexAtom =
      Atom(name: '_OnboardingController.currentPageIndex', context: context);

  @override
  int get currentPageIndex {
    _$currentPageIndexAtom.reportRead();
    return super.currentPageIndex;
  }

  @override
  set currentPageIndex(int value) {
    _$currentPageIndexAtom.reportWrite(value, super.currentPageIndex, () {
      super.currentPageIndex = value;
    });
  }

  late final _$pageControllerAtom =
      Atom(name: '_OnboardingController.pageController', context: context);

  @override
  PageController get pageController {
    _$pageControllerAtom.reportRead();
    return super.pageController;
  }

  @override
  set pageController(PageController value) {
    _$pageControllerAtom.reportWrite(value, super.pageController, () {
      super.pageController = value;
    });
  }

  late final _$_OnboardingControllerActionController =
      ActionController(name: '_OnboardingController', context: context);

  @override
  void updatePageIndicator(int index) {
    final _$actionInfo = _$_OnboardingControllerActionController.startAction(
        name: '_OnboardingController.updatePageIndicator');
    try {
      return super.updatePageIndicator(index);
    } finally {
      _$_OnboardingControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextPage(BuildContext context) {
    final _$actionInfo = _$_OnboardingControllerActionController.startAction(
        name: '_OnboardingController.nextPage');
    try {
      return super.nextPage(context);
    } finally {
      _$_OnboardingControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic skipPage() {
    final _$actionInfo = _$_OnboardingControllerActionController.startAction(
        name: '_OnboardingController.skipPage');
    try {
      return super.skipPage();
    } finally {
      _$_OnboardingControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentPageIndex: ${currentPageIndex},
pageController: ${pageController}
    ''';
  }
}
