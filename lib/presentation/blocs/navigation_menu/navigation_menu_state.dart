part of 'navigation_menu_bloc.dart';

@immutable
sealed class NavigationMenuState {}

class NavigationMenuInitial extends NavigationMenuState {}

class NavigationMenuChangeIndexState extends NavigationMenuState {
  final int index;

  NavigationMenuChangeIndexState({required this.index});
} 