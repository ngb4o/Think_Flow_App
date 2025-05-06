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

// Update note
class NoteUpdateDetailLoadingState extends NoteDetailState {}

class NoteUpdateDetailSuccessActionSate extends NoteDetailActionState {}

class NoteUpdateDetailErrorActionState extends NoteDetailActionState {
  final String message;

  NoteUpdateDetailErrorActionState({required this.message});
}

// Update text note
class NoteUpdateTextDetailLoadingState extends NoteDetailState {}

class NoteUpdateTextDetailSuccessActionSate extends NoteDetailActionState {}

class NoteUpdateTextDetailErrorActionState extends NoteDetailActionState {
  final String message;

  NoteUpdateTextDetailErrorActionState({required this.message});
}

// Create audio note
class NotesCreateAudioDetailLoadingState extends NoteDetailState {}

class NotesCreateAudioDetailSuccessActionState extends NoteDetailActionState {}

class NotesCreateAudioDetailErrorActionState extends NoteDetailActionState {
  final String message;

  NotesCreateAudioDetailErrorActionState({required this.message});
}

// Delete audio note
class NoteDeleteAudioLoadingState extends NoteDetailState {}

class NoteDeleteAudioSuccessState extends NoteDetailActionState {}

class NoteDeleteAudioErrorState extends NoteDetailActionState {
  final String message;

  NoteDeleteAudioErrorState({required this.message});
}

// Note member
class NoteDetailMemberLoadingState extends NoteDetailState {}

class NoteDetailMemberSuccessState extends NoteDetailState {
  final NoteMemberModel? members;
  NoteDetailMemberSuccessState({this.members});
}

class NoteDetailMemberErrorState extends NoteDetailState {}

class NoteDetailMemberErrorActionState extends NoteDetailActionState {
  final String message;

  NoteDetailMemberErrorActionState({required this.message});
}


// Notify
class NotesUpdateNotifyUpdateActionState extends NoteDetailActionState {}

