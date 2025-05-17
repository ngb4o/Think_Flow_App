part of 'text_summary_bloc.dart';

@immutable
sealed class TextSummaryEvent {}

class TextSummaryInitialFetchDataEvent extends TextSummaryEvent {
  final String noteId;

  TextSummaryInitialFetchDataEvent({required this.noteId});
}

class TextSummaryCreateTextEvent extends TextSummaryEvent {
  final String textId;
  final String? noteId;
  TextSummaryCreateTextEvent({required this.textId, this.noteId});
}

class TextSummaryClickButtonUpdateSummaryTextEvent extends TextSummaryEvent {
  final String textId;
  final String summaryText;

  TextSummaryClickButtonUpdateSummaryTextEvent({required this.textId, required this.summaryText});
}
