part of 'widget_imports.dart';

class OnboardingDotNavigation extends StatelessWidget {
  const OnboardingDotNavigation({super.key, required this.controller});
final OnboardingController controller;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      left: TSizes.defaultSpace,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        onDotClicked: controller.updatePageIndicator,
        count: 3,
        effect: ExpandingDotsEffect(
          activeDotColor: dark ? TColors.primary : TColors.primary,
          dotHeight: 9,
        ),
      ),
    );
  }
}
