part of 'password_configuration_bloc.dart';

@immutable
sealed class PasswordConfigurationEvent {}

class PasswordConfigurationClickButtonForgotPasswordEvent extends PasswordConfigurationEvent {
  final String email;

  PasswordConfigurationClickButtonForgotPasswordEvent({required this.email});
}

class PasswordConfigurationClickButtonResetPasswordEvent extends PasswordConfigurationEvent {
  final String email;
  final String otp;
  final String newPassword;

  PasswordConfigurationClickButtonResetPasswordEvent({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
}