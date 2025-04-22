part of 'note_detail_bloc.dart';

@immutable
sealed class NoteDetailEvent {}

class NoteTextDetailInitialFetchDataEvent extends NoteDetailEvent {
  final String noteId;

  NoteTextDetailInitialFetchDataEvent({required this.noteId});
}

class NoteAudioDetailInitialFetchDataEvent extends NoteDetailEvent {
  final String noteId;

  NoteAudioDetailInitialFetchDataEvent({required this.noteId});
}
