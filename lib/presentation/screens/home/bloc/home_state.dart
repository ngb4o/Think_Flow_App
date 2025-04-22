part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

abstract class HomeActionState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final NoteModel noteModel;

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

  HomeNavigationToNoteDetailPageActionState({
    required this.noteId,
    required this.title,
    required this.createAt,
  });
}
