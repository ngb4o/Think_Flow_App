part of 'note_share_bloc.dart';

@immutable
sealed class NoteShareEvent {}

class NoteShareInitialFetchDataEvent extends NoteShareEvent {}

