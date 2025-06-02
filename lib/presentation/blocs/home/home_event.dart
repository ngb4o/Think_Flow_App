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

class HomeClickNavigationToNoteDetailPageEvent extends HomeEvent {
  final String noteId;
  final String title;
  final String createAt;
  final String permission;
  final String ownerName;

  HomeClickNavigationToNoteDetailPageEvent({
    required this.noteId,
    required this.title,
    required this.createAt,
    required this.permission,
    required this.ownerName,
  });
}

class HomeClickButtonArchiveNoteEvent extends HomeEvent {
  final String noteId;

  HomeClickButtonArchiveNoteEvent({required this.noteId});
}
class HomeClickButtonNavigationToArchivedPageEvent extends HomeEvent {}

class HomeClickButtonNavigationToNotificationPageEvent extends HomeEvent {}

