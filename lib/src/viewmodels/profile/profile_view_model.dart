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
}
