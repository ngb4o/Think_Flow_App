import 'package:flutter/material.dart';
import 'package:think_flow/data/repositories/auth_repo.dart';
import 'package:think_flow/presentation/router/router_imports.dart';
import 'package:think_flow/presentation/screens/login/bloc/login_bloc.dart';
import 'package:think_flow/presentation/screens/signup/bloc/signup_bloc.dart';
import 'package:think_flow/presentation/screens/verify_email/bloc/verify_email_bloc.dart';
import 'package:think_flow/utils/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = LoginBloc(AuthRepo());
    final SignupBloc signupBloc = SignupBloc(AuthRepo());
    final VerifyEmailBloc verifyEmailBloc = VerifyEmailBloc(AuthRepo());
    return MultiBlocProvider(
      providers: [
        // Login
        BlocProvider(create: (context) => loginBloc),
        // Signup
        BlocProvider(create: (context) => signupBloc),
        // Verify Email
        BlocProvider(create: (context) => verifyEmailBloc),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: TAppTheme.lightTheme,
        darkTheme: TAppTheme.darkTheme,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
