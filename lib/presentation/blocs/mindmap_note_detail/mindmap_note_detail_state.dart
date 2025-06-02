part of 'mindmap_note_detail_bloc.dart';

@immutable
sealed class MindmapNoteDetailState {}

class MindmapNoteDetailInitial extends MindmapNoteDetailState {}

class MindmapNoteDetailLoadingState extends MindmapNoteDetailState {}

class MindmapNoteDetailSuccessState extends MindmapNoteDetailState {
  final NoteModel noteModel;

  MindmapNoteDetailSuccessState({required this.noteModel});
}

class MindmapNoteDetailErrorState extends MindmapNoteDetailState {
  final String message;

  MindmapNoteDetailErrorState({required this.message});
}

// Action States
sealed class MindmapNoteDetailActionState extends MindmapNoteDetailState {}

class MindmapNoteDetailCreateLoadingState extends MindmapNoteDetailState {}

class MindmapNoteDetailCreateSuccessActionState extends MindmapNoteDetailActionState {}

class MindmapNoteDetailCreateErrorActionState extends MindmapNoteDetailActionState {
  final String message;

  MindmapNoteDetailCreateErrorActionState({required this.message});
}

class MindmapNoteDetailUpdateLoadingState extends MindmapNoteDetailState {}

class MindmapNoteDetailUpdateSuccessActionState extends MindmapNoteDetailActionState {}

class MindmapNoteDetailErrorActionState extends MindmapNoteDetailActionState {
  final String message;

  MindmapNoteDetailErrorActionState({required this.message});
} 