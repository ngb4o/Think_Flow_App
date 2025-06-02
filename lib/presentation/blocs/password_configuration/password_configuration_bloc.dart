import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/repositories/auth_repo.dart';

import '../../../data/data_sources/remote/api_exception.dart';

part 'password_configuration_event.dart';
part 'password_configuration_state.dart';

class PasswordConfigurationBloc extends Bloc<PasswordConfigurationEvent, PasswordConfigurationState> {
  final AuthRepo authRepo;
  PasswordConfigurationBloc(this.authRepo) : super(PasswordConfigurationInitial()) {
    on<PasswordConfigurationClickButtonForgotPasswordEvent>(passwordConfigurationClickButtonForgotPasswordEvent);

    on<PasswordConfigurationClickButtonResetPasswordEvent>(passwordConfigurationClickButtonResetPasswordEvent);
  }

  FutureOr<void> passwordConfigurationClickButtonForgotPasswordEvent(
      PasswordConfigurationClickButtonForgotPasswordEvent event, Emitter<PasswordConfigurationState> emit) async {
    emit(PasswordConfigurationForgotPasswordLoadingState());
    try {
      var forgotPasswordData = await authRepo.forgotPassword(event.email);
      if (forgotPasswordData.data != null) {
        emit(PasswordConfigurationForgotPasswordSuccessState());
      }
    } on ApiException catch (e) {
      emit(PasswordConfigurationForgotPasswordErrorState());
      emit(PasswordConfigurationForgotPasswordErrorActionState(message: e.message));
    } catch (e) {
      emit(PasswordConfigurationForgotPasswordErrorState());
      emit(PasswordConfigurationForgotPasswordErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> passwordConfigurationClickButtonResetPasswordEvent(
      PasswordConfigurationClickButtonResetPasswordEvent event, Emitter<PasswordConfigurationState> emit) async {
    emit(PasswordConfigurationResetPasswordLoadingState());
    try {
      var resetPasswordData = await authRepo.resetPassword(event.email, event.otp, event.newPassword);
      if (resetPasswordData.data != null) {
        emit(PasswordConfigurationResetPasswordSuccessState());
      }
    } on ApiException catch (e) {
      emit(PasswordConfigurationResetPasswordErrorState());
      emit(PasswordConfigurationResetPasswordErrorActionState(message: e.message));
    } catch (e) {
      emit(PasswordConfigurationResetPasswordErrorState());
      emit(PasswordConfigurationResetPasswordErrorActionState(message: 'An unexpected error occurred'));
    }
  }
}
