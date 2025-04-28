import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

import '../../../../data/models/note_model.dart';

part 'note_archived_event.dart';

part 'note_archived_state.dart';

class NoteArchivedBloc extends Bloc<NoteArchivedEvent, NoteArchivedState> {
  final NoteRepo noteRepo;
  String? nextCursor;
  bool hasMoreData = true;
  List<Note> notes = [];
  bool isLoadingMore = false;

  NoteArchivedBloc(this.noteRepo) : super(NoteArchivedInitial()) {
    on<NoteArchivedInitialFetchDataEvent>(noteArchivedInitialFetchDataEvent);
    on<NoteClickButtonUnarchiveEvent>(noteClickButtonUnarchiveEvent);
  }

  FutureOr<void> noteArchivedInitialFetchDataEvent(
      NoteArchivedInitialFetchDataEvent event, Emitter<NoteArchivedState> emit) async {
    emit(NoteArchivedLoadingState());
    try {
      final noteArchivedData = await noteRepo.getListArchived();
      nextCursor = noteArchivedData.paging.nextCursor;
      hasMoreData = nextCursor != null;
      notes = noteArchivedData.data;
      emit(NoteArchivedSuccessState(noteModel: noteArchivedData));
    } on ApiException catch (e) {
      emit(NoteArchivedErrorState(message: e.message));
    } catch (e) {
      emit(NoteArchivedErrorState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteClickButtonUnarchiveEvent(
      NoteClickButtonUnarchiveEvent event, Emitter<NoteArchivedState> emit) async {
    emit(NoteUnarchiveLoadingState());
    try {
      final archiveData = await noteRepo.unarchiveNote(event.noteId);
      if(archiveData.data) {
        emit(NoteUnarchiveSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(NoteUnarchiveErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteUnarchiveErrorActionState(message: 'An unexpected error occurred'));

    }
  }
}
