part of 'notification_bloc.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

abstract class NotificationActionState extends NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationSuccessState extends NotificationState {
  final NotificationModel notificationModel;

  NotificationSuccessState({required this.notificationModel});
}

class NotificationErrorState extends NotificationState {}

class NotificationErrorActionState extends NotificationActionState {
  final String message;

  NotificationErrorActionState({required this.message});
}

class NotificationLoadMoreLoadingState extends NotificationState {}

class NotificationAcceptShareNoteLoadingState extends NotificationState {}

class NotificationAcceptShareNoteSuccessActionState extends NotificationActionState {}

class NotificationAcceptShareNoteErrorState extends NotificationState {}

class NotificationAcceptShareNoteErrorActionState extends NotificationActionState {
  final String message;

  NotificationAcceptShareNoteErrorActionState({required this.message});
}
