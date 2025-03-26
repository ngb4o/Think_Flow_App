part of 'router_imports.dart';

@AutoRouterConfig(replaceInRouteName: 'Route')
class AppRouter extends RootStackRouter {

  @override
  RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashScreenRoute.page, path: "/", initial: true),
    AutoRoute(page: OnboardingScreenRoute.page),
  ];

}
