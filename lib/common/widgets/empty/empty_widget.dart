import 'package:flutter/material.dart';
import 'package:think_flow/utils/helpers/helper_functions.dart';
import 'package:think_flow/utils/loaders/animation_loader.dart';

import '../../../generated/assets.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class TEmptyWidget extends StatelessWidget {
  const TEmptyWidget({
    super.key,
    this.subTitle,
    this.title,
  });

  final String? subTitle;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TAnimationLoaderWidget(text:'', animation: Assets.animations53207EmptyFile,),
        Text(
          title ?? '',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isDarkMode ? TColors.white : TColors.darkerGrey,
                fontStyle: FontStyle.italic
              ),


        ),
        SizedBox(height: TSizes.xs),
        Text(
          subTitle ?? '',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
