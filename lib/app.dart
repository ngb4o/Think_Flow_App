import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:think_flow/data/repositories/auth_repo.dart';
import 'package:think_flow/data/repositories/note_repo.dart';
import 'package:think_flow/data/repositories/noti_repo.dart';
import 'package:think_flow/data/repositories/user_repo.dart';
import 'package:think_flow/presentation/blocs/audio_note_detail/audio_note_detail_bloc.dart';
import 'package:think_flow/presentation/blocs/mindmap_note_detail/mindmap_note_detail_bloc.dart';
import 'package:think_flow/presentation/blocs/summary_note_detail/summary_note_detail_bloc.dart';
import 'package:think_flow/presentation/blocs/text_note_detail/text_note_detail_bloc.dart';
import 'package:think_flow/presentation/router/router_imports.dart';
import 'package:think_flow/presentation/blocs/audio_summary/audio_summary_bloc.dart';
import 'package:think_flow/presentation/blocs/audio_transcrip/audio_transcript_bloc.dart';
import 'package:think_flow/presentation/blocs/home/home_bloc.dart';
import 'package:think_flow/presentation/blocs/note_share/home_share_note_bloc.dart';
import 'package:think_flow/presentation/blocs/login/login_bloc.dart';
import 'package:think_flow/presentation/blocs/note_archived/note_archived_bloc.dart';
import 'package:think_flow/presentation/screens/note_detail/bloc/note_detail_bloc.dart';
import 'package:think_flow/presentation/blocs/note_share_to_me/note_share_bloc.dart';
import 'package:think_flow/presentation/blocs/note/notes_bloc.dart';
import 'package:think_flow/presentation/blocs/notification/notification_bloc.dart';
import 'package:think_flow/presentation/blocs/password_configuration/password_configuration_bloc.dart';
import 'package:think_flow/presentation/blocs/profile/profile_bloc.dart';
import 'package:think_flow/presentation/blocs/settings/settings_bloc.dart';
import 'package:think_flow/presentation/blocs/signup/signup_bloc.dart';
import 'package:think_flow/presentation/blocs/verify_email/verify_email_bloc.dart';
import 'package:think_flow/utils/theme/theme.dart';

import 'presentation/blocs/text_summary/text_summary_bloc.dart';

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
    final TextNoteDetailBloc textNoteDetailBloc = TextNoteDetailBloc(noteRepo);
    final AudioNoteDetailBloc audioNoteDetailBloc = AudioNoteDetailBloc(noteRepo);
    final SummaryNoteDetailBloc summaryNoteDetailBloc = SummaryNoteDetailBloc(noteRepo);
    final MindmapNoteDetailBloc  mindmapNoteDetailBloc = MindmapNoteDetailBloc(noteRepo);
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
        // Text note detail
        BlocProvider(create: (context) => textNoteDetailBloc),
        // Audio note detail
        BlocProvider(create: (context) => audioNoteDetailBloc),
        // Summary note detail
        BlocProvider(create: (context) => summaryNoteDetailBloc),
        // Mindmap note detail        
        BlocProvider(create: (context) => mindmapNoteDetailBloc),
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
