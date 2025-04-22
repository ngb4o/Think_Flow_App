part of 'notes_bloc.dart';

@immutable
sealed class NotesState {}

final class NotesInitial extends NotesState {}

abstract class NotesActionState extends NotesState {}

class NotesCreateLoadingState extends NotesState {}

class NotesCreateSuccessActionSate extends NotesActionState {
  final String id;

  NotesCreateSuccessActionSate({required this.id});
}

class NotesCreateErrorActionState extends NotesActionState {
  final String message;

  NotesCreateErrorActionState({required this.message});
}

class NotesCreateTextLoadingState extends NotesState {}

class NotesCreateTextSuccessActionState extends NotesActionState {}

class NotesCreateTextErrorActionState extends NotesActionState {
  final String message;

  NotesCreateTextErrorActionState({required this.message});
}

class NotesCreateAudioLoadingState extends NotesState {}

class NotesCreateAudioSuccessActionState extends NotesActionState {}

class NotesCreateAudioErrorActionState extends NotesActionState {
  final String message;

  NotesCreateAudioErrorActionState({required this.message});
}

class NotesNotifyHomeUpdateActionState extends NotesActionState {}

