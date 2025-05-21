import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import 'appbar.dart';
import 'notification_menu_icon.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar(
      {super.key,
      this.iconSecurityActionAppbar = false,
      this.showActionButtonAppbar = true,
      this.centerAppbar = false,
      this.showBackArrow = false,
      this.centerTitle = false,
      this.showIconFilter = false,
      this.actionButtonOnPressed,
      });

  final bool iconSecurityActionAppbar;
  final bool showActionButtonAppbar;
  final bool centerAppbar;
  final bool showBackArrow;
  final bool centerTitle;
  final bool showIconFilter;
  final VoidCallback? actionButtonOnPressed;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return TAppbar(
      showBackArrow: showBackArrow,
      title: Row(
        mainAxisAlignment: centerAppbar ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Image.asset(width: 60, height: 40, TImages.logo),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TTexts.homeAppbarTitle,
                style: Theme.of(context).textTheme.labelMedium!.apply(color: TColors.primary),
              ),
              Text(
                TTexts.appName,
                style: Theme.of(context).textTheme.headlineSmall!.apply(color: TColors.primary),
              ),
            ],
          ),
        ],
      ),
      actions: showActionButtonAppbar
          ? [
              TActionAppbarIcon(
                icon: iconSecurityActionAppbar ? Icons.security : Iconsax.notification5,
                iconColor: TColors.primary,
                onPressed: actionButtonOnPressed ?? () {},
              ),
              if (showIconFilter)
                TActionAppbarIcon(
                  icon: Iconsax.filter5,
                  iconColor: dark ? TColors.grey : TColors.black.withOpacity(0.7),
                  onPressed: () {},
                ),
            ]
          : [],
    );
  }
}
