part of 'note_share_bloc.dart';

@immutable
sealed class NoteShareState {}

final class NoteShareInitial extends NoteShareState {}

abstract class NoteShareActionState extends NoteShareState {}

class NoteShareLoadingState extends NoteShareState {}

class NoteShareSuccessState extends NoteShareState {
  final ListNoteModel noteModel;

  NoteShareSuccessState({required this.noteModel});
}

class NoteShareErrorState extends NoteShareState {
  final String message;

  NoteShareErrorState({required this.message});
}
