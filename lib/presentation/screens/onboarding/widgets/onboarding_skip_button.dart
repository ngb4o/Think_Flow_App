part of 'widget_imports.dart';

class OnboardingSkippButton extends StatelessWidget {
  const OnboardingSkippButton({super.key, required this.controller});

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(
        onPressed: () {
          controller.skipPage();
        },
        child: Text(
          'Skip',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }
}
