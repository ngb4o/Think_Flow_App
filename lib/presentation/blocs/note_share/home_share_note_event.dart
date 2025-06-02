part of 'home_share_note_bloc.dart';

@immutable
sealed class HomeShareNoteEvent {}

class HomeShareNoteInitialFetchDataMemberEvent extends HomeShareNoteEvent {
  final String noteId;

  HomeShareNoteInitialFetchDataMemberEvent({required this.noteId});
}

class HomeShareNoteClickButtonShareLinkNoteToEmailEvent extends HomeShareNoteEvent {
  final String noteId;
  final String email;
  final String permission;

  HomeShareNoteClickButtonShareLinkNoteToEmailEvent({
    required this.noteId,
    required this.email,
    required this.permission,
  });
}

class HomeShareNoteClickButtonCreateLinkNoteEvent extends HomeShareNoteEvent {
  final String noteId;
  final String permission;

  HomeShareNoteClickButtonCreateLinkNoteEvent({
    required this.noteId,
    required this.permission,
  });
}

class HomeShareNoteUpdatePermissionMemberEvent extends HomeShareNoteEvent {
  final String noteId;
  final String userId;
  final String permission;

  HomeShareNoteUpdatePermissionMemberEvent({
    required this.noteId,
    required this.userId,
    required this.permission,
  });
}
