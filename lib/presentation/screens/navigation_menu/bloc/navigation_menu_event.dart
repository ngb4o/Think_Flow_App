part of 'navigation_menu_bloc.dart';

@immutable
sealed class NavigationMenuEvent {}

class NavigationMenuChangeIndexEvent extends NavigationMenuEvent {
  final int index;

  NavigationMenuChangeIndexEvent({required this.index});
} 