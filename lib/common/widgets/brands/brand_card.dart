
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../custom_shapes/containers/t_rounded_container.dart';
import '../t_circular_image.dart';
import '../texts/t_brand_title_text_with_verified_icon.dart';

class TBrandCard extends StatelessWidget {
  const TBrandCard({
    super.key,
    this.onTap,
    required this.showBorder,
    required this.title,
    required this.iconData,
  });

  final bool showBorder;
  final VoidCallback? onTap;
  final String title;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      // Container Design
      child: TRoundedContainer(
        padding: const EdgeInsets.all(TSizes.xs),
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Flexible(
              child: Icon(iconData)
            ),
            const SizedBox(width: TSizes.spaceBtwItems / 2),

            // Text
            TBrandTitleWithVerifiedIcon(
              title: title,
              brandTextSize: TextSizes.large,
            ),
          ],
        ),
      ),
    );
  }
}
