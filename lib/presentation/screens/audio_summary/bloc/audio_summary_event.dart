part of 'audio_summary_bloc.dart';

@immutable
sealed class AudioSummaryEvent {}


class AudioSummaryInitialFetchDataAudioEvent extends AudioSummaryEvent {
  final String audioId;

  AudioSummaryInitialFetchDataAudioEvent({required this.audioId});
}


class AudioSummaryCreateSummaryTextEvent extends AudioSummaryEvent {
  final String audioId;

  AudioSummaryCreateSummaryTextEvent({required this.audioId});
}

class AudioSummaryClickButtonUpdateSummaryTextEvent extends AudioSummaryEvent {
  final String textId;
  final String summaryText;
  final String? audioId;

  AudioSummaryClickButtonUpdateSummaryTextEvent({required this.textId, required this.summaryText, this.audioId});
}