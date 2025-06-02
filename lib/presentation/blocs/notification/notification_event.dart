part of 'notification_bloc.dart';

@immutable
sealed class NotificationEvent {}

class NotificationInitialFetchDataEvent extends NotificationEvent {}

class NotificationLoadMoreDataEvent extends NotificationEvent {}

class NotificationAcceptShareNoteEvent extends NotificationEvent {
  final String tokenId;

  NotificationAcceptShareNoteEvent({required this.tokenId});
}
