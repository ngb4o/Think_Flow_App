import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:think_flow/data/repositories/auth_repo.dart';
import 'package:think_flow/data/repositories/note_repo.dart';
import 'package:think_flow/data/repositories/noti_repo.dart';
import 'package:think_flow/data/repositories/user_repo.dart';
import 'package:think_flow/presentation/router/router_imports.dart';
import 'package:think_flow/presentation/screens/audio_summary/bloc/audio_summary_bloc.dart';
import 'package:think_flow/presentation/screens/audio_transcript/bloc/audio_transcript_bloc.dart';
import 'package:think_flow/presentation/screens/home/bloc/home_bloc.dart';
import 'package:think_flow/presentation/screens/home/widgets/home_share_note/bloc/home_share_note_bloc.dart';
import 'package:think_flow/presentation/screens/login/bloc/login_bloc.dart';
import 'package:think_flow/presentation/screens/note_archived/bloc/note_archived_bloc.dart';
import 'package:think_flow/presentation/screens/note_detail/bloc/note_detail_bloc.dart';
import 'package:think_flow/presentation/screens/note_share/bloc/note_share_bloc.dart';
import 'package:think_flow/presentation/screens/notes/bloc/notes_bloc.dart';
import 'package:think_flow/presentation/screens/notification/bloc/notification_bloc.dart';
import 'package:think_flow/presentation/screens/password_configuration/bloc/password_configuration_bloc.dart';
import 'package:think_flow/presentation/screens/profile/bloc/profile_bloc.dart';
import 'package:think_flow/presentation/screens/settings/bloc/settings_bloc.dart';
import 'package:think_flow/presentation/screens/signup/bloc/signup_bloc.dart';
import 'package:think_flow/presentation/screens/verify_email/bloc/verify_email_bloc.dart';
import 'package:think_flow/utils/theme/theme.dart';

import 'presentation/screens/text_summary/bloc/bloc/text_summary_bloc.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final AuthRepo authRepo = AuthRepo();
    final UserRepo userRepo = UserRepo();
    final NoteRepo noteRepo = NoteRepo();
    final NotificationRepo notificationRepo = NotificationRepo();

    final LoginBloc loginBloc = LoginBloc(authRepo);
    final SignupBloc signupBloc = SignupBloc(authRepo);
    final VerifyEmailBloc verifyEmailBloc = VerifyEmailBloc(authRepo);
    final PasswordConfigurationBloc passwordConfigurationBloc = PasswordConfigurationBloc(authRepo);
    final SettingsBloc settingsBloc = SettingsBloc(authRepo, userRepo);
    final HomeBloc homeBloc = HomeBloc(noteRepo);
    final NotesBloc notesBloc = NotesBloc(noteRepo);
    final NoteDetailBloc noteDetailBloc = NoteDetailBloc(noteRepo);
    final NoteArchivedBloc noteArchivedBloc = NoteArchivedBloc(noteRepo);
    final NoteShareBloc noteShareBloc = NoteShareBloc(noteRepo);
    final HomeShareNoteBloc homeShareNoteBloc = HomeShareNoteBloc(noteRepo);
    final ProfileBloc profileBloc = ProfileBloc(userRepo);
    final TextSummaryBloc textSummaryBloc = TextSummaryBloc(noteRepo);
    final AudioSummaryBloc audioSummaryBloc = AudioSummaryBloc(noteRepo);
    final AudioTranscriptBloc audioTranscriptBloc = AudioTranscriptBloc(noteRepo);
    final NotificationBloc notificationBloc = NotificationBloc(notificationRepo);
    return MultiBlocProvider(
      providers: [
        // Login
        BlocProvider(create: (context) => loginBloc),
        // Signup
        BlocProvider(create: (context) => signupBloc),
        // Verify mail
        BlocProvider(create: (context) => verifyEmailBloc),
        // Password configuration
        BlocProvider(create: (context) => passwordConfigurationBloc),
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
        // Note share
        BlocProvider(create: (context) => noteShareBloc),
        // Home share
        BlocProvider(create: (context) => homeShareNoteBloc),
        // Profile
        BlocProvider(create: (context) => profileBloc),
        // Text summary
        BlocProvider(create: (context) => textSummaryBloc),
        // Audio summary
        BlocProvider(create: (context) => audioSummaryBloc),
        // Audio transcript
        BlocProvider(create: (context) => audioTranscriptBloc),
        // Notification
        BlocProvider(create: (context) => notificationBloc),
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
