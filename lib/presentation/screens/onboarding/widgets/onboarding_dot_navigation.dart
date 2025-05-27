part of 'widget_imports.dart';

class OnboardingDotNavigation extends StatelessWidget {
  const OnboardingDotNavigation({super.key, required this.bloc});
  final OnboardingBloc bloc;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      bloc: bloc,
      buildWhen: (previous, current) => current is OnboardingSuccessState,
      builder: (context, state) {
        if (state is OnboardingSuccessState) {
          return Positioned(
            bottom: TDeviceUtils.getBottomNavigationBarHeight(),
            left: TSizes.defaultSpace,
            child: SmoothPageIndicator(
              controller: state.pageController,
              onDotClicked: (index) {
                bloc.add(OnboardingUpdatePageEvent(index: index));
              },
              count: 4,
              effect: ExpandingDotsEffect(
                activeDotColor: dark ? TColors.primary : TColors.primary,
                dotHeight: 9,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
