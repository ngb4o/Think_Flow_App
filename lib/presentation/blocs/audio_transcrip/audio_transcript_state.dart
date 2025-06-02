part of 'audio_transcript_bloc.dart';

@immutable
sealed class AudioTranscriptState {}

final class AudioTranscriptInitial extends AudioTranscriptState {}

abstract class AudioTranscriptActionState extends AudioTranscriptState {}

class AudioTranscriptLoadingState extends AudioTranscriptState {}

class AudioTranscriptSuccessState extends AudioTranscriptState {
  final AudioNoteModel? audioNoteModel;
  AudioTranscriptSuccessState({this.audioNoteModel});
}

class AudioTranscriptErrorState extends AudioTranscriptState {}

class AudioTranscriptErrorActionState extends AudioTranscriptActionState {
  final String message;

  AudioTranscriptErrorActionState({required this.message});
}


class AudioTranscriptUpdateTextLoadingState extends AudioTranscriptState {}

class AudioTranscriptUpdateTextSuccessActionState extends AudioTranscriptState {}

class AudioTranscriptUpdateTextErrorActionState extends AudioTranscriptActionState {
  final String message;
  AudioTranscriptUpdateTextErrorActionState({required this.message});
}