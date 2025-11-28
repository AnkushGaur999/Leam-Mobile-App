import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leam/src/core/data/data_state.dart';
import 'package:leam/src/models/profile_data.dart';
import 'package:leam/src/repositories/profile_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;

  ProfileViewModel({required this.repository}) : super(ProfileInitial()) {
    on<GetProfileDetailsEvent>(_fetchProfileData);
    on<UpdateProfilePictureEvent>(_updateProfilePicture);
    add(GetProfileDetailsEvent());
  }

  Future<void> _fetchProfileData(
    GetProfileDetailsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileDetailsLoading());

    final result = await repository.getUserProfile();

    if (result is DataSuccess) {
      emit(ProfileDetailsLoaded(profileData: result.data!));
    } else {
      emit(ProfileDetailsFailure(message: result.message!));
    }
  }

  Future<void> _updateProfilePicture(
    UpdateProfilePictureEvent event,
    Emitter<ProfileState> emit,
  ) async {
   // emit(UpdateProfilePictureLoading());

    final result = await repository.uploadProfilePicture(file: event.file);

    if (result is DataSuccess) {
      print("Success");
   //   emit(UpdateProfilePictureSuccess());
      add(GetProfileDetailsEvent());
    } else {
      print("Error: ${result.message}");
   //   emit(UpdateProfilePictureFailed());
    }
  }
}
