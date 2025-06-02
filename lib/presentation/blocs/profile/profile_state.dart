part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

abstract class ProfileActionState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final UserModel userModel;
  final bool isAvatarLoading;
  ProfileSuccessState({
    required this.userModel,
    this.isAvatarLoading = false,
  });
}

class ProfileErrorState extends ProfileState {
  final String message;
  ProfileErrorState({required this.message});
}

class ProfileUpdateAvatarLoadingState extends ProfileState {}

class ProfileUpdateAvatarSuccessActionState extends ProfileActionState {}

class ProfileUpdateAvatarErrorState extends ProfileActionState {
  final String message;
  ProfileUpdateAvatarErrorState({required this.message});
}
