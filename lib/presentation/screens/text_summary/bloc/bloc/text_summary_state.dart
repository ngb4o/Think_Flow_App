part of 'text_summary_bloc.dart';

@immutable
sealed class TextSummaryState {}

final class TextSummaryInitial extends TextSummaryState {}

abstract class TextSummaryActionState extends TextSummaryState {}

class TextSummaryLoadingState extends TextSummaryState {}

class TextSummarySuccessState extends TextSummaryState {
  final TextNoteModel textNoteModel;

  TextSummarySuccessState({required this.textNoteModel});
}

class TextSummaryErrorActionState extends TextSummaryActionState {
  final String message;

  TextSummaryErrorActionState({required this.message});
}

class TextSummaryCreateTextLoadingState extends TextSummaryState {}

class TextSummaryCreateTextSuccessState extends TextSummaryState {}

class TextSummaryCreateTextErrorActionState extends TextSummaryActionState {
  final String message;

  TextSummaryCreateTextErrorActionState({required this.message});
}

class TextSummaryUpdateSummaryDetailLoadingState extends TextSummaryState {}

class TextSummaryUpdateSummaryDetailSuccessActionState extends TextSummaryActionState {}

class TextSummaryUpdateSummaryDetailErrorActionState extends TextSummaryActionState {
  final String message;
  TextSummaryUpdateSummaryDetailErrorActionState({required this.message});
}
