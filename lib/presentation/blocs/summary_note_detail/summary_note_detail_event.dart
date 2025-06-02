part of 'summary_note_detail_bloc.dart';

@immutable
sealed class SummaryNoteDetailEvent {}

class SummaryNoteDetailInitialFetchDataEvent extends SummaryNoteDetailEvent {
  final String noteId;
  final String permission;

  SummaryNoteDetailInitialFetchDataEvent({required this.noteId, required this.permission});
}

class SummaryNoteDetailCreateEvent extends SummaryNoteDetailEvent {
  final String noteId;
  final String permission;

  SummaryNoteDetailCreateEvent({required this.noteId, required this.permission});
}

class SummaryNoteDetailUpdateEvent extends SummaryNoteDetailEvent {
  final String noteId;
  final String summaryText;

  SummaryNoteDetailUpdateEvent({required this.noteId, required this.summaryText});
} 