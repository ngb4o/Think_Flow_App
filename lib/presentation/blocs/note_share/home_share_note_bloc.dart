import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/note_member_model.dart';
import 'package:think_flow/data/repositories/note_repo.dart';

part 'home_share_note_event.dart';
part 'home_share_note_state.dart';

class HomeShareNoteBloc extends Bloc<HomeShareNoteEvent, HomeShareNoteState> {
  final NoteRepo noteRepo;

  HomeShareNoteBloc(this.noteRepo) : super(HomeShareNoteInitial()) {
    on<HomeShareNoteInitialFetchDataMemberEvent>(_onInitialFetchDataMember);
    on<HomeShareNoteClickButtonShareLinkNoteToEmailEvent>(_onShareLinkNoteToEmail);
    on<HomeShareNoteClickButtonCreateLinkNoteEvent>(_onCreateLinkNote);
    on<HomeShareNoteUpdatePermissionMemberEvent>(homeShareNoteUpdatePermissionMemberEvent);
  }

  FutureOr<void> _onInitialFetchDataMember(
      HomeShareNoteInitialFetchDataMemberEvent event, Emitter<HomeShareNoteState> emit) async {
    emit(HomeShareNoteMemberLoadingState());
    try {
      var noteDetailMemberData = await noteRepo.getNoteMember(event.noteId);
      if (noteDetailMemberData.data != null) {
        emit(HomeShareNoteMemberSuccessState(members: noteDetailMemberData));
      }
    } on ApiException catch (e) {
      emit(HomeShareNoteMemberErrorState());
      emit(HomeShareNoteMemberErrorActionState(message: e.message));
    } catch (e) {
      emit(HomeShareNoteMemberErrorState());
      emit(HomeShareNoteMemberErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> _onShareLinkNoteToEmail(
      HomeShareNoteClickButtonShareLinkNoteToEmailEvent event, Emitter<HomeShareNoteState> emit) async {
    emit(HomeShareNoteShareLinkNoteToEmailLoadingState());
    try {
      final shareLinkNoteToEmailData = await noteRepo.shareLinkNoteToEmail(event.email, event.permission, event.noteId);
      if(shareLinkNoteToEmailData.data != null) {
        emit(HomeShareNoteShareLinkNoteToEmailSuccessState());
        emit(HomeShareNoteShareLinkNoteToEmailSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(HomeShareNoteShareLinkNoteToEmailErrorActionState(message: e.message));
    } catch (e) {
      emit(HomeShareNoteShareLinkNoteToEmailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> _onCreateLinkNote(
      HomeShareNoteClickButtonCreateLinkNoteEvent event, Emitter<HomeShareNoteState> emit) async {
    emit(HomeShareNoteCreateLinkNoteLoadingState());
    try {
      final createLinkNoteData = await noteRepo.createLinkNote(event.permission, event.noteId);
      if(createLinkNoteData.data?.url != null) {
        emit(HomeShareNoteCreateLinkNoteSuccessState(link: createLinkNoteData.data?.url));
        emit(HomeShareNoteCreateLinkNoteSuccessActionState(link: createLinkNoteData.data?.url));
      }
    } on ApiException catch (e) {
      emit(HomeShareNoteCreateLinkNoteErrorActionState(message: e.message));
    } catch (e) {
      emit(HomeShareNoteCreateLinkNoteErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> homeShareNoteUpdatePermissionMemberEvent(
      HomeShareNoteUpdatePermissionMemberEvent event, Emitter<HomeShareNoteState> emit) async {
    emit(HomeShareNoteUpdatePermissionMemberLoadingState());
    try {
      final createLinkNoteData = await noteRepo.updatePermissionMember(event.noteId, event.userId, event.permission);
      if(createLinkNoteData.data?.url != null) {
        emit(HomeShareNoteUpdatePermissionMemberSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(HomeShareNoteUpdatePermissionMemberErrorState(message: e.message));
    } catch (e) {
      emit(HomeShareNoteUpdatePermissionMemberErrorState(message: 'An unexpected error occurred'));
    }
  }
}
