import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/audio_note_model.dart';
import 'package:think_flow/data/models/text_note_model.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

part 'note_detail_event.dart';

part 'note_detail_state.dart';

class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  final NoteRepo noteRepo;

  NoteDetailBloc(this.noteRepo) : super(NoteDetailInitial()) {
    on<NoteTextDetailInitialFetchDataEvent>(onTextDetailInitialFetch);
    on<NoteAudioDetailInitialFetchDataEvent>(onAudioDetailInitialFetch);
  }

  FutureOr<void> onTextDetailInitialFetch(
      NoteTextDetailInitialFetchDataEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteTextDetailLoadingState());
    try {
      var noteTextDetailData = await noteRepo.getTextNote(event.noteId);
      if (noteTextDetailData.data != null) {
        emit(NoteTextDetailSuccessState(textNoteModel: noteTextDetailData));
      }
    } on ApiException catch (e) {
      emit(NoteTextDetailErrorState());
      emit(NoteTextDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteTextDetailErrorState());
      emit(NoteTextDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> onAudioDetailInitialFetch(
      NoteAudioDetailInitialFetchDataEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteAudioDetailLoadingState());
    try {
      var noteAudioDetailData = await noteRepo.getListAudioNote(event.noteId);
      if (noteAudioDetailData.data != null) {
        emit(NoteAudioDetailSuccessState(audioNoteModel: noteAudioDetailData));
      }
    } on ApiException catch (e) {
      emit(NoteAudioDetailErrorState());
      emit(NoteAudioDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteAudioDetailErrorState());
      emit(NoteAudioDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }
}
