part of 'text_summary_bloc.dart';

@immutable
sealed class TextSummaryEvent {}

class TextSummaryInitialFetchDataEvent extends TextSummaryEvent {
  final String noteId;
  final String permission;

  TextSummaryInitialFetchDataEvent({required this.noteId, required this.permission});
}

class TextSummaryCreateTextEvent extends TextSummaryEvent {
  final String textId;
  final String? noteId;
  final String permission;

  TextSummaryCreateTextEvent({required this.textId, this.noteId, required this.permission});
}

class TextSummaryClickButtonUpdateSummaryTextEvent extends TextSummaryEvent {
  final String textId;
  final String summaryText;
  final String permission;

  TextSummaryClickButtonUpdateSummaryTextEvent({required this.textId, required this.summaryText, required this.permission});
}
