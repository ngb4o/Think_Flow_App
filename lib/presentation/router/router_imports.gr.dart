// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:think_flow/presentation/screens/onboarding/onboarding_imports.dart'
    as _i1;
import 'package:think_flow/presentation/screens/splash/splash_imports.dart'
    as _i2;

/// generated route for
/// [_i1.OnboardingScreen]
class OnboardingScreenRoute extends _i3.PageRouteInfo<void> {
  const OnboardingScreenRoute({List<_i3.PageRouteInfo>? children})
    : super(OnboardingScreenRoute.name, initialChildren: children);

  static const String name = 'OnboardingScreenRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i1.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i2.SplashScreen]
class SplashScreenRoute extends _i3.PageRouteInfo<void> {
  const SplashScreenRoute({List<_i3.PageRouteInfo>? children})
    : super(SplashScreenRoute.name, initialChildren: children);

  static const String name = 'SplashScreenRoute';

  static _i3.PageInfo page = _i3.PageInfo(
    name,
    builder: (data) {
      return const _i2.SplashScreen();
    },
  );
}
