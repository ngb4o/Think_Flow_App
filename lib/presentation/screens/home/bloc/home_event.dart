part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialFetchDataEvent extends HomeEvent {}

class HomeLoadMoreDataEvent extends HomeEvent {}

class HomeClickButtonNavigationToCreateNotesPageEvent extends HomeEvent {}

class HomeClickButtonNavigationToShareNotePageEvent extends HomeEvent {}

class HomeClickButtonDeleteNoteEvent extends HomeEvent {
  final String noteId;

  HomeClickButtonDeleteNoteEvent({required this.noteId});
}
