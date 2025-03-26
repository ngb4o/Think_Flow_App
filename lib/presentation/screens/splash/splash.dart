part of 'splash_imports.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    moveToOnboarding();
    super.initState();
  }

  moveToOnboarding() async {
    await Future.delayed(Duration(seconds: 2), () {
      AutoRouter.of(context).push(OnboardingScreenRoute());
    },);
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadedScaleAnimation(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(TImages.logo, height: 48, width: 48),
              AppSpacing.w4,
              Text(
                TTexts.appName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: TColors.c6368D1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
