import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/repositories/auth_repo.dart';
import 'package:think_flow/data/repositories/user_repo.dart';

import '../../../../data/data_sources/remote/api_exception.dart';
import '../../../../data/models/user_model.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final AuthRepo authRepo;
  final UserRepo userRepo;
  SettingsBloc(this.authRepo, this.userRepo) : super(SettingsInitial()) {
    on<SettingInitialFetchDataEvent>(settingInitialFetchDataEvent);
    on<SettingClickButtonLogoutEvent>(settingLogoutButtonClickEvent);
    on<SettingClickButtonNavigationToProfilePageEvent>(
        settingClickButtonNavigationToProfilePageEvent);
  }

  FutureOr<void> settingInitialFetchDataEvent(
      SettingInitialFetchDataEvent event, Emitter<SettingsState> emit) async {
    emit(SettingLoadingState());
    try {
      var userData = await userRepo.getUserProfile();
      if (userData.data != null) {
        emit(SettingSuccessState(userModel: userData));
      }
    } on ApiException catch (e) {
      emit(SettingErrorState(message: e.message));
      emit(SettingErrorActionState(message: e.message));
    } catch (e) {
      emit(SettingErrorState(message: 'An unexpected error occurred'));
      emit(SettingErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> settingLogoutButtonClickEvent(
      SettingClickButtonLogoutEvent event, Emitter<SettingsState> emit) async {
    emit(SettingLogoutLoadingState());
    try {
      var logoutData = await authRepo.logout();
      if (logoutData.data != null) {
        emit(SettingLogoutSuccessState());
        emit(SettingLogoutSuccessActionState());
      } else {
        emit(SettingLogoutErrorState());
        emit(SettingLogoutErrorActionState(
            message: 'Signup failed. Please try again.'));
      }
    } on ApiException catch (e) {
      emit(SettingLogoutErrorState());
      emit(SettingLogoutErrorActionState(message: e.message));
    } catch (e) {
      emit(SettingLogoutErrorState());
      emit(SettingLogoutErrorActionState(
          message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> settingClickButtonNavigationToProfilePageEvent(
      SettingClickButtonNavigationToProfilePageEvent event,
      Emitter<SettingsState> emit) async {
    if (state is SettingSuccessState) {
      final currentState = state as SettingSuccessState;
      emit(SettingNavigationToProfilePageActionState(
          userModel: currentState.userModel));
    }
  }
}
