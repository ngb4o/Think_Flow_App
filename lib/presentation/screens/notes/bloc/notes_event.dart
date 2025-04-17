part of 'notes_bloc.dart';

@immutable
sealed class NotesEvent {}

class NotesClickButtonCreateEvent extends NotesEvent {
  final String title;

  NotesClickButtonCreateEvent({required this.title});
}

class NoteCreateTextEvent extends NotesEvent {
  final String id;
  final Map<String, dynamic> content;

  NoteCreateTextEvent({required this.id, required this.content});
}

class NotesNotifyHomeUpdateEvent extends NotesEvent {}
