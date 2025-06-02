part of 'summary_note_detail_bloc.dart';

@immutable
sealed class SummaryNoteDetailState {}

class SummaryNoteDetailInitial extends SummaryNoteDetailState {}

class SummaryNoteDetailLoadingState extends SummaryNoteDetailState {}

class SummaryNoteDetailSuccessState extends SummaryNoteDetailState {
  final NoteModel noteModel;

  SummaryNoteDetailSuccessState({required this.noteModel});
}

class SummaryNoteDetailErrorState extends SummaryNoteDetailState {
  final String message;

  SummaryNoteDetailErrorState({required this.message});
}

// Action States
sealed class SummaryNoteDetailActionState extends SummaryNoteDetailState {}

class SummaryNoteDetailCreateLoadingState extends SummaryNoteDetailState {}

class SummaryNoteDetailCreateSuccessActionState extends SummaryNoteDetailActionState {}

class SummaryNoteDetailCreateErrorActionState extends SummaryNoteDetailActionState {
  final String message;

  SummaryNoteDetailCreateErrorActionState({required this.message});
}

class SummaryNoteDetailUpdateLoadingState extends SummaryNoteDetailState {}

class SummaryNoteDetailUpdateSuccessActionState extends SummaryNoteDetailActionState {}

class SummaryNoteDetailErrorActionState extends SummaryNoteDetailActionState {
  final String message;

  SummaryNoteDetailErrorActionState({required this.message});
} 