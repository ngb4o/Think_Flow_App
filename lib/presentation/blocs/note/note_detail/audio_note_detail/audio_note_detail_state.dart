part of 'audio_note_detail_bloc.dart';

@immutable
sealed class AudioNoteDetailState {}

class AudioNoteDetailInitial extends AudioNoteDetailState {}

class AudioNoteDetailLoadingState extends AudioNoteDetailState {}

class AudioNoteDetailSuccessState extends AudioNoteDetailState {
  final ListAudioNoteModel listAudioNoteModel;

  AudioNoteDetailSuccessState({required this.listAudioNoteModel});
}

class AudioNoteDetailErrorState extends AudioNoteDetailState {
  final String message;

  AudioNoteDetailErrorState({required this.message});
}

// Action States
sealed class AudioNoteDetailActionState extends AudioNoteDetailState {}

class AudioNoteDetailCreateLoadingState extends AudioNoteDetailState {}

class AudioNoteDetailCreateSuccessActionState extends AudioNoteDetailActionState {}

class AudioNoteDetailCreateErrorActionState extends AudioNoteDetailActionState {
  final String message;

  AudioNoteDetailCreateErrorActionState({required this.message});
}

class AudioNoteDetailDeleteLoadingState extends AudioNoteDetailState {}

class AudioNoteDetailDeleteSuccessActionState extends AudioNoteDetailActionState {}

class AudioNoteDetailDeleteErrorActionState extends AudioNoteDetailActionState {
  final String message;

  AudioNoteDetailDeleteErrorActionState({required this.message});
}

class AudioNoteDetailErrorActionState extends AudioNoteDetailActionState {
  final String message;

  AudioNoteDetailErrorActionState({required this.message});
}

class AudioNoteDetailNavigationToTranscriptActionState extends AudioNoteDetailActionState {
  final String audioId;
  final String permission;

  AudioNoteDetailNavigationToTranscriptActionState({required this.audioId, required this.permission});
}

class AudioNoteDetailNavigationToSummaryActionState extends AudioNoteDetailActionState {
  final String audioId;
  final String permission;

  AudioNoteDetailNavigationToSummaryActionState({required this.audioId, required this.permission});
} 