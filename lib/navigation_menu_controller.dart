
import 'package:mobx/mobx.dart';
import 'package:think_flow/presentation/screens/home/home_imports.dart';
import 'package:think_flow/presentation/screens/settings/settings_imports.dart';
import 'package:think_flow/presentation/summary/summary_imports.dart';

part 'navigation_menu_controller.g.dart';

class NavigationMenuController = _NavigationMenuController with _$NavigationMenuController;

abstract class _NavigationMenuController with Store {
  @observable
  int selectedIndex = 0;

  final screens = [
    const HomeScreen(),
    const SummaryScreen(),
    const SettingsScreen(),
  ];
}