import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:think_flow/data/repositories/auth_repo.dart';
import 'package:think_flow/data/repositories/note_repo.dart';
import 'package:think_flow/data/repositories/user_repo.dart';
import 'package:think_flow/presentation/router/router_imports.dart';
import 'package:think_flow/presentation/screens/home/bloc/home_bloc.dart';
import 'package:think_flow/presentation/screens/login/bloc/login_bloc.dart';
import 'package:think_flow/presentation/screens/note_archived/bloc/note_archived_bloc.dart';
import 'package:think_flow/presentation/screens/note_detail/bloc/note_detail_bloc.dart';
import 'package:think_flow/presentation/screens/notes/bloc/notes_bloc.dart';
import 'package:think_flow/presentation/screens/settings/bloc/settings_bloc.dart';
import 'package:think_flow/presentation/screens/signup/bloc/signup_bloc.dart';
import 'package:think_flow/presentation/screens/verify_email/bloc/verify_email_bloc.dart';
import 'package:think_flow/utils/theme/theme.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final AuthRepo authRepo = AuthRepo();
    final UserRepo userRepo = UserRepo();
    final NoteRepo noteRepo = NoteRepo();

    final LoginBloc loginBloc = LoginBloc(authRepo);
    final SignupBloc signupBloc = SignupBloc(authRepo);
    final VerifyEmailBloc verifyEmailBloc = VerifyEmailBloc(authRepo);
    final SettingsBloc settingsBloc = SettingsBloc(authRepo, userRepo);
    final HomeBloc homeBloc = HomeBloc(noteRepo);
    final NotesBloc notesBloc = NotesBloc(noteRepo);
    final NoteDetailBloc noteDetailBloc = NoteDetailBloc(noteRepo);
    final NoteArchivedBloc noteArchivedBloc = NoteArchivedBloc(noteRepo);

    return MultiBlocProvider(
      providers: [
        // Login
        BlocProvider(create: (context) => loginBloc),
        // Signup
        BlocProvider(create: (context) => signupBloc),
        // Verify mail
        BlocProvider(create: (context) => verifyEmailBloc),
        // Settings
        BlocProvider(create: (context) => settingsBloc),
        // Home
        BlocProvider(create: (context) => homeBloc),
        // Notes
        BlocProvider(create: (context) => notesBloc),
        // Note detail
        BlocProvider(create: (context) => noteDetailBloc),
        // Note archived
        BlocProvider(create: (context) => noteArchivedBloc),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        routerConfig: _appRouter.config(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],
      ),
    );
  }
}
