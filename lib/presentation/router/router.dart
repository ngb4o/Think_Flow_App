part of 'router_imports.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends $AppRouter {

  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashScreenRoute.page, path: "/", initial: true),
    AutoRoute(page: OnboardingScreenRoute.page),
    AutoRoute(page: LoginScreenRoute.page),
    AutoRoute(page: SignUpScreenRoute.page),
    AutoRoute(page: ForgetPasswordScreenRoute.page),
    // AutoRoute(page: ResetPasswordScreenRoute())
  ];

}
