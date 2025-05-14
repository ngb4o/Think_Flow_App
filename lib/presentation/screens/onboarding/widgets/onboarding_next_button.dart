part of 'widget_imports.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({super.key, required this.controller});
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      right: TSizes.defaultSpace + 2,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12)),
          backgroundColor: dark ? TColors.primary : TColors.primary,
          elevation: 6,
          shadowColor: dark ? TColors.primary.withOpacity(0.5) : TColors.primary.withOpacity(0.5),
        ),
        onPressed: () {
          controller.nextPage(context);
        },
        child: Observer(
          builder: (_) => controller.currentPageIndex == 2
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: TSizes.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Get Started'),
                      SizedBox(width: TSizes.sm),
                      Icon(
                        Iconsax.arrow_right_3,
                        color: TColors.white,
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: TSizes.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Continue'),
                      SizedBox(width: TSizes.sm),
                      Icon(
                        Iconsax.arrow_right_3,
                        color: TColors.white,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
