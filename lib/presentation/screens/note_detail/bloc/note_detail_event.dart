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

class NoteClickButtonUpdateEvent extends NoteDetailEvent {
  final String noteId;
  final String title;

  NoteClickButtonUpdateEvent({required this.noteId, required this.title});
}

class NoteClickButtonUpdateTextEvent extends NoteDetailEvent {
  final String noteId;
  final Map<String, dynamic> content;

  NoteClickButtonUpdateTextEvent({required this.noteId, required this.content});
}

class NoteClickButtonCreateAudioEvent extends NoteDetailEvent {
  final String id;
  final File audioFile;

  NoteClickButtonCreateAudioEvent({required this.id, required this.audioFile});
}

class NoteClickButtonDeleteAudioEvent extends NoteDetailEvent {
  final String audioId;

  NoteClickButtonDeleteAudioEvent({required this.audioId});
}