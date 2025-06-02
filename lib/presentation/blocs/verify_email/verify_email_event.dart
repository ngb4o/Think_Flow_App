part of 'verify_email_bloc.dart';

@immutable
sealed class VerifyEmailEvent {}

class VerifyEmailButtonClickEvent extends VerifyEmailEvent {
  final String email;
  final String otp;

  VerifyEmailButtonClickEvent({required this.email,required this.otp});
}

class ResendVerifyEmailButtonClickEvent extends VerifyEmailEvent {
  final String email;

  ResendVerifyEmailButtonClickEvent({required this.email});
}

class VerifyEmailButtonClickNavigationToLoginPageEvent extends VerifyEmailEvent {}