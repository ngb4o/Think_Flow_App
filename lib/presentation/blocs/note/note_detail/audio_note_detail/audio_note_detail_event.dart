part of 'audio_note_detail_bloc.dart';

@immutable
sealed class AudioNoteDetailEvent {}

class AudioNoteDetailInitialFetchDataEvent extends AudioNoteDetailEvent {
  final String noteId;

  AudioNoteDetailInitialFetchDataEvent({required this.noteId});
}

class AudioNoteDetailCreateEvent extends AudioNoteDetailEvent {
  final String id;
  final File audioFile;

  AudioNoteDetailCreateEvent({required this.id, required this.audioFile});
}

class AudioNoteDetailDeleteEvent extends AudioNoteDetailEvent {
  final String audioId;

  AudioNoteDetailDeleteEvent({required this.audioId});
}

class AudioNoteDetailNavigationToTranscriptEvent extends AudioNoteDetailEvent {
  final String audioId;
  final String permission;

  AudioNoteDetailNavigationToTranscriptEvent({required this.audioId, required this.permission});
}

class AudioNoteDetailNavigationToSummaryEvent extends AudioNoteDetailEvent {
  final String audioId;
  final String permission;

  AudioNoteDetailNavigationToSummaryEvent({required this.audioId, required this.permission});
} 