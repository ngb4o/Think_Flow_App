import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/presentation/screens/home/home_imports.dart';
import 'package:think_flow/presentation/screens/settings/settings_imports.dart';
import 'package:think_flow/presentation/screens/summary/summary_imports.dart';

part 'navigation_menu_event.dart';
part 'navigation_menu_state.dart';

class NavigationMenuBloc extends Bloc<NavigationMenuEvent, NavigationMenuState> {
  NavigationMenuBloc() : super(NavigationMenuInitial()) {
    on<NavigationMenuChangeIndexEvent>(_onChangeIndex);
  }

  final screens = [
    const HomeScreen(),
    const SummaryScreen(),
    const SettingsScreen(),
  ];

  void _onChangeIndex(NavigationMenuChangeIndexEvent event, Emitter<NavigationMenuState> emit) {
    emit(NavigationMenuChangeIndexState(index: event.index));
  }
} 