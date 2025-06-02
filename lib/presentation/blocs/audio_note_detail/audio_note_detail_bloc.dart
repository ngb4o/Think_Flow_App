import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/list_audio_note_model.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

part 'audio_note_detail_event.dart';
part 'audio_note_detail_state.dart';

class AudioNoteDetailBloc extends Bloc<AudioNoteDetailEvent, AudioNoteDetailState> {
  final NoteRepo noteRepo;

  AudioNoteDetailBloc(this.noteRepo) : super(AudioNoteDetailInitial()) {
    on<AudioNoteDetailInitialFetchDataEvent>(audioNoteDetailInitialFetchDataEvent);
    on<AudioNoteDetailCreateEvent>(audioNoteDetailCreateEvent);
    on<AudioNoteDetailDeleteEvent>(audioNoteDetailDeleteEvent);
    on<AudioNoteDetailNavigationToTranscriptEvent>(audioNoteDetailNavigationToTranscriptEvent);
    on<AudioNoteDetailNavigationToSummaryEvent>(audioNoteDetailNavigationToSummaryEvent);
  }

  FutureOr<void> audioNoteDetailInitialFetchDataEvent(
      AudioNoteDetailInitialFetchDataEvent event, Emitter<AudioNoteDetailState> emit) async {
    emit(AudioNoteDetailLoadingState());
    try {
      var noteAudioDetailData = await noteRepo.getListAudioNote(event.noteId);
      if (noteAudioDetailData.data != null) {
        emit(AudioNoteDetailSuccessState(listAudioNoteModel: noteAudioDetailData));
      }
    } on ApiException catch (e) {
      emit(AudioNoteDetailErrorState(message: e.message));
      emit(AudioNoteDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(AudioNoteDetailErrorState(message: 'An unexpected error occurred'));
      emit(AudioNoteDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> audioNoteDetailCreateEvent(
      AudioNoteDetailCreateEvent event, Emitter<AudioNoteDetailState> emit) async {
    emit(AudioNoteDetailCreateLoadingState());
    try {
      var createAudioData = await noteRepo.createAudiNote(event.id, event.audioFile);
      if (createAudioData.data != null) {
        emit(AudioNoteDetailCreateSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(AudioNoteDetailCreateErrorActionState(message: e.message));
    } catch (e) {
      emit(AudioNoteDetailCreateErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> audioNoteDetailDeleteEvent(
      AudioNoteDetailDeleteEvent event, Emitter<AudioNoteDetailState> emit) async {
    emit(AudioNoteDetailDeleteLoadingState());
    try {
      var deleteAudioData = await noteRepo.deleteAudio(event.audioId);
      if (deleteAudioData.data != null) {
        emit(AudioNoteDetailDeleteSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(AudioNoteDetailDeleteErrorActionState(message: e.message));
    } catch (e) {
      emit(AudioNoteDetailDeleteErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> audioNoteDetailNavigationToTranscriptEvent(
      AudioNoteDetailNavigationToTranscriptEvent event, Emitter<AudioNoteDetailState> emit) async {
    emit(AudioNoteDetailNavigationToTranscriptActionState(audioId: event.audioId, permission: event.permission));
  }

  FutureOr<void> audioNoteDetailNavigationToSummaryEvent(
      AudioNoteDetailNavigationToSummaryEvent event, Emitter<AudioNoteDetailState> emit) async {
    emit(AudioNoteDetailNavigationToSummaryActionState(audioId: event.audioId, permission: event.permission));
  }
} 