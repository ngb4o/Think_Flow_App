// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i16;
import 'package:flutter/cupertino.dart' as _i19;
import 'package:flutter/material.dart' as _i17;
import 'package:think_flow/common/screens/success_screen/success_screen.dart'
    as _i12;
import 'package:think_flow/data/models/user_model.dart' as _i18;
import 'package:think_flow/navigation_menu.dart' as _i5;
import 'package:think_flow/presentation/screens/home/home_imports.dart' as _i3;
import 'package:think_flow/presentation/screens/login/login_imports.dart'
    as _i4;
import 'package:think_flow/presentation/screens/notes/notes_imports.dart'
    as _i6;
import 'package:think_flow/presentation/screens/notes/widgets/audio_notes/audio_notes_imports.dart'
    as _i1;
import 'package:think_flow/presentation/screens/notes/widgets/text_notes/text_notes_imports.dart'
    as _i14;
import 'package:think_flow/presentation/screens/onboarding/onboarding_imports.dart'
    as _i7;
import 'package:think_flow/presentation/screens/password_configuration/password_configuration_imports.dart'
    as _i2;
import 'package:think_flow/presentation/screens/profile/profile_imports.dart'
    as _i8;
import 'package:think_flow/presentation/screens/settings/settings_imports.dart'
    as _i9;
import 'package:think_flow/presentation/screens/signup/signup_imports.dart'
    as _i10;
import 'package:think_flow/presentation/screens/splash/splash_imports.dart'
    as _i11;
import 'package:think_flow/presentation/screens/summary/summary_imports.dart'
    as _i13;
import 'package:think_flow/presentation/screens/verify_email/verify_email_imports.dart'
    as _i15;

abstract class $AppRouter extends _i16.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i16.PageFactory> pagesMap = {
    AudioNotesPageRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AudioNotesPage(),
      );
    },
    ForgetPasswordScreenRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ForgetPasswordScreen(),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomeScreen(),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.LoginScreen(),
      );
    },
    NavigationMenuRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.NavigationMenu(),
      );
    },
    NotesPageRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.NotesPage(),
      );
    },
    OnboardingScreenRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.OnboardingScreen(),
      );
    },
    ProfileScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ProfileScreenRouteArgs>();
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i8.ProfileScreen(
          key: args.key,
          userModel: args.userModel,
        ),
      );
    },
    ResetPasswordScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ResetPasswordScreenRouteArgs>();
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.ResetPasswordScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
    SettingsScreenRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SettingsScreen(),
      );
    },
    SignUpScreenRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SignUpScreen(),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SplashScreen(),
      );
    },
    SuccessScreenRoute.name: (routeData) {
      final args = routeData.argsAs<SuccessScreenRouteArgs>();
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.SuccessScreen(
          key: args.key,
          title: args.title,
          subTitle: args.subTitle,
          onPressed: args.onPressed,
          animation: args.animation,
        ),
      );
    },
    SummaryScreenRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SummaryScreen(),
      );
    },
    TextNotesPageRoute.name: (routeData) {
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.TextNotesPage(),
      );
    },
    VerifyEmailScreenRoute.name: (routeData) {
      final args = routeData.argsAs<VerifyEmailScreenRouteArgs>(
          orElse: () => const VerifyEmailScreenRouteArgs());
      return _i16.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.VerifyEmailScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AudioNotesPage]
class AudioNotesPageRoute extends _i16.PageRouteInfo<void> {
  const AudioNotesPageRoute({List<_i16.PageRouteInfo>? children})
      : super(
          AudioNotesPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'AudioNotesPageRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ForgetPasswordScreen]
class ForgetPasswordScreenRoute extends _i16.PageRouteInfo<void> {
  const ForgetPasswordScreenRoute({List<_i16.PageRouteInfo>? children})
      : super(
          ForgetPasswordScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgetPasswordScreenRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HomeScreen]
class HomeScreenRoute extends _i16.PageRouteInfo<void> {
  const HomeScreenRoute({List<_i16.PageRouteInfo>? children})
      : super(
          HomeScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i4.LoginScreen]
class LoginScreenRoute extends _i16.PageRouteInfo<void> {
  const LoginScreenRoute({List<_i16.PageRouteInfo>? children})
      : super(
          LoginScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginScreenRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i5.NavigationMenu]
class NavigationMenuRoute extends _i16.PageRouteInfo<void> {
  const NavigationMenuRoute({List<_i16.PageRouteInfo>? children})
      : super(
          NavigationMenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'NavigationMenuRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i6.NotesPage]
class NotesPageRoute extends _i16.PageRouteInfo<void> {
  const NotesPageRoute({List<_i16.PageRouteInfo>? children})
      : super(
          NotesPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotesPageRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i7.OnboardingScreen]
class OnboardingScreenRoute extends _i16.PageRouteInfo<void> {
  const OnboardingScreenRoute({List<_i16.PageRouteInfo>? children})
      : super(
          OnboardingScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingScreenRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i8.ProfileScreen]
class ProfileScreenRoute extends _i16.PageRouteInfo<ProfileScreenRouteArgs> {
  ProfileScreenRoute({
    _i17.Key? key,
    required _i18.UserModel userModel,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          ProfileScreenRoute.name,
          args: ProfileScreenRouteArgs(
            key: key,
            userModel: userModel,
          ),
          initialChildren: children,
        );

  static const String name = 'ProfileScreenRoute';

  static const _i16.PageInfo<ProfileScreenRouteArgs> page =
      _i16.PageInfo<ProfileScreenRouteArgs>(name);
}

class ProfileScreenRouteArgs {
  const ProfileScreenRouteArgs({
    this.key,
    required this.userModel,
  });

  final _i17.Key? key;

  final _i18.UserModel userModel;

  @override
  String toString() {
    return 'ProfileScreenRouteArgs{key: $key, userModel: $userModel}';
  }
}

/// generated route for
/// [_i2.ResetPasswordScreen]
class ResetPasswordScreenRoute
    extends _i16.PageRouteInfo<ResetPasswordScreenRouteArgs> {
  ResetPasswordScreenRoute({
    _i19.Key? key,
    required String email,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          ResetPasswordScreenRoute.name,
          args: ResetPasswordScreenRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ResetPasswordScreenRoute';

  static const _i16.PageInfo<ResetPasswordScreenRouteArgs> page =
      _i16.PageInfo<ResetPasswordScreenRouteArgs>(name);
}

class ResetPasswordScreenRouteArgs {
  const ResetPasswordScreenRouteArgs({
    this.key,
    required this.email,
  });

  final _i19.Key? key;

  final String email;

  @override
  String toString() {
    return 'ResetPasswordScreenRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i9.SettingsScreen]
class SettingsScreenRoute extends _i16.PageRouteInfo<void> {
  const SettingsScreenRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SettingsScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsScreenRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i10.SignUpScreen]
class SignUpScreenRoute extends _i16.PageRouteInfo<void> {
  const SignUpScreenRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SignUpScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpScreenRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SplashScreen]
class SplashScreenRoute extends _i16.PageRouteInfo<void> {
  const SplashScreenRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SuccessScreen]
class SuccessScreenRoute extends _i16.PageRouteInfo<SuccessScreenRouteArgs> {
  SuccessScreenRoute({
    _i17.Key? key,
    required String title,
    required String subTitle,
    required void Function() onPressed,
    required String animation,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          SuccessScreenRoute.name,
          args: SuccessScreenRouteArgs(
            key: key,
            title: title,
            subTitle: subTitle,
            onPressed: onPressed,
            animation: animation,
          ),
          initialChildren: children,
        );

  static const String name = 'SuccessScreenRoute';

  static const _i16.PageInfo<SuccessScreenRouteArgs> page =
      _i16.PageInfo<SuccessScreenRouteArgs>(name);
}

class SuccessScreenRouteArgs {
  const SuccessScreenRouteArgs({
    this.key,
    required this.title,
    required this.subTitle,
    required this.onPressed,
    required this.animation,
  });

  final _i17.Key? key;

  final String title;

  final String subTitle;

  final void Function() onPressed;

  final String animation;

  @override
  String toString() {
    return 'SuccessScreenRouteArgs{key: $key, title: $title, subTitle: $subTitle, onPressed: $onPressed, animation: $animation}';
  }
}

/// generated route for
/// [_i13.SummaryScreen]
class SummaryScreenRoute extends _i16.PageRouteInfo<void> {
  const SummaryScreenRoute({List<_i16.PageRouteInfo>? children})
      : super(
          SummaryScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SummaryScreenRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i14.TextNotesPage]
class TextNotesPageRoute extends _i16.PageRouteInfo<void> {
  const TextNotesPageRoute({List<_i16.PageRouteInfo>? children})
      : super(
          TextNotesPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'TextNotesPageRoute';

  static const _i16.PageInfo<void> page = _i16.PageInfo<void>(name);
}

/// generated route for
/// [_i15.VerifyEmailScreen]
class VerifyEmailScreenRoute
    extends _i16.PageRouteInfo<VerifyEmailScreenRouteArgs> {
  VerifyEmailScreenRoute({
    _i19.Key? key,
    String? email,
    List<_i16.PageRouteInfo>? children,
  }) : super(
          VerifyEmailScreenRoute.name,
          args: VerifyEmailScreenRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'VerifyEmailScreenRoute';

  static const _i16.PageInfo<VerifyEmailScreenRouteArgs> page =
      _i16.PageInfo<VerifyEmailScreenRouteArgs>(name);
}

class VerifyEmailScreenRouteArgs {
  const VerifyEmailScreenRouteArgs({
    this.key,
    this.email,
  });

  final _i19.Key? key;

  final String? email;

  @override
  String toString() {
    return 'VerifyEmailScreenRouteArgs{key: $key, email: $email}';
  }
}
