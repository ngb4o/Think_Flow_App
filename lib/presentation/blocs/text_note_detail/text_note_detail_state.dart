part of 'text_note_detail_bloc.dart';

@immutable
sealed class TextNoteDetailState {}

class TextNoteDetailInitial extends TextNoteDetailState {}

class TextNoteDetailLoadingState extends TextNoteDetailState {}

class TextNoteDetailSuccessState extends TextNoteDetailState {
  final TextNoteModel textNoteModel;

  TextNoteDetailSuccessState({required this.textNoteModel});
}

class TextNoteDetailErrorState extends TextNoteDetailState {
  final String message;

  TextNoteDetailErrorState({required this.message});
}

// Action States
sealed class TextNoteDetailActionState extends TextNoteDetailState {}

class TextNoteDetailUpdateLoadingState extends TextNoteDetailState {}

class TextNoteDetailUpdateSuccessActionState extends TextNoteDetailActionState {}

class TextNoteDetailErrorActionState extends TextNoteDetailActionState {
  final String message;

  TextNoteDetailErrorActionState({required this.message});
}

class TextNoteDetailNavigationToSummaryActionState extends TextNoteDetailActionState {
  final String textId;
  final String permission;

  TextNoteDetailNavigationToSummaryActionState({required this.textId, required this.permission});
} 