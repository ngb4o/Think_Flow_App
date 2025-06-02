import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/note_model.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

part 'mindmap_note_detail_event.dart';
part 'mindmap_note_detail_state.dart';

class MindmapNoteDetailBloc extends Bloc<MindmapNoteDetailEvent, MindmapNoteDetailState> {
  final NoteRepo noteRepo;

  MindmapNoteDetailBloc(this.noteRepo) : super(MindmapNoteDetailInitial()) {
    on<MindmapNoteDetailInitialFetchDataEvent>(mindmapNoteDetailInitialFetchDataEvent);
    on<MindmapNoteDetailCreateEvent>(mindmapNoteDetailCreateEvent);
    on<MindmapNoteDetailUpdateEvent>(mindmapNoteDetailUpdateEvent);
  }

  FutureOr<void> mindmapNoteDetailInitialFetchDataEvent(
      MindmapNoteDetailInitialFetchDataEvent event, Emitter<MindmapNoteDetailState> emit) async {
    emit(MindmapNoteDetailLoadingState());
    try {
      var noteData = await noteRepo.getNote(event.noteId);
      if (noteData.data?.mindmap == null) {
        if (event.permission != 'read') {
          add(MindmapNoteDetailCreateEvent(noteId: event.noteId, permission: event.permission));
        } else {
          emit(MindmapNoteDetailSuccessState(noteModel: noteData));
        }
      } else {
        emit(MindmapNoteDetailSuccessState(noteModel: noteData));
      }
    } on ApiException catch (e) {
      emit(MindmapNoteDetailErrorState(message: e.message));
      emit(MindmapNoteDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(MindmapNoteDetailErrorState(message: 'An unexpected error occurred'));
      emit(MindmapNoteDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> mindmapNoteDetailCreateEvent(
      MindmapNoteDetailCreateEvent event, Emitter<MindmapNoteDetailState> emit) async {
    if (event.permission == 'read') {
      emit(MindmapNoteDetailCreateErrorActionState(
          message: 'Access denied. Please contact the owner to update permissions.'));
      return;
    }

    emit(MindmapNoteDetailCreateLoadingState());
    try {
      var createMindmapData = await noteRepo.createMindmapNote(event.noteId);
      if (createMindmapData.data != null) {
        emit(MindmapNoteDetailCreateSuccessActionState());
        add(MindmapNoteDetailInitialFetchDataEvent(noteId: event.noteId, permission: event.permission));
      }
    } on ApiException catch (e) {
      emit(MindmapNoteDetailCreateErrorActionState(message: e.message));
    } catch (e) {
      emit(MindmapNoteDetailCreateErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> mindmapNoteDetailUpdateEvent(
      MindmapNoteDetailUpdateEvent event, Emitter<MindmapNoteDetailState> emit) async {
    emit(MindmapNoteDetailUpdateLoadingState());
    try {
      var updateMindmapData = await noteRepo.updateMindmapNote(event.mindmapId, event.mindmapData);
      if (updateMindmapData.data != null) {
        emit(MindmapNoteDetailUpdateSuccessActionState());
        add(MindmapNoteDetailInitialFetchDataEvent(noteId: event.mindmapId, permission: event.permission));
      }
    } on ApiException catch (e) {
      emit(MindmapNoteDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(MindmapNoteDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }
} 