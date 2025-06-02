part of 'audio_summary_bloc.dart';

@immutable
sealed class AudioSummaryState {}

final class AudioSummaryInitial extends AudioSummaryState {}

abstract class AudioSummaryActionState extends AudioSummaryState {}

class AudioSummaryLoadingState extends AudioSummaryState {}

class AudioSummarySuccessState extends AudioSummaryState {
  final AudioNoteModel? audioNoteModel;
  AudioSummarySuccessState({this.audioNoteModel});
}

class AudioSummaryErrorState extends AudioSummaryState {}

class AudioSummaryErrorActionState extends AudioSummaryActionState {
  final String message;
  AudioSummaryErrorActionState({required this.message});
}

class AudioSummaryCreateSummaryTextLoadingState extends AudioSummaryState {}

class AudioSummaryCreateTextSuccessState extends AudioSummaryState {}

class AudioSummaryCreateTextErrorState extends AudioSummaryState {
  final String message;

  AudioSummaryCreateTextErrorState({required this.message});
}

class AudioSummaryUpdateTextSummaryLoadingState extends AudioSummaryState {}

class AudioSummaryUpdateSummaryTextSuccessActionState extends AudioSummaryActionState {}

class TextSummaryUpdateSummaryTextErrorActionState extends AudioSummaryActionState {
  final String message;
  TextSummaryUpdateSummaryTextErrorActionState({required this.message});
}