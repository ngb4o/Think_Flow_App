import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/models/text_note_model.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

import '../../../../../data/data_sources/remote/api_exception.dart';

part 'text_summary_event.dart';
part 'text_summary_state.dart';

class TextSummaryBloc extends Bloc<TextSummaryEvent, TextSummaryState> {
  final NoteRepo noteRepo;
  TextSummaryBloc(this.noteRepo) : super(TextSummaryInitial()) {
    on<TextSummaryInitialFetchDataEvent>(textSummaryInitialFetchDataEvent);
    on<TextSummaryCreateTextEvent>(textSummaryCreateTextEvent);
    on<TextSummaryClickButtonUpdateSummaryTextEvent>(textSummaryClickButtonUpdateSummaryTextEvent);
  }

  FutureOr<void> textSummaryInitialFetchDataEvent(
      TextSummaryInitialFetchDataEvent event, Emitter<TextSummaryState> emit) async {
    emit(TextSummaryLoadingState());
    try {
      final textData = await noteRepo.getTextNote(event.noteId);
      if (textData.data?.summary?.summaryText != null) {
        emit(TextSummarySuccessState(textNoteModel: textData));
      } else {
        add(TextSummaryCreateTextEvent(
          textId: textData.data!.id.toString(),
          noteId: event.noteId,
        ));
      }
    } on ApiException catch (e) {
      emit(TextSummaryErrorActionState(message: e.message));
    } catch (e) {
      emit(TextSummaryErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> textSummaryCreateTextEvent(
      TextSummaryCreateTextEvent event, Emitter<TextSummaryState> emit) async {
    emit(TextSummaryCreateTextLoadingState());
    try {
      final textData = await noteRepo.createSummaryText(event.textId);
      if (textData.data != null) {
        emit(TextSummaryCreateTextSuccessState());
        if (event.noteId != null) {
          add(TextSummaryInitialFetchDataEvent(noteId: event.noteId!));
        }
      }
    } on ApiException catch (e) {
      emit(TextSummaryCreateTextErrorActionState(message: e.message));
    } catch (e) {
      emit(TextSummaryCreateTextErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> textSummaryClickButtonUpdateSummaryTextEvent(
      TextSummaryClickButtonUpdateSummaryTextEvent event, Emitter<TextSummaryState> emit) async {
    emit(TextSummaryUpdateSummaryDetailLoadingState());
    try {
      var noteUpdateSummaryData = await noteRepo.updateSummaryNote(event.textId, event.summaryText);
      if (noteUpdateSummaryData.data != null) {
        emit(TextSummaryUpdateSummaryDetailSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(TextSummaryUpdateSummaryDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(TextSummaryUpdateSummaryDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }
}
