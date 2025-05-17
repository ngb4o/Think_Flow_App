import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/audio_note_model.dart';
import 'package:think_flow/data/models/note_model.dart';
import 'package:think_flow/data/models/text_note_model.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

import '../../../../data/models/note_member_model.dart';

part 'note_detail_event.dart';

part 'note_detail_state.dart';

class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  final NoteRepo noteRepo;

  NoteDetailBloc(this.noteRepo) : super(NoteDetailInitial()) {
    // ==================== TEXT NOTE FEATURE ====================
    on<NoteTextDetailInitialFetchDataEvent>(noteTextDetailInitialFetchDataEvent);

    // ==================== AUDIO NOTE FEATURE ====================
    on<NoteAudioDetailInitialFetchDataEvent>(noteAudioDetailInitialFetchDataEvent);

    // ==================== NOTE MEMBER FEATURE ====================
    on<NoteDetailInitialFetchDataMemberEvent>(noteDetailInitialFetchDataMemberEvent);

    // ==================== NOTE UPDATE FEATURE ====================
    on<NoteClickButtonUpdateEvent>(noteClickButtonUpdateEvent);

    // ==================== TEXT NOTE UPDATE FEATURE ====================
    on<NoteClickButtonUpdateTextEvent>(noteClickButtonUpdateTextEvent);

    // ==================== AUDIO NOTE CREATE/DELETE FEATURE ====================
    on<NoteClickButtonCreateAudioEvent>(noteClickButtonCreateAudioEvent);
    on<NoteClickButtonDeleteAudioEvent>(noteClickButtonDeleteAudioEvent);

    // ==================== SUMMARY NOTE FEATURE ====================
    on<NoteInitialFetchDataSummaryNoteEvent>(noteInitialFetchDataSummaryNoteEvent);
    on<NoteClickButtonUpdateSummaryNoteEvent>(noteClickButtonUpdateSummaryNoteEvent);
    on<NoteDetailCreateSummaryNoteEvent>(noteDetailCreateSummaryNoteEvent);

    // ==================== MINDMAP NOTE FEATURE ====================
    on<NoteInitialFetchDataMindmapEvent>(noteInitialFetchDataMindmapEvent);
    on<NoteDetailCreateMindmapEvent>(noteDetailCreateMindmapEvent);
    on<NoteDetailUpdateMindmapEvent>(noteDetailUpdateMindmapEvent);

    on<NoteDetaiClickButtonNavigationToSummaryTextEvent>(noteDetaiClickButtonNavigationToSummaryTextEvent);
  }

  // ==================== TEXT NOTE FEATURE ====================
  FutureOr<void> noteTextDetailInitialFetchDataEvent(
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

  // ==================== AUDIO NOTE FEATURE ====================
  FutureOr<void> noteAudioDetailInitialFetchDataEvent(
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

  // ==================== NOTE MEMBER FEATURE ====================
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

  // ==================== NOTE UPDATE FEATURE ====================
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

  // ==================== TEXT NOTE UPDATE FEATURE ====================
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

  // ==================== AUDIO NOTE CREATE FEATURE ====================
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

  // ==================== AUDIO NOTE DELETE FEATURE ====================
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

  // ==================== SUMMARY NOTE FEATURE ====================
  FutureOr<void> noteInitialFetchDataSummaryNoteEvent(
      NoteInitialFetchDataSummaryNoteEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteSummaryLoadingState());
    try {
      var noteData = await noteRepo.getNote(event.noteId);
      if (noteData.data?.summary == null) {
        // If summary is empty, create a new one
        add(NoteDetailCreateSummaryNoteEvent(noteId: event.noteId));
      } else {
        emit(NoteSummarySuccessState(noteModel: noteData));
      }
    } on ApiException catch (e) {
      emit(NoteSummaryErrorState());
      emit(NoteSummaryErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteSummaryErrorState());
      emit(NoteSummaryErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteDetailCreateSummaryNoteEvent(
      NoteDetailCreateSummaryNoteEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteDetailCreateSummaryNoteLoadingState());
    try {
      var createSummaryData = await noteRepo.createSummaryNote(event.noteId);
      if (createSummaryData.data != null) {
        emit(NoteDetailCreateSummaryNoteSuccessActionState());

        add(NoteInitialFetchDataSummaryNoteEvent(noteId: event.noteId));
      }
    } on ApiException catch (e) {
      emit(NoteDetailCreateSummaryNoteErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteDetailCreateSummaryNoteErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteClickButtonUpdateSummaryNoteEvent(
      NoteClickButtonUpdateSummaryNoteEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteUpdateSummaryDetailLoadingState());
    try {
      var noteUpdateSummaryData = await noteRepo.updateSummaryNote(event.noteId, event.summaryText);
      if (noteUpdateSummaryData.data != null) {
        emit(NoteUpdateSummaryDetailSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(NoteUpdateSummaryDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteUpdateSummaryDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  // ==================== MINDMAP NOTE FEATURE ====================
  FutureOr<void> noteInitialFetchDataMindmapEvent(
      NoteInitialFetchDataMindmapEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteMindmapLoadingState());
    try {
      var noteData = await noteRepo.getNote(event.noteId);
      if (noteData.data?.mindmap == null) {
        // If mindmap is empty, create a new one
        add(NoteDetailCreateMindmapEvent(noteId: event.noteId));
      } else {
        emit(NoteMindmapSuccessState(noteModel: noteData));
      }
    } on ApiException catch (e) {
      emit(NoteMindmapErrorState());
      emit(NoteMindmapErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteMindmapErrorState());
      emit(NoteMindmapErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteDetailCreateMindmapEvent(
      NoteDetailCreateMindmapEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteCreateMindmapLoadingState());
    try {
      var createMindmapData = await noteRepo.createMindmapNote(event.noteId);
      if (createMindmapData.data != null) {
        emit(NoteCreateMindmapSuccessActionState());
        // Reload the mindmap data after creating
        add(NoteInitialFetchDataMindmapEvent(noteId: event.noteId));
      }
    } on ApiException catch (e) {
      emit(NoteCreateMindmapErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteCreateMindmapErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteDetailUpdateMindmapEvent(
      NoteDetailUpdateMindmapEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteUpdateMindmapLoadingState());
    try {
      var updateMindmapData = await noteRepo.updateMindmapNote(event.mindmapId, event.mindmapData);
      if (updateMindmapData.data != null) {
        emit(NoteUpdateMindmapSuccessActionState());
        // Reload the mindmap data after updating
        add(NoteInitialFetchDataMindmapEvent(noteId: event.mindmapId));
      }
    } on ApiException catch (e) {
      emit(NoteUpdateMindmapErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteUpdateMindmapErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> noteDetaiClickButtonNavigationToSummaryTextEvent(
      NoteDetaiClickButtonNavigationToSummaryTextEvent event, Emitter<NoteDetailState> emit) {
    emit(NoteDetailNavigationToSummaryTextPageActionState());
  }
}
