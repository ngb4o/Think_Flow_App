part of 'note_archived_bloc.dart';

@immutable
sealed class NoteArchivedState {}

final class NoteArchivedInitial extends NoteArchivedState {}

abstract class NoteArchivedActionState  extends NoteArchivedState {}

class NoteArchivedLoadingState extends NoteArchivedState {}

class NoteArchivedSuccessState extends NoteArchivedState {
  final ListNoteModel noteModel;

  NoteArchivedSuccessState({required this.noteModel});
}

class NoteArchivedErrorState extends NoteArchivedState {
  final String message;

  NoteArchivedErrorState({required this.message});
}

class NoteUnarchiveLoadingState extends NoteArchivedState {}

class NoteUnarchiveSuccessActionState extends NoteArchivedActionState {}

class NoteUnarchiveErrorActionState extends NoteArchivedActionState {
  final String message;

  NoteUnarchiveErrorActionState({required this.message});
}
