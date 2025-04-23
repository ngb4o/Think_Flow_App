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

// Update note state
class NoteUpdateLoadingState extends NoteDetailState {}

class NoteUpdateSuccessActionSate extends NoteDetailActionState {}

class NoteUpdateErrorActionState extends NoteDetailActionState {
  final String message;

  NoteUpdateErrorActionState({required this.message});
}

// Update text note state
class NoteUpdateTextLoadingState extends NoteDetailState {}

class NoteUpdateTextSuccessActionSate extends NoteDetailActionState {}

class NoteUpdateTextErrorActionState extends NoteDetailActionState {
  final String message;

  NoteUpdateTextErrorActionState({required this.message});
}

// Notify
class NotesUpdateNotifyUpdateActionState extends NoteDetailActionState {}

