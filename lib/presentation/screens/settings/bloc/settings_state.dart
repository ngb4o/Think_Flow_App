part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

abstract class SettingsActionState extends SettingsState {}

class SettingLoadingState extends SettingsState {}

class SettingSuccessState extends SettingsState {
  final UserModel userModel;

  SettingSuccessState({required this.userModel});
}

class SettingErrorState extends SettingsState {
  final String message;

  SettingErrorState({required this.message});
}

class SettingErrorActionState extends SettingsActionState {
  final String message;

  SettingErrorActionState({required this.message});
}

class SettingLogoutLoadingState extends SettingsState {}

class SettingLogoutSuccessState extends SettingsState {}

class SettingLogoutErrorState extends SettingsState {}

class SettingLogoutSuccessActionState extends SettingsActionState {}

class SettingLogoutErrorActionState extends SettingsActionState {
  final String message;

  SettingLogoutErrorActionState({required this.message});
}

class SettingNavigationToProfilePageActionState extends SettingsActionState {
  final UserModel userModel;

  SettingNavigationToProfilePageActionState({required this.userModel});
}
