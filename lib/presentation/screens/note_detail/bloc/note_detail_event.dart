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
class NoteDetailInitialFetchDataListAudioEvent extends NoteDetailEvent {
  final String noteId;

  NoteDetailInitialFetchDataListAudioEvent({required this.noteId});
}

// ==================== SUMMARY FEATURE ====================
class NoteDetailInitialFetchDataSummaryNoteEvent extends NoteDetailEvent {
  final String noteId;

  NoteDetailInitialFetchDataSummaryNoteEvent({required this.noteId});
}

// ==================== MINDMAP FEATURE ====================
class NoteDetailInitialFetchDataMindmapEvent extends NoteDetailEvent {
  final String noteId;

  NoteDetailInitialFetchDataMindmapEvent({required this.noteId});
}

// ==================== NOTE UPDATE FEATURE ====================
class NoteDetailClickButtonUpdateTitleEvent extends NoteDetailEvent {
  final String noteId;
  final String title;

  NoteDetailClickButtonUpdateTitleEvent({required this.noteId, required this.title});
}

// ==================== TEXT NOTE UPDATE FEATURE ====================
class NoteDetailClickButtonUpdateTextEvent extends NoteDetailEvent {
  final String noteId;
  final Map<String, dynamic> content;

  NoteDetailClickButtonUpdateTextEvent({required this.noteId, required this.content});
}

// ==================== AUDIO NOTE CREATE FEATURE ====================
class NoteDetailClickButtonCreateAudioEvent extends NoteDetailEvent {
  final String id;
  final File audioFile;

  NoteDetailClickButtonCreateAudioEvent({required this.id, required this.audioFile});
}

// ==================== AUDIO NOTE DELETE FEATURE ====================
class NoteDetailClickButtonDeleteAudioEvent extends NoteDetailEvent {
  final String audioId;

  NoteDetailClickButtonDeleteAudioEvent({required this.audioId});
}

// ==================== SUMMARY UPDATE FEATURE ====================
class NoteDetailClickButtonUpdateSummaryTextEvent extends NoteDetailEvent {
  final String noteId;
  final String summaryText;

  NoteDetailClickButtonUpdateSummaryTextEvent({required this.noteId, required this.summaryText});
}

// ==================== SUMMARY CREATE FEATURE ====================
class NoteDetailCreateSummaryTextEvent extends NoteDetailEvent {
  final String noteId;

  NoteDetailCreateSummaryTextEvent({required this.noteId});
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

class NoteDetaiClickButtonNavigationToAudioSummaryTextEvent extends NoteDetailEvent {
  final String audioId;
  final String permission;

  NoteDetaiClickButtonNavigationToAudioSummaryTextEvent({required this.audioId, required this.permission});
}

class NoteDetaiClickButtonNavigationToAudioTranscriptTextEvent extends NoteDetailEvent {
  final String audioId;
  final String permission;

  NoteDetaiClickButtonNavigationToAudioTranscriptTextEvent({required this.audioId, required this.permission});
}
