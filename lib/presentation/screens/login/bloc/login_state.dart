part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

abstract class LoginActionSate extends LoginState {}

final class LoginInitial extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginErrorState extends LoginState {}

class LoginNavigationToSignupPageActionState extends LoginActionSate {}

class LoginNavigationToForgetPasswordPageActionState extends LoginActionSate {}

class LoginSuccessActionState extends LoginActionSate {}

class LoginErrorActionState extends LoginActionSate {
  final String message;

  LoginErrorActionState({required this.message});
}
