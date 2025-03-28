part of 'onboarding_imports.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final OnboardingController onboardingController = OnboardingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: onboardingController.pageController,
            onPageChanged: onboardingController.updatePageIndicator,
            children: const [
              // OnBoardingPage1
              OnboardingPage(
                image: TImages.onBoardingImage1,
                title: TTexts.onBoardingTitle1,
                subTitle: TTexts.onBoardingSubTitle1,
              ),

              // OnBoardingPage2
              OnboardingPage(
                image: TImages.onBoardingImage2,
                title: TTexts.onBoardingTitle2,
                subTitle: TTexts.onBoardingSubTitle2,
              ),

              // OnBoardingPage3
              OnboardingPage(
                image: TImages.onBoardingImage3,
                title: TTexts.onBoardingTitle3,
                subTitle: TTexts.onBoardingSubTitle3,
              ),
            ],
          ),
          // Skip Button
           OnboardingSkippButton(controller: onboardingController),

          // Dot Navigation SmoothPageIndicator
           OnboardingDotNavigation(controller: onboardingController),

          // Circular Button
          OnboardingNextButton(controller: onboardingController),
        ],
      ),
    );
  }
}
