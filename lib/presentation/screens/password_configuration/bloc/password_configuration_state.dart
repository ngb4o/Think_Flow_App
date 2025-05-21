part of 'password_configuration_bloc.dart';

@immutable
sealed class PasswordConfigurationState {}

final class PasswordConfigurationInitial extends PasswordConfigurationState {}

abstract class PasswordConfigurationActionState extends PasswordConfigurationState {}

class PasswordConfigurationForgotPasswordLoadingState extends PasswordConfigurationState {}

class PasswordConfigurationForgotPasswordSuccessState extends PasswordConfigurationActionState {}

class PasswordConfigurationForgotPasswordErrorState extends PasswordConfigurationState {}

class PasswordConfigurationForgotPasswordErrorActionState extends PasswordConfigurationActionState {
  final String message;

  PasswordConfigurationForgotPasswordErrorActionState({required this.message});
}

class PasswordConfigurationResetPasswordLoadingState extends PasswordConfigurationState {}

class PasswordConfigurationResetPasswordSuccessState extends PasswordConfigurationActionState {}

class PasswordConfigurationResetPasswordErrorState extends PasswordConfigurationState {}

class PasswordConfigurationResetPasswordErrorActionState extends PasswordConfigurationActionState {
  final String message;

  PasswordConfigurationResetPasswordErrorActionState({required this.message});
}