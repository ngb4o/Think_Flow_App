import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/device/device_utility.dart';
import '../../../utils/helpers/helper_functions.dart';

class TTabBar extends StatelessWidget implements PreferredSizeWidget {
  const TTabBar({
    super.key, 
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.width,
    this.fullWidth = false,
    this.paddingBetweenTabs = false,
  });

  final List<Widget> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double? width;
  final bool fullWidth;
  final bool paddingBetweenTabs;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Material(
      color: dark ? TColors.black : TColors.white,
      child: SizedBox(
        height: 40,
        width: width ?? MediaQuery.of(context).size.width,
        child: TabBar(
          dividerColor: Colors.transparent,
          labelColor: TColors.black,
          indicatorWeight: 1,
          isScrollable: !fullWidth,
          tabAlignment: fullWidth ? TabAlignment.fill : TabAlignment.center,
          unselectedLabelColor: TColors.black,
          indicatorPadding: EdgeInsets.zero,
          labelPadding: fullWidth ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 3),
          indicator: const BoxDecoration(),
          enableFeedback: false,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          onTap: onTap,
          tabs: List.generate(tabs.length, (index) {
            final bool isSelected = currentIndex == index;
            return Padding(
              padding: paddingBetweenTabs ? EdgeInsets.symmetric(horizontal: 2) : EdgeInsets.symmetric(horizontal: 0),
              child: Container(
                width: fullWidth ? (width ?? MediaQuery.of(context).size.width) / tabs.length : null,
                padding: fullWidth ? EdgeInsets.zero : const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? (selectedColor ?? (dark ? TColors.c6368D1 : TColors.primary))
                      : (unselectedColor ?? Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if ((tabs[index] as Tab).icon != null) ...[
                        IconTheme(
                          data: IconThemeData(
                            color: isSelected
                                ? (selectedTextColor ?? Colors.white)
                                : (unselectedTextColor ?? Colors.black),
                            size: ((tabs[index] as Tab).icon as Icon).size,
                          ),
                          child: (tabs[index] as Tab).icon!,
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        (tabs[index] as Tab).text ?? '',
                        style: isSelected
                            ? Theme.of(context).textTheme.bodyLarge?.copyWith(color: selectedTextColor ?? Colors.white)
                            : Theme.of(context).textTheme.bodyLarge?.copyWith(color: unselectedTextColor ?? Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}
