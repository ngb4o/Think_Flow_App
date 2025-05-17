part of 'note_detail_bloc.dart';

/// Base event class
@immutable
sealed class NoteDetailEvent {}

// ==================== TEXT NOTE FEATURE ====================
class NoteTextDetailInitialFetchDataEvent extends NoteDetailEvent {
  final String noteId;

  NoteTextDetailInitialFetchDataEvent({required this.noteId});
}

// ==================== NOTE MEMBER FEATURE ====================
class NoteDetailInitialFetchDataMemberEvent extends NoteDetailEvent {
  final String noteId;

  NoteDetailInitialFetchDataMemberEvent({required this.noteId});
}

// ==================== AUDIO NOTE FEATURE ====================
class NoteAudioDetailInitialFetchDataEvent extends NoteDetailEvent {
  final String noteId;

  NoteAudioDetailInitialFetchDataEvent({required this.noteId});
}

// ==================== SUMMARY FEATURE ====================
class NoteInitialFetchDataSummaryNoteEvent extends NoteDetailEvent {
  final String noteId;

  NoteInitialFetchDataSummaryNoteEvent({required this.noteId});
}

// ==================== MINDMAP FEATURE ====================
class NoteInitialFetchDataMindmapEvent extends NoteDetailEvent {
  final String noteId;

  NoteInitialFetchDataMindmapEvent({required this.noteId});
}

// ==================== NOTE UPDATE FEATURE ====================
class NoteClickButtonUpdateEvent extends NoteDetailEvent {
  final String noteId;
  final String title;

  NoteClickButtonUpdateEvent({required this.noteId, required this.title});
}

// ==================== TEXT NOTE UPDATE FEATURE ====================
class NoteClickButtonUpdateTextEvent extends NoteDetailEvent {
  final String noteId;
  final Map<String, dynamic> content;

  NoteClickButtonUpdateTextEvent({required this.noteId, required this.content});
}

// ==================== AUDIO NOTE CREATE FEATURE ====================
class NoteClickButtonCreateAudioEvent extends NoteDetailEvent {
  final String id;
  final File audioFile;

  NoteClickButtonCreateAudioEvent({required this.id, required this.audioFile});
}

// ==================== AUDIO NOTE DELETE FEATURE ====================
class NoteClickButtonDeleteAudioEvent extends NoteDetailEvent {
  final String audioId;

  NoteClickButtonDeleteAudioEvent({required this.audioId});
}

// ==================== SUMMARY UPDATE FEATURE ====================
class NoteClickButtonUpdateSummaryNoteEvent extends NoteDetailEvent {
  final String noteId;
  final String summaryText;

  NoteClickButtonUpdateSummaryNoteEvent({required this.noteId, required this.summaryText});
}

// ==================== SUMMARY CREATE FEATURE ====================
class NoteDetailCreateSummaryNoteEvent extends NoteDetailEvent {
  final String noteId;

  NoteDetailCreateSummaryNoteEvent({required this.noteId});
}

// ==================== MINDMAP CREATE FEATURE ====================
class NoteDetailCreateMindmapEvent extends NoteDetailEvent {
  final String noteId;

  NoteDetailCreateMindmapEvent({required this.noteId});
}

// ==================== MINDMAP UPDATE FEATURE ====================
class NoteDetailUpdateMindmapEvent extends NoteDetailEvent {
  final String mindmapId;
  final Map<String, dynamic> mindmapData;

  NoteDetailUpdateMindmapEvent({required this.mindmapId, required this.mindmapData});
}

class NoteDetaiClickButtonNavigationToSummaryTextEvent extends NoteDetailEvent {
  final String textId;

  NoteDetaiClickButtonNavigationToSummaryTextEvent({required this.textId});
}