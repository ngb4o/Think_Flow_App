part of 'onboarding_imports.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final OnboardingBloc onboardingBloc;

  @override
  void initState() {
    super.initState();
    onboardingBloc = OnboardingBloc();
    onboardingBloc.add(OnboardingInitialEvent());
  }

  @override
  void dispose() {
    onboardingBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<OnboardingBloc, OnboardingState>(
        bloc: onboardingBloc,
        listenWhen: (previous, current) => current is OnboardingSuccessState,
        buildWhen: (previous, current) => current is OnboardingSuccessState,
        listener: (context, state) {
          if (state is OnboardingSuccessState) {
            // Handle any side effects here if needed
          }
        },
        builder: (context, state) {
          if (state is OnboardingSuccessState) {
            return Stack(
              children: [
                PageView(
                  controller: state.pageController,
                  onPageChanged: (index) {
                    onboardingBloc.add(OnboardingUpdatePageEvent(index: index));
                  },
                  children: [
                    // OnBoardingPage1
                    OnboardingPage(
                      image: Assets.animationOnboarding1,
                      title: TTexts.onBoardingTitle1,
                      subTitle: TTexts.onBoardingSubTitle1,
                      isLottie: true,
                    ),

                    // OnBoardingPage4
                    OnboardingPage(
                      image: Assets.animationOnboarding4,
                      title: TTexts.onBoardingTitle2,
                      subTitle: TTexts.onBoardingSubTitle2,
                      isLottie: true,
                    ),

                    // OnBoardingPage2
                    OnboardingPage(
                      image: Assets.animationOnboarding2,
                      title: TTexts.onBoardingTitle3,
                      subTitle: TTexts.onBoardingSubTitle3,
                      isLottie: true,
                    ),

                    // OnBoardingPage3
                    OnboardingPage(
                      image: Assets.animationOnboarding3,
                      title: TTexts.onBoardingTitle4,
                      subTitle: TTexts.onBoardingSubTitle4,
                      isLottie: true,
                    ),
                  ],
                ),
                // Skip Button
                OnboardingSkippButton(bloc: onboardingBloc),

                // Dot Navigation SmoothPageIndicator
                OnboardingDotNavigation(bloc: onboardingBloc),

                // Button
                OnboardingNextButton(bloc: onboardingBloc),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
