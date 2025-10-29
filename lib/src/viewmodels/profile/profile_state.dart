part of 'profile_view_model.dart';

sealed class ProfileState extends Equatable {}

final class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

final class ProfileDetailsLoading extends ProfileState {
  @override
  List<Object> get props => [];
}

final class ProfileDetailsLoaded extends ProfileState {
  final ProfileData profileData;

  ProfileDetailsLoaded({required this.profileData});

  @override
  List<Object> get props => [profileData];
}

final class ProfileDetailsFailure extends ProfileState {
  final String message;

  ProfileDetailsFailure({required this.message});

  @override
  List<Object> get props => [message];
}
