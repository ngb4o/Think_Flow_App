part of 'audio_transcript_bloc.dart';

@immutable
sealed class AudioTranscriptEvent {}

class AudioTranscriptInitialFetchDataAudioEvent extends AudioTranscriptEvent {
  final String audioId;

  AudioTranscriptInitialFetchDataAudioEvent({required this.audioId});
}

class AudioTranscriptClickButtonUpdateSummaryTextEvent extends AudioTranscriptEvent {
  final String transcriptId;
  final String content;
  final String? audioId;

  AudioTranscriptClickButtonUpdateSummaryTextEvent({required this.transcriptId, required this.content, this.audioId});
}