part of 'signup_bloc.dart';

@immutable
sealed class SignupState {}

abstract class SignupActionState extends SignupState {}

final class SignupInitial extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessState extends SignupState {}

class SignupErrorState extends SignupState {}

class SignupNavigationToVerifyEmailScreenActionState extends SignupActionState {}

class SignupErrorActionState extends SignupActionState {
  final String message;

  SignupErrorActionState({required this.message});
}
