part of 'text_note_detail_bloc.dart';

@immutable
sealed class TextNoteDetailEvent {}

class TextNoteDetailInitialFetchDataEvent extends TextNoteDetailEvent {
  final String noteId;

  TextNoteDetailInitialFetchDataEvent({required this.noteId});
}

class TextNoteDetailUpdateEvent extends TextNoteDetailEvent {
  final String noteId;
  final Map<String, dynamic> content;

  TextNoteDetailUpdateEvent({required this.noteId, required this.content});
}

class TextNoteDetailNavigationToSummaryEvent extends TextNoteDetailEvent {
  final String textId;
  final String permission;

  TextNoteDetailNavigationToSummaryEvent({required this.textId, required this.permission});
} 