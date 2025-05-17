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
    AutoRoute(page: NavigationMenuRoute.page),
    AutoRoute(page: HomeScreenRoute.page),
    AutoRoute(page: SettingsScreenRoute.page),
    AutoRoute(page: SummaryScreenRoute.page),
    AutoRoute(page: ProfileScreenRoute.page),
    AutoRoute(page: VerifyEmailScreenRoute.page),
    AutoRoute(page: SuccessScreenRoute.page),
    AutoRoute(page: TextNotesPageRoute.page),
    AutoRoute(page: AudioNotesPageRoute.page),
    AutoRoute(page: NotesPageRoute.page),
    AutoRoute(page: NoteDetailScreenRoute.page),
    AutoRoute(page: NoteArchivedScreenRoute.page),
    AutoRoute(page: NoteShareScreenRoute.page),
    AutoRoute(page: TextSummaryScreenRoute.page),
  ];

}
