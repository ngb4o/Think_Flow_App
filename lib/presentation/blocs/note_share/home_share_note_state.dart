part of 'home_share_note_bloc.dart';

@immutable
sealed class HomeShareNoteState {}

final class HomeShareNoteInitial extends HomeShareNoteState {}

abstract class HomeShareNoteActionState extends HomeShareNoteState {}

class HomeShareNoteMemberLoadingState extends HomeShareNoteState {}

class HomeShareNoteMemberSuccessState extends HomeShareNoteState {
  final NoteMemberModel? members;
  HomeShareNoteMemberSuccessState({this.members});
}

class HomeShareNoteMemberErrorState extends HomeShareNoteState {}

class HomeShareNoteMemberErrorActionState extends HomeShareNoteActionState {
  final String message;
  HomeShareNoteMemberErrorActionState({required this.message});
}

class HomeShareNoteShareLinkNoteToEmailLoadingState extends HomeShareNoteState {}

class HomeShareNoteShareLinkNoteToEmailSuccessState extends HomeShareNoteState {}

class HomeShareNoteShareLinkNoteToEmailSuccessActionState extends HomeShareNoteActionState {}

class HomeShareNoteShareLinkNoteToEmailErrorActionState extends HomeShareNoteActionState {
  final String message;
  HomeShareNoteShareLinkNoteToEmailErrorActionState({required this.message});
}

class HomeShareNoteCreateLinkNoteLoadingState extends HomeShareNoteState {}

class HomeShareNoteCreateLinkNoteSuccessState extends HomeShareNoteState {
  final String? link;
  HomeShareNoteCreateLinkNoteSuccessState({this.link});
}

class HomeShareNoteCreateLinkNoteSuccessActionState extends HomeShareNoteActionState {
  final String? link;
  HomeShareNoteCreateLinkNoteSuccessActionState({required this.link});
}

class HomeShareNoteCreateLinkNoteErrorActionState extends HomeShareNoteActionState {
  final String message;
  HomeShareNoteCreateLinkNoteErrorActionState({required this.message});
}

class HomeShareNoteUpdatePermissionMemberLoadingState extends HomeShareNoteState {}

class HomeShareNoteUpdatePermissionMemberSuccessActionState extends HomeShareNoteActionState {}

class HomeShareNoteUpdatePermissionMemberErrorState extends HomeShareNoteActionState {
  final String message;
  HomeShareNoteUpdatePermissionMemberErrorState({required this.message});
}


