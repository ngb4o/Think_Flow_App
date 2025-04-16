part of 'text_notes_bloc.dart';

@immutable
sealed class TextNotesEvent {}

class TextNotesClickButtonCreateNewEvent extends TextNotesEvent {
  final String title;

  TextNotesClickButtonCreateNewEvent({required this.title});
}

class TextNotesClickButtonCreateTextEvent extends TextNotesEvent {
  final String id;
  final Map<String, dynamic> content;

  TextNotesClickButtonCreateTextEvent({required this.id, required this.content});
}

class TextNotesNotifyHomeUpdateEvent extends TextNotesEvent {}
