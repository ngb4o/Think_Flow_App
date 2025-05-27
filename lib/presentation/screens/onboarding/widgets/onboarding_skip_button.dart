part of 'widget_imports.dart';

class OnboardingSkippButton extends StatelessWidget {
  const OnboardingSkippButton({super.key, required this.bloc});
  final OnboardingBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(
        onPressed: () {
          bloc.add(OnboardingSkipPageEvent());
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
