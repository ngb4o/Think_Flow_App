part of 'audio_summary_bloc.dart';

@immutable
sealed class AudioSummaryEvent {}


class AudioSummaryInitialFetchDataAudioEvent extends AudioSummaryEvent {
  final String audioId;
  final String permission;

  AudioSummaryInitialFetchDataAudioEvent({required this.audioId, required this.permission});
}


class AudioSummaryCreateSummaryTextEvent extends AudioSummaryEvent {
  final String audioId;
  final String permission;

  AudioSummaryCreateSummaryTextEvent({required this.audioId, required this.permission});
}

class AudioSummaryClickButtonUpdateSummaryTextEvent extends AudioSummaryEvent {
  final String textId;
  final String summaryText;
  final String? audioId;
  final String permission;

  AudioSummaryClickButtonUpdateSummaryTextEvent({
    required this.textId, 
    required this.summaryText, 
    this.audioId,
    required this.permission
  });
}