import 'dart:async';
import 'dart:io';

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
    on<NoteCreateAudioEvent>(noteCreateAudioEvent);
  }

  FutureOr<void> notesClickButtonCreateEvent(
      NotesClickButtonCreateEvent event, Emitter<NotesState> emit) async {
    emit(NotesCreateLoadingState());
    try {
      var createNoteData = await noteRepo.createNewNote(event.title);
      if(createNoteData.data != null) {
        emit(NotesCreateSuccessActionSate(id: createNoteData.data));
        emit(NotesNotifyHomeUpdateActionState());
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
      }
    } on ApiException catch (e) {
      emit(NotesCreateTextErrorActionState(message: e.message));
    } catch (e) {
      emit(NotesCreateTextErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteCreateAudioEvent(NoteCreateAudioEvent event, Emitter<NotesState> emit) async {
    emit(NotesCreateAudioLoadingState());
    try {
      var createAudioData = await noteRepo.createAudiNote(event.id, event.audioFile);
      if(createAudioData.data != null) {
        emit(NotesCreateAudioSuccessActionState());
        emit(NotesNotifyHomeUpdateActionState());
      }
    } on ApiException catch (e) {
      emit(NotesCreateAudioErrorActionState(message: e.message));
    } catch (e) {
      emit(NotesCreateAudioErrorActionState(message: 'An unexpected error occurred'));
    }
  }
}
