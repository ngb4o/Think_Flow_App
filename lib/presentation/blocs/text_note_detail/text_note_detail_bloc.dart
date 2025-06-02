import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/text_note_model.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

part 'text_note_detail_event.dart';
part 'text_note_detail_state.dart';

class TextNoteDetailBloc extends Bloc<TextNoteDetailEvent, TextNoteDetailState> {
  final NoteRepo noteRepo;

  TextNoteDetailBloc(this.noteRepo) : super(TextNoteDetailInitial()) {
    on<TextNoteDetailInitialFetchDataEvent>(textNoteDetailInitialFetchDataEvent);
    on<TextNoteDetailUpdateEvent>(textNoteDetailUpdateEvent);
    on<TextNoteDetailNavigationToSummaryEvent>(textNoteDetailNavigationToSummaryEvent);
  }

  FutureOr<void> textNoteDetailInitialFetchDataEvent(
      TextNoteDetailInitialFetchDataEvent event, Emitter<TextNoteDetailState> emit) async {
    emit(TextNoteDetailLoadingState());
    try {
      var noteTextDetailData = await noteRepo.getTextNote(event.noteId);
      if (noteTextDetailData.data != null) {
        emit(TextNoteDetailSuccessState(textNoteModel: noteTextDetailData));
      }
    } on ApiException catch (e) {
      emit(TextNoteDetailErrorState(message: e.message));
      emit(TextNoteDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(TextNoteDetailErrorState(message: 'An unexpected error occurred'));
      emit(TextNoteDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> textNoteDetailUpdateEvent(
      TextNoteDetailUpdateEvent event, Emitter<TextNoteDetailState> emit) async {
    emit(TextNoteDetailUpdateLoadingState());
    try {
      var noteUpdateTextData = await noteRepo.updateTextNote(event.noteId, event.content);
      if (noteUpdateTextData.data != null) {
        emit(TextNoteDetailUpdateSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(TextNoteDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(TextNoteDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> textNoteDetailNavigationToSummaryEvent(
      TextNoteDetailNavigationToSummaryEvent event, Emitter<TextNoteDetailState> emit) async {
    emit(TextNoteDetailNavigationToSummaryActionState(textId: event.textId, permission: event.permission));
  }
} 