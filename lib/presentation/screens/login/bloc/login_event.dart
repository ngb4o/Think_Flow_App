part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginButtonClickEvent extends LoginEvent {
  String email;
  String password;

  LoginButtonClickEvent({required this.email, required this.password});
}

class LoginClickButtonNavigationToSignupPageEvent extends LoginEvent {}

class LoginClickButtonNavigationToForgetPasswordPageEvent extends LoginEvent {}
