part of 'note_detail_bloc.dart';

abstract class NoteDetailState {}

class NoteDetailInitial extends NoteDetailState {}

abstract class NoteDetailActionState extends NoteDetailState {}

// Text states
class NoteTextDetailLoadingState extends NoteDetailState {}

class NoteTextDetailSuccessState extends NoteDetailState {
  final TextNoteModel? textNoteModel;

  NoteTextDetailSuccessState({this.textNoteModel});
}

class NoteTextDetailErrorState extends NoteDetailState {}

class NoteTextDetailErrorActionState extends NoteDetailActionState {
  final String message;
  NoteTextDetailErrorActionState({required this.message});
}

// Audio states
class NoteAudioDetailLoadingState extends NoteDetailState {}

class NoteAudioDetailSuccessState extends NoteDetailState {
  final AudioNoteModel? audioNoteModel;
  NoteAudioDetailSuccessState({this.audioNoteModel});
}

class NoteAudioDetailErrorState extends NoteDetailState {}

class NoteAudioDetailErrorActionState extends NoteDetailActionState {
  final String message;
  NoteAudioDetailErrorActionState({required this.message});
}
