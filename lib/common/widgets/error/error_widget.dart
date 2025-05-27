import 'package:flutter/material.dart';
import 'package:think_flow/generated/assets.dart';
import 'package:think_flow/utils/constants/sizes.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';

class TErrorWidget extends StatelessWidget {
  const TErrorWidget({
    super.key,
    this.subError = 'An error has occurred. Please wait and try again.',
  });

  final String subError;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            // Image
            Image(
              width: THelperFunctions.screenWidth(context),
              height: THelperFunctions.screenHeight(context) * 0.6,
              image: AssetImage(Assets.onBoardingImagesSammyLineNoConnection),
            ),

            // Title
            Text(
              'Error',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: isDarkMode ? TColors.white : TColors.darkerGrey,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: TSizes.sm),

            // Subtitle
            Text(
              subError,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
