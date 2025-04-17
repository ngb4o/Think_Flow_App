import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/text_note_model.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

part 'note_detail_event.dart';

part 'note_detail_state.dart';

class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  final NoteRepo noteRepo;

  NoteDetailBloc(this.noteRepo) : super(NoteDetailInitial()) {
    on<NoteDetailInitialFetchDataEvent>(noteDetailInitialFetchDataEvent);
  }

  FutureOr<void> noteDetailInitialFetchDataEvent(
      NoteDetailInitialFetchDataEvent event, Emitter<NoteDetailState> emit) async {
    emit(NoteDetailLoadingState());
    try {
      var noteDetailData = await noteRepo.getTextNote(event.noteId);
      if (noteDetailData.data != null) {
        emit(
          NoteDetailSuccessState(
            textNoteModel: TextNoteModel(data: noteDetailData.data),
          ),
        );
      }
    } on ApiException catch (e) {
      emit(NoteDetailErrorState());
      emit(NoteDetailErrorActionState(message: e.message));
    } catch (e) {
      emit(NoteDetailErrorState());
      emit(NoteDetailErrorActionState(message: 'An unexpected error occurred'));
    }
  }
}
