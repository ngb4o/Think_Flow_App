import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:iconsax/iconsax.dart';
import 'package:think_flow/navigation_menu_controller.dart';
import 'package:think_flow/utils/constants/colors.dart';
import 'package:think_flow/utils/helpers/helper_functions.dart';

@RoutePage()
class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NavigationMenuController();

    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Observer(
        builder: (context) => NavigationBar(
          height: 85,
          elevation: 0,
          backgroundColor: dark ? TColors.black : TColors.white,
          indicatorColor: Colors.transparent,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: controller.selectedIndex,
          onDestinationSelected: (index) {
            controller.selectedIndex = index;
          },
          destinations: [
            buildNavigationDestination(
              index: 0,
              controller: controller,
              icon: Iconsax.note_215,
              label: 'Home',
            ),
            buildNavigationDestination(
              index: 1,
              controller: controller,
              icon: Iconsax.cpu_charge5,
              label: 'AI',
            ),
            buildNavigationDestination(
              index: 2,
              controller: controller,
              icon: Icons.settings,
              label: 'Setting',
            ),
          ],
        ),
      ),
      body: Observer(
        builder: (context) => controller.screens[controller.selectedIndex],
      ),
    );
  }

  NavigationDestination buildNavigationDestination({
    required int index,
    required NavigationMenuController controller,
    required IconData icon,
    required String label,
  }) {
    return NavigationDestination(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 2,
            width: 70,
            color: controller.selectedIndex == index ? TColors.primary : Colors.transparent,
          ),
          const SizedBox(height: 10),
          Icon(
            icon,
            size: 30,
            color: controller.selectedIndex == index ? TColors.primary : Colors.grey,
          ),
        ],
      ),
      label: label,
    );
  }
}
