import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:think_flow/presentation/blocs/navigation_menu/navigation_menu_bloc.dart';
import 'package:think_flow/utils/constants/colors.dart';
import 'package:think_flow/utils/helpers/helper_functions.dart';

@RoutePage()
class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return BlocProvider(
      create: (context) => NavigationMenuBloc(),
      child: BlocBuilder<NavigationMenuBloc, NavigationMenuState>(
        builder: (context, state) {
          final bloc = context.read<NavigationMenuBloc>();
          final currentIndex = state is NavigationMenuChangeIndexState ? state.index : 0;

          return Scaffold(
            bottomNavigationBar: NavigationBar(
              height: 85,
              elevation: 0,
              backgroundColor: dark ? TColors.black : TColors.white,
              indicatorColor: Colors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                bloc.add(NavigationMenuChangeIndexEvent(index: index));
              },
              destinations: [
                buildNavigationDestination(
                  index: 0,
                  currentIndex: currentIndex,
                  icon: Iconsax.note_215,
                  label: 'Home',
                ),
                buildNavigationDestination(
                  index: 1,
                  currentIndex: currentIndex,
                  icon: Iconsax.cpu_charge5,
                  label: 'AI',
                ),
                buildNavigationDestination(
                  index: 2,
                  currentIndex: currentIndex,
                  icon: Icons.settings,
                  label: 'Setting',
                ),
              ],
            ),
            body: bloc.screens[currentIndex],
          );
        },
      ),
    );
  }

  NavigationDestination buildNavigationDestination({
    required int index,
    required int currentIndex,
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
            color: currentIndex == index ? TColors.primary : Colors.transparent,
          ),
          const SizedBox(height: 10),
          Icon(
            icon,
            size: 30,
            color: currentIndex == index ? TColors.primary : Colors.grey,
          ),
        ],
      ),
      label: label,
    );
  }
} 