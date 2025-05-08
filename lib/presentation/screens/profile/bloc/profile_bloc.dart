import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:think_flow/data/models/user_model.dart';
import 'package:think_flow/data/repositories/user_repo.dart';

import '../../../../data/data_sources/remote/api_exception.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepo userRepo;
  ProfileBloc(this.userRepo) : super(ProfileInitial()) {
    on<ProfileInitialFetchDataEvent>(profileInitialFetchDataEvent);
    on<ProfileUpdateAvatarEvent>(profileUpdateAvatarEvent);
  }

  Future<void> profileInitialFetchDataEvent(
    ProfileInitialFetchDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(ProfileLoadingState());
      final userData = await userRepo.getUserProfile();
      emit(ProfileSuccessState(userModel: userData));
    } on ApiException catch (e) {
      emit(ProfileErrorState(message: e.message));
    } catch (e) {
      emit(ProfileErrorState(message: 'An unexpected error occurred'));
    }
  }

  Future<void> profileUpdateAvatarEvent(
    ProfileUpdateAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (state is ProfileSuccessState) {
        final currentState = state as ProfileSuccessState;
        emit(ProfileSuccessState(
          userModel: currentState.userModel,
          isAvatarLoading: true,
        ));
      }
      
      final imageResponse = await userRepo.createImage(event.imageFile);
      await userRepo.updateAvatar(imageResponse.data);
      
      // Fetch updated profile data
      final userModel = await userRepo.getUserProfile();
      emit(ProfileSuccessState(userModel: userModel));
      emit(ProfileUpdateAvatarSuccessActionState());
    } on ApiException catch (e) {
      emit(ProfileUpdateAvatarErrorState(message: e.message));
    } catch (e) {
      emit(ProfileUpdateAvatarErrorState(message: 'An unexpected error occurred'));
    }
  }
}