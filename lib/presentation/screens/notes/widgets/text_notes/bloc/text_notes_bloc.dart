import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

import '../../../../../../data/data_sources/remote/api_exception.dart';

part 'text_notes_event.dart';
part 'text_notes_state.dart';

class TextNotesBloc extends Bloc<TextNotesEvent, TextNotesState> {
  final NoteRepo noteRepo;

  TextNotesBloc(this.noteRepo) : super(TextNotesInitial()) {
    on<TextNotesClickButtonCreateNewEvent>(textNotesClickButtonCreateNewEvent);
    on<TextNotesClickButtonCreateTextEvent>(textNotesClickButtonCreateTextEvent);
    on<TextNotesNotifyHomeUpdateEvent>(textNotesNotifyHomeUpdateEvent);
  }

  FutureOr<void> textNotesClickButtonCreateNewEvent(
      TextNotesClickButtonCreateNewEvent event, Emitter<TextNotesState> emit) async {
    emit(TextNotesCreateNewLoadingState());
    try {
      var createNewNoteData = await noteRepo.createNewNote(event.title);
      if (createNewNoteData.data != null) {
        emit(TextNotesCreateNewSuccessState());
        emit(TextNotesCreateNewSuccessActionState(noteId: createNewNoteData.data));
      }
    } on ApiException catch (e) {
      emit(TextNotesCreateNewErrorActionState(message: e.message));
    } catch (e) {
      emit(TextNotesCreateNewErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> textNotesClickButtonCreateTextEvent(
      TextNotesClickButtonCreateTextEvent event, Emitter<TextNotesState> emit) async {
    emit(TextNotesCreateTextLoadingState());
    try {
      var createTextNoteData = await noteRepo.createTextNote(event.id, event.content);
      if (createTextNoteData.data != null) {
        emit(TextNotesCreateTextSuccessState());
        emit(TextNotesCreateTextSuccessActionState());
        emit(TextNotesNotifyHomeUpdateActionState());
      }
    } on ApiException catch (e) {
      emit(TextNotesCreateTextErrorActionState(message: e.message));
    } catch (e) {
      emit(TextNotesCreateTextErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> textNotesNotifyHomeUpdateEvent(
      TextNotesNotifyHomeUpdateEvent event, Emitter<TextNotesState> emit) {
    emit(TextNotesNotifyHomeUpdateActionState());
  }
}
