import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/note_model.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

part 'summary_note_detail_event.dart';
part 'summary_note_detail_state.dart';

class SummaryNoteDetailBloc extends Bloc<SummaryNoteDetailEvent, SummaryNoteDetailState> {
  final NoteRepo noteRepo;

  SummaryNoteDetailBloc(this.noteRepo) : super(SummaryNoteDetailInitial()) {
    on<SummaryNoteDetailInitialFetchDataEvent>(summaryNoteDetailInitialFetchDataEvent);
    on<SummaryNoteDetailCreateEvent>(summaryNoteDetailCreateEvent);
    on<SummaryNoteDetailUpdateEvent>(summaryNoteDetailUpdateEvent);
  }

  FutureOr<void> summaryNoteDetailInitialFetchDataEvent(
      SummaryNoteDetailInitialFetchDataEvent event, Emitter<SummaryNoteDetailState> emit) async {
    emit(SummaryNoteDetailLoadingState());
    try {
      var noteData = await noteRepo.getNote(event.noteId);
      if (noteData.data?.summary == null) {
        if (event.permission != 'read') {
          add(SummaryNoteDetailCreateEvent(noteId: event.noteId, permission: event.permission));
        } else {
          emit(SummaryNoteDetailSuccessState(noteModel: noteData));
        }
      } else {
        emit(SummaryNoteDetailSuccessState(noteModel: noteData));
      }
    } on ApiException catch (e) {
      emit(SummaryNoteDetailErrorState(message: e.message));
      emit(SummaryNoteDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(SummaryNoteDetailErrorState(message: 'An unexpected error occurred'));
      emit(SummaryNoteDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> summaryNoteDetailCreateEvent(
      SummaryNoteDetailCreateEvent event, Emitter<SummaryNoteDetailState> emit) async {
    if (event.permission == 'read') {
      emit(SummaryNoteDetailCreateErrorActionState(
          message: 'Access denied. Please contact the owner to update permissions.'));
      return;
    }

    emit(SummaryNoteDetailCreateLoadingState());
    try {
      var createSummaryData = await noteRepo.createSummaryNote(event.noteId);
      if (createSummaryData.data != null) {
        emit(SummaryNoteDetailCreateSuccessActionState());
        add(SummaryNoteDetailInitialFetchDataEvent(noteId: event.noteId, permission: event.permission));
      }
    } on ApiException catch (e) {
      emit(SummaryNoteDetailCreateErrorActionState(message: e.message));
    } catch (e) {
      emit(SummaryNoteDetailCreateErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> summaryNoteDetailUpdateEvent(
      SummaryNoteDetailUpdateEvent event, Emitter<SummaryNoteDetailState> emit) async {
    emit(SummaryNoteDetailUpdateLoadingState());
    try {
      var updateSummaryData = await noteRepo.updateSummaryNote(event.noteId, event.summaryText);
      if (updateSummaryData.data != null) {
        emit(SummaryNoteDetailUpdateSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(SummaryNoteDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(SummaryNoteDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }
} 