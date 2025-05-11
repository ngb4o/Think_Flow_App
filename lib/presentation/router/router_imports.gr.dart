// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i20;
import 'package:flutter/cupertino.dart' as _i22;
import 'package:flutter/material.dart' as _i21;
import 'package:think_flow/common/screens/success_screen/success_screen.dart'
    as _i15;
import 'package:think_flow/presentation/screens/home/home_imports.dart' as _i3;
import 'package:think_flow/presentation/screens/login/login_imports.dart'
    as _i4;
import 'package:think_flow/presentation/screens/navigation_menu/navigation_menu.dart'
    as _i5;
import 'package:think_flow/presentation/screens/note_archived/note_archived_imports.dart'
    as _i6;
import 'package:think_flow/presentation/screens/note_detail/note_detail_imports.dart'
    as _i7;
import 'package:think_flow/presentation/screens/note_detail/widgets/widget_imports.dart'
    as _i16;
import 'package:think_flow/presentation/screens/note_share/note_share_imports.dart'
    as _i8;
import 'package:think_flow/presentation/screens/notes/notes_imports.dart'
    as _i9;
import 'package:think_flow/presentation/screens/notes/widgets/audio_notes/audio_notes_imports.dart'
    as _i1;
import 'package:think_flow/presentation/screens/notes/widgets/text_notes/text_notes_imports.dart'
    as _i18;
import 'package:think_flow/presentation/screens/onboarding/onboarding_imports.dart'
    as _i10;
import 'package:think_flow/presentation/screens/password_configuration/password_configuration_imports.dart'
    as _i2;
import 'package:think_flow/presentation/screens/profile/profile_imports.dart'
    as _i11;
import 'package:think_flow/presentation/screens/settings/settings_imports.dart'
    as _i12;
import 'package:think_flow/presentation/screens/signup/signup_imports.dart'
    as _i13;
import 'package:think_flow/presentation/screens/splash/splash_imports.dart'
    as _i14;
import 'package:think_flow/presentation/screens/summary/summary_imports.dart'
    as _i17;
import 'package:think_flow/presentation/screens/verify_email/verify_email_imports.dart'
    as _i19;

abstract class $AppRouter extends _i20.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i20.PageFactory> pagesMap = {
    AudioNotesPageRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AudioNotesPage(),
      );
    },
    ForgetPasswordScreenRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ForgetPasswordScreen(),
      );
    },
    HomeScreenRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.HomeScreen(),
      );
    },
    LoginScreenRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.LoginScreen(),
      );
    },
    NavigationMenuRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.NavigationMenu(),
      );
    },
    NoteArchivedScreenRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.NoteArchivedScreen(),
      );
    },
    NoteDetailScreenRoute.name: (routeData) {
      final args = routeData.argsAs<NoteDetailScreenRouteArgs>();
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.NoteDetailScreen(
          key: args.key,
          noteId: args.noteId,
          title: args.title,
          createAt: args.createAt,
          permission: args.permission,
          ownerName: args.ownerName,
        ),
      );
    },
    NoteShareScreenRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.NoteShareScreen(),
      );
    },
    NotesPageRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.NotesPage(),
      );
    },
    OnboardingScreenRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.OnboardingScreen(),
      );
    },
    ProfileScreenRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.ProfileScreen(),
      );
    },
    ResetPasswordScreenRoute.name: (routeData) {
      final args = routeData.argsAs<ResetPasswordScreenRouteArgs>();
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.ResetPasswordScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
    SettingsScreenRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.SettingsScreen(),
      );
    },
    SignUpScreenRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SignUpScreen(),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.SplashScreen(),
      );
    },
    SuccessScreenRoute.name: (routeData) {
      final args = routeData.argsAs<SuccessScreenRouteArgs>();
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i15.SuccessScreen(
          key: args.key,
          title: args.title,
          subTitle: args.subTitle,
          onPressed: args.onPressed,
          animation: args.animation,
        ),
      );
    },
    SummaryDetailTabRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.SummaryDetailTab(),
      );
    },
    SummaryScreenRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.SummaryScreen(),
      );
    },
    TextNotesPageRoute.name: (routeData) {
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i18.TextNotesPage(),
      );
    },
    VerifyEmailScreenRoute.name: (routeData) {
      final args = routeData.argsAs<VerifyEmailScreenRouteArgs>(
          orElse: () => const VerifyEmailScreenRouteArgs());
      return _i20.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i19.VerifyEmailScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.AudioNotesPage]
class AudioNotesPageRoute extends _i20.PageRouteInfo<void> {
  const AudioNotesPageRoute({List<_i20.PageRouteInfo>? children})
      : super(
          AudioNotesPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'AudioNotesPageRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ForgetPasswordScreen]
class ForgetPasswordScreenRoute extends _i20.PageRouteInfo<void> {
  const ForgetPasswordScreenRoute({List<_i20.PageRouteInfo>? children})
      : super(
          ForgetPasswordScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ForgetPasswordScreenRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i3.HomeScreen]
class HomeScreenRoute extends _i20.PageRouteInfo<void> {
  const HomeScreenRoute({List<_i20.PageRouteInfo>? children})
      : super(
          HomeScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeScreenRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i4.LoginScreen]
class LoginScreenRoute extends _i20.PageRouteInfo<void> {
  const LoginScreenRoute({List<_i20.PageRouteInfo>? children})
      : super(
          LoginScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginScreenRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i5.NavigationMenu]
class NavigationMenuRoute extends _i20.PageRouteInfo<void> {
  const NavigationMenuRoute({List<_i20.PageRouteInfo>? children})
      : super(
          NavigationMenuRoute.name,
          initialChildren: children,
        );

  static const String name = 'NavigationMenuRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i6.NoteArchivedScreen]
class NoteArchivedScreenRoute extends _i20.PageRouteInfo<void> {
  const NoteArchivedScreenRoute({List<_i20.PageRouteInfo>? children})
      : super(
          NoteArchivedScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'NoteArchivedScreenRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i7.NoteDetailScreen]
class NoteDetailScreenRoute
    extends _i20.PageRouteInfo<NoteDetailScreenRouteArgs> {
  NoteDetailScreenRoute({
    _i21.Key? key,
    required String noteId,
    required String title,
    required String createAt,
    required String permission,
    required String ownerName,
    List<_i20.PageRouteInfo>? children,
  }) : super(
          NoteDetailScreenRoute.name,
          args: NoteDetailScreenRouteArgs(
            key: key,
            noteId: noteId,
            title: title,
            createAt: createAt,
            permission: permission,
            ownerName: ownerName,
          ),
          initialChildren: children,
        );

  static const String name = 'NoteDetailScreenRoute';

  static const _i20.PageInfo<NoteDetailScreenRouteArgs> page =
      _i20.PageInfo<NoteDetailScreenRouteArgs>(name);
}

class NoteDetailScreenRouteArgs {
  const NoteDetailScreenRouteArgs({
    this.key,
    required this.noteId,
    required this.title,
    required this.createAt,
    required this.permission,
    required this.ownerName,
  });

  final _i21.Key? key;

  final String noteId;

  final String title;

  final String createAt;

  final String permission;

  final String ownerName;

  @override
  String toString() {
    return 'NoteDetailScreenRouteArgs{key: $key, noteId: $noteId, title: $title, createAt: $createAt, permission: $permission, ownerName: $ownerName}';
  }
}

/// generated route for
/// [_i8.NoteShareScreen]
class NoteShareScreenRoute extends _i20.PageRouteInfo<void> {
  const NoteShareScreenRoute({List<_i20.PageRouteInfo>? children})
      : super(
          NoteShareScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'NoteShareScreenRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i9.NotesPage]
class NotesPageRoute extends _i20.PageRouteInfo<void> {
  const NotesPageRoute({List<_i20.PageRouteInfo>? children})
      : super(
          NotesPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotesPageRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i10.OnboardingScreen]
class OnboardingScreenRoute extends _i20.PageRouteInfo<void> {
  const OnboardingScreenRoute({List<_i20.PageRouteInfo>? children})
      : super(
          OnboardingScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'OnboardingScreenRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i11.ProfileScreen]
class ProfileScreenRoute extends _i20.PageRouteInfo<void> {
  const ProfileScreenRoute({List<_i20.PageRouteInfo>? children})
      : super(
          ProfileScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProfileScreenRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ResetPasswordScreen]
class ResetPasswordScreenRoute
    extends _i20.PageRouteInfo<ResetPasswordScreenRouteArgs> {
  ResetPasswordScreenRoute({
    _i22.Key? key,
    required String email,
    List<_i20.PageRouteInfo>? children,
  }) : super(
          ResetPasswordScreenRoute.name,
          args: ResetPasswordScreenRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ResetPasswordScreenRoute';

  static const _i20.PageInfo<ResetPasswordScreenRouteArgs> page =
      _i20.PageInfo<ResetPasswordScreenRouteArgs>(name);
}

class ResetPasswordScreenRouteArgs {
  const ResetPasswordScreenRouteArgs({
    this.key,
    required this.email,
  });

  final _i22.Key? key;

  final String email;

  @override
  String toString() {
    return 'ResetPasswordScreenRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i12.SettingsScreen]
class SettingsScreenRoute extends _i20.PageRouteInfo<void> {
  const SettingsScreenRoute({List<_i20.PageRouteInfo>? children})
      : super(
          SettingsScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SettingsScreenRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i13.SignUpScreen]
class SignUpScreenRoute extends _i20.PageRouteInfo<void> {
  const SignUpScreenRoute({List<_i20.PageRouteInfo>? children})
      : super(
          SignUpScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpScreenRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i14.SplashScreen]
class SplashScreenRoute extends _i20.PageRouteInfo<void> {
  const SplashScreenRoute({List<_i20.PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i15.SuccessScreen]
class SuccessScreenRoute extends _i20.PageRouteInfo<SuccessScreenRouteArgs> {
  SuccessScreenRoute({
    _i21.Key? key,
    required String title,
    required String subTitle,
    required void Function() onPressed,
    required String animation,
    List<_i20.PageRouteInfo>? children,
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

  static const _i20.PageInfo<SuccessScreenRouteArgs> page =
      _i20.PageInfo<SuccessScreenRouteArgs>(name);
}

class SuccessScreenRouteArgs {
  const SuccessScreenRouteArgs({
    this.key,
    required this.title,
    required this.subTitle,
    required this.onPressed,
    required this.animation,
  });

  final _i21.Key? key;

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
/// [_i16.SummaryDetailTab]
class SummaryDetailTabRoute extends _i20.PageRouteInfo<void> {
  const SummaryDetailTabRoute({List<_i20.PageRouteInfo>? children})
      : super(
          SummaryDetailTabRoute.name,
          initialChildren: children,
        );

  static const String name = 'SummaryDetailTabRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i17.SummaryScreen]
class SummaryScreenRoute extends _i20.PageRouteInfo<void> {
  const SummaryScreenRoute({List<_i20.PageRouteInfo>? children})
      : super(
          SummaryScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SummaryScreenRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i18.TextNotesPage]
class TextNotesPageRoute extends _i20.PageRouteInfo<void> {
  const TextNotesPageRoute({List<_i20.PageRouteInfo>? children})
      : super(
          TextNotesPageRoute.name,
          initialChildren: children,
        );

  static const String name = 'TextNotesPageRoute';

  static const _i20.PageInfo<void> page = _i20.PageInfo<void>(name);
}

/// generated route for
/// [_i19.VerifyEmailScreen]
class VerifyEmailScreenRoute
    extends _i20.PageRouteInfo<VerifyEmailScreenRouteArgs> {
  VerifyEmailScreenRoute({
    _i22.Key? key,
    String? email,
    List<_i20.PageRouteInfo>? children,
  }) : super(
          VerifyEmailScreenRoute.name,
          args: VerifyEmailScreenRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'VerifyEmailScreenRoute';

  static const _i20.PageInfo<VerifyEmailScreenRouteArgs> page =
      _i20.PageInfo<VerifyEmailScreenRouteArgs>(name);
}

class VerifyEmailScreenRouteArgs {
  const VerifyEmailScreenRouteArgs({
    this.key,
    this.email,
  });

  final _i22.Key? key;

  final String? email;

  @override
  String toString() {
    return 'VerifyEmailScreenRouteArgs{key: $key, email: $email}';
  }
}
