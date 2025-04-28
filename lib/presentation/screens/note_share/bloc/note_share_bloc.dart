import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

import '../../../../data/models/note_model.dart';

part 'note_share_event.dart';

part 'note_share_state.dart';

class NoteShareBloc extends Bloc<NoteShareEvent, NoteShareState> {
  final NoteRepo noteRepo;
  String? nextCursor;
  bool hasMoreData = true;
  List<Note> notes = [];
  bool isLoadingMore = false;

  NoteShareBloc(this.noteRepo) : super(NoteShareInitial()) {
    on<NoteShareInitialFetchDataEvent>(noteShareInitialFetchDataEvent);
  }

  FutureOr<void> noteShareInitialFetchDataEvent(
      NoteShareInitialFetchDataEvent event, Emitter<NoteShareState> emit) async {
    emit(NoteShareLoadingState());
    try {
      final noteShareWithMeData = await noteRepo.getNoteShareWithMe();
      nextCursor = noteShareWithMeData.paging.nextCursor;
      hasMoreData = nextCursor != null;
      notes = noteShareWithMeData.data;
      emit(NoteShareSuccessState(noteModel: noteShareWithMeData));
    } on ApiException catch (e) {
      emit(NoteShareErrorState(message: e.message));
    } catch (e) {
      emit(NoteShareErrorState(message: 'An unexpected error occurred'));

    }
  }
}
