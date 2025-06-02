part of 'note_archived_bloc.dart';

@immutable
sealed class NoteArchivedEvent {}

class NoteArchivedInitialFetchDataEvent extends NoteArchivedEvent {}

class NoteClickButtonUnarchiveEvent extends NoteArchivedEvent {
  final String noteId;

  NoteClickButtonUnarchiveEvent({required this.noteId});
}
