part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class ProfileInitialFetchDataEvent extends ProfileEvent {}

class ProfileUpdateAvatarEvent extends ProfileEvent {
  final File imageFile;
  ProfileUpdateAvatarEvent({required this.imageFile});
}