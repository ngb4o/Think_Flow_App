import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:think_flow/data/data_sources/remote/api_exception.dart';
import 'package:think_flow/data/repositories/auth_repo.dart';

import '../../../../services/firebase_messaging_service.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepo authRepo;

  LoginBloc(this.authRepo) : super(LoginInitial()) {
    on<LoginButtonClickEvent>(loginButtonClickEvent);
    on<LoginWithGoogleEvent>(loginWithGoogleEvent);
    on<LoginClickButtonNavigationToSignupPageEvent>(loginClickButtonNavigateToSignupPageEvent);
    on<LoginClickButtonNavigationToForgetPasswordPageEvent>(loginClickButtonNavigateToForgetPasswordPageEvent);
  }

  FutureOr<void> loginButtonClickEvent(LoginButtonClickEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      var loginData = await authRepo.loginWithEmailAndPassword(event.email, event.password);
      if (loginData.data != null) {
        emit(LoginSuccessState());
        emit(LoginSuccessActionState());
        await FirebaseMessagingService.instance().registerPendingToken();
      }
    } on ApiException catch (e) {
      if (e.code == 403) {
        await authRepo.resendVerifyEmail(event.email);
        emit(LoginNavigationToVerifyEmailPage(email: event.email));
      }
      emit(LoginErrorState());
      emit(LoginErrorActionState(message: e.message));
    } catch (e) {
      emit(LoginErrorState());
      emit(LoginErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> loginWithGoogleEvent(LoginWithGoogleEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoadingState());
    try {
      var loginData = await authRepo.loginWithGoogle();
      if (loginData.data != null) {
        emit(LoginSuccessState());
        emit(LoginSuccessActionState());
        await FirebaseMessagingService.instance().registerPendingToken();
      }
    } on ApiException catch (e) {
      emit(LoginErrorState());
      emit(LoginErrorActionState(message: e.message));
    } catch (e) {
      emit(LoginErrorState());
      emit(LoginErrorActionState(message: 'An unexpected error occurred during Google sign in'));
    }
  }

  FutureOr<void> loginClickButtonNavigateToSignupPageEvent(
      LoginClickButtonNavigationToSignupPageEvent event, Emitter<LoginState> emit) async {
    emit(LoginNavigationToSignupPageActionState());
  }

  FutureOr<void> loginClickButtonNavigateToForgetPasswordPageEvent(
      LoginClickButtonNavigationToForgetPasswordPageEvent event, Emitter<LoginState> emit) async {
    emit(LoginNavigationToForgetPasswordPageActionState());
  }
}
