import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../data/data_sources/remote/api_exception.dart';
import '../../../../data/models/audio_note_model.dart';
import '../../../../data/repositories/note_repo.dart';

part 'audio_transcript_event.dart';
part 'audio_transcript_state.dart';

class AudioTranscriptBloc extends Bloc<AudioTranscriptEvent, AudioTranscriptState> {
  final NoteRepo noteRepo;
  AudioTranscriptBloc(this.noteRepo) : super(AudioTranscriptInitial()) {
    on<AudioTranscriptInitialFetchDataAudioEvent>(audioTranscriptInitialFetchDataAudioEvent);

    on<AudioTranscriptClickButtonUpdateSummaryTextEvent>(audioTranscriptClickButtonUpdateSummaryTextEvent);
  }

  FutureOr<void> audioTranscriptInitialFetchDataAudioEvent(
      AudioTranscriptInitialFetchDataAudioEvent event, Emitter<AudioTranscriptState> emit) async {
    emit(AudioTranscriptLoadingState());
    try {
      var noteAudioDetailData = await noteRepo.getAudio(event.audioId);
      if (noteAudioDetailData.data?.transcript?.content != null) {
        emit(AudioTranscriptSuccessState(audioNoteModel: noteAudioDetailData));
      } else {
        emit(AudioTranscriptSuccessState(audioNoteModel: noteAudioDetailData));
      }
    } on ApiException catch (e) {
      emit(AudioTranscriptErrorState());
      emit(AudioTranscriptErrorActionState(message: e.message));
    } catch (e) {
      emit(AudioTranscriptErrorState());
      emit(AudioTranscriptErrorActionState(message: 'An unexpected error occurred: $e'));
    }
  }

  FutureOr<void> audioTranscriptClickButtonUpdateSummaryTextEvent(
      AudioTranscriptClickButtonUpdateSummaryTextEvent event, Emitter<AudioTranscriptState> emit) async {
    emit(AudioTranscriptUpdateTextLoadingState());
    try {
      var noteUpdateSummaryData = await noteRepo.updateTranscriptNote(event.transcriptId, event.content);
      if (noteUpdateSummaryData.data != null) {
        emit(AudioTranscriptUpdateTextSuccessActionState());
        add(AudioTranscriptInitialFetchDataAudioEvent(audioId: event.audioId!));
      }
    } on ApiException catch (e) {
      emit(AudioTranscriptUpdateTextErrorActionState(message: e.message));
    } catch (e) {
      emit(AudioTranscriptUpdateTextErrorActionState(message: 'An unexpected error occurred'));
    }
  }
}
