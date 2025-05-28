part of 'widget_imports.dart';

class OnboardingNextButton extends StatelessWidget {
  const OnboardingNextButton({super.key, required this.bloc});
  final OnboardingBloc bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      bloc: bloc,
      buildWhen: (previous, current) => current is OnboardingSuccessState,
      builder: (context, state) {
        if (state is OnboardingSuccessState) {
          return Positioned(
            right: TSizes.defaultSpace + 2,
            bottom: TDeviceUtils.getBottomNavigationBarHeight(),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: TColors.primary,
                elevation: 5,
                shadowColor: TColors.primary.withOpacity(0.5) 
              ),
              onPressed: () {
                bloc.add(OnboardingNextPageEvent(context: context));
              },
              child: state.currentPageIndex == 3
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
                  : const Padding(
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
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
