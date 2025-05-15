import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/list_note_model.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NoteRepo noteRepo;
  String? nextCursor;
  bool hasMoreData = true;
  List<Note> notes = [];
  bool isLoadingMore = false;

  HomeBloc(this.noteRepo) : super(HomeInitial()) {
    on<HomeInitialFetchDataEvent>(homeInitialFetchDataEvent);
    on<HomeLoadMoreDataEvent>(homeLoadMoreDataEvent);
    on<HomeClickButtonNavigationToCreateNotesPageEvent>(homeClickButtonNavigationToNotesPageEvent);
    on<HomeClickButtonNavigationToShareNotePageEvent>(homeClickButtonNavigationToShareNotePageEvent);
    on<HomeClickNavigationToNoteDetailPageEvent>(homeClickNavigationToNoteDetailPageEvent);
    on<HomeClickButtonDeleteNoteEvent>(homeClickButtonDeleteNoteEvent);
    on<HomeClickButtonNavigationToArchivedPageEvent>(homeClickButtonNavigationToArchivedPageEvent);
    on<HomeClickButtonArchiveNoteEvent>(homeClickButtonArchiveNoteEvent);
  }

  FutureOr<void> homeInitialFetchDataEvent(HomeInitialFetchDataEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      final noteData = await noteRepo.getListNotes();
      nextCursor = noteData.paging.nextCursor;
      hasMoreData = nextCursor != null;
      notes = noteData.data;
      emit(HomeSuccessState(noteModel: noteData));
    } on ApiException catch (e) {
      emit(HomeErrorState());
      emit(HomeErrorActionState(message: e.message));
    } catch (e) {
      emit(HomeErrorState());
      emit(HomeErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> homeLoadMoreDataEvent(HomeLoadMoreDataEvent event, Emitter<HomeState> emit) async {
    if (!hasMoreData || nextCursor == null || nextCursor!.isEmpty || isLoadingMore) return;

    isLoadingMore = true;
    try {
      final noteData = await noteRepo.getListNotes(cursor: nextCursor);
      nextCursor = noteData.paging.nextCursor;
      hasMoreData = nextCursor != null && nextCursor!.isNotEmpty;
      notes.addAll(noteData.data);
      emit(HomeSuccessState(
        noteModel: ListNoteModel(
          data: notes,
          paging: noteData.paging,
          extra: noteData.extra,
        ),
      ));
    } on ApiException catch (e) {
      emit(HomeErrorActionState(message: e.message));
    } catch (e) {
      emit(HomeErrorActionState(message: 'An unexpected error occurred'));
    } finally {
      isLoadingMore = false;
    }
  }

  FutureOr<void> homeClickButtonNavigationToNotesPageEvent(
      HomeClickButtonNavigationToCreateNotesPageEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigationToCreateNotesPageActionState());
  }

  FutureOr<void> homeClickButtonNavigationToShareNotePageEvent(
      HomeClickButtonNavigationToShareNotePageEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigationToShareNotePageActionState());
  }

  FutureOr<void> homeClickNavigationToNoteDetailPageEvent(
      HomeClickNavigationToNoteDetailPageEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigationToNoteDetailPageActionState(
      noteId: event.noteId,
      title: event.title,
      createAt: event.createAt,
      permission: event.permission,
      ownerName: event.ownerName,
    ));
  }

  FutureOr<void> homeClickButtonArchiveNoteEvent(HomeClickButtonArchiveNoteEvent event, Emitter<HomeState> emit) async {
    emit(HomeArchiveNoteLoadingState());
    try {
      final archiveData = await noteRepo.archiveNote(event.noteId);
      if (archiveData.data) {
        emit(HomeArchiveNoteSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(HomeArchiveNoteErrorActionState(message: e.message));
    } catch (e) {
      emit(HomeArchiveNoteErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> homeClickButtonNavigationToArchivedPageEvent(
      HomeClickButtonNavigationToArchivedPageEvent event, Emitter<HomeState> emit) {
    emit(HomeNavigationToArchivedPageActionState());
  }

  FutureOr<void> homeClickButtonDeleteNoteEvent(HomeClickButtonDeleteNoteEvent event, Emitter<HomeState> emit) async {
    emit(HomeDeleteNoteLoadingState());
    try {
      final deleteNoteData = await noteRepo.deleteNote(event.noteId);
      if (deleteNoteData.data) {
        emit(HomeDeleteNoteSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(HomeDeleteNoteErrorActionState(message: e.message));
    } catch (e) {
      emit(HomeDeleteNoteErrorActionState(message: 'An unexpected error occurred'));
    }
  }
}
