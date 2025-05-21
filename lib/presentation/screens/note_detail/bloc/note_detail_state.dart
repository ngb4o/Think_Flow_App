part of 'note_detail_bloc.dart';

/// Base state class
abstract class NoteDetailState {}

/// Initial state
class NoteDetailInitial extends NoteDetailState {}

/// Base action state class
abstract class NoteDetailActionState extends NoteDetailState {}

// ==================== TEXT NOTE FEATURE ====================
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

// ==================== AUDIO NOTE FEATURE ====================
class NoteListAudioDetailLoadingState extends NoteDetailState {}

class NoteListAudioDetailSuccessState extends NoteDetailState {
  final ListAudioNoteModel? listAudioNoteModel;
  NoteListAudioDetailSuccessState({this.listAudioNoteModel});
}

class NoteListAudioDetailErrorState extends NoteDetailState {}

class NoteListAudioDetailErrorActionState extends NoteDetailActionState {
  final String message;
  NoteListAudioDetailErrorActionState({required this.message});
}

// ==================== NOTE UPDATE FEATURE ====================
class NoteUpdateDetailLoadingState extends NoteDetailState {}

class NoteUpdateDetailSuccessActionSate extends NoteDetailActionState {}

class NoteUpdateDetailErrorActionState extends NoteDetailActionState {
  final String message;
  NoteUpdateDetailErrorActionState({required this.message});
}

// ==================== TEXT NOTE UPDATE FEATURE ====================
class NoteUpdateTextDetailLoadingState extends NoteDetailState {}

class NoteUpdateTextDetailSuccessActionSate extends NoteDetailActionState {}

class NoteUpdateTextDetailErrorActionState extends NoteDetailActionState {
  final String message;
  NoteUpdateTextDetailErrorActionState({required this.message});
}

// ==================== AUDIO NOTE CREATE FEATURE ====================
class NotesCreateAudioDetailLoadingState extends NoteDetailState {}

class NotesCreateAudioDetailSuccessActionState extends NoteDetailActionState {}

class NotesCreateAudioDetailErrorActionState extends NoteDetailActionState {
  final String message;
  NotesCreateAudioDetailErrorActionState({required this.message});
}

// ==================== AUDIO NOTE DELETE FEATURE ====================
class NoteDeleteAudioLoadingState extends NoteDetailState {}

class NoteDeleteAudioSuccessState extends NoteDetailActionState {}

class NoteDeleteAudioErrorState extends NoteDetailActionState {
  final String message;
  NoteDeleteAudioErrorState({required this.message});
}

// ==================== NOTE MEMBER FEATURE ====================
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

// ==================== NOTIFY UPDATE FEATURE ====================
class NotesUpdateNotifyUpdateActionState extends NoteDetailActionState {}

// ==================== SUMMARY UPDATE FEATURE ====================
class NoteUpdateSummaryDetailLoadingState extends NoteDetailState {}

class NoteUpdateSummaryDetailSuccessActionState extends NoteDetailActionState {}

class NoteUpdateSummaryDetailErrorActionState extends NoteDetailActionState {
  final String message;
  NoteUpdateSummaryDetailErrorActionState({required this.message});
}

// ==================== SUMMARY CREATE FEATURE ====================
class NoteDetailCreateSummaryNoteLoadingState extends NoteDetailState {}

class NoteDetailCreateSummaryNoteSuccessActionState
    extends NoteDetailActionState {}

class NoteDetailCreateSummaryNoteErrorActionState
    extends NoteDetailActionState {
  final String message;
  NoteDetailCreateSummaryNoteErrorActionState({required this.message});
}

// ==================== SUMMARY FEATURE ====================
class NoteSummaryLoadingState extends NoteDetailState {}

class NoteSummarySuccessState extends NoteDetailState {
  final NoteModel? noteModel;
  NoteSummarySuccessState({this.noteModel});
}

class NoteSummaryErrorState extends NoteDetailState {}

class NoteSummaryErrorActionState extends NoteDetailActionState {
  final String message;
  NoteSummaryErrorActionState({required this.message});
}

// ==================== MINDMAP FEATURE ====================
class NoteMindmapLoadingState extends NoteDetailState {}

class NoteMindmapSuccessState extends NoteDetailState {
  final NoteModel? noteModel;
  NoteMindmapSuccessState({this.noteModel});
}

class NoteMindmapErrorState extends NoteDetailState {}

class NoteMindmapErrorActionState extends NoteDetailActionState {
  final String message;
  NoteMindmapErrorActionState({required this.message});
}

// ==================== MINDMAP CREATE FEATURE ====================
class NoteCreateMindmapLoadingState extends NoteDetailState {}

class NoteCreateMindmapSuccessActionState extends NoteDetailActionState {}

class NoteCreateMindmapErrorActionState extends NoteDetailActionState {
  final String message;
  NoteCreateMindmapErrorActionState({required this.message});
}

// ==================== MINDMAP UPDATE FEATURE ====================
class NoteUpdateMindmapLoadingState extends NoteDetailState {}

class NoteUpdateMindmapSuccessActionState extends NoteDetailActionState {}

class NoteUpdateMindmapErrorActionState extends NoteDetailActionState {
  final String message;
  NoteUpdateMindmapErrorActionState({required this.message});
}

class NoteDetailNavigationToSummaryTextPageActionState
    extends NoteDetailActionState {}

class NoteAudioDetailErrorActionState extends NoteDetailActionState {
  final String message;
  NoteAudioDetailErrorActionState({required this.message});
}

class NoteDetailNavigationToAudioSummaryTextPageActionState
    extends NoteDetailActionState {
  final String audioId;
  final String permission;

  NoteDetailNavigationToAudioSummaryTextPageActionState(
      {required this.audioId, required this.permission});
}

class NoteDetailNavigationToAudioTranscriptionTextPageActionState
    extends NoteDetailActionState {
  final String audioId;
  final String permission;

  NoteDetailNavigationToAudioTranscriptionTextPageActionState(
      {required this.audioId, required this.permission});
}