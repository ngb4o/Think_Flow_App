import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

import '../../../../data/data_sources/remote/api_exception.dart';
import '../../../../data/models/audio_note_model.dart';

part 'audio_summary_event.dart';
part 'audio_summary_state.dart';

class AudioSummaryBloc extends Bloc<AudioSummaryEvent, AudioSummaryState> {
  final NoteRepo noteRepo;
  AudioSummaryBloc(this.noteRepo) : super(AudioSummaryInitial()) {
    on<AudioSummaryInitialFetchDataAudioEvent>(audioSummaryInitialFetchDataAudioEvent);

    on<AudioSummaryCreateSummaryTextEvent>(audioSummaryCreateSummaryTextEvent);

    on<AudioSummaryClickButtonUpdateSummaryTextEvent>(audioSummaryClickButtonUpdateSummaryTextEvent);
  }

  FutureOr<void> audioSummaryInitialFetchDataAudioEvent(
      AudioSummaryInitialFetchDataAudioEvent event, Emitter<AudioSummaryState> emit) async {
    emit(AudioSummaryLoadingState());
    try {
      var noteAudioDetailData = await noteRepo.getAudio(event.audioId);
      if (noteAudioDetailData.data?.summary?.summaryText != null) {
        emit(AudioSummarySuccessState(audioNoteModel: noteAudioDetailData));
      } else {
        if (event.permission != 'read') {
          add(AudioSummaryCreateSummaryTextEvent(
            audioId: event.audioId,
            permission: event.permission,
          ));
        } else {
          emit(AudioSummarySuccessState(audioNoteModel: noteAudioDetailData));
        }
      }
    } on ApiException catch (e) {
      emit(AudioSummaryErrorState());
      emit(AudioSummaryErrorActionState(message: e.message));
    } catch (e) {
      emit(AudioSummaryErrorState());
      emit(AudioSummaryErrorActionState(message: 'An unexpected error occurred: $e'));
    }
  }

  FutureOr<void> audioSummaryCreateSummaryTextEvent(
      AudioSummaryCreateSummaryTextEvent event, Emitter<AudioSummaryState> emit) async {
    if (event.permission == 'read') {
      emit(AudioSummaryCreateTextErrorState(
          message: 'Access denied. Please contact the owner to update permissions.'));
      return;
    }

    emit(AudioSummaryCreateSummaryTextLoadingState());
    try {
      var createAudioSummaryTextData = await noteRepo.createAudioSummaryText(event.audioId);
      if (createAudioSummaryTextData.data != null) {
        emit(AudioSummaryCreateTextSuccessState());
        add(AudioSummaryInitialFetchDataAudioEvent(audioId: event.audioId, permission: event.permission));
      }
    } on ApiException catch (e) {
      emit(AudioSummaryCreateTextErrorState(message: e.message));
    } catch (e) {
      emit(AudioSummaryCreateTextErrorState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> audioSummaryClickButtonUpdateSummaryTextEvent(
      AudioSummaryClickButtonUpdateSummaryTextEvent event, Emitter<AudioSummaryState> emit) async {
    if (event.permission == 'read') {
      emit(TextSummaryUpdateSummaryTextErrorActionState(
          message: 'Access denied. Please contact the owner to update permissions.'));
      return;
    }

    emit(AudioSummaryUpdateTextSummaryLoadingState());
    try {
      var noteUpdateSummaryData = await noteRepo.updateSummaryNote(event.textId, event.summaryText);
      if (noteUpdateSummaryData.data != null) {
        emit(AudioSummaryUpdateSummaryTextSuccessActionState());
        if (event.audioId != null) {
          add(AudioSummaryInitialFetchDataAudioEvent(audioId: event.audioId!, permission: event.permission));
        }
      }
    } on ApiException catch (e) {
      emit(TextSummaryUpdateSummaryTextErrorActionState(message: e.message));
    } catch (e) {
      emit(TextSummaryUpdateSummaryTextErrorActionState(message: 'An unexpected error occurred'));
    }
  }
}
