import 'package:flutter/material.dart';
import 'package:think_flow/utils/constants/colors.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
  });

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: TabBar(
        padding: EdgeInsets.symmetric(horizontal: 10),
        dividerColor: Colors.transparent,
        labelColor: TColors.black,
        indicatorWeight: 3,
        isScrollable: true,
        tabAlignment: TabAlignment.center,
        unselectedLabelColor: TColors.black,
        indicatorPadding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.symmetric(horizontal: 3),
        indicator: const BoxDecoration(),
        enableFeedback: false,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        onTap: onTap,
        tabs: List.generate(tabs.length, (index) {
          final bool isSelected = currentIndex == index;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: isSelected ? (selectedColor ?? TColors.primary) : (unselectedColor ?? Colors.grey.shade200),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Tab(
              child: Text(
                tabs[index],
                style: isSelected
                    ? Theme.of(context).textTheme.bodyLarge?.copyWith(color: selectedTextColor ?? Colors.white)
                    : Theme.of(context).textTheme.bodyLarge?.copyWith(color: unselectedTextColor ?? Colors.black),
              ),
            ),
          );
        }),
      ),
    );
  }
}
