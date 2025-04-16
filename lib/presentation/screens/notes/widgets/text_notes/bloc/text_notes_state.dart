part of 'text_notes_bloc.dart';

@immutable
sealed class TextNotesState {}

abstract class TextNotesActionState extends TextNotesState {}

final class TextNotesInitial extends TextNotesState {}

class TextNotesCreateNewLoadingState extends TextNotesState {}

class TextNotesCreateNewSuccessState extends TextNotesState {}

class TextNotesCreateNewSuccessActionState extends TextNotesActionState {
  final String noteId;
  TextNotesCreateNewSuccessActionState({required this.noteId});
}

class TextNotesCreateNewErrorState extends TextNotesState {}

class TextNotesCreateNewErrorActionState extends TextNotesActionState {
  final String message;

  TextNotesCreateNewErrorActionState({required this.message});
}

class TextNotesCreateTextLoadingState extends TextNotesState {}

class TextNotesCreateTextSuccessState extends TextNotesActionState {}

class TextNotesCreateTextSuccessActionState extends TextNotesActionState {}

class TextNotesCreateTextErrorState extends TextNotesState {}

class TextNotesCreateTextErrorActionState extends TextNotesActionState {
  final String message;

  TextNotesCreateTextErrorActionState({required this.message});
}

class TextNotesNotifyHomeUpdateActionState extends TextNotesActionState {}
