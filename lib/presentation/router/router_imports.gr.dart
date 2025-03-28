// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/cupertino.dart' as _i7;
import 'package:think_flow/presentation/screens/login/login_imports.dart'
    as _i2;
import 'package:think_flow/presentation/screens/onboarding/onboarding_imports.dart'
    as _i3;
import 'package:think_flow/presentation/screens/password_configuration/password_configuration_imports.dart'
    as _i1;
import 'package:think_flow/presentation/screens/signup/signup_imports.dart'
    as _i4;
import 'package:think_flow/presentation/screens/splash/splash_imports.dart'
    as _i5;

abstract class $AppRouter extends _i6.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    ForgetPasswordScreenRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.ForgetPasswordScreen(),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
      );
    },
    OnboardingScreenRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.OnboardingScreen(),
      );
    },
    ResetPasswordScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ResetPasswordScreenRouteArgs>();
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i1.ResetPasswordScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
    SignUpScreenRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.SignUpScreen(),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.ForgetPasswordScreen]
class ForgetPasswordScreenRoute extends _i6.PageRouteInfo<void> {
  const ForgetPasswordScreenRoute({List<_i6.PageRouteInfo>? children})
      : super(
          ForgetPasswordScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgetPasswordScreenRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i2.LoginScreen]
class LoginScreenRoute extends _i6.PageRouteInfo<void> {
  const LoginScreenRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LoginScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginScreenRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i3.OnboardingScreen]
class OnboardingScreenRoute extends _i6.PageRouteInfo<void> {
  const OnboardingScreenRoute({List<_i6.PageRouteInfo>? children})
      : super(
          OnboardingScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingScreenRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i1.ResetPasswordScreen]
class ResetPasswordScreenRoute
    extends _i6.PageRouteInfo<ResetPasswordScreenRouteArgs> {
  ResetPasswordScreenRoute({
    _i7.Key? key,
    required String email,
    List<_i6.PageRouteInfo>? children,
  }) : super(
          ResetPasswordScreenRoute.name,
          args: ResetPasswordScreenRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ResetPasswordScreenRoute';

  static const _i6.PageInfo<ResetPasswordScreenRouteArgs> page =
      _i6.PageInfo<ResetPasswordScreenRouteArgs>(name);
}

class ResetPasswordScreenRouteArgs {
  const ResetPasswordScreenRouteArgs({
    this.key,
    required this.email,
  });

  final _i7.Key? key;

  final String email;

  @override
  String toString() {
    return 'ResetPasswordScreenRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i4.SignUpScreen]
class SignUpScreenRoute extends _i6.PageRouteInfo<void> {
  const SignUpScreenRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SignUpScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpScreenRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i5.SplashScreen]
class SplashScreenRoute extends _i6.PageRouteInfo<void> {
  const SplashScreenRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}
