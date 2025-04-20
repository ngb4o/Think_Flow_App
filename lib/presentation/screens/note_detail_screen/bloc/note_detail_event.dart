part of 'note_detail_bloc.dart';

@immutable
sealed class NoteDetailEvent {}

class NoteDetailInitialFetchDataEvent extends NoteDetailEvent {
  final String noteId;

  NoteDetailInitialFetchDataEvent({required this.noteId});
}
