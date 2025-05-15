part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

abstract class HomeActionState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final ListNoteModel noteModel;

  HomeSuccessState({required this.noteModel});
}

class HomeErrorState extends HomeState {}

class HomeErrorActionState extends HomeActionState {
  final String message;

  HomeErrorActionState({required this.message});
}

class HomeNavigationToCreateNotesPageActionState extends HomeActionState {}

class HomeNavigationToShareNotePageActionState extends HomeActionState {}

class HomeDeleteNoteLoadingState extends HomeState {}

class HomeDeleteNoteSuccessActionState extends HomeActionState {}

class HomeDeleteNoteErrorActionState extends HomeActionState {
  final String message;

  HomeDeleteNoteErrorActionState({required this.message});
}

class HomeNavigationToNoteDetailPageActionState extends HomeActionState {
  final String noteId;
  final String title;
  final String createAt;
  final String permission;
  final String ownerName;

  HomeNavigationToNoteDetailPageActionState({
    required this.noteId,
    required this.title,
    required this.createAt,
    required this.permission,
    required this.ownerName,
  });
}

class HomeArchiveNoteLoadingState extends HomeState {}

class HomeArchiveNoteSuccessActionState extends HomeActionState {}

class HomeArchiveNoteErrorActionState extends HomeActionState {
  final String message;

  HomeArchiveNoteErrorActionState({required this.message});
}

class HomeNavigationToArchivedPageActionState extends HomeActionState {}

