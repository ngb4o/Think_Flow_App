// import 'dart:async';
//
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:think_flow/data/models/user_model.dart';
// import 'package:think_flow/data/repositories/user_repo.dart';
//
// import '../../../../data/data_sources/remote/api_exception.dart';
//
// part 'profile_event.dart';
// part 'profile_state.dart';
//
// class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
//   final UserRepo userRepo;
//   ProfileBloc(this.userRepo) : super(ProfileInitial()) {
//     on<ProfileInitialFetchDataEvent>(profileInitialFetchDataEvent);
//   }
//
//   FutureOr<void> profileInitialFetchDataEvent(ProfileInitialFetchDataEvent event, Emitter<ProfileState> emit) async {
//     emit(ProfileLoadingState());
//     try {
//       var userData = await userRepo.getUserProfile();
//       if (userData.data != null) {
//         emit(ProfileSuccessState(userModel: userData));
//       }
//     } on ApiException catch (e) {
//       emit(ProfileErrorState());
//       emit(ProfileErrorActionState(message: e.message));
//     } catch (e) {
//       emit(ProfileErrorState());
//       emit(ProfileErrorActionState(message: 'An unexpected error occurred'));
//     }
//   }
// }
