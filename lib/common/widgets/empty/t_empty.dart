import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class TEmpty extends StatelessWidget {
  const TEmpty({super.key, required this.subTitle});

  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Iconsax.document_text, size: 64, color: TColors.darkerGrey),
        SizedBox(height: TSizes.spaceBtwItems),
        Text(
          'No content yet',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: TColors.darkerGrey,
          ),
        ),
        Text(
          subTitle,
          style: Theme.of(context).textTheme.bodySmall
        ),
      ],
    );
  }
}
