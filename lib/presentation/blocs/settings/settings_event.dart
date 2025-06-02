part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class SettingInitialFetchDataEvent extends SettingsEvent {}

class SettingClickButtonLogoutEvent extends SettingsEvent {}

class SettingClickButtonNavigationToProfilePageEvent extends SettingsEvent {}
