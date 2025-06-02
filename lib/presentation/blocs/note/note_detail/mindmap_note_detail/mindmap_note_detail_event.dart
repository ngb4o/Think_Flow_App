part of 'mindmap_note_detail_bloc.dart';

@immutable
sealed class MindmapNoteDetailEvent {}

class MindmapNoteDetailInitialFetchDataEvent extends MindmapNoteDetailEvent {
  final String noteId;
  final String permission;

  MindmapNoteDetailInitialFetchDataEvent({required this.noteId, required this.permission});
}

class MindmapNoteDetailCreateEvent extends MindmapNoteDetailEvent {
  final String noteId;
  final String permission;

  MindmapNoteDetailCreateEvent({required this.noteId, required this.permission});
}

class MindmapNoteDetailUpdateEvent extends MindmapNoteDetailEvent {
  final String mindmapId;
  final Map<String, dynamic> mindmapData;
  final String permission;

  MindmapNoteDetailUpdateEvent({required this.mindmapId, required this.mindmapData, required this.permission});
} 