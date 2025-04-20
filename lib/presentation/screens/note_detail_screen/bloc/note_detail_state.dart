part of 'note_detail_bloc.dart';

@immutable
sealed class NoteDetailState {}

final class NoteDetailInitial extends NoteDetailState {}

abstract class NoteDetailActionState extends NoteDetailState {}

class NoteDetailLoadingState extends NoteDetailState {}

class NoteDetailSuccessState extends NoteDetailState {
  final TextNoteModel textNoteModel;

  NoteDetailSuccessState({required this.textNoteModel});
}

class NoteDetailErrorState extends NoteDetailState {}

class NoteDetailErrorActionState extends NoteDetailActionState {
  final String message;

  NoteDetailErrorActionState({required this.message});
}
