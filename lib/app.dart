import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:think_flow/presentation/router/router_imports.dart';
import 'package:think_flow/utils/theme/theme.dart';

class App extends StatelessWidget {
  App({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      routerConfig: _appRouter.config(),
    );
  }
}
