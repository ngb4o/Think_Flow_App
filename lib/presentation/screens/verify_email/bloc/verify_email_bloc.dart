import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:think_flow/data/models/data_model.dart';
import 'package:think_flow/data/repositories/auth_repo.dart';

import '../../../../data/data_sources/remote/api_exception.dart';

part 'verify_email_event.dart';
part 'verify_email_state.dart';

class VerifyEmailBloc extends Bloc<VerifyEmailEvent, VerifyEmailState> {
  final AuthRepo authRepo;
  VerifyEmailBloc(this.authRepo) : super(VerifyEmailInitial()) {
    on<VerifyEmailButtonClickEvent>(verifyEmailButtonClickEvent);
    on<ResendVerifyEmailButtonClickEvent>(resendVerifyEmailButtonClickEvent);
    on<VerifyEmailButtonClickNavigationToLoginPageEvent>(verifyEmailButtonClickNavigationToLoginPageEvent);
  }


  FutureOr<void> verifyEmailButtonClickEvent(VerifyEmailButtonClickEvent event, Emitter<VerifyEmailState> emit) async {
    emit(VerifyEmailLoadingState());
    try {
      var verifyEmailData = await authRepo.verifyEmail(event.email, event.otp);
      if (verifyEmailData.data != null) {
        emit(VerifyEmailSuccessState(dataModel: verifyEmailData));
        emit(VerifyEmailNavigationToSuccessPageActionState());
      }
    } on ApiException catch (e) {
      emit(VerifyEmailErrorState());
      emit(VerifyEmailErrorActionState(message: e.message));
    } catch (e) {
      emit(VerifyEmailErrorState());
      emit(VerifyEmailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> resendVerifyEmailButtonClickEvent(ResendVerifyEmailButtonClickEvent event, Emitter<VerifyEmailState> emit) async {
    emit(ResendVerifyEmailLoadingState());
    try {
      var resendVerifyEmailData = await authRepo.resendVerifyEmail(event.email);
      if (resendVerifyEmailData.data != null) {
        emit(ResendVerifyEmailSuccessState());
        emit(ResendVerifyEmailSuccessActionState(dataModel: resendVerifyEmailData));
      }
    } on ApiException catch (e) {
      emit(ResendVerifyEmailErrorState());
      emit(ResendVerifyEmailErrorActionState(message: e.message));
    } catch (e) {
      emit(ResendVerifyEmailErrorState());
      emit(ResendVerifyEmailErrorActionState(message: 'An unexpected error occurred'));
    }
  }

  FutureOr<void> verifyEmailButtonClickNavigationToLoginPageEvent(VerifyEmailButtonClickNavigationToLoginPageEvent event, Emitter<VerifyEmailState> emit) async {
    emit(VerifyEmailNavigationToLoginPageActionState());
  }
}
