part of "profile_view_model.dart";

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();
}

final class GetProfileDetailsEvent extends ProfileEvent {
  const GetProfileDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateProfilePictureEvent extends ProfileEvent {
  final File file;

  const UpdateProfilePictureEvent({required this.file});

  @override
  List<Object?> get props => [file];
}
