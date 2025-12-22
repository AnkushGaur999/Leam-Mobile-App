part of 'profile_view_model.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();

  @override
  List<Object> get props => [];
}

final class ProfileDetailsLoading extends ProfileState {
  const ProfileDetailsLoading();

  @override
  List<Object> get props => [];
}

final class ProfileDetailsLoaded extends ProfileState {
  final ProfileData profileData;

  const ProfileDetailsLoaded({required this.profileData});

  @override
  List<Object> get props => [profileData];
}

final class ProfileDetailsFailure extends ProfileState {
  final String message;

  const ProfileDetailsFailure({required this.message});

  @override
  List<Object> get props => [message];
}

final class UpdateProfilePictureLoading extends ProfileState {
  const UpdateProfilePictureLoading();

  @override
  List<Object?> get props => throw UnimplementedError();
}

final class UpdateProfilePictureSuccess extends ProfileState {
  const UpdateProfilePictureSuccess();

  @override
  List<Object?> get props => [];
}

final class UpdateProfilePictureFailed extends ProfileState {
  const UpdateProfilePictureFailed();

  @override
  List<Object?> get props => [];
}
