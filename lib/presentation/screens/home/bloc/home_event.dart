part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialFetchDataEvent extends HomeEvent {}

class HomeLoadMoreDataEvent extends HomeEvent {}

class HomeClickButtonNavigationToCreateTextNotePageEvent extends HomeEvent {}

class HomeClickButtonNavigationToCreateRecordNotePageEvent extends HomeEvent {}

class HomeClickButtonDeleteNoteEvent extends HomeEvent {
  final String noteId;

  HomeClickButtonDeleteNoteEvent({required this.noteId});
}
