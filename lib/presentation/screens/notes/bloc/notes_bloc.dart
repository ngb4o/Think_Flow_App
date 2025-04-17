import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

part 'notes_event.dart';

part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepo noteRepo;
  NotesBloc(this.noteRepo) : super(NotesInitial()) {
    on<NotesClickButtonCreateEvent>(notesClickButtonCreateEvent);
    on<NoteCreateTextEvent>(noteCreateTextEvent);
    on<NotesNotifyHomeUpdateEvent>(notesNotifyHomeUpdateEvent);
  }

  FutureOr<void> notesClickButtonCreateEvent(
      NotesClickButtonCreateEvent event, Emitter<NotesState> emit) async {
    emit(NotesCreateLoadingState());
    try {
      var createNoteData = await noteRepo.createNewNote(event.title);
      if(createNoteData.data != null) {
        emit(NotesCreateTextActionState(id:  createNoteData.data));
        emit(NotesCreateSuccessActionSate());
      }
    } on ApiException catch (e) {
      emit(NotesCreateErrorActionState(message: e.message));
    } catch (e) {
      emit(NotesCreateErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteCreateTextEvent(NoteCreateTextEvent event, Emitter<NotesState> emit) async {
    emit(NotesCreateTextLoadingState());
    try {
      var createTextData = await noteRepo.createTextNote(event.id, event.content);
      if(createTextData.data != null) {
        emit(NotesCreateTextSuccessActionState());
        emit(NotesNotifyHomeUpdateActionState());
      }
    } on ApiException catch (e) {
      emit(NotesCreateTextErrorActionState(message: e.message));
    } catch (e) {
      emit(NotesCreateTextErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> notesNotifyHomeUpdateEvent(
      NotesNotifyHomeUpdateEvent event, Emitter<NotesState> emit) {
    emit(NotesNotifyHomeUpdateActionState());
  }
}
