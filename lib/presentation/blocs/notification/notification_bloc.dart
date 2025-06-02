import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/models/notification_model.dart';
import 'package:think_flow/data/repositories/noti_repo.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepo notificationRepo;
  String? nextCursor;
  bool hasMoreData = true;
  List<Datum> notifications = [];
  bool isLoadingMore = false;

  NotificationBloc(this.notificationRepo) : super(NotificationInitial()) {
    on<NotificationInitialFetchDataEvent>(notificationInitialFetchDataEvent);
    on<NotificationLoadMoreDataEvent>(notificationLoadMoreDataEvent);
    on<NotificationAcceptShareNoteEvent>(notificationAcceptShareNoteEvent);
  }

  FutureOr<void> notificationInitialFetchDataEvent(
      NotificationInitialFetchDataEvent event, Emitter<NotificationState> emit) async {
    emit(NotificationLoadingState());
    try {
      final notificationData = await notificationRepo.getListNotification(null);
      nextCursor = notificationData.paging?.nextCursor;
      hasMoreData = nextCursor != null;
      notifications = notificationData.data ?? [];
      emit(NotificationSuccessState(notificationModel: notificationData));
    } on ApiException catch (e) {
      emit(NotificationErrorState());
      emit(NotificationErrorActionState(message: e.message));
    } catch (e) {
      emit(NotificationErrorState());
      emit(NotificationErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> notificationLoadMoreDataEvent(
      NotificationLoadMoreDataEvent event, Emitter<NotificationState> emit) async {
    if (!hasMoreData || nextCursor == null || nextCursor!.isEmpty || isLoadingMore) return;

    isLoadingMore = true;
    try {
      final notificationData = await notificationRepo.getListNotification(nextCursor);
      nextCursor = notificationData.paging?.nextCursor;
      hasMoreData = nextCursor != null && nextCursor!.isNotEmpty;
      notifications.addAll(notificationData.data ?? []);
      emit(NotificationSuccessState(
        notificationModel: NotificationModel(
          data: notifications,
          paging: notificationData.paging,
          extra: notificationData.extra,
        ),
      ));
    } on ApiException catch (e) {
      emit(NotificationErrorActionState(message: e.message));
    } catch (e) {
      emit(NotificationErrorActionState(message: 'An unexpected error occurred'));
    } finally {
      isLoadingMore = false;
    }
  }

  FutureOr<void> notificationAcceptShareNoteEvent(
      NotificationAcceptShareNoteEvent event, Emitter<NotificationState> emit) async {
    try {
      final acceptData = await notificationRepo.acceptShareNote(event.tokenId);
      if (acceptData.data != null) {
        emit(NotificationAcceptShareNoteSuccessActionState());
      }
    } on ApiException catch (e) {
      emit(NotificationAcceptShareNoteErrorActionState(message: e.message));
    } catch (e) {
      emit(NotificationAcceptShareNoteErrorActionState(message: 'An unexpected error occurred'));
    }
  }
}
