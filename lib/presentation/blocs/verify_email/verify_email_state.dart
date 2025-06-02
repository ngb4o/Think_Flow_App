part of 'verify_email_bloc.dart';

@immutable
sealed class VerifyEmailState {}

abstract class VerifyEmailActionState extends VerifyEmailState {}

final class VerifyEmailInitial extends VerifyEmailState {}

class VerifyEmailLoadingState extends VerifyEmailState {}

class VerifyEmailSuccessState extends VerifyEmailState {
  final DataModel dataModel;

  VerifyEmailSuccessState({required this.dataModel});
}

class VerifyEmailErrorState extends VerifyEmailState {}

class VerifyEmailErrorActionState extends VerifyEmailActionState {
  final String message;

  VerifyEmailErrorActionState({required this.message});
}

class ResendVerifyEmailLoadingState extends VerifyEmailState {}

class ResendVerifyEmailSuccessState extends VerifyEmailState {
}

class ResendVerifyEmailSuccessActionState extends VerifyEmailActionState {
  final DataModel dataModel;

  ResendVerifyEmailSuccessActionState({required this.dataModel});
}

class ResendVerifyEmailErrorState extends VerifyEmailState {}

class ResendVerifyEmailErrorActionState extends VerifyEmailActionState {
  final String message;

  ResendVerifyEmailErrorActionState({required this.message});
}

class VerifyEmailNavigationToLoginPageActionState extends VerifyEmailActionState {}

class VerifyEmailNavigationToSuccessPageActionState extends VerifyEmailActionState {}


