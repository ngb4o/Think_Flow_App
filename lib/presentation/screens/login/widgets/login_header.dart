part of 'widget_imports.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image
        const Image(
          height: 150,
          image: AssetImage(TImages.logo),
        ),

        // Title
        Text(
          TTexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: TSizes.sm,
        ),

        // SubTitle
        Text(
          TTexts.loginSubTitle,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
