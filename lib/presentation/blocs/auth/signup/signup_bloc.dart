import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:think_flow/data/repositories/auth_repo.dart';

import '../../../../data/data_sources/remote/api_exception.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthRepo authRepo;

  SignupBloc(this.authRepo) : super(SignupInitial()) {
    on<SignupButtonClickEvent>(signupButtonClickEvent);
  }

  FutureOr<void> signupButtonClickEvent(SignupButtonClickEvent event, Emitter<SignupState> emit) async {
    emit(SignupLoadingState());
    emit(SignupLoadingActionState());
    try {
      var signupData = await authRepo.signupWithEmailAndPassword(
        event.firstName,
        event.lastName,
        event.email,
        event.password,
      );
      if (signupData) {
        emit(SignupSuccessState());
        emit(SignupNavigationToVerifyEmailScreenActionState());
      } else {
        emit(SignupErrorState());
        emit(SignupErrorActionState(message: 'Signup failed. Please try again.'));
      }
    } on ApiException catch (e) {
      emit(SignupErrorState());
      emit(SignupErrorActionState(message: e.message));
    } catch (e) {
      emit(SignupErrorState());
      emit(SignupErrorActionState(message: 'An unexpected error occurred'));
    }
  }
}
