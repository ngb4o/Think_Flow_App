part of 'notes_bloc.dart';

@immutable
sealed class NotesState {}

final class NotesInitial extends NotesState {}

abstract class NotesActionState extends NotesState {}

class NotesCreateLoadingState extends NotesState {}

class NotesCreateSuccessActionSate extends NotesActionState {}

class NotesCreateErrorActionState extends NotesActionState {
  final String message;

  NotesCreateErrorActionState({required this.message});
}

class NotesCreateTextActionState extends NotesActionState {
  final String id;

  NotesCreateTextActionState({required this.id});
}

class NotesCreateTextLoadingState extends NotesState {}

class NotesCreateTextSuccessActionState extends NotesActionState {}

class NotesCreateTextErrorActionState extends NotesActionState {
  final String message;

  NotesCreateTextErrorActionState({required this.message});
}

class NotesNotifyHomeUpdateActionState extends NotesActionState {}

