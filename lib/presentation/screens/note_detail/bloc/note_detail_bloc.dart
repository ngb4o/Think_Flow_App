import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/audio_note_model.dart';
import 'package:think_flow/data/models/text_note_model.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

import '../../../../data/models/note_member_model.dart';

part 'note_detail_event.dart';

part 'note_detail_state.dart';

class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  final NoteRepo noteRepo;

  NoteDetailBloc(this.noteRepo) : super(NoteDetailInitial()) {
    on<NoteTextDetailInitialFetchDataEvent>(onTextDetailInitialFetch);
    on<NoteAudioDetailInitialFetchDataEvent>(onAudioDetailInitialFetch);
    on<NoteDetailInitialFetchDataMemberEvent>(noteDetailInitialFetchDataMemberEvent);
    on<NoteClickButtonUpdateEvent>(noteClickButtonUpdateEvent);
    on<NoteClickButtonUpdateTextEvent>(noteClickButtonUpdateTextEvent);
    on<NoteClickButtonCreateAudioEvent>(noteClickButtonCreateAudioEvent);
    on<NoteClickButtonDeleteAudioEvent>(noteClickButtonDeleteAudioEvent);
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

  FutureOr<void> noteDetailInitialFetchDataMemberEvent(
      NoteDetailInitialFetchDataMemberEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteDetailMemberLoadingState());
    try {
      var noteDetailMemberData = await noteRepo.getNoteMember(event.noteId);
      if (noteDetailMemberData.data != null) {
        emit(NoteDetailMemberSuccessState(members: noteDetailMemberData));
      }
    } on ApiException catch (e) {
      emit(NoteDetailMemberErrorState());
      emit(NoteDetailMemberErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteDetailMemberErrorState());
      emit(NoteDetailMemberErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteClickButtonUpdateEvent(NoteClickButtonUpdateEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteUpdateDetailLoadingState());
    try {
      var noteUpdateData = await noteRepo.updateNote(event.noteId, event.title);
      if (noteUpdateData.data != null) {
        emit(NoteUpdateDetailSuccessActionSate());
        emit(NotesUpdateNotifyUpdateActionState());
      }
    } on ApiException catch (e) {
      emit(NoteUpdateDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteUpdateDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteClickButtonUpdateTextEvent(
      NoteClickButtonUpdateTextEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteUpdateTextDetailLoadingState());
    try {
      var noteUpdateTextData = await noteRepo.updateTextNote(event.noteId, event.content);
      if (noteUpdateTextData.data != null) {
        emit(NoteUpdateTextDetailSuccessActionSate());
      }
    } on ApiException catch (e) {
      emit(NoteUpdateTextDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteUpdateTextDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteClickButtonCreateAudioEvent(
      NoteClickButtonCreateAudioEvent event, Emitter<NoteDetailState> emit) async {
    emit(NotesCreateAudioDetailLoadingState());
    try {
      var createAudioData = await noteRepo.createAudiNote(event.id, event.audioFile);
      if (createAudioData.data != null) {
        emit(NotesCreateAudioDetailSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(NotesCreateAudioDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(NotesCreateAudioDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteClickButtonDeleteAudioEvent(
      NoteClickButtonDeleteAudioEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteDeleteAudioLoadingState());
    try {
      var createAudioData = await noteRepo.deleteAudio(event.audioId);
      if (createAudioData.data != null) {
        emit(NoteDeleteAudioSuccessState());
      }
    } on ApiException catch (e) {
      emit(NoteDeleteAudioErrorState(message: e.message));
    } catch (e) {
      emit(NoteDeleteAudioErrorState(message: 'An unexpected error occurred'));
    }
  }
}
